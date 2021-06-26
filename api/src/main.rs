#[macro_use]
extern crate rocket;
use std::{collections::HashMap, str::FromStr};

use jsonwebtoken::DecodingKey;
use rocket::{
    fairing::{self, AdHoc},
    futures::StreamExt,
    outcome::try_outcome,
    request::{self, FromRequest},
    serde::{json::Json, Deserialize, Deserializer, Serialize},
    Build, Rocket, State,
};
use sqlx::ConnectOptions;
use uuid::Uuid;

type Db = sqlx::PgPool;

#[derive(Debug)]
enum AuthError {
    GuardFetch,
    InvalidAuthorization,
    TokenExpired,
}

#[derive(Debug)]
struct User {
    id: Uuid,
}

#[derive(Debug, Serialize, Deserialize)]
struct Claims {
    sub: Uuid,
    exp: usize,
    iat: chrono::DateTime<chrono::Utc>,
}

#[rocket::async_trait]
impl<'r> FromRequest<'r> for User {
    type Error = AuthError;

    async fn from_request(
        request: &'r request::Request<'_>,
    ) -> request::Outcome<Self, Self::Error> {
        let secret = try_outcome!(request
            .guard::<&State<Config>>()
            .await
            .map_failure(|(s, _)| (s, AuthError::GuardFetch)));

        let auth = match request.headers().get_one("Authorization") {
            Some(a) => a,
            None => {
                return request::Outcome::Failure((
                    rocket::http::Status::BadRequest,
                    AuthError::InvalidAuthorization,
                ))
            }
        };
        if !auth.starts_with("Bearer") {
            error!("Authorization does not start with Bearer");
            return request::Outcome::Failure((
                rocket::http::Status::BadRequest,
                AuthError::InvalidAuthorization,
            ));
        }
        let auth = auth.trim_start_matches("Bearer").trim_start();
        let decoded = match jsonwebtoken::decode::<Claims>(
            auth,
            &DecodingKey::from_secret(&secret.jwt_secret),
            &jsonwebtoken::Validation::new(jsonwebtoken::Algorithm::HS256),
        ) {
            Err(e) => {
                error!("Could not decode JWT: {:?}", e);
                return request::Outcome::Failure((
                    rocket::http::Status::BadRequest,
                    AuthError::InvalidAuthorization,
                ));
            }
            Ok(d) => d,
        };
        if decoded.claims.iat + chrono::Duration::seconds(decoded.claims.exp as i64)
            < chrono::Utc::now()
        {
            return request::Outcome::Failure((
                rocket::http::Status::Unauthorized,
                AuthError::TokenExpired,
            ));
        }
        request::Outcome::Success(User {
            id: decoded.claims.sub,
        })
    }
}

#[derive(Serialize)]
struct RspOk<T> {
    status: &'static str,
    #[serde(flatten)]
    value: T,
}

#[derive(Serialize)]
struct RspErr {
    status: &'static str,
    code: usize,
    reason: String,
}

macro_rules! define_error {
    (
    pub enum Error {
        $(
            $variant:ident = { reason: $reason:literal, code: $code:literal $(,)?}
        ),*
        $(,)?
    }
    ) => {
        #[derive(Clone, Copy)]
        pub enum Error {
            $(
                $variant,
            )*
        }

        impl Error {
            fn reason(self, reason: Option<String>) -> RspErr {
                match self {
                $(
                    Self::$variant => {
                        let reason = reason.unwrap_or_else(|| $reason.into());
                        RspErr {status: "err", reason, code: $code}
                    }
                )*
                }
            }
            fn default_err(self) -> RspErr {
                self.reason(None)
            }
        }
    };
}

define_error! {
    pub enum Error {
        ListAlreadyExists = {
            reason: "list already exists",
            code: 0,
        },
        UnknownAccount = {
            reason: "unkown account",
            code: 1,
        },
        NoSuchList = {
            reason: "no such list",
            code: 2,
        },
        NotWritable = {
            reason: "list is not writable",
            code: 3,
        },
    }
}

