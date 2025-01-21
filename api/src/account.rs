use std::{sync::Arc, time::Duration};

use axum::{
    extract::{self, FromRequestParts},
    http::request::Parts,
    routing::{get, post},
    Json, Router,
};
use axum_extra::{
    headers::{authorization::Bearer, Authorization},
    TypedHeader,
};
use jwt_simple::prelude::{Claims, MACLike, NoCustomClaims};
use kabalist_types::{
    GetAccountNameResponse, LoginRequest, LoginResponse, RecoverPasswordRequest,
    RecoverPasswordResponse, RecoveryInfoResponse, RegisterRequest, RegisterResponse,
};
use tokio_stream::StreamExt;
use uuid::Uuid;

use crate::{ok_response::*, ErrResponse, Error, KabalistState, OkResponse, Rsp, State};

#[derive(Debug)]
pub(crate) struct User {
    pub id: Uuid,
}

impl FromRequestParts<Arc<KabalistState>> for User {
    type Rejection = Error;

    async fn from_request_parts(
        parts: &mut Parts,
        state: &Arc<KabalistState>,
    ) -> Result<Self, Self::Rejection> {
        let TypedHeader(Authorization(bearer)) =
            TypedHeader::<Authorization<Bearer>>::from_request_parts(parts, state)
                .await
                .map_err(|_| Error::MissingAuthorization)?;

        let claims = state
            .config
            .jwt_secret
            .0
            .verify_token::<NoCustomClaims>(bearer.token(), None)?;

        Ok(User {
            /* We control the subject, so we are sure that we set it to an uuid */
            id: claims.subject.unwrap().parse().unwrap(),
        })
    }
}

pub(crate) fn router() -> Router<Arc<KabalistState>> {
    Router::new()
        .route("/login", post(login))
        .route("/register/{id}", post(register))
        .route("/recover/{id}", get(recovery_info).post(recover_password))
        .route("/{id}/name", get(get_account_name))
}

/// Generate a JWT in order to use the other routes
#[utoipa::path(
    post,
    path = "/api/account/login",
    responses(
        (status = 200, description = "JWT", body = OkLoginResponse),
        (status = 404, description = "Unknown Account", body = ErrResponse),
        (status = 500, description = "Internal Error", body = ErrResponse),
    ),
    request_body = LoginRequest,
)]
#[tracing::instrument(skip(state))]
async fn login(state: State, Json(request): Json<LoginRequest>) -> Rsp<LoginResponse> {
    let mut rsp = sqlx::query!(
        "SELECT id FROM accounts WHERE name = $1::text::citext AND password = crypt($2, password)",
        request.username,
        request.password.0,
    )
    .fetch(&state.0.pool);

    let id = match rsp.next().await {
        None => return Err(Error::UnknownAccount),
        Some(Err(e)) => return Err(e.into()),
        Some(Ok(id)) => id.id,
    };

    let mut claims = Claims::create(Duration::from_millis(state.0.config.exp as _).into());
    claims.subject = Some(id.to_string());

    let token = state.0.config.jwt_secret.0.authenticate(claims)?;

    OkResponse::ok(LoginResponse { token })
}

#[utoipa::path(
    post,
    path = "/api/account/register/{id}",
    responses(
        (status = 200, description = "Register Information", body = OkRegisterResponse),
        (status = 404, description = "Unknown Account", body = ErrResponse),
        (status = 500, description = "Internal Error", body = ErrResponse),
    ),
    params(
        ("id" = Uuid, Path, description = "Registration ID"),
    ),
    request_body = RegisterRequest,
)]
#[tracing::instrument(skip(state))]
async fn register(
    state: State,
    extract::Path(id): extract::Path<Uuid>,
    Json(req): Json<RegisterRequest>,
) -> Rsp<RegisterResponse> {
    let mut tx = state.0.pool.begin().await?;

    let mut is_registered =
        sqlx::query!("SELECT id FROM registrations WHERE id = $1", id).fetch(&mut *tx);
    match is_registered.next().await {
        None => return Err(Error::RegistrationDoesNotExist),
        Some(Err(e)) => return Err(e.into()),
        Some(Ok(_)) => (),
    }
    drop(is_registered);

    sqlx::query!(
        r#"INSERT INTO accounts (id, name, password)
               VALUES (uuid_generate_v4(), $1::text::citext, crypt($2, gen_salt('bf')))"#,
        req.username,
        req.password
    )
    .execute(&mut *tx)
    .await?;

    sqlx::query!("DELETE FROM registrations WHERE id = $1", id)
        .execute(&mut *tx)
        .await?;

    tx.commit().await?;

    OkResponse::ok(RegisterResponse {})
}

