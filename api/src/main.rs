#[macro_use]
extern crate rocket;
use std::{collections::HashMap, str::FromStr};

use jsonwebtoken::DecodingKey;
use kabalist_types::{uuid::Uuid, *};
use rocket::{
    fairing::{self, AdHoc},
    futures::StreamExt,
    http::Header,
    outcome::try_outcome,
    request::{self, FromRequest},
    response::status::BadRequest,
    serde::{json::Json, Deserialize, Deserializer, Serialize},
    Build, Rocket, State,
};
use rocket_dyn_templates::Template;
use rocket_okapi::{
    okapi::openapi3,
    openapi_get_routes,
    rapidoc::{self, make_rapidoc, RapiDocConfig},
    request::{OpenApiFromRequest, RequestHeaderInput},
    settings::UrlObject,
    swagger_ui::{make_swagger_ui, SwaggerUIConfig},
    util::{add_schema_response, produce_any_responses},
    JsonSchema,
};
use rocket_okapi::{openapi, response::OpenApiResponderInner};
use schemars::schema::{SchemaObject, NumberValidation};
use serde_repr::{Deserialize_repr, Serialize_repr};
use sqlx::ConnectOptions;

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

impl<'r> OpenApiFromRequest<'r> for User {
    fn from_request_input(
        _gen: &mut rocket_okapi::gen::OpenApiGenerator,
        _name: String,
        _required: bool,
    ) -> rocket_okapi::Result<rocket_okapi::request::RequestHeaderInput> {
        let security_scheme = openapi3::SecurityScheme {
            description: Some(
                "Requires an Bearer token to access, token is: `mytoken`.".to_owned(),
            ),
            data: openapi3::SecuritySchemeData::Http {
                scheme: "bearer".to_owned(), // `basic`, `digest`, ...
                // Just gives use a hint to the format used
                bearer_format: Some("bearer".to_owned()),
            },
            extensions: openapi3::Object::default(),
        };
        let mut security_req = openapi3::SecurityRequirement::new();
        security_req.insert("JWT".to_owned(), Vec::new());

        Ok(RequestHeaderInput::Security(
            "JWT".into(),
            security_scheme,
            security_req,
        ))
    }
}

macro_rules! define_error {
    (
    pub enum Error {
        $(
            $variant:ident = { description: $description:literal, code: $code:literal $(,)?}
        ),*
        $(,)?
    }
    ) => {
        #[derive(Serialize_repr, Deserialize_repr, Clone, Copy)]
        #[repr(u16)]
        pub enum Error {
            $(
                $variant = $code,
            )*
        }

        impl JsonSchema for Error {
            fn is_referenceable() -> bool {
                false
            }

            fn schema_name() -> String {
                "Error".into()
            }

            fn json_schema(_: &mut schemars::gen::SchemaGenerator) -> schemars::schema::Schema {
                SchemaObject {
                    instance_type: Some(schemars::schema::InstanceType::Integer.into()),
                    number: Some(Box::new(NumberValidation {
                        maximum: [$($code,)*].iter().max().map(|&x| x as f64),
                        minimum: [$($code,)*].iter().min().map(|&x| x as f64),
                        ..Default::default()
                    })),
                    ..Default::default()
                }.into()
            }
        }

        impl Error {
            fn into_err_with_desc(self, description: Option<String>) -> ErrResponse {
                match self {
                $(
                    Self::$variant => {
                        let description = description.unwrap_or_else(|| $description.into());
                        ErrResponse {
                            err: UserError {
                                code: self,
                                description,
                            }
                        }
                    }
                )*
                }
            }
            fn into_err(self) -> ErrResponse {
                self.into_err_with_desc(None)
            }
        }
    };
}

