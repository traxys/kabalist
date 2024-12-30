use std::{borrow::Cow, collections::HashMap, sync::Arc};

use axum::{
    extract::{self, FromRef, FromRequestParts, Query},
    http::{header::COOKIE, HeaderMap, HeaderValue, StatusCode},
    response::{IntoResponse, Redirect},
    routing::get,
    Extension, Router,
};
use axum_extra::extract::{
    cookie::{Cookie, Key, SameSite},
    CookieJar, PrivateCookieJar,
};
use color_eyre::eyre::{self, eyre, ContextCompat, WrapErr};
use kabalist_types::GetAccountNameResponse;
use openidconnect::{
    AuthorizationCode, CsrfToken, Nonce, OAuth2TokenResponse, PkceCodeChallenge, PkceCodeVerifier,
    RedirectUrl, Scope, UserInfoClaims,
};
use sqlx::PgPool;
use tracing::*;
use uuid::Uuid;

use crate::{ErrResponse, Error, OkGetAccountNameResponse, OkResponse, Rsp};

#[derive(Clone, Debug)]
pub struct Oauth2Client {
    config: Arc<crate::config::Config>,
    oauth2: Arc<openidconnect::core::CoreClient>,
    key: Key,
}

impl FromRef<Oauth2Client> for Key {
    fn from_ref(state: &Oauth2Client) -> Self {
        state.key.clone()
    }
}

pub(crate) fn router() -> Router {
    Router::new()
        .route("/{id}/name", get(get_account_name))
        .route("/login", get(oauth2_login))
        .route("/callback", get(oauth2_callback))
        .route("/callback/mobile", get(oauth2_callback_mobile))
}

impl Oauth2Client {
    pub(crate) async fn from_config(
        config: Arc<crate::config::Config>,
    ) -> color_eyre::Result<Self> {
        let client_metadata = openidconnect::core::CoreProviderMetadata::discover_async(
            openidconnect::IssuerUrl::from_url(config.oauth_issuer.clone()),
            openidconnect::reqwest::async_http_client,
        )
        .await?;
        let client = openidconnect::core::CoreClient::from_provider_metadata(
            client_metadata,
            openidconnect::ClientId::new(config.oauth_id.clone()),
            Some(openidconnect::ClientSecret::new(
                config.oauth_secret.clone(),
            )),
        )
        .set_redirect_uri(openidconnect::RedirectUrl::new(
            config.oauth_redirect.clone(),
        )?);

        Ok(Self {
            key: Key::from(config.cookie_secret.0.as_slice()),
            oauth2: Arc::new(client),
            config,
        })
    }
}

async fn oauth2_login(
    Extension(state): Extension<Oauth2Client>,
    hmap: HeaderMap,
    query: Query<HashMap<String, Option<String>>>,
) -> Result<(PrivateCookieJar, Redirect), StatusCode> {
    let jar = PrivateCookieJar::from_headers(&hmap, state.key.clone());
    let (challenge, result) = PkceCodeChallenge::new_random_sha256();

    let mobile = query.contains_key("mobile");

    let (url, _csrf, _nonce) = state
        .oauth2
        .authorize_url(
            openidconnect::AuthenticationFlow::<openidconnect::core::CoreResponseType>::AuthorizationCode,
            CsrfToken::new_random,
            Nonce::new_random,
        )
        .set_pkce_challenge(challenge)
        .add_scope(Scope::new("email".to_string()))
        .add_scope(Scope::new("profile".to_string()))
        .set_redirect_uri(Cow::Owned(
            RedirectUrl::new(if !mobile {
                    state.config.oauth_redirect.clone()
            } else {state.config.oauth_redirect_mobile.clone()})
                .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?,
        ))
        .url();

    Ok((
        jar.add(Cookie::new("pkce", result.secret().clone())),
        Redirect::to(url.as_str()),
    ))
}

