use std::{collections::HashMap, fmt::Debug};

use serde::{Deserialize, Serialize};
#[cfg(feature = "openapi")]
use utoipa::{PartialSchema, ToResponse, ToSchema};
pub use uuid;
use uuid::Uuid;

#[derive(Serialize, Deserialize, thiserror::Error, Debug, PartialEq, Eq, Hash, Clone)]
#[cfg_attr(feature = "openapi", derive(ToSchema))]
#[error("Api returned an error: {description}")]
pub struct RspErr {
    pub code: usize,
    pub description: String,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone)]
#[cfg_attr(feature = "openapi", derive(ToSchema))]
#[serde(rename_all = "lowercase")]
pub enum RspData<T> {
    Ok(T),
    Err(RspErr),
}

impl<T> From<RspData<T>> for Result<T, RspErr> {
    fn from(v: RspData<T>) -> Self {
        match v {
            RspData::Ok(v) => Ok(v),
            RspData::Err(v) => Err(v),
        }
    }
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Hash, Clone)]
#[serde(transparent)]
pub struct SecretString(pub String);

impl Debug for SecretString {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "*********")
    }
}

#[cfg(feature = "openapi")]
impl PartialSchema for SecretString {
    fn schema() -> utoipa::openapi::RefOr<utoipa::openapi::schema::Schema> {
        utoipa::openapi::ObjectBuilder::new()
            .schema_type(utoipa::openapi::schema::SchemaType::Type(
                utoipa::openapi::Type::String,
            ))
            .build()
            .into()
    }
}

#[cfg(feature = "openapi")]
impl ToSchema for SecretString {
    fn name() -> std::borrow::Cow<'static, str> {
        "SecretString".into()
    }
}

#[derive(Serialize, Deserialize, Debug, PartialEq, Eq, Hash, Clone, Copy)]
#[cfg_attr(feature = "openapi", derive(ToResponse, ToSchema))]
pub struct Empty {}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone)]
#[cfg_attr(feature = "openapi", derive(ToSchema))]
pub struct LoginRequest {
    pub password: SecretString,
    pub username: String,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone)]
#[cfg_attr(feature = "openapi", derive(ToResponse, ToSchema))]
pub struct LoginResponse {
    pub token: String,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone)]
#[cfg_attr(feature = "openapi", derive(ToSchema))]
pub struct CreateListRequest {
    pub name: String,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone)]
#[cfg_attr(feature = "openapi", derive(ToResponse, ToSchema))]
pub struct CreateListResponse {
    pub id: Uuid,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Clone, Copy, Hash)]
#[cfg_attr(feature = "openapi", derive(ToSchema))]
#[serde(rename_all = "snake_case")]
pub enum ListStatus {
    Owned,
    SharedWrite,
    SharedRead,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Clone, Hash)]
#[cfg_attr(feature = "openapi", derive(ToSchema))]
pub struct ListInfo {
    pub name: String,
    pub status: ListStatus,
    pub public: bool,
    pub owner: Uuid,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Clone)]
#[cfg_attr(feature = "openapi", derive(ToResponse, ToSchema))]
pub struct GetListsResponse {
    pub results: HashMap<Uuid, ListInfo>,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, Copy)]
#[cfg_attr(feature = "openapi", derive(ToResponse, ToSchema))]
pub struct SearchAccountResponse {
    pub id: Uuid,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone)]
#[cfg_attr(feature = "openapi", derive(ToSchema))]
pub struct Item {
    pub id: i32,
    pub name: String,
    pub amount: Option<String>,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone)]
#[cfg_attr(feature = "openapi", derive(ToResponse, ToSchema))]
pub struct ReadListResponse {
    pub items: Vec<Item>,
    pub readonly: bool,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone)]
#[cfg_attr(feature = "openapi", derive(ToSchema))]
pub struct AddToListRequest {
    pub name: String,
    pub amount: Option<String>,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, Copy)]
#[cfg_attr(feature = "openapi", derive(ToResponse, ToSchema))]
pub struct AddToListResponse {
    pub id: i32,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, Copy)]