#[derive(Responder)]
#[response(bound = "T: Serialize")]
enum Rsp<T> {
    #[response(status = 500)]
    Sqlx(rocket::response::Debug<sqlx::Error>),
    #[response(status = 500)]
    Internal(rocket::response::Debug<String>),
    Ok(Json<RspOk<T>>),
    #[response(status = 400)]
    Err(Json<RspErr>),
}

impl<T: Serialize> From<sqlx::Error> for Rsp<T> {
    fn from(err: sqlx::Error) -> Self {
        Rsp::Sqlx(err.into())
    }
}

impl<T: Serialize> Rsp<T> {
    fn ok(value: T) -> Self {
        Rsp::Ok(Json(RspOk {
            status: "ok",
            value,
        }))
    }

    fn internal_err<R: Into<String>>(reason: R) -> Self {
        Rsp::Internal(reason.into().into())
    }
}

impl<T: Serialize> From<RspErr> for Rsp<T> {
    fn from(e: RspErr) -> Self {
        Self::Err(e.into())
    }
}

macro_rules! try_rsp {
    ($e:expr) => {
        match $e {
            Ok(x) => x,
            Err(e) => return e.into(),
        }
    };
}

#[derive(Deserialize, Debug)]
struct LoginRequest {
    password: String,
    username: String,
}

#[derive(Serialize, Debug)]
struct LoginResponse {
    token: String,
}

#[post("/login", data = "<request>")]
async fn login(
    cfg: &State<Config>,
    db: &State<Db>,
    request: Json<LoginRequest>,
) -> Result<Rsp<LoginResponse>, rocket::response::Debug<jsonwebtoken::errors::Error>> {
    let mut rsp = sqlx::query!(
        "SELECT id FROM accounts WHERE name = $1 AND password = crypt($2, password)",
        request.username,
        request.password
    )
    .fetch(&**db);
    let id = match rsp.next().await {
        None => return Ok(Error::UnknownAccount.default_err().into()),
        Some(Err(e)) => return Ok(e.into()),
        Some(Ok(id)) => id.id,
    };

    let claims = Claims {
        sub: id,
        exp: cfg.exp,
        iat: chrono::Utc::now(),
    };

    let token = match jsonwebtoken::encode(
        &jsonwebtoken::Header::default(),
        &claims,
        &jsonwebtoken::EncodingKey::from_secret(&cfg.jwt_secret),
    ) {
        Err(e) => return Err(e.into()),
        Ok(t) => t,
    };

    Ok(Rsp::ok(LoginResponse { token }))
}

#[derive(Deserialize)]
struct CreateListRequest {
    name: String,
}

#[derive(Serialize)]
struct CreateListResponse {
    id: Uuid,
}

#[post("/list", data = "<list>")]
async fn create_list(
    db: &State<Db>,
    user: User,
    list: Json<CreateListRequest>,
) -> Rsp<CreateListResponse> {
    let fetch_lists = try_rsp!(
        sqlx::query!(
            "SELECT COUNT(*) FROM lists WHERE owner = $1 AND name = $2",
            user.id,
            list.name
        )
        .fetch_one(&**db)
        .await
    );

    match fetch_lists.count {
        Some(0) | None => (),
        _ => return Error::ListAlreadyExists.default_err().into(),
    }

    let list_id = try_rsp!(
        sqlx::query!(
            "INSERT INTO lists (id, owner, name) VALUES (uuid_generate_v4(), $1, $2) RETURNING id",
            user.id,
            list.name
        )
        .fetch_one(&**db)
        .await
    );

    Rsp::ok(CreateListResponse { id: list_id.id })
}

#[derive(Serialize)]
struct ListofLists {
    results: HashMap<String, Uuid>,
}

#[get("/search/list/<name>")]
async fn search_list(db: &State<Db>, user: User, name: String) -> Rsp<ListofLists> {
    let results = try_rsp!(
        sqlx::query!(
            "SELECT name, id FROM lists WHERE (owner = $1 OR id IN (SELECT list FROM list_sharing WHERE shared = $1)) AND name ILIKE '%' || $2 || '%'",
            user.id,
            name
        )
        .fetch_all(&**db)
        .await
    );

    Rsp::ok(ListofLists {
        results: results.into_iter().map(|row| (row.name, row.id)).collect(),
    })
}

