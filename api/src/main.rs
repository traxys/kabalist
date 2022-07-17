use std::{net::SocketAddr, sync::Arc};

use axum::{
    extract::{self, Query},
    http::{header, HeaderValue, Method, StatusCode},
    response::IntoResponse,
    routing::get,
    Extension, Json, Router,
};
use figment::{
    providers::{self, Format},
    Figment,
};
use kabalist_types::{uuid::Uuid, *};
use serde::{Deserialize, Serialize};
use serde_repr::{Deserialize_repr, Serialize_repr};
use sqlx::{postgres::PgPoolOptions, PgPool};
use tokio_stream::StreamExt;
use tower_http::cors::CorsLayer;
use utoipa::{
    openapi::security::{self, SecurityScheme},
    Component, Modify, OpenApi,
};
use utoipa_swagger_ui::SwaggerUi;

mod account;
mod config;
mod list;
mod pantry;
mod share;

pub(crate) use account::User;

macro_rules! define_error {
    (
    pub enum Error {
        $(
            $variant:ident = { description: $description:literal, code: $code:literal, status: $status:expr $(,)?}
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

        impl Component for Error {
           fn component() -> utoipa::openapi::schema::Component {
               utoipa::openapi::PropertyBuilder::new()
                   .component_type(utoipa::openapi::ComponentType::Number)
                   .enum_values(Some([$(stringify!($code),)*]))
                   .build()
                   .into()
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
            fn status(&self) -> StatusCode {
                match self {
                $(
                    Self::$variant => $status,
                )*
                }
            }
        }
    };
}

define_error! {
    pub enum Error {
        Internal = {
            description: "internal error",
            code: 0,
            status: StatusCode::INTERNAL_SERVER_ERROR,
        },
        ListAlreadyExists = {
            description: "list already exists",
            code: 1,
            status: StatusCode::BAD_REQUEST,
        },
        UnknownAccount = {
            description: "unkown account",
            code: 2,
            status: StatusCode::NOT_FOUND,
        },
        NoSuchList = {
            description: "no such list",
            code: 3,
            status: StatusCode::NOT_FOUND,
        },
        NotWritable = {
            description: "list is not writable",
            code: 4,
            status: StatusCode::BAD_REQUEST,
        },
        RegistrationDoesNotExist = {
            description: "registration does not exist",
            code: 5,
            status: StatusCode::NOT_FOUND,
        },
        InvalidRecovery = {
            description: "recovery does not exists",
            code: 6,
            status: StatusCode::NOT_FOUND,
        },
        AccountNotFound = {
            description: "account not found",
            code: 7,
            status: StatusCode::NOT_FOUND,
        },
        MissingAuthorization = {
            description: "token is missing",
            code: 8,
            status: StatusCode::BAD_REQUEST,
        },
        InvalidToken = {
            description: "token is invalid",
            code: 10,
            status: StatusCode::BAD_REQUEST,
        },
        TokenExpired = {
            description: "token has expired",
            code: 9,
            status: StatusCode::UNAUTHORIZED,
        },
    }
}

impl From<sqlx::Error> for Error {
    fn from(e: sqlx::Error) -> Self {
        tracing::error!("Database error: {:?}", e);
        Error::Internal
    }
}

impl From<jsonwebtoken::errors::Error> for Error {
    fn from(e: jsonwebtoken::errors::Error) -> Self {
        tracing::error!("Could not create JWT: {:?}", e);
        Error::Internal
    }
}

#[derive(Serialize, Deserialize, Component)]
#[aliases(
    OkLoginResponse = OkResponse<LoginResponse>,
    OkCreateListResponse = OkResponse<CreateListResponse>,
    OkGetListsResponse = OkResponse<GetListsResponse>,
    OkSearchAccountResponse = OkResponse<SearchAccountResponse>,
    OkReadListResponse = OkResponse<ReadListResponse>,
    OkAddToListResponse = OkResponse<AddToListResponse>,
    OkGetHistoryResponse = OkResponse<GetHistoryResponse>,
    OkUpdateItemResponse = OkResponse<UpdateItemResponse>,
    OkDeleteItemResponse = OkResponse<DeleteItemResponse>,
    OkDeleteListResponse = OkResponse<DeleteListResponse>,
    OkUnshareResponse = OkResponse<UnshareResponse>,
    OkGetSharesResponse = OkResponse<GetSharesResponse>,
    OkShareListResponse = OkResponse<ShareListResponse>,
    OkDeleteShareResponse = OkResponse<DeleteShareResponse>,
    OkRecoveryInfoResponse = OkResponse<RecoveryInfoResponse>,
    OkRecoverPasswordResponse = OkResponse<RecoverPasswordResponse>,
    OkRegisterResponse = OkResponse<RegisterResponse>,
    OkGetAccountNameResponse = OkResponse<GetAccountNameResponse>,
    OkSetPublicResponse = OkResponse<SetPublicResponse>,
    OkRemovePublicResponse = OkResponse<RemovePublicResponse>,
    OkGetPantryResponse = OkResponse<GetPantryResponse>,
    OkAddToPantryResponse = OkResponse<AddToPantryResponse>,
    OkRefillPantryResponse = OkResponse<RefillPantryResponse>,
)]
struct OkResponse<T> {
    ok: T,
}

impl<T> OkResponse<T> {
    fn ok(v: T) -> Rsp<T> {
        Ok(Json(Self { ok: v }))
    }
}

#[derive(Serialize, Deserialize, Component)]
struct ErrResponse {
    err: UserError,
}

type Rsp<T> = Result<Json<OkResponse<T>>, Error>;

#[derive(Serialize, Deserialize, Component)]
struct UserError {
    code: Error,
    description: String,
}

impl IntoResponse for Error {
    fn into_response(self) -> axum::response::Response {
        (self.status(), Json(self.into_err())).into_response()
    }
}

async fn is_owner(db: &PgPool, user_id: Uuid, list_id: Uuid) -> Result<(), Error> {
    let has_list = sqlx::query!(
        "SELECT COUNT(*) FROM lists WHERE owner = $1 AND id = $2",
        user_id,
        list_id
    )
    .fetch_one(db)
    .await?;

    match has_list.count {
        Some(0) | None => Err(Error::NoSuchList),
        _ => Ok(()),
    }
}

async fn check_list(db: &PgPool, user_id: Uuid, list_id: Uuid, write: bool) -> Result<(), Error> {
    if is_owner(db, user_id, list_id).await.is_ok() {
        return Ok(());
    }

    let mut shared_status = sqlx::query!(
        "SELECT readonly FROM list_sharing WHERE list = $1 AND shared = $2",
        list_id,
        user_id
    )
    .fetch(db);

    match shared_status
        .next()
        .await
        .map(|r| r.map(|row| row.readonly))
    {
        Some(Ok(true)) if write => Err(Error::NotWritable),
        Some(Ok(_)) => Ok(()),
        Some(Err(e)) => Err(e.into()),
        None => Err(Error::NoSuchList),
    }
}

#[utoipa::path(
    get,
    path = "/api/search/list/{name}",
    responses(
        (status = 200, description = "Lists", body = OkGetListsResponse),
        (status = 400, description = "Invalid request", body = ErrResponse),
        (status = 500, description = "Internal Error", body = ErrResponse),
    ),
    params(
        ("name" = String, Path, description = "Part of the list name"),
    ),
    security(
        ("token" = [])
    )
)]
#[tracing::instrument(skip(db))]
async fn search_list(
    Extension(db): Extension<PgPool>,
    user: User,
    extract::Path(name): extract::Path<String>,
) -> Rsp<GetListsResponse> {
    let results_owned = sqlx::query!(
        "SELECT name, id, pub FROM lists WHERE owner = $1 AND name ILIKE '%' || $2 || '%'",
        user.id,
        name
    )
    .fetch_all(&db)
    .await?;

    let results_shared = sqlx::query!(
        r#"SELECT name, id, readonly, pub
               FROM lists, list_sharing
               WHERE (lists.id = list_sharing.list)
                   AND shared = $1
                   AND name ILIKE '%' || $2 || '%'"#,
        user.id,
        name
    )
    .fetch_all(&db)
    .await?;

    OkResponse::ok(GetListsResponse {
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

#[utoipa::path(
    get,
    path = "/api/search/account/{name}",
    responses(
        (status = 200, description = "Account ID", body = OkSearchAccountResponse),
        (status = 400, description = "Invalid request", body = ErrResponse),
        (status = 500, description = "Internal Error", body = ErrResponse),
    ),
    params(
        ("name" = String, Path, description = "Account name"),
    ),
    security(
        ("token" = [])
    )
)]
#[tracing::instrument(skip(db))]
async fn search_account(
    Extension(db): Extension<PgPool>,
    _user: User,
    extract::Path(name): extract::Path<String>,
) -> Rsp<SearchAccountResponse> {
    let result = sqlx::query!(
        "SELECT id FROM accounts WHERE name ILIKE $1::text::citext",
        name
    )
    .fetch_one(&db)
    .await?;

    OkResponse::ok(SearchAccountResponse { id: result.id })
}

#[derive(Deserialize, Component, Debug)]
struct SearchQuery {
    search: String,
}

#[utoipa::path(
    get,
    path = "/api/history/{list}",
    responses(
        (status = 200, description = "Account ID", body = OkGetHistoryResponse),
        (status = 400, description = "Invalid request", body = ErrResponse),
        (status = 500, description = "Internal Error", body = ErrResponse),
    ),
    params(
        ("list" = Uuid, Path, description = "List ID"),
        ("search" = Option<String>, Query, description = "Substring Search")
    ),
    security(
        ("token" = [])
    )
)]
#[tracing::instrument(skip(db))]
async fn history_search(
    Extension(db): Extension<PgPool>,
    user: User,
    extract::Path(list): extract::Path<Uuid>,
    search: Option<Query<SearchQuery>>,
) -> Rsp<GetHistoryResponse> {
    let results =
        sqlx::query!(
            "SELECT name::text FROM history WHERE list = $1 AND creator = $2 AND name ILIKE '%' || $3 || '%'",
            list,
            user.id,
            search.as_ref().map(|Query(q)| -> &str { &q.search }).unwrap_or(""),
        )
        .fetch_all(&db)
        .await?;

    OkResponse::ok(GetHistoryResponse {
        matches: results.into_iter().filter_map(|row| row.name).collect(),
    })
}