define_error! {
    pub enum Error {
        Internal = {
            description: "internal error",
            code: 0,
        },
        ListAlreadyExists = {
            description: "list already exists",
            code: 1,
        },
        UnknownAccount = {
            description: "unkown account",
            code: 2,
        },
        NoSuchList = {
            description: "no such list",
            code: 3,
        },
        NotWritable = {
            description: "list is not writable",
            code: 4,
        },
        RegistrationDoesNotExist = {
            description: "registration does not exist",
            code: 5,
        },
        InvalidRecovery = {
            description: "recovery does not exists",
            code: 6,
        },
        AccountNotFound = {
            description: "account not found",
            code: 7,
        },
    }
}

#[derive(Serialize, Deserialize, JsonSchema)]
struct OkResponse<T> {
    ok: T,
}

#[derive(Serialize, Deserialize, JsonSchema)]
struct ErrResponse {
    err: UserError,
}

impl<T> From<Error> for Rsp<T> {
    fn from(e: Error) -> Self {
        Rsp::Err(BadRequest(Some(Json(e.into_err()))))
    }
}

#[derive(Serialize, Deserialize, JsonSchema)]
struct UserError {
    code: Error,
    description: String,
}

#[derive(Responder)]
enum Rsp<T> {
    Ok(Json<OkResponse<T>>),
    Err(BadRequest<Json<ErrResponse>>),
}

impl<T> OpenApiResponderInner for Rsp<T>
where
    T: JsonSchema,
{
    fn responses(
        gen: &mut rocket_okapi::gen::OpenApiGenerator,
    ) -> rocket_okapi::Result<openapi3::Responses> {
        let mut response = openapi3::Responses::default();
        let ok_schema = gen.json_schema::<OkResponse<T>>();
        let err_schema = gen.json_schema::<ErrResponse>();
        add_schema_response(&mut response, 200, "application/json", ok_schema)?;
        add_schema_response(&mut response, 400, "application/json", err_schema)?;
        Ok(response)
    }
}

impl<T: Serialize> From<sqlx::Error> for Rsp<T> {
    fn from(err: sqlx::Error) -> Self {
        error!("SQLX error: {:?}", err);
        Error::Internal.into()
    }
}

impl<T: Serialize> Rsp<T> {
    fn ok(value: T) -> Self {
        Rsp::Ok(Json(OkResponse { ok: value }))
    }

