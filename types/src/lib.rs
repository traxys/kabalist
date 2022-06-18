use std::collections::HashMap;

use schemars::JsonSchema;
use serde::{Deserialize, Serialize};
pub use uuid;
use uuid::Uuid;

#[derive(
    Serialize, Deserialize, thiserror::Error, Debug, PartialEq, Eq, Hash, Clone, JsonSchema,
)]
#[error("Api returned an error: {description}")]
pub struct RspErr {
    pub code: usize,
    pub description: String,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, JsonSchema)]
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

#[derive(Serialize, Deserialize, Debug, PartialEq, Eq, Hash, Clone, Copy, JsonSchema)]
pub struct Empty {}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, JsonSchema)]
pub struct LoginRequest {
    pub password: String,
    pub username: String,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, JsonSchema)]
pub struct LoginResponse {
    pub token: String,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, JsonSchema)]
pub struct CreateListRequest {
    pub name: String,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, JsonSchema)]
pub struct CreateListResponse {
    pub id: Uuid,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Clone, Copy, Hash, JsonSchema)]
#[serde(rename_all = "snake_case")]
pub enum ListStatus {
    Owned,
    SharedWrite,
    SharedRead,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Clone, Hash, Copy, JsonSchema)]
pub struct ListInfo {
    pub id: Uuid,
    pub status: ListStatus,
    pub public: bool,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Clone, JsonSchema)]
pub struct GetListsResponse {
    pub results: HashMap<String, ListInfo>,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, Copy, JsonSchema)]
pub struct SearchAccountResponse {
    pub id: Uuid,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, JsonSchema)]
pub struct Item {
    pub id: i32,
    pub name: String,
    pub amount: Option<String>,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, JsonSchema)]
pub struct ReadListResponse {
    pub items: Vec<Item>,
    pub readonly: bool,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, JsonSchema)]
pub struct AddToListRequest {
    pub name: String,
    pub amount: Option<String>,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, Copy, JsonSchema)]
pub struct AddToListResponse {
    pub id: i32,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, Copy, JsonSchema)]
pub struct ShareListRequest {
    pub share_with: Uuid,
    pub readonly: bool,
}

pub type ShareListResponse = Empty;

pub type DeleteItemResponse = Empty;

pub type DeleteShareResponse = Empty;

pub type DeleteListResponse = Empty;

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, JsonSchema)]
pub struct RegisterRequest {
    pub username: String,
    pub password: String,
}

pub type RegisterResponse = Empty;

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, JsonSchema)]
pub struct UpdateItemRequest {
    pub name: Option<String>,
    pub amount: Option<String>,
}

pub type UpdateItemResponse = Empty;

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, JsonSchema)]
pub struct RecoveryInfoResponse {
    pub username: String,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, JsonSchema)]
pub struct RecoverPasswordRequest {
    pub password: String,
}

pub type RecoverPasswordResponse = Empty;

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Clone, JsonSchema)]
pub struct GetSharesResponse {
    pub shared_with: HashMap<Uuid, bool>,
    pub public_link: Option<String>,
}

pub type UnshareResponse = Empty;

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, JsonSchema)]
pub struct GetAccountNameResponse {
    pub username: String,
}

pub type SetPublicResponse = crate::Empty;

pub type RemovePublicResponse = crate::Empty;

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, JsonSchema)]
pub struct GetHistoryResponse {
    pub matches: Vec<String>,
}