#[derive(Serialize)]
struct AccountSearch {
    id: Uuid,
}

#[get("/search/account/<name>")]
async fn search_account(db: &State<Db>, _user: User, name: String) -> Rsp<AccountSearch> {
    let result = try_rsp!(
        sqlx::query!("SELECT id FROM accounts WHERE name ILIKE $1", name)
            .fetch_one(&**db)
            .await
    );

    Rsp::ok(AccountSearch { id: result.id })
}

#[get("/list")]
async fn list_lists(db: &State<Db>, user: User) -> Rsp<ListofLists> {
    let results = try_rsp!(
        sqlx::query!("SELECT name, id FROM lists WHERE owner = $1 OR id IN (SELECT list FROM list_sharing WHERE shared = $1)", user.id)
            .fetch_all(&**db)
            .await
    );

    Rsp::ok(ListofLists {
        results: results.into_iter().map(|row| (row.name, row.id)).collect(),
    })
}

type CheckListResult = Result<Result<(), Error>, sqlx::Error>;

async fn is_owner(db: &State<Db>, user_id: &Uuid, list_id: &Uuid) -> CheckListResult {
    let has_list = sqlx::query!(
        "SELECT COUNT(*) FROM lists WHERE owner = $1 AND id = $2",
        user_id,
        list_id
    )
    .fetch_one(&**db)
    .await?;

    match has_list.count {
        Some(0) | None => Ok(Err(Error::NoSuchList)),
        _ => return Ok(Ok(())),
    }
}

async fn check_list(
    db: &State<Db>,
    user_id: &Uuid,
    list_id: &Uuid,
    write: bool,
) -> CheckListResult {
    if let Ok(_) = is_owner(db, user_id, list_id).await? {
        return Ok(Ok(()));
    }

    let mut shared_status = sqlx::query!(
        "SELECT readonly FROM list_sharing WHERE list = $1 AND shared = $2",
        list_id,
        user_id
    )
    .fetch(&**db);

    match shared_status
        .next()
        .await
        .map(|r| r.map(|row| row.readonly))
    {
        Some(Ok(true)) if write => Ok(Err(Error::NotWritable)),
        Some(Ok(_)) => Ok(Ok(())),
        Some(Err(e)) => Err(e),
        None => Ok(Err(Error::NoSuchList)),
    }
}

macro_rules! try_check_list {
    ($e:expr) => {
        match $e {
            Ok(Ok(v)) => v,
            Ok(Err(e)) => return e.default_err().into(),
            Err(e) => return e.into(),
        }
    };
}

#[derive(Serialize, Deserialize)]
struct Item {
    id: i32,
    name: String,
    amount: Option<String>,
}

#[derive(Serialize)]
struct ReadListResponse {
    items: Vec<Item>,
    readonly: bool,
}

#[get("/list/<id>")]
async fn read_list(db: &State<Db>, user: User, id: Uuid) -> Rsp<ReadListResponse> {
    try_check_list!(check_list(db, &user.id, &id, false).await);

    let items = try_rsp!(
        sqlx::query!(
            "SELECT id, name, amount FROM lists_content WHERE list = $1",
            id
        )
        .fetch_all(&**db)
        .await
    );
    let readonly = try_rsp!(
        sqlx::query!(
            " SELECT COALESCE((SELECT readonly FROM list_sharing WHERE list = $1), false)",
            id
        )
        .fetch_one(&**db)
        .await
    );

    Rsp::ok(ReadListResponse {
        items: items
            .into_iter()
            .map(|row| Item {
                id: row.id,
                name: row.name,
                amount: row.amount,
            })
            .collect(),
        readonly: readonly.coalesce.unwrap_or(false),
    })
}

#[derive(Deserialize)]
struct AddListRequest {
    name: String,
    amount: Option<String>,
}

#[derive(Serialize)]
struct AddListResponse {
    id: i32,
}