    fn _internal_err<R: Into<String>>(reason: R) -> Self {
        let r = reason.into();
        error!("Internal error: {}", r);
        Error::Internal.into()
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

#[openapi(tag = "KabaList")]
#[post("/login", data = "<request>")]
async fn login(
    cfg: &State<Config>,
    db: &State<Db>,
    request: Json<LoginRequest>,
) -> Result<Rsp<LoginResponse>, rocket::response::Debug<jsonwebtoken::errors::Error>> {
    let mut rsp = sqlx::query!(
        "SELECT id FROM accounts WHERE name = $1::text::citext AND password = crypt($2, password)",
        request.username,
        request.password
    )
    .fetch(&**db);
    let id = match rsp.next().await {
        None => return Ok(Error::UnknownAccount.into()),
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

#[openapi(tag = "KabaList")]
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
        _ => return Error::ListAlreadyExists.into(),
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

#[openapi(tag = "KabaList")]
#[get("/search/list/<name>")]
async fn search_list(db: &State<Db>, user: User, name: String) -> Rsp<GetListsResponse> {
    let results_owned = try_rsp!(
        sqlx::query!(
            "SELECT name, id, pub FROM lists WHERE owner = $1 AND name ILIKE '%' || $2 || '%'",
            user.id,
            name
        )
        .fetch_all(&**db)
        .await
    );
    let results_shared = try_rsp!(
        sqlx::query!(
            r#"SELECT name, id, readonly, pub
               FROM lists, list_sharing
               WHERE (lists.id = list_sharing.list)
                   AND shared = $1
                   AND name ILIKE '%' || $2 || '%'"#,
            user.id,
            name
        )
        .fetch_all(&**db)
        .await
    );

    Rsp::ok(GetListsResponse {
        results: results_owned
            .into_iter()
            .map(|row| {
                (
                    row.name,
                    ListInfo {
                        id: row.id,
                        status: ListStatus::Owned,
                        public: row.r#pub.unwrap_or(false),
                    },
                )
            })
            .chain(results_shared.into_iter().map(|row| {
                (
                    row.name,
                    ListInfo {
                        id: row.id,
                        status: if row.readonly {
                            ListStatus::SharedRead
                        } else {
                            ListStatus::SharedWrite
                        },
                        public: row.r#pub.unwrap_or(false),
                    },
                )
            }))
            .collect(),
    })
}

#[openapi(tag = "KabaList")]
#[get("/search/account/<name>")]
async fn search_account(db: &State<Db>, _user: User, name: String) -> Rsp<SearchAccountResponse> {
    let result = try_rsp!(
        sqlx::query!(
            "SELECT id FROM accounts WHERE name ILIKE $1::text::citext",
            name
        )
        .fetch_one(&**db)
        .await
    );

    Rsp::ok(SearchAccountResponse { id: result.id })
}

#[openapi(tag = "KabaList")]
#[get("/list")]
async fn list_lists(db: &State<Db>, user: User) -> Rsp<GetListsResponse> {
    let results_owned = try_rsp!(
        sqlx::query!(
            r#"
        SELECT name, id, pub
        FROM lists WHERE owner = $1"#,
            user.id
        )
        .fetch_all(&**db)
        .await
    );
    let results_shared = try_rsp!(
        sqlx::query!(
            r#"SELECT name, id, readonly, pub
               FROM lists, list_sharing
               WHERE (lists.id = list_sharing.list)
                   AND shared = $1 "#,
            user.id
        )
        .fetch_all(&**db)
        .await
    );

    Rsp::ok(GetListsResponse {
        results: results_owned
            .into_iter()
            .map(|row| {
                (
                    row.name,
                    ListInfo {
                        id: row.id,
                        status: ListStatus::Owned,
                        public: row.r#pub.unwrap_or(false),
                    },
                )
            })
            .chain(results_shared.into_iter().map(|row| {
                (
                    row.name,
                    ListInfo {
                        id: row.id,
                        status: if row.readonly {
                            ListStatus::SharedRead
                        } else {
                            ListStatus::SharedWrite
                        },
                        public: row.r#pub.unwrap_or(false),
                    },
                )
            }))
            .collect(),
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
            Ok(Err(e)) => return e.into(),
            Err(e) => return e.into(),
        }
    };
}

#[openapi(tag = "KabaList")]
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
    let mut readonly_result = sqlx::query!(
        "SELECT readonly FROM list_sharing WHERE list = $1 AND shared = $2",
        id,
        user.id,
    )
    .fetch(&**db);

    let readonly = match readonly_result.next().await {
        Some(Ok(v)) => v.readonly,
        Some(Err(e)) => return e.into(),
        None => false,
    };

    Rsp::ok(ReadListResponse {
        items: items
            .into_iter()
            .map(|row| Item {
                id: row.id,
                name: row.name,
                amount: row.amount,
            })
            .collect(),
        readonly,
    })
}

#[openapi(tag = "KabaList")]
#[post("/list/<id>", data = "<item>")]
async fn add_list(
    db: &State<Db>,
    user: User,
    id: Uuid,
    item: Json<AddToListRequest>,
) -> Rsp<AddToListResponse> {
    try_check_list!(check_list(db, &user.id, &id, true).await);

    let mut tx = try_rsp!(db.begin().await);

    let item_id = try_rsp!(
        sqlx::query!(
            "INSERT INTO lists_content (list, name, amount) VALUES ($1, $2, $3) RETURNING id",
            id,
            item.name,
            item.amount
        )
        .fetch_one(&mut tx)
        .await
    );

    try_rsp!(
        sqlx::query!(
            r#"INSERT INTO history (list, creator, name, last_used)
               VALUES ($1, $2, $3::text::citext, now())
               ON CONFLICT (list, creator, name) DO
               UPDATE SET last_used = now()"#,
            id,
            user.id,
            item.name
        )
        .execute(&mut tx)
        .await
    );

    try_rsp!(tx.commit().await);

    Rsp::ok(AddToListResponse { id: item_id.id })
}

#[openapi(tag = "KabaList")]
#[get("/history/<list>?<search>")]
async fn history_search(
    db: &State<Db>,
    user: User,
    list: Uuid,
    search: String,
) -> Rsp<GetHistoryResponse> {
    let results = try_rsp!(
        sqlx::query!(
            "SELECT name::text FROM history WHERE list = $1 AND creator = $2 AND name ILIKE '%' || $3 || '%'",
            list,
            user.id, search
        )
        .fetch_all(&**db)
        .await
    );

    Rsp::ok(GetHistoryResponse {
        matches: results
            .into_iter()
            .map(|row| row.name)
            .filter_map(|x| x)
            .collect(),
    })
}

#[openapi(tag = "KabaList")]
#[patch("/list/<list>/<item>", data = "<update>")]
async fn update_item(
    db: &State<Db>,
    user: User,
    list: Uuid,
    item: i32,
    update: Json<UpdateItemRequest>,
) -> Rsp<UpdateItemResponse> {
    try_check_list!(check_list(db, &user.id, &list, true).await);

    let mut tx = try_rsp!(db.begin().await);
    if let Some(name) = &update.name {
        try_rsp!(
            sqlx::query!(
                "UPDATE lists_content SET name = $1 WHERE list = $2 AND id = $3",
                name,
                list,
                item
            )
            .execute(&mut tx)
            .await
        );
    }
    if let Some(amount) = &update.amount {
        try_rsp!(
            sqlx::query!(
                "UPDATE lists_content SET amount = $1 WHERE list = $2 AND id = $3",
                amount,
                list,
                item
            )
            .execute(&mut tx)
            .await
        );
    }

    try_rsp!(tx.commit().await);

    Rsp::ok(UpdateItemResponse {})
}

#[openapi(tag = "KabaList")]
#[delete("/list/<list>/<item>")]
async fn delete_item(db: &State<Db>, user: User, list: Uuid, item: i32) -> Rsp<DeleteItemResponse> {
    try_check_list!(check_list(db, &user.id, &list, true).await);

    try_rsp!(
        sqlx::query!(
            "DELETE FROM lists_content WHERE list = $1 AND id = $2",
            list,
            item
        )
        .execute(&**db)
        .await
    );

    Rsp::ok(DeleteItemResponse {})
}

#[openapi(tag = "KabaList")]
#[get("/share/<id>")]
async fn get_shares(db: &State<Db>, user: User, id: Uuid) -> Rsp<GetSharesResponse> {
    try_check_list!(check_list(db, &user.id, &id, true).await);

    let shared = try_rsp!(
        sqlx::query!(
            "SELECT shared, readonly FROM list_sharing WHERE list = $1",
            id
        )
        .fetch_all(&**db)
        .await
    );

    Rsp::ok(GetSharesResponse {
        public_link: None,
        shared_with: shared
            .into_iter()
            .map(|row| (row.shared, row.readonly))
            .collect(),
    })
}

#[openapi(tag = "KabaList")]
#[put("/share/<id>", data = "<request>")]
async fn share_list(
    db: &State<Db>,
    user: User,
    id: Uuid,
    request: Json<ShareListRequest>,
) -> Rsp<ShareListResponse> {
    try_check_list!(check_list(db, &user.id, &id, true).await);

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

    Rsp::ok(ShareListResponse {})
}

#[openapi(tag = "KabaList")]
#[delete("/share/<list>/<account>")]
async fn unshare(db: &State<Db>, user: User, list: Uuid, account: Uuid) -> Rsp<UnshareResponse> {
    try_check_list!(is_owner(db, &user.id, &list).await);

    let mut tx = try_rsp!(db.begin().await);

    try_rsp!(
        sqlx::query!(
            "DELETE FROM list_sharing WHERE list = $1 AND shared = $2",
            list,
            account
        )
        .execute(&mut tx)
        .await
    );

    try_rsp!(
        sqlx::query!(
            "DELETE FROM history WHERE list = $1 AND creator = $2",
            list,
            account
        )
        .execute(&mut tx)
        .await
    );

    try_rsp!(tx.commit().await);

    Rsp::ok(UnshareResponse {})
}

#[openapi(tag = "KabaList")]
#[delete("/share/<id>")]
async fn delete_shares(db: &State<Db>, user: User, id: Uuid) -> Rsp<DeleteShareResponse> {
    try_check_list!(is_owner(db, &user.id, &id).await);

    let mut tx = try_rsp!(db.begin().await);

    try_rsp!(
        sqlx::query!("DELETE FROM list_sharing WHERE list = $1", id)
            .execute(&mut tx)
            .await
    );

    try_rsp!(
        sqlx::query!(
            "DELETE FROM history WHERE list = $1 AND creator != $2",
            id,
            user.id,
        )
        .execute(&mut tx)
        .await
    );

    try_rsp!(tx.commit().await);

    Rsp::ok(DeleteShareResponse {})
}

#[openapi(tag = "KabaList")]
#[delete("/list/<id>")]
async fn delete_list(db: &State<Db>, user: User, id: Uuid) -> Rsp<DeleteListResponse> {
    try_check_list!(is_owner(db, &user.id, &id).await);
    let mut tx = try_rsp!(db.begin().await);

    try_rsp!(
        sqlx::query!("DELETE FROM list_sharing WHERE list = $1", id)
            .execute(&mut tx)
            .await
    );
    try_rsp!(
        sqlx::query!("DELETE FROM lists_content WHERE list = $1", id)
            .execute(&mut tx)
            .await
    );
    try_rsp!(
        sqlx::query!("DELETE FROM history WHERE list = $1", id)
            .execute(&mut tx)
            .await
    );
    try_rsp!(
        sqlx::query!("DELETE FROM lists WHERE id = $1", id)
            .execute(&mut tx)
            .await
    );

    try_rsp!(tx.commit().await);

    Rsp::ok(DeleteListResponse {})
}

#[openapi(tag = "KabaList")]
#[post("/register/<id>", data = "<req>")]
async fn register(db: &State<Db>, id: Uuid, req: Json<RegisterRequest>) -> Rsp<RegisterResponse> {
    let mut tx = try_rsp!(db.begin().await);

    let mut is_registered =
        sqlx::query!("SELECT id FROM registrations WHERE id = $1", id).fetch(&mut tx);
    match is_registered.next().await {
        None => return Error::RegistrationDoesNotExist.into(),
        Some(Err(e)) => return e.into(),
        Some(Ok(_)) => (),
    }
    drop(is_registered);

    try_rsp!(
        sqlx::query!(
            r#"INSERT INTO accounts (id, name, password)
               VALUES (uuid_generate_v4(), $1::text::citext, crypt($2, gen_salt('bf')))"#,
            req.username,
            req.password
        )
        .execute(&mut tx)
        .await
    );

    try_rsp!(
        sqlx::query!("DELETE FROM registrations WHERE id = $1", id)
            .execute(&mut tx)
            .await
    );

    try_rsp!(tx.commit().await);

    Rsp::ok(RegisterResponse {})
}

#[openapi(tag = "KabaList")]
#[get("/recover/<id>")]
async fn recovery_info(db: &State<Db>, id: Uuid) -> Rsp<RecoveryInfoResponse> {
    let username = try_rsp!(
        sqlx::query!(
            r#"SELECT accounts.name::text
               FROM password_reset,accounts
               WHERE password_reset.id = $1
                AND password_reset.account = accounts.id"#,
            id
        )
        .fetch_one(&**db)
        .await
    )
    .name;

    match username {
        Some(username) => Rsp::ok(RecoveryInfoResponse { username }),
        None => Error::InvalidRecovery.into(),
    }
}

#[openapi(tag = "KabaList")]
#[post("/recover/<id>", data = "<request>")]
async fn recover_password(
    db: &State<Db>,
    id: Uuid,
    request: Json<RecoverPasswordRequest>,
) -> Rsp<RecoverPasswordResponse> {
    let mut tx = try_rsp!(db.begin().await);

    let account = try_rsp!(
        sqlx::query!(
            "SELECT password_reset.account FROM password_reset WHERE id = $1",
            id
        )
        .fetch_one(&mut tx)
        .await
    )
    .account;

    try_rsp!(
        sqlx::query!("DELETE FROM password_reset WHERE id = $1", id)
            .execute(&mut tx)
            .await
    );
    try_rsp!(
        sqlx::query!(
            "UPDATE accounts SET password = crypt($2, gen_salt('bf')) WHERE id = $1",
            account,
            request.password
        )
        .execute(&mut tx)
        .await
    );

    try_rsp!(tx.commit().await);

    Rsp::ok(RecoverPasswordResponse {})
}

#[openapi(tag = "KabaList")]
#[get("/account/<id>/name")]
async fn get_account_name(db: &State<Db>, _user: User, id: Uuid) -> Rsp<GetAccountNameResponse> {
    let name = try_rsp!(
        sqlx::query!("SELECT name::text FROM accounts WHERE id = $1", id)
            .fetch_one(&**db)
            .await
    )
    .name;

    match name {
        Some(username) => Rsp::ok(GetAccountNameResponse { username }),
        None => Error::AccountNotFound.into(),
    }
}

#[openapi(tag = "KabaList")]
#[put("/public/<id>")]
async fn set_public(db: &State<Db>, id: Uuid, user: User) -> Rsp<SetPublicResponse> {
    try_check_list!(is_owner(db, &user.id, &id).await);

    try_rsp!(
        sqlx::query!("UPDATE lists SET pub = true WHERE id = $1", id)
            .execute(&**db)
            .await
    );

    Rsp::ok(SetPublicResponse {})
}

#[openapi(tag = "KabaList")]
#[delete("/public/<id>")]
async fn remove_public(db: &State<Db>, id: Uuid, user: User) -> Rsp<RemovePublicResponse> {
    try_check_list!(is_owner(db, &user.id, &id).await);

    try_rsp!(
        sqlx::query!("UPDATE lists SET pub = false WHERE id = $1", id)
            .execute(&**db)
            .await
    );

    Rsp::ok(RemovePublicResponse {})
}

#[derive(Responder)]
enum PublicResponse {
    SqlxError(rocket::response::Debug<sqlx::Error>),
    NotFound(rocket::response::status::NotFound<()>),
    Ok(Template),
}

impl OpenApiResponderInner for PublicResponse {
    fn responses(
        gen: &mut rocket_okapi::gen::OpenApiGenerator,
    ) -> rocket_okapi::Result<openapi3::Responses> {
        let err = rocket::response::Debug::<sqlx::Error>::responses(gen)?;
        let not_found = rocket::response::status::NotFound::<()>::responses(gen)?;
        let template = Template::responses(gen)?;

        produce_any_responses(produce_any_responses(err, not_found)?, template)
    }
}

#[derive(Serialize)]
struct PublicResponseCtx {
    items: Vec<(String, Option<String>)>,
}

#[openapi(tag = "KabaList")]
#[get("/public/<id>")]
async fn get_public_list(db: &State<Db>, id: Uuid) -> PublicResponse {
    let pb = match sqlx::query!("SELECT pub FROM lists WHERE id = $1", id)
        .fetch_one(&**db)
        .await
    {
        Ok(v) => v,
        Err(e) => return PublicResponse::SqlxError(e.into()),
    };
    if !pb.r#pub.unwrap_or(false) {
        return PublicResponse::NotFound(rocket::response::status::NotFound(()));
    }

    let contents = match sqlx::query!("SELECT name,amount FROM lists_content WHERE list = $1", id)
        .fetch_all(&**db)
        .await
    {
        Ok(v) => v,
        Err(e) => return PublicResponse::SqlxError(e.into()),
    };
    let contents = PublicResponseCtx {
        items: contents
            .into_iter()
            .map(|row| (row.name, row.amount))
            .collect(),
    };

    PublicResponse::Ok(Template::render("public_list", &contents))
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

struct CORS;

#[rocket::async_trait]
impl fairing::Fairing for CORS {
    fn info(&self) -> fairing::Info {
        fairing::Info {
            name: "CORS headers",
            kind: fairing::Kind::Response,
        }
    }

    async fn on_response<'r>(&self, _req: &'r rocket::Request<'_>, res: &mut rocket::Response<'r>) {
        res.adjoin_header(Header::new("Access-Control-Allow-Origin", "*"));
        res.adjoin_header(Header::new(
            "Access-Control-Allow-Methods",
            "POST, GET, DELETE, PUT, OPTIONS, PATCH",
        ));
        res.adjoin_header(Header::new("Access-Control-Allow-Headers", "*"));
        res.adjoin_header(Header::new("Access-Control-Allow-Credentials", "true"));
    }
}

struct Options;

#[derive(Clone, Copy)]
struct OptionsHandler;

#[rocket::async_trait]
impl rocket::route::Handler for OptionsHandler {
    async fn handle<'r>(
        &self,
        request: &'r rocket::Request<'_>,
        _data: rocket::Data<'r>,
    ) -> rocket::route::Outcome<'r> {
        rocket::route::Outcome::from(request, "")
    }
}

