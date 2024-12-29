use axum::{
    extract,
    routing::{delete, get},
    Extension, Json, Router,
};
use kabalist_types::{
    DeleteShareResponse, GetSharesResponse, ShareListRequest, ShareListResponse, UnshareResponse,
};
use sqlx::PgPool;
use uuid::Uuid;

use crate::{account::User, check_list, is_owner, ok_response::*, ErrResponse, OkResponse, Rsp};

pub(crate) fn router() -> Router {
    Router::new()
        .route(
            "/:id",
            get(get_shares).put(share_list).delete(delete_shares),
        )
        .route("/:id/:account", delete(unshare))
}

#[utoipa::path(
    get,
    path = "/api/share/{id}",
    responses(
        (status = 200, description = "Shared list", body = OkGetSharesResponse),
        (status = 400, description = "Invalid request", body = ErrResponse),
        (status = 500, description = "Internal Error", body = ErrResponse),
    ),
    params(
        ("id" = Uuid, Path, description = "List ID"),
    ),
    security(
        ("token" = [])
    )
)]
#[tracing::instrument(skip(db))]
async fn get_shares(
    Extension(db): Extension<PgPool>,
    user: User,
    extract::Path(id): extract::Path<Uuid>,
) -> Rsp<GetSharesResponse> {
    check_list(&db, user.id, id, true).await?;

    let shared = sqlx::query!(
        "SELECT shared, readonly FROM list_sharing WHERE list = $1",
        id
    )
    .fetch_all(&db)
    .await?;

    OkResponse::ok(GetSharesResponse {
        public_link: None,
        shared_with: shared
            .into_iter()
            .map(|row| (row.shared, row.readonly))
            .collect(),
    })
}

#[utoipa::path(
    put,
    path = "/api/share/{id}",
    responses(
        (status = 200, description = "Shared list", body = OkShareListResponse),
        (status = 400, description = "Invalid request", body = ErrResponse),
        (status = 500, description = "Internal Error", body = ErrResponse),
    ),
    request_body = ShareListRequest,
    params(
        ("id" = Uuid, Path, description = "List ID"),
    ),
    security(
        ("token" = [])
    )
)]
#[tracing::instrument(skip(db))]
async fn share_list(
    Extension(db): Extension<PgPool>,
    user: User,
    extract::Path(id): extract::Path<Uuid>,
    Json(request): Json<ShareListRequest>,
) -> Rsp<ShareListResponse> {
    check_list(&db, user.id, id, true).await?;

    sqlx::query!(
        r#"
            INSERT INTO list_sharing (list, shared, readonly)
            VALUES ($1, $2, $3) ON CONFLICT DO NOTHING"#,
        id,
        request.share_with,
        request.readonly
    )
    .execute(&db)
    .await?;

    OkResponse::ok(ShareListResponse {})
}

#[utoipa::path(
    delete,
    path = "/api/share/{id}/{account}",
    responses(
        (status = 200, description = "Shared list", body = OkUnshareResponse),
        (status = 400, description = "Invalid request", body = ErrResponse),
        (status = 500, description = "Internal Error", body = ErrResponse),
    ),
    params(
        ("id" = Uuid, Path, description = "List ID"),
        ("account" = Uuid, Path, description = "Account ID"),
    ),
    security(
        ("token" = [])
    )
)]
#[tracing::instrument(skip(db))]
async fn unshare(
    Extension(db): Extension<PgPool>,
    user: User,
    extract::Path((list, account)): extract::Path<(Uuid, Uuid)>,
) -> Rsp<UnshareResponse> {
    is_owner(&db, user.id, list).await?;

    let mut tx = db.begin().await?;

    sqlx::query!(
        "DELETE FROM list_sharing WHERE list = $1 AND shared = $2",
        list,
        account
    )
    .execute(&mut *tx)
    .await?;

    sqlx::query!(
        "DELETE FROM history WHERE list = $1 AND creator = $2",
        list,
        account
    )
    .execute(&mut *tx)
    .await?;

    tx.commit().await?;

    OkResponse::ok(UnshareResponse {})
}

#[utoipa::path(
    delete,
    path = "/api/share/{id}",
    responses(
        (status = 200, description = "Shared list", body = OkDeleteShareResponse),
        (status = 400, description = "Invalid request", body = ErrResponse),
        (status = 500, description = "Internal Error", body = ErrResponse),
    ),
    params(
        ("id" = Uuid, Path, description = "List ID"),
    ),
    security(
        ("token" = [])
    )
)]
async fn delete_shares(
    Extension(db): Extension<PgPool>,
    user: User,
    extract::Path(id): extract::Path<Uuid>,
) -> Rsp<DeleteShareResponse> {
    is_owner(&db, user.id, id).await?;

    let mut tx = db.begin().await?;

    sqlx::query!("DELETE FROM list_sharing WHERE list = $1", id)
        .execute(&mut *tx)
        .await?;

    sqlx::query!(
        "DELETE FROM history WHERE list = $1 AND creator != $2",
        id,
        user.id,
    )
    .execute(&mut *tx)
    .await?;

    tx.commit().await?;

    OkResponse::ok(DeleteShareResponse {})
}