#[post("/list/<id>", data = "<item>")]
async fn add_list(
    db: &State<Db>,
    user: User,
    id: Uuid,
    item: Json<AddListRequest>,
) -> Rsp<AddListResponse> {
    try_check_list!(check_list(db, &user.id, &id, true).await);

    let id = try_rsp!(
        sqlx::query!(
            "INSERT INTO lists_content (list, name, amount) VALUES ($1, $2, $3) RETURNING id",
            id,
            item.name,
            item.amount
        )
        .fetch_one(&**db)
        .await
    );

    Rsp::ok(AddListResponse { id: id.id })
}

#[derive(Deserialize)]
pub struct ShareRequest {
    share_with: Uuid,
    readonly: bool,
}

#[put("/share/<id>", data = "<request>")]
async fn share_list(db: &State<Db>, user: User, id: Uuid, request: Json<ShareRequest>) -> Rsp<()> {
    try_check_list!(is_owner(db, &user.id, &id).await);

    try_rsp!(
        sqlx::query!(
            r#"
            INSERT INTO list_sharing (list, shared, readonly) 
            VALUES ($1, $2, $3) ON CONFLICT DO NOTHING"#,
            id,
            request.share_with,
            request.readonly
        )
        .execute(&**db)
        .await
    );

    Rsp::ok(())
}

#[delete("/share/<id>")]
async fn delete_share(db: &State<Db>, user: User, id: Uuid) -> Rsp<()> {
    try_check_list!(is_owner(db, &user.id, &id).await);

    try_rsp!(
        sqlx::query!("DELETE FROM list_sharing WHERE list = $1", id)
            .execute(&**db)
            .await
    );

    Rsp::ok(())
}

async fn init_db(rocket: Rocket<Build>) -> fairing::Result {
    use rocket_sync_db_pools::Config;

    let config = match Config::from("sqlx", &rocket) {
        Ok(config) => config,
        Err(e) => {
            error!("Failed to read SQLx config: {}", e);
            return Err(rocket);
        }
    };

    let mut opts = match sqlx::postgres::PgConnectOptions::from_str(&config.url) {
        Ok(opts) => opts,
        Err(e) => {
            error!("Failed to parse pg url: {}", e);
            return Err(rocket);
        }
    };

    opts.disable_statement_logging();
    let db = match Db::connect_with(opts).await {
        Ok(db) => db,
        Err(e) => {
            error!("Failed to connect to SQLx database: {}", e);
            return Err(rocket);
        }
    };

    /*
       if let Err(e) = sqlx::migrate!("sqlx/migrations").run(&db).await {
           error!("Failed to initialize SQLx database: {}", e);
           return Err(rocket);
       }
    */

    Ok(rocket.manage(db))
}

pub fn deserialize_base64<'de, D>(de: D) -> Result<Vec<u8>, D::Error>
where
    D: Deserializer<'de>,
{
    use rocket::serde::de::Visitor;

    struct DecodingVisitor;
    impl<'de> Visitor<'de> for DecodingVisitor {
        type Value = Vec<u8>;

        fn expecting(&self, formatter: &mut std::fmt::Formatter) -> std::fmt::Result {
            formatter.write_str("must be a base 64 string")
        }

        fn visit_str<E>(self, v: &str) -> Result<Self::Value, E>
        where
            E: serde::de::Error,
        {
            base64::decode(v).map_err(E::custom)
        }
    }

    de.deserialize_str(DecodingVisitor)
}

#[derive(Deserialize, Debug)]
struct Config {
    #[serde(deserialize_with = "deserialize_base64")]
    jwt_secret: Vec<u8>,
    exp: usize,
}

#[launch]
fn rocket() -> _ {
    rocket::build()
        .attach(AdHoc::try_on_ignite("SQLx", init_db))
        .attach(AdHoc::config::<Config>())
        .mount(
            "/",
            routes![
                login,
                list_lists,
                create_list,
                search_list,
                read_list,
                add_list,
                share_list,
                search_account,
                delete_share,
            ],
        )
}