#[rocket::async_trait]
impl fairing::Fairing for Options {
    fn info(&self) -> fairing::Info {
        fairing::Info {
            name: "OPTIONS routes",
            kind: fairing::Kind::Ignite,
        }
    }

    async fn on_ignite(&self, rocket: Rocket<Build>) -> fairing::Result {
        let mut routes = HashMap::new();
        for route in rocket.routes() {
            if !routes.contains_key(route.uri.as_str()) {
                let key = route.uri.as_str().to_owned();
                let mut value = route.clone();
                value.method = rocket::http::Method::Options;
                value.handler = Box::new(OptionsHandler);
                if let Some(name) = &value.name {
                    value.name = Some(("options_".to_string() + name).into());
                }
                routes.insert(key, value);
            }
        }

        Ok(rocket.mount("/", routes.into_iter().map(|(_, v)| v).collect::<Vec<_>>()))
    }
}

#[launch]
fn rocket() -> _ {
    rocket::build()
        .attach(AdHoc::try_on_ignite("SQLx", init_db))
        .attach(AdHoc::config::<Config>())
        .attach(CORS)
        .attach(Options)
        .attach(Template::fairing())
        .mount(
            "/",
            openapi_get_routes![
                login,
                list_lists,
                create_list,
                search_list,
                read_list,
                add_list,
                share_list,
                search_account,
                delete_shares,
                delete_item,
                delete_list,
                update_item,
                register,
                recovery_info,
                recover_password,
                unshare,
                get_shares,
                get_account_name,
                set_public,
                get_public_list,
                remove_public,
                history_search,
            ],
        )
        .mount(
            "/swagger_ui/",
            make_swagger_ui(&SwaggerUIConfig {
                url: "../openapi.json".into(),
                ..Default::default()
            }),
        )
        .mount(
            "/rapidoc/",
            make_rapidoc(&RapiDocConfig {
                general: rapidoc::GeneralConfig {
                    spec_urls: vec![UrlObject::new("General", "../openapi.json")],
                    ..Default::default()
                },
                hide_show: rapidoc::HideShowConfig {
                    allow_spec_url_load: false,
                    allow_spec_file_load: false,
                    ..Default::default()
                },
                ..Default::default()
            }),
        )
}