#[tokio::main]
async fn main() -> color_eyre::Result<()> {
    color_eyre::install()?;
    tracing_subscriber::fmt::init();

    let config: Arc<config::Config> = Arc::new(
        Figment::from(providers::Serialized::defaults(config::Config::default()))
            .merge(providers::Toml::file("KabaList.toml"))
            .merge(providers::Env::prefixed("KABALIST_"))
            .extract()?,
    );

    tracing::info!("Starting with config: {:#?}", config);

    let addr = SocketAddr::from((config.listen_addr, config.port));

    #[derive(OpenApi)]
    #[openapi(
        handlers(
            search_list,
            search_account,
            history_search,
            list::create_list,
            list::update_item,
            list::delete_item,
            list::list_lists,
            list::read_list,
            list::add_list,
            list::delete_list,
            list::set_public,
            list::remove_public,
            list::get_public_list,
            account::login,
            account::register,
            account::recovery_info,
            account::recover_password,
            account::get_account_name,
            share::delete_shares,
            share::unshare,
            share::get_shares,
            share::share_list,
            pantry::get_pantry,
            pantry::add_to_pantry,
            pantry::refill_pantry,
        ),
        components(
            ErrResponse,
            UserError,
            Error,
            SecretString,
            LoginRequest,
            LoginResponse,
            OkLoginResponse, // Imports all other OkResponses
            CreateListRequest,
            CreateListResponse,
            OkCreateListResponse,
            GetListsResponse,
            ListInfo,
            ListStatus,
            SearchAccountResponse,
            Item,
            ReadListResponse,
            AddToListResponse,
            AddToListRequest,
            GetHistoryResponse,
            UpdateItemRequest,
            UpdateItemResponse,
            DeleteItemResponse,
            DeleteListResponse,
            UnshareResponse,
            GetSharesResponse,
            ShareListRequest,
            ShareListResponse,
            DeleteShareResponse,
            RecoveryInfoResponse,
            RecoverPasswordRequest,
            RecoverPasswordResponse,
            RegisterRequest,
            RegisterResponse,
            GetAccountNameResponse,
            RemovePublicResponse,
            SetPublicResponse,
            PantryItem,
            GetPantryResponse,
            AddToPantryRequest,
            AddToPantryResponse,
            RefillPantryResponse,
        ),
        modifiers(&SecurityKey),
    )]
    struct ApiDoc;

    struct SecurityKey;

    impl Modify for SecurityKey {
        fn modify(&self, openapi: &mut utoipa::openapi::OpenApi) {
            if let Some(components) = openapi.components.as_mut() {
                components.add_security_scheme(
                    "token",
                    SecurityScheme::Http(security::Http::new(security::HttpAuthScheme::Bearer)),
                )
            }
        }
    }

    let db = PgPoolOptions::new().connect(&config.database_url).await?;

    let templates = tera::Tera::new("public/*.tera")?;

    let api = Router::new()
        .route("/search/list/:name", get(search_list))
        .route("/search/account/:name", get(search_account))
        .route("/history/:id", get(history_search))
        .nest("/list", list::router())
        .nest("/share", share::router())
        .nest("/account", account::router())
        .nest("/pantry", pantry::router());

    #[cfg(feature = "frontend")]
    let frontend = config.frontend.clone();

    let app = Router::new()
        .merge(SwaggerUi::new("/swagger-ui/*tail").url("/api-doc/openapi.json", ApiDoc::openapi()))
        .nest("/api", api)
        .layer(Extension(templates))
        .layer(Extension(config))
        .layer(Extension(db))
        .layer(
            CorsLayer::new()
                .allow_origin("*".parse::<HeaderValue>().unwrap())
                .allow_headers([header::CONTENT_TYPE, header::AUTHORIZATION])
                .allow_methods([
                    Method::GET,
                    Method::PATCH,
                    Method::POST,
                    Method::DELETE,
                    Method::PUT,
                ]),
        );

    #[cfg(feature = "frontend")]
    let app = match frontend {
        None => app,
        Some(mut p) => {
            use axum::routing::get_service;

            async fn handle_error(err: std::io::Error) -> impl IntoResponse {
                tracing::error!("File serving error: {:?}", err);
                (StatusCode::INTERNAL_SERVER_ERROR, "Something went wrong...")
            }

            app.fallback(
                get_service(tower_http::services::ServeDir::new(&p).fallback(
                    tower_http::services::ServeFile::new({
                        p.push("index.html");
                        p
                    }),
                ))
                .handle_error(handle_error),
            )
        }
    };

    axum::Server::bind(&addr)
        .serve(app.into_make_service())
        .await
        .map_err(Into::into)
}
