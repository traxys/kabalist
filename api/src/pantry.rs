use axum::{
    extract::Path,
    routing::{get, patch, post},
    Extension, Json, Router,
};
use kabalist_types::{
    AddToPantryRequest, AddToPantryResponse, DeletePantryItemResponse, EditPantryItemRequest,
    EditPantryItemResponse, GetPantryResponse, PantryItem, RefillPantryResponse,
};
use sqlx::PgPool;
use uuid::Uuid;

use crate::{User, check_list, OkResponse, Rsp, *};

pub(crate) fn router() -> Router {
    Router::new()
        .route("/:id", get(get_pantry).post(add_to_pantry))
        .route("/:id/refill", post(refill_pantry))
        .route(
            "/:id/:item",
            patch(set_pantry_item).delete(delete_pantry_item),
        )
}

#[utoipa::path(
    get,
    path = "/api/pantry/{id}",
    responses(
        (status = 200, description = "Pantry Content", body = OkGetPantryResponse),
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
async fn get_pantry(
    Extension(db): Extension<PgPool>,
    user: User,
    Path(list): Path<Uuid>,
) -> Rsp<GetPantryResponse> {
    check_list(&db, user.id, list, false).await?;
    let items = sqlx::query!("SELECT * FROM pantry_content WHERE list = $1", list)
        .fetch_all(&db)
        .await?
        .into_iter()
        .map(|row| PantryItem {
            name: row.name,
            id: row.item,
            amount: row.amount,
            target: row.target,
        })
        .collect();
    OkResponse::ok(GetPantryResponse { items })
}

#[utoipa::path(
    post,
    path = "/api/pantry/{id}",
    responses(
        (status = 200, description = "Item Added", body = OkAddToPantryResponse),
        (status = 400, description = "Invalid request", body = ErrResponse),
        (status = 500, description = "Internal Error", body = ErrResponse),
    ),
    request_body = AddToPantryRequest,
    params(
        ("id" = Uuid, Path, description = "List ID"),
    ),
    security(
        ("token" = [])
    )
)]
#[tracing::instrument(skip(db))]
async fn add_to_pantry(
    Extension(db): Extension<PgPool>,
    user: User,
    Path(list): Path<Uuid>,
    Json(request): Json<AddToPantryRequest>,
) -> Rsp<AddToPantryResponse> {
    check_list(&db, user.id, list, true).await?;

    sqlx::query!(
        "INSERT INTO pantry_content (list, name, target) VALUES ($1, $2, $3)",
        list,
        request.name,
        request.target
    )
    .execute(&db)
    .await?;

    OkResponse::ok(AddToPantryResponse {})
}

#[utoipa::path(
    patch,
    path = "/api/pantry/{id}/{item}",
    responses(
        (status = 200, description = "Item Edited", body = OkEditPantryItemResponse),
        (status = 400, description = "Invalid request", body = ErrResponse),
        (status = 500, description = "Internal Error", body = ErrResponse),
    ),
    request_body = EditPantryItemRequest,
    params(
        ("id" = Uuid, Path, description = "List ID"),
        ("item" = i32, Path, description = "Item ID"),
    ),
    security(
        ("token" = [])
    )
)]
#[tracing::instrument(skip(db))]
async fn set_pantry_item(
    Extension(db): Extension<PgPool>,
    user: User,
    Path((list, item)): Path<(Uuid, i32)>,
    Json(request): Json<EditPantryItemRequest>,
) -> Rsp<EditPantryItemResponse> {
    check_list(&db, user.id, list, true).await?;

    sqlx::query!(
        "
        UPDATE pantry_content
            SET amount = COALESCE($1, amount),
                target = COALESCE($2, target)
            WHERE
                list = $3 AND item = $4",
        request.amount,
        request.target,
        list,
        item
    )
    .execute(&db)
    .await?;

    OkResponse::ok(EditPantryItemResponse {})
}

#[utoipa::path(
    delete,
    path = "/api/pantry/{id}/{item}",
    responses(
        (status = 200, description = "Item Deleted", body = OkDeletePantryItemResponse),
        (status = 400, description = "Invalid request", body = ErrResponse),
        (status = 500, description = "Internal Error", body = ErrResponse),
    ),
    params(
        ("id" = Uuid, Path, description = "List ID"),
        ("item" = i32, Path, description = "Item ID"),
    ),
    security(
        ("token" = [])
    )
)]
#[tracing::instrument(skip(db))]
async fn delete_pantry_item(
    Extension(db): Extension<PgPool>,
    user: User,
    Path((list, item)): Path<(Uuid, i32)>,
) -> Rsp<DeletePantryItemResponse> {
    check_list(&db, user.id, list, true).await?;

    let mut tx = db.begin().await?;

    sqlx::query!(
        "DELETE FROM lists_content WHERE from_pantry = $1 AND list = $2",
        item,
        list
    )
    .execute(&mut *tx)
    .await?;

    sqlx::query!(
        "DELETE FROM pantry_content WHERE item = $1 AND list = $2",
        item,
        list
    )
    .execute(&mut *tx)
    .await?;

    tx.commit().await?;

    OkResponse::ok(DeletePantryItemResponse {})
}

#[utoipa::path(
    post,
    path = "/api/pantry/{id}/refill",
    responses(
        (status = 200, description = "Pantry Refilled", body = OkRefillPantryResponse),
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
async fn refill_pantry(
    Extension(db): Extension<PgPool>,
    user: User,
    Path(list): Path<Uuid>,
) -> Rsp<RefillPantryResponse> {
    check_list(&db, user.id, list, true).await?;

    sqlx::query!(
        r#"INSERT INTO lists_content (list,name,amount,from_pantry)
            SELECT list,name,(target - amount) as amount,item as from_pantry
                FROM pantry_content
                WHERE amount < target AND list = $1"#,
        list
    )
    .execute(&db)
    .await?;

    OkResponse::ok(RefillPantryResponse {})
}
