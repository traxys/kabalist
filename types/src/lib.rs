use schemars::JsonSchema;
use serde::{Deserialize, Serialize};
pub use uuid;

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

pub mod login {
    use schemars::JsonSchema;
    use serde::{Deserialize, Serialize};

    #[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, JsonSchema)]
    pub struct Request {
        pub password: String,
        pub username: String,
    }

    #[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, JsonSchema)]
    pub struct Response {
        pub token: String,
    }
}

pub mod create_list {
    use schemars::JsonSchema;
    use serde::{Deserialize, Serialize};
    use uuid::Uuid;

    #[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, JsonSchema)]
    pub struct Request {
        pub name: String,
    }

    #[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, JsonSchema)]
    pub struct Response {
        pub id: Uuid,
    }
}

pub mod get_lists {
    use schemars::JsonSchema;
    use serde::{Deserialize, Serialize};
    use std::collections::HashMap;
    use uuid::Uuid;

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
    pub struct Response {
        pub results: HashMap<String, ListInfo>,
    }
}

pub mod search_account {
    use schemars::JsonSchema;
    use serde::{Deserialize, Serialize};
    use uuid::Uuid;

    #[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, Copy, JsonSchema)]
    pub struct Response {
        pub id: Uuid,
    }
}

pub mod read_list {
    use schemars::JsonSchema;
    use serde::{Deserialize, Serialize};

    #[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, JsonSchema)]
    pub struct Item {
        pub id: i32,
        pub name: String,
        pub amount: Option<String>,
    }

    #[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, JsonSchema)]
    pub struct Response {
        pub items: Vec<Item>,
        pub readonly: bool,
    }
}

pub mod add_to_list {
    use schemars::JsonSchema;
    use serde::{Deserialize, Serialize};

    #[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, JsonSchema)]
    pub struct Request {
        pub name: String,
        pub amount: Option<String>,
    }

    #[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, Copy, JsonSchema)]
    pub struct Response {
        pub id: i32,
    }
}

pub mod share_list {
    use schemars::JsonSchema;
    use serde::{Deserialize, Serialize};
    use uuid::Uuid;

    #[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, Copy, JsonSchema)]
    pub struct Request {
        pub share_with: Uuid,
        pub readonly: bool,
    }

    pub type Response = super::Empty;
}

pub mod delete_item {
    pub type Response = super::Empty;
}

pub mod delete_share {
    pub type Response = super::Empty;
}

pub mod delete_list {
    pub type Response = super::Empty;
}

pub mod register {
    use schemars::JsonSchema;
    pub use serde::{Deserialize, Serialize};

    #[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, JsonSchema)]
    pub struct Request {
        pub username: String,
        pub password: String,
    }

    pub type Response = super::Empty;
}

pub mod update_item {
    use schemars::JsonSchema;
    pub use serde::{Deserialize, Serialize};

    #[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, JsonSchema)]
    pub struct Request {
        pub name: Option<String>,
        pub amount: Option<String>,
    }

    pub type Response = super::Empty;
}

pub mod recovery_info {
    use schemars::JsonSchema;
    pub use serde::{Deserialize, Serialize};

    #[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, JsonSchema)]
    pub struct Response {
        pub username: String,
    }
}

pub mod recover_password {
    use schemars::JsonSchema;
    pub use serde::{Deserialize, Serialize};

    #[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, JsonSchema)]
    pub struct Request {
        pub password: String,
    }

    pub type Response = super::Empty;
}

pub mod get_shares {
    use schemars::JsonSchema;
    pub use serde::{Deserialize, Serialize};
    use uuid::Uuid;

    #[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, JsonSchema)]
    pub struct Response {
        pub shared_with: Vec<(Uuid, bool)>,
        pub public_link: Option<String>,
    }
}

pub mod unshare {
    pub use serde::{Deserialize, Serialize};

    pub type Response = super::Empty;
}

pub mod get_account_name {
    use schemars::JsonSchema;
    pub use serde::{Deserialize, Serialize};

    #[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, JsonSchema)]
    pub struct Response {
        pub username: String,
    }
}

pub mod set_public {
    pub type Response = crate::Empty;
}

pub mod remove_public {
    pub type Response = crate::Empty;
}

pub mod get_history {
    use schemars::JsonSchema;
    use serde::{Deserialize, Serialize};

    #[derive(Serialize, Deserialize, PartialEq, Eq, Debug, Hash, Clone, JsonSchema)]
    pub struct Response {
        pub matches: Vec<String>,
    }
}