#[utoipa::path(
    get,
    path = "/api/account/recover/{id}",
    responses(
        (status = 200, description = "Recovery Information", body = OkRecoveryInfoResponse),
        (status = 404, description = "Unknown Account", body = ErrResponse),
        (status = 500, description = "Internal Error", body = ErrResponse),
    ),
    params(
        ("id" = Uuid, Path, description = "Recovery ID"),
    ),
)]
#[tracing::instrument(skip(state))]
async fn recovery_info(
    state: State,
    extract::Path(id): extract::Path<Uuid>,
) -> Rsp<RecoveryInfoResponse> {
    let username = sqlx::query!(
        r#"SELECT accounts.name::text
               FROM password_reset,accounts
               WHERE password_reset.id = $1
                AND password_reset.account = accounts.id"#,
        id
    )
    .fetch_one(&state.0.pool)
    .await?
    .name;

    match username {
        Some(username) => OkResponse::ok(RecoveryInfoResponse { username }),
        None => Err(Error::InvalidRecovery),
    }
}

#[utoipa::path(
    post,
    path = "/api/account/recover/{id}",
    responses(
        (status = 200, description = "Recovery Information", body = OkRecoverPasswordResponse),
        (status = 404, description = "Unknown Account", body = ErrResponse),
        (status = 500, description = "Internal Error", body = ErrResponse),
    ),
    params(
        ("id" = Uuid, Path, description = "Recovery ID"),
    ),
    request_body = RecoverPasswordRequest
)]
async fn recover_password(
    state: State,
    extract::Path(id): extract::Path<Uuid>,
    Json(request): Json<RecoverPasswordRequest>,
) -> Rsp<RecoverPasswordResponse> {
    let mut tx = state.0.pool.begin().await?;

    let account = sqlx::query!(
        "SELECT password_reset.account FROM password_reset WHERE id = $1",
        id
    )
    .fetch_one(&mut *tx)
    .await?
    .account;

    sqlx::query!("DELETE FROM password_reset WHERE id = $1", id)
        .execute(&mut *tx)
        .await?;
    sqlx::query!(
        "UPDATE accounts SET password = crypt($2, gen_salt('bf')) WHERE id = $1",
        account,
        request.password
    )
    .execute(&mut *tx)
    .await?;

    tx.commit().await?;

    OkResponse::ok(RecoverPasswordResponse {})
}

#[utoipa::path(
    get,
    path = "/api/account/{id}/name",
    responses(
        (status = 200, description = "Account Name", body = OkGetAccountNameResponse),
        (status = 404, description = "Unknown Account", body = ErrResponse),
        (status = 500, description = "Internal Error", body = ErrResponse),
    ),
    params(
        ("id" = Uuid, Path, description = "Account ID"),
    ),
    security(
        ("token" = [])
    )
)]
async fn get_account_name(
    state: State,
    _user: User,
    extract::Path(id): extract::Path<Uuid>,
) -> Rsp<GetAccountNameResponse> {
    let name = sqlx::query!("SELECT name::text FROM accounts WHERE id = $1", id)
        .fetch_one(&state.0.pool)
        .await?
        .name;

    match name {
        Some(username) => OkResponse::ok(GetAccountNameResponse { username }),
        None => Err(Error::AccountNotFound),
    }
}
