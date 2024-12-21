use std::iter::FromIterator;

use axum::{
    extract,
    http::StatusCode,
    response::{Html, IntoResponse},
    routing::{get, patch, post, put},
    Extension, Json, Router,
};
use kabalist_types::{
    AddToListRequest, AddToListResponse, CreateListRequest, CreateListResponse, DeleteItemResponse,
    DeleteListResponse, GetListsResponse, Item, ListInfo, ListStatus, ReadListResponse,
    RemovePublicResponse, SetPublicResponse, UpdateItemRequest, UpdateItemResponse,
};
use sqlx::PgPool;
use tera::Tera;
use tokio_stream::StreamExt;
use uuid::Uuid;

use crate::{check_list, is_owner, ErrResponse, Error, OkResponse, Rsp, User, *};

pub(crate) fn router() -> Router {
    Router::new()
        .route("/", post(create_list).get(list_lists))
        .route("/{id}", get(read_list).post(add_list).delete(delete_list))
        .route("/{id}/{item}", patch(update_item).delete(delete_item))
        .route(
            "/{id}/public",
            put(set_public).delete(remove_public).get(get_public_list),
        )
}

#[utoipa::path(
    get,
    path = "/api/list",
    responses(
        (status = 200, description = "Lists", body = OkGetListsResponse),
        (status = 400, description = "Invalid request", body = ErrResponse),
        (status = 500, description = "Internal Error", body = ErrResponse),
    ),
    security(
        ("token" = [])
    )
)]
#[tracing::instrument(skip(db))]
#[axum::debug_handler]
pub(crate) async fn list_lists(
    Extension(db): Extension<PgPool>,
    user: User,
) -> Rsp<GetListsResponse> {
    let results_owned = sqlx::query!(
        r#"
        SELECT name, id, pub, owner
        FROM lists WHERE owner = $1"#,
        user.id
    )
    .fetch_all(&db)
    .await?;
    let results_shared = sqlx::query!(
        r#"SELECT name, id, readonly, pub, owner
               FROM lists, list_sharing
               WHERE (lists.id = list_sharing.list)
                   AND shared = $1 "#,
        user.id
    )
    .fetch_all(&db)
    .await?;

    OkResponse::ok(GetListsResponse {
        results: results_owned
            .into_iter()
            .map(|row| {
                (
                    row.id,
                    ListInfo {
                        name: row.name,
                        status: ListStatus::Owned,
                        public: row.r#pub.unwrap_or(false),
                        owner: row.owner,
                    },
                )
            })
            .chain(results_shared.into_iter().map(|row| {
                (
                    row.id,
                    ListInfo {
                        name: row.name,
                        status: if row.readonly {
                            ListStatus::SharedRead
                        } else {
                            ListStatus::SharedWrite
                        },
                        public: row.r#pub.unwrap_or(false),
                        owner: row.owner,
                    },
                )
            }))
            .collect(),
    })
}

#[utoipa::path(
    post,
    path = "/api/list",
    responses(
        (status = 200, description = "List ID", body = OkLoginResponse),
        (status = 400, description = "Invalid request", body = ErrResponse),
        (status = 500, description = "Internal Error", body = ErrResponse),
    ),
    request_body = CreateListRequest,
    security(
        ("token" = [])
    )
)]
#[axum::debug_handler]
#[tracing::instrument(skip(db))]
pub(crate) async fn create_list(
    Extension(db): Extension<PgPool>,
    user: User,
    Json(list): Json<CreateListRequest>,
) -> Rsp<CreateListResponse> {
    match sqlx::query!(
        "SELECT COUNT(*) FROM lists WHERE owner = $1 AND name = $2",
        user.id,
        list.name
    )
    .fetch_one(&db)
    .await?
    .count
    {
        Some(0) | None => (),
        _ => return Err(Error::ListAlreadyExists),
    }

    let list_id = sqlx::query!(
        "INSERT INTO lists (id, owner, name) VALUES (uuid_generate_v4(), $1, $2) RETURNING id",
        user.id,
        list.name
    )
    .fetch_one(&db)
    .await?;

    OkResponse::ok(CreateListResponse { id: list_id.id })
}

