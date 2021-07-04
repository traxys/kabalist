use serde::Serialize;
use lists_types::RspData;
pub use lists_types::{
    add_to_list::Response as AddItemResponse,
    create_list::Response as CreateListResponse,
    delete_item::Response as DeleteItemResponse,
    delete_share::Response as DeleteShareResponse,
    get_lists::{ListInfo, ListStatus, Response as ListsResponse},
    login::Response as LoginResponse,
    read_list::{Item, Response as ReadResponse},
    register::Response as RegisterResponse,
    search_account::Response as SearchAccountResponse,
    share_list::Response as ShareResponse,
    uuid::Uuid,
    RspErr,
};

pub type Result<T, E = Error> = std::result::Result<T, E>;

#[derive(Debug, thiserror::Error)]
pub enum Error {
    #[error("An http error occured")]
    Http(#[from] reqwest::Error),
    #[error("An api error occured")]
    Api(#[from] RspErr),
}

fn map_res<T>(res: RspData<T>) -> Result<T> {
    let res: Result<_, lists_types::RspErr> = res.into();
    res.map_err(Into::into)
}

pub async fn login(url: &str, username: &str, password: &str) -> Result<LoginResponse> {
    #[derive(Serialize)]
    struct LoginRequest<'a> {
        username: &'a str,
        password: &'a str,
    }

    let client = reqwest::Client::new();
    let token: RspData<LoginResponse> = client
        .post(format!("{}/login", url))
        .json(&LoginRequest { username, password })
        .send()
        .await?
        .json()
        .await?;

    map_res(token)
}

pub struct Client {
    client: reqwest::Client,
    token: String,
    url: String,
}

impl Client {
    pub fn new(url: String, token: String) -> Self {
        Self {
            client: reqwest::Client::new(),
            token,
            url,
        }
    }

    pub async fn lists(&self) -> Result<ListsResponse> {
        let lists: RspData<lists_types::get_lists::Response> = self
            .client
            .get(&format!("{}/list", self.url))
            .bearer_auth(&self.token)
            .send()
            .await?
            .json()
            .await?;

        map_res(lists)
    }

    pub async fn search(&self, name: &str) -> Result<ListsResponse> {
        let lists: RspData<lists_types::get_lists::Response> = self
            .client
            .get(&format!("{}/search/list/{}", self.url, name))
            .bearer_auth(&self.token)
            .send()
            .await?
            .json()
            .await?;

        map_res(lists)
    }

    pub async fn read(&self, id: &Uuid) -> Result<ReadResponse> {
        let rsp: RspData<ReadResponse> = self
            .client
            .get(&format!("{}/list/{}", self.url, id))
            .bearer_auth(&self.token)
            .send()
            .await?
            .json()
            .await?;

        map_res(rsp)
    }

    pub async fn add(
        &self,
        list: &Uuid,
        name: &str,
        amount: Option<&str>,
    ) -> Result<AddItemResponse> {
        #[derive(Serialize)]
        struct Request<'a> {
            name: &'a str,
            amount: Option<&'a str>,
        }

        let rsp: RspData<AddItemResponse> = self
            .client
            .post(&format!("{}/list/{}", self.url, list))
            .bearer_auth(&self.token)
            .json(&Request { name, amount })
            .send()
            .await?
            .json()
            .await?;

        map_res(rsp)
    }

    pub async fn search_account(&self, name: &str) -> Result<SearchAccountResponse> {
        let rsp: RspData<SearchAccountResponse> = self
            .client
            .get(&format!("{}/search/account/{}", self.url, name))
            .bearer_auth(&self.token)
            .send()
            .await?
            .json()
            .await?;

        map_res(rsp)
    }

    pub async fn share(
        &self,
        list: &Uuid,
        share_with: &Uuid,
        readonly: bool,
    ) -> Result<ShareResponse> {
        #[derive(Serialize)]
        struct Request<'a> {
            share_with: &'a Uuid,
            readonly: bool,
        }

        let rsp: RspData<ShareResponse> = self
            .client
            .put(&format!("{}/share/{}", self.url, list))
            .bearer_auth(&self.token)
            .json(&Request {
                share_with,
                readonly,
            })
            .send()
            .await?
            .json()
            .await?;

        map_res(rsp)
    }

    pub async fn delete_share(&self, list: &Uuid) -> Result<DeleteShareResponse> {
        let rsp: RspData<DeleteShareResponse> = self
            .client
            .delete(&format!("{}/share/{}", self.url, list))
            .bearer_auth(&self.token)
            .send()
            .await?
            .json()
            .await?;

        map_res(rsp)
    }

    pub async fn create_list(&self, list_name: &str) -> Result<CreateListResponse> {
        #[derive(Serialize)]
        struct Request<'a> {
            name: &'a str,
        }

        let rsp: RspData<CreateListResponse> = self
            .client
            .post(&format!("{}/list", self.url))
            .bearer_auth(&self.token)
            .json(&Request { name: list_name })
            .send()
            .await?
            .json()
            .await?;

        map_res(rsp)
    }

    pub async fn delete_item(&self, list: &Uuid, item: i32) -> Result<DeleteItemResponse> {
        let rsp: RspData<DeleteItemResponse> = self
            .client
            .delete(&format!("{}/list/{}/{}", self.url, list, item))
            .bearer_auth(&self.token)
            .send()
            .await?
            .json()
            .await?;

        map_res(rsp)
    }

    pub async fn register(
        &self,
        token: Uuid,
        username: &str,
        password: &str,
    ) -> Result<RegisterResponse> {
        #[derive(Serialize)]
        struct RegisterRequest<'a> {
            username: &'a str,
            password: &'a str,
        }

        let rsp: RspData<RegisterResponse> = self
            .client
            .post(&format!("{}/register/{}", self.url, token))
            .json(&RegisterRequest { username, password })
            .bearer_auth(&self.token)
            .send()
            .await?
            .json()
            .await?;

        map_res(rsp)
    }
}
