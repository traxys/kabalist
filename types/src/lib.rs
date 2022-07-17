use std::{collections::HashMap, fmt::Debug};

use serde::{Deserialize, Serialize};
use utoipa::Component;
pub use uuid;
use uuid::Uuid;

#[derive(
    Serialize, Deserialize, thiserror::Error, Debug, PartialEq, Eq, Hash, Clone, Component,
)]
#[error("Api returned an error: {description}")]
pub struct RspErr {
    pub code: usize,
    pub description: String,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, Component)]
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

impl Component for SecretString {
    fn component() -> utoipa::openapi::schema::Component {
        utoipa::openapi::PropertyBuilder::new()
            .component_type(utoipa::openapi::ComponentType::String)
            .build()
            .into()
    }
}

#[derive(Serialize, Deserialize, Debug, PartialEq, Eq, Hash, Clone, Copy, Component)]
pub struct Empty {}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, Component)]
pub struct LoginRequest {
    pub password: SecretString,
    pub username: String,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, Component)]
pub struct LoginResponse {
    pub token: String,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, Component)]
pub struct CreateListRequest {
    pub name: String,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, Component)]
pub struct CreateListResponse {
    pub id: Uuid,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Clone, Copy, Hash, Component)]
#[serde(rename_all = "snake_case")]
pub enum ListStatus {
    Owned,
    SharedWrite,
    SharedRead,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Clone, Hash, Copy, Component)]
pub struct ListInfo {
    pub id: Uuid,
    pub status: ListStatus,
    pub public: bool,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Clone, Component)]
pub struct GetListsResponse {
    pub results: HashMap<String, ListInfo>,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, Copy, Component)]
pub struct SearchAccountResponse {
    pub id: Uuid,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, Component)]
pub struct Item {
    pub id: i32,
    pub name: String,
    pub amount: Option<String>,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, Component)]
pub struct ReadListResponse {
    pub items: Vec<Item>,
    pub readonly: bool,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, Component)]
pub struct AddToListRequest {
    pub name: String,
    pub amount: Option<String>,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, Copy, Component)]
pub struct AddToListResponse {
    pub id: i32,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, Copy, Component)]
pub struct ShareListRequest {
    pub share_with: Uuid,
    pub readonly: bool,
}

pub type ShareListResponse = Empty;

pub type DeleteItemResponse = Empty;

pub type DeleteShareResponse = Empty;

pub type DeleteListResponse = Empty;

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, Component)]
pub struct RegisterRequest {
    pub username: String,
    pub password: String,
}

pub type RegisterResponse = Empty;

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, Component)]
pub struct UpdateItemRequest {
    pub name: Option<String>,
    pub amount: Option<String>,
}

pub type UpdateItemResponse = Empty;

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, Component)]
pub struct RecoveryInfoResponse {
    pub username: String,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, Component)]
pub struct RecoverPasswordRequest {
    pub password: String,
}

pub type RecoverPasswordResponse = Empty;

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Clone, Component)]
pub struct GetSharesResponse {
    pub shared_with: HashMap<Uuid, bool>,
    pub public_link: Option<String>,
}

pub type UnshareResponse = Empty;

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, Component)]
pub struct GetAccountNameResponse {
    pub username: String,
}

pub type SetPublicResponse = crate::Empty;

pub type RemovePublicResponse = crate::Empty;

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, Component)]
pub struct GetHistoryResponse {
    pub matches: Vec<String>,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, Component)]
pub struct PantryItem {
    pub name: String,
    pub id: i32,
    pub amount: i32,
    pub target: i32,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, Component)]
pub struct GetPantryResponse {
    pub items: Vec<PantryItem>,
}

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, Component)]
pub struct AddToPantryRequest {
    pub name: String,
    pub target: i32,
}

pub type AddToPantryResponse = crate::Empty;

pub type RefillPantryResponse = crate::Empty;