#[cfg_attr(feature = "openapi", derive(ToSchema))]
pub struct ShareListRequest {
    pub share_with: Uuid,
    pub readonly: bool,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, Copy)]
#[cfg_attr(feature = "openapi", derive(ToSchema))]
pub struct ShareListResponse {}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, Copy)]
#[cfg_attr(feature = "openapi", derive(ToSchema))]
pub struct DeleteItemResponse {}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, Copy)]
#[cfg_attr(feature = "openapi", derive(ToSchema))]
pub struct DeleteShareResponse {}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, Copy)]
#[cfg_attr(feature = "openapi", derive(ToSchema))]
pub struct DeleteListResponse {}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone)]
#[cfg_attr(feature = "openapi", derive(ToSchema))]
pub struct RegisterRequest {
    pub username: String,
    pub password: String,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, Copy)]
#[cfg_attr(feature = "openapi", derive(ToSchema))]
pub struct RegisterResponse {}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone)]
#[cfg_attr(feature = "openapi", derive(ToSchema))]
pub struct UpdateItemRequest {
    pub name: Option<String>,
    pub amount: Option<String>,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, Copy)]
#[cfg_attr(feature = "openapi", derive(ToSchema))]
pub struct UpdateItemResponse {}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone)]
#[cfg_attr(feature = "openapi", derive(ToResponse, ToSchema))]
pub struct RecoveryInfoResponse {
    pub username: String,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone)]
#[cfg_attr(feature = "openapi", derive(ToSchema))]
pub struct RecoverPasswordRequest {
    pub password: String,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, Copy)]
#[cfg_attr(feature = "openapi", derive(ToSchema))]
pub struct RecoverPasswordResponse {}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Clone)]
#[cfg_attr(feature = "openapi", derive(ToResponse, ToSchema))]
pub struct GetSharesResponse {
    pub shared_with: HashMap<Uuid, bool>,
    pub public_link: Option<String>,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, Copy)]
#[cfg_attr(feature = "openapi", derive(ToSchema))]
pub struct UnshareResponse {}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone)]
#[cfg_attr(feature = "openapi", derive(ToResponse, ToSchema))]
pub struct GetAccountNameResponse {
    pub username: String,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone)]
#[cfg_attr(feature = "openapi", derive(ToResponse, ToSchema))]
pub struct SetPublicResponse {}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone)]
#[cfg_attr(feature = "openapi", derive(ToResponse, ToSchema))]
pub struct RemovePublicResponse {}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone)]
#[cfg_attr(feature = "openapi", derive(ToResponse, ToSchema))]
pub struct GetHistoryResponse {
    pub matches: Vec<String>,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone)]
#[cfg_attr(feature = "openapi", derive(ToSchema))]
pub struct PantryItem {
    pub name: String,
    pub id: i32,
    pub amount: i32,
    pub target: i32,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone)]
#[cfg_attr(feature = "openapi", derive(ToResponse, ToSchema))]
pub struct GetPantryResponse {
    pub items: Vec<PantryItem>,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone)]
#[cfg_attr(feature = "openapi", derive(ToSchema))]
pub struct AddToPantryRequest {
    pub name: String,
    pub target: i32,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone)]
#[cfg_attr(feature = "openapi", derive(ToResponse, ToSchema))]
pub struct AddToPantryResponse {}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone)]
#[cfg_attr(feature = "openapi", derive(ToResponse, ToSchema))]
pub struct RefillPantryResponse {}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone)]
#[cfg_attr(feature = "openapi", derive(ToSchema))]
pub struct EditPantryItemRequest {
    pub target: Option<i32>,
    pub amount: Option<i32>,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone)]
#[cfg_attr(feature = "openapi", derive(ToResponse, ToSchema))]
pub struct EditPantryItemResponse {}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone)]
#[cfg_attr(feature = "openapi", derive(ToResponse, ToSchema))]
pub struct DeletePantryItemResponse {}