#[utoipa::path(
    get,
    path = "/api/list/{id}",
    responses(
        (status = 200, description = "List Content", body = OkReadListResponse),
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
#[axum::debug_handler]
#[tracing::instrument(skip(db))]
pub(crate) async fn read_list(
    Extension(db): Extension<PgPool>,
    user: User,
    extract::Path(id): extract::Path<Uuid>,
) -> Rsp<ReadListResponse> {
    check_list(&db, user.id, id, false).await?;

    let items = sqlx::query!(
        "SELECT id, name, amount FROM lists_content WHERE list = $1",
        id
    )
    .fetch_all(&db)
    .await?;

    let mut readonly_result = sqlx::query!(
        "SELECT readonly FROM list_sharing WHERE list = $1 AND shared = $2",
        id,
        user.id,
    )
    .fetch(&db);

    let readonly = match readonly_result.next().await {
        Some(Ok(v)) => v.readonly,
        Some(Err(e)) => return Err(e.into()),
        None => false,
    };

    OkResponse::ok(ReadListResponse {
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

#[utoipa::path(
    post,
    path = "/api/list/{id}",
    responses(
        (status = 200, description = "New Item", body = OkAddToListResponse),
        (status = 400, description = "Invalid request", body = ErrResponse),
        (status = 500, description = "Internal Error", body = ErrResponse),
    ),
    request_body = AddToListRequest,
    params(
        ("id" = Uuid, Path, description = "List ID"),
    ),
    security(
        ("token" = [])
    )
)]
#[axum::debug_handler]
#[tracing::instrument(skip(db))]
pub(crate) async fn add_list(
    Extension(db): Extension<PgPool>,
    user: User,
    extract::Path(id): extract::Path<Uuid>,
    Json(item): Json<AddToListRequest>,
) -> Rsp<AddToListResponse> {
    check_list(&db, user.id, id, true).await?;

    let mut tx = db.begin().await?;

    let item_id = sqlx::query!(
        "INSERT INTO lists_content (list, name, amount) VALUES ($1, $2, $3) RETURNING id",
        id,
        item.name,
        item.amount
    )
    .fetch_one(&mut *tx)
    .await?;

    sqlx::query!(
        r#"INSERT INTO history (list, creator, name, last_used)
               VALUES ($1, $2, $3::text::citext, now())
               ON CONFLICT (list, creator, name) DO
               UPDATE SET last_used = now()"#,
        id,
        user.id,
        item.name
    )
    .execute(&mut *tx)
    .await?;

    tx.commit().await?;

    OkResponse::ok(AddToListResponse { id: item_id.id })
}

#[utoipa::path(
    patch,
    path = "/api/list/{id}/{item}",
    responses(
        (status = 200, description = "Update Item", body = OkUpdateItemResponse),
        (status = 400, description = "Invalid request", body = ErrResponse),
        (status = 500, description = "Internal Error", body = ErrResponse),
    ),
    request_body = UpdateItemRequest,
    params(
        ("id" = Uuid, Path, description = "List ID"),
        ("item" = i32, Path, description = "Item ID"),
    ),
    security(
        ("token" = [])
    )
)]
#[axum::debug_handler]
#[tracing::instrument(skip(db))]
pub(crate) async fn update_item(
    Extension(db): Extension<PgPool>,
    user: User,
    extract::Path((list, item)): extract::Path<(Uuid, i32)>,
    Json(update): Json<UpdateItemRequest>,
) -> Rsp<UpdateItemResponse> {
    check_list(&db, user.id, list, true).await?;

    let mut tx = db.begin().await?;

    if let Some(name) = &update.name {
        sqlx::query!(
            "UPDATE lists_content SET name = $1 WHERE list = $2 AND id = $3",
            name,
            list,
            item
        )
        .execute(&mut *tx)
        .await?;
    }

    if let Some(amount) = &update.amount {
        sqlx::query!(
            "UPDATE lists_content SET amount = $1 WHERE list = $2 AND id = $3",
            amount,
            list,
            item
        )
        .execute(&mut *tx)
        .await?;
    }

    tx.commit().await?;

    OkResponse::ok(UpdateItemResponse {})
}