async fn oauth2_callback(
    Extension(state): Extension<Oauth2Client>,
    Extension(db): Extension<PgPool>,
    Query(params): Query<HashMap<String, String>>,
    hmap: HeaderMap,
) -> Result<impl IntoResponse, StatusCode> {
    let jar = PrivateCookieJar::from_headers(&hmap, state.key.clone());
    let inner = || async {
        let Some(code) = params.get("code") else {
            warn!("oauth2 callback no code querystring");
            return Ok::<_, color_eyre::eyre::Report>((jar, Redirect::to("/")));
        };
        let bearer = state
            .oauth2
            .exchange_code(AuthorizationCode::new(code.to_string()))
            .set_pkce_verifier(PkceCodeVerifier::new(
                jar.get("pkce")
                    .map(|c| c.value().to_string())
                    .wrap_err("no pkce")?,
            ))
            .request_async(openidconnect::reqwest::async_http_client)
            .await
            .wrap_err("get token error")?;
        let rtok = bearer.access_token();
        let userinfo: UserInfoClaims<
            openidconnect::EmptyAdditionalClaims,
            openidconnect::core::CoreGenderClaim,
        > = state
            .oauth2
            .user_info(rtok.clone(), None)?
            .request_async(openidconnect::reqwest::async_http_client)
            .await?;

        let uuid = get_uuid_for_mail(
            userinfo
                .preferred_username()
                .ok_or_else(|| eyre!("missing preferred username"))?
                .as_str()
                .to_string(),
            userinfo
                .name()
                .ok_or_else(|| eyre!("missing preferred username"))?
                .get(None)
                .ok_or_else(|| eyre!("missing preferred username"))?
                .as_str()
                .to_string(),
            db,
        )
        .await?;

        let mut cookie = Cookie::new("user", uuid.to_string());
        cookie.set_same_site(SameSite::Lax);
        cookie.set_secure(false);
        cookie.set_path("/");

        eyre::Result::Ok((jar.add(cookie), Redirect::to("/")))
    };
    match inner().await {
        Ok(ret) => Ok(ret),
        Err(e) => {
            error!("Oauth2 Callback Error: {:?}", e);
            Err(StatusCode::INTERNAL_SERVER_ERROR)
        }
    }
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
pub async fn get_account_name(
    Extension(db): Extension<PgPool>,
    _user: User,
    extract::Path(id): extract::Path<Uuid>,
) -> Rsp<GetAccountNameResponse> {
    let name = sqlx::query!("SELECT name::text FROM accounts WHERE id = $1", id)
        .fetch_one(&db)
        .await?
        .name;

    match name {
        Some(username) => OkResponse::ok(GetAccountNameResponse { username }),
        None => Err(Error::AccountNotFound),
    }
}

async fn oauth2_callback_mobile(
    Extension(state): Extension<Oauth2Client>,
    Extension(db): Extension<PgPool>,
    Query(params): Query<HashMap<String, String>>,
    hmap: HeaderMap,
) -> Result<impl IntoResponse, StatusCode> {
    // We basically want to do the same stuff as [`oauth2_callback`] function, but redirect to
    // another uri with the encrypted token. This delegate the logic portion to the function and
    // just extract the cookie we want
    let raw_rsp = oauth2_callback(
        Extension(state.clone()),
        Extension(db.clone()),
        Query(params),
        hmap,
    )
    .await?;

    let rsp = raw_rsp.into_response();
    let user_set_cookie = rsp.headers().get("set-cookie").unwrap().to_str().unwrap();

    let mut headermap = HeaderMap::new();
    headermap.append(COOKIE, HeaderValue::from_str(user_set_cookie).unwrap());
    let cookie_jar = CookieJar::from_headers(&headermap);
    eyre::Result::Ok(Redirect::to(&format!(
        "kabalist://auth?{}",
        cookie_jar.get("user").unwrap()
    )))
}

async fn get_uuid_for_mail(mail: String, name: String, database: PgPool) -> eyre::Result<Uuid> {
    let uuid = sqlx::query!(
        "SELECT mail_to_uuid.account FROM mail_to_uuid WHERE mail_to_uuid.mail = $1",
        mail
    )
    .map(|r| r.account)
    .fetch_optional(&database)
    .await?
    .flatten();

    if let Some(uuid) = uuid {
        // the user exists, just return that
        return Ok(uuid);
    }
    let mut tx = database.begin().await?;
    info!("creating a user for mail='{mail}' name='{name}'");
    let db_uuid = sqlx::query!(
        r#"INSERT INTO accounts (id, name, password)
           VALUES (uuid_generate_v4(), 
                   $1::text::citext, 
                   crypt('', gen_salt('bf')))
           RETURNING id"#,
        name,
    )
    .map(|r| r.id)
    .fetch_one(&mut *tx)
    .await?;
    sqlx::query!(
        "INSERT INTO mail_to_uuid (id, mail, account) VALUES (uuid_generate_v4(), $1, $2)",
        mail,
        db_uuid,
    )
    .execute(&mut *tx)
    .await?;

    tx.commit().await?;

    Ok(db_uuid)
}

#[derive(Debug, Clone)]
pub struct User {
    pub id: uuid::Uuid,
}

impl<S: Send + Sync> FromRequestParts<S> for User {
    type Rejection = StatusCode;

    async fn from_request_parts(
        parts: &mut axum::http::request::Parts,
        state: &S,
    ) -> Result<Self, Self::Rejection> {
        let hmap = HeaderMap::from_request_parts(parts, state)
            .await
            .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
        let Extension(s): Extension<Oauth2Client> = Extension::from_request_parts(parts, state)
            .await
            .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;

        let jar = PrivateCookieJar::from_headers(dbg!(&hmap), s.key.clone());
        let uuid_raw = jar
            .get("user")
            .map(|c| c.value().to_string())
            .ok_or(StatusCode::BAD_REQUEST)?;

        let uuid = Uuid::parse_str(uuid_raw.as_str()).map_err(|_| StatusCode::UNAUTHORIZED)?;
        Ok(User { id: uuid })
    }
}
