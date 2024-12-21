use axum::Redirect;

async fn oauth2_login(State(state): State<AppState>) -> Result<Redirect, StatusCode> {
    Ok(Redirect::to(
        &(state
            .oauth
            .get_auth_url()
            .await
            .map_err(|e| {
                error!("{e}");
                StatusCode::INTERNAL_SERVER_ERROR
            })?
            .to_string()),
    ))
}

#[axum::debug_handler]
async fn oauth2_callback(
    State(state): State<AppState>,
    Query(params): Query<HashMap<String, String>>,
    jar: PrivateCookieJar,
) -> Result<impl IntoResponse, StatusCode> {
    let inner = || async {
        let Some(code) = params.get("code") else {
            info!();
            return Ok::<_, color_eyre::eyre::Report>((jar, Redirect::to("/")));
        };
        let Some(state_csrf) = params.get("state") else {
            return Ok((jar, Redirect::to("/")));
        };
        let token = state
            .oauth
            .get_user_token(code, state_csrf)
            .await
            .wrap_err("callback")?;

        let res: User42 = state
            .oauth
            .do_request(
                "https://api.intra.42.fr/v2/me",
                &[] as &[(String, String); 0],
                Some(&token),
            )
            .await
            .wrap_err("Unable to get user self")?;

        let mut cookie = Cookie::new("token", res.id.to_string());
        cookie.set_same_site(SameSite::None);
        cookie.set_secure(false);
        cookie.set_path("/");
        // cookie.set_domain("localhost:3000");
        // cookie.set_http_only(Some(false));
        let ujar = jar.add(cookie);
        Ok((ujar, Redirect::to("/")))
    };
    match inner().await {
        Ok(ret) => Ok(ret),
        Err(e) => {
            error!("{:?}", e);
            Err(StatusCode::INTERNAL_SERVER_ERROR)
        }
    }
}