#[utoipa::path(
    delete,
    path = "/api/list/{id}/{item}",
    responses(
        (status = 200, description = "Delete Item", body = OkDeleteItemResponse),
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
#[axum::debug_handler]
pub(crate) async fn delete_item(
    Extension(db): Extension<PgPool>,
    user: User,
    extract::Path((list, item)): extract::Path<(Uuid, i32)>,
) -> Rsp<DeleteItemResponse> {
    check_list(&db, user.id, list, true).await?;

    let mut tx = db.begin().await?;

    sqlx::query!(
        "UPDATE pantry_content
        SET amount = amount +
            (SELECT
                COALESCE(convert_to_integer(lists_content.amount), 0) as added
            FROM lists_content
            WHERE lists_content.list = $1 AND lists_content.id = $2)
        WHERE
            pantry_content.item =
                (SELECT lists_content.from_pantry
                 FROM lists_content
                 WHERE lists_content.list = $1 AND lists_content.id = $2)",
        list,
        item
    )
    .execute(&mut *tx)
    .await?;

    sqlx::query!(
        "DELETE FROM lists_content WHERE list = $1 AND id = $2",
        list,
        item
    )
    .execute(&mut *tx)
    .await?;

    tx.commit().await?;

    OkResponse::ok(DeleteItemResponse {})
}

#[utoipa::path(
    delete,
    path = "/api/list/{id}",
    responses(
        (status = 200, description = "List Deleted", body = OkDeleteListResponse),
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
#[axum::debug_handler]
pub(crate) async fn delete_list(
    Extension(db): Extension<PgPool>,
    user: User,
    extract::Path(id): extract::Path<Uuid>,
) -> Rsp<DeleteListResponse> {
    is_owner(&db, user.id, id).await?;
    let mut tx = db.begin().await?;

    sqlx::query!("DELETE FROM list_sharing WHERE list = $1", id)
        .execute(&mut *tx)
        .await?;
    sqlx::query!("DELETE FROM lists_content WHERE list = $1", id)
        .execute(&mut *tx)
        .await?;
    sqlx::query!("DELETE FROM history WHERE list = $1", id)
        .execute(&mut *tx)
        .await?;
    sqlx::query!("DELETE FROM lists WHERE id = $1", id)
        .execute(&mut *tx)
        .await?;

    tx.commit().await?;

    OkResponse::ok(DeleteListResponse {})
}

#[utoipa::path(
    put,
    path = "/api/list/{id}/public",
    responses(
        (status = 200, description = "Sucess", body = OkSetPublicResponse),
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
async fn set_public(
    Extension(db): Extension<PgPool>,
    extract::Path(id): extract::Path<Uuid>,
    user: User,
) -> Rsp<SetPublicResponse> {
    is_owner(&db, user.id, id).await?;

    sqlx::query!("UPDATE lists SET pub = true WHERE id = $1", id)
        .execute(&db)
        .await?;

    OkResponse::ok(SetPublicResponse {})
}

#[utoipa::path(
    delete,
    path = "/api/list/{id}/public",
    responses(
        (status = 200, description = "Sucess", body = OkRemovePublicResponse),
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
async fn remove_public(
    Extension(db): Extension<PgPool>,
    extract::Path(id): extract::Path<Uuid>,
    user: User,
) -> Rsp<RemovePublicResponse> {
    is_owner(&db, user.id, id).await?;

    sqlx::query!("UPDATE lists SET pub = false WHERE id = $1", id)
        .execute(&db)
        .await?;

    OkResponse::ok(RemovePublicResponse {})
}

enum PublicError {
    NotFound,
    InternalError,
}

impl From<sqlx::Error> for PublicError {
    fn from(e: sqlx::Error) -> Self {
        tracing::error!("SQLX error: {:?}", e);
        Self::InternalError
    }
}

impl From<tera::Error> for PublicError {
    fn from(e: tera::Error) -> Self {
        tracing::error!("Tera error: {:?}", e);
        Self::InternalError
    }
}

impl IntoResponse for PublicError {
    fn into_response(self) -> axum::response::Response {
        match self {
            PublicError::NotFound => (StatusCode::NOT_FOUND, "List not found").into_response(),
            PublicError::InternalError => {
                (StatusCode::INTERNAL_SERVER_ERROR, "Internal Server Error").into_response()
            }
        }
    }
}

#[utoipa::path(
    get,
    path = "/api/list/{id}/public",
    responses(
        (status = 200, description = "List", body = String, content_type = "text/html"),
        (status = 404, description = "List Not Found", body = String),
        (status = 500, description = "Internal Error", body = String),
    ),
    params(
        ("id" = Uuid, Path, description = "List ID"),
    ),
)]
#[tracing::instrument(skip(db, tera))]
async fn get_public_list(
    Extension(db): Extension<PgPool>,
    Extension(tera): Extension<Tera>,
    extract::Path(id): extract::Path<Uuid>,
) -> Result<Html<String>, PublicError> {
    let pb = sqlx::query!("SELECT pub FROM lists WHERE id = $1", id)
        .fetch_one(&db)
        .await?;

    if !pb.r#pub.unwrap_or(false) {
        return Err(PublicError::NotFound);
    }

    let contents = sqlx::query!("SELECT name,amount FROM lists_content WHERE list = $1", id)
        .fetch_all(&db)
        .await?;

    let mut context = tera::Context::new();
    context.insert(
        "items",
        &Vec::from_iter(contents.into_iter().map(|row| (row.name, row.amount))),
    );

    tera.render("public_list.html.tera", &context)
        .map_err(Into::into)
        .map(Html)
}
