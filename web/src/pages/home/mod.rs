use std::collections::HashMap;

use kabalist_client::{ListInfo, Uuid};
use yew::prelude::*;

mod list;
mod modals;
mod sidebar;

use list::List;
use sidebar::Sidebar;
use yew_router::{history::History, prelude::RouterScopeExt};

use crate::Route;

#[derive(Clone, PartialEq, Properties)]
pub struct Props {
    pub logout: Callback<()>,
    pub token: String,
    pub username: String,
    pub list_id: Option<Uuid>,
}

pub struct Home {
    client: kabalist_client::Client,
    lists: HashMap<String, ListInfo>,
    error: Option<String>,
}

pub enum HomeMessage {
    SetLists(HashMap<String, ListInfo>),
    Error(String),
    ResetError,
}

#[derive(Clone, PartialEq)]
struct Token(String);

async fn lists(client: kabalist_client::Client) -> HomeMessage {
    match client.lists().await {
        Err(e) => HomeMessage::Error(format!("Could not sync lists: {:?}", e)),
        Ok(v) => HomeMessage::SetLists(v.results),
    }
}

impl Component for Home {
    type Message = HomeMessage;
    type Properties = Props;

    fn create(ctx: &Context<Self>) -> Self {
        let home = Home {
            client: kabalist_client::Client::new(
                crate::endpoint(),
                ctx.props().token.clone(),
            ),
            lists: HashMap::new(),
            error: None,
        };

        ctx.link().send_future(lists(home.client.clone()));
        home
    }

    fn update(&mut self, _: &Context<Self>, message: Self::Message) -> bool {
        match message {
            HomeMessage::SetLists(lists) => {
                let redraw = self.lists != lists;
                self.lists = lists;
                redraw
            }
            HomeMessage::Error(e) => {
                self.error = Some(e);
                true
            }
            HomeMessage::ResetError => {
                self.error = None;
                true
            }
        }
    }

    fn view(&self, ctx: &Context<Self>) -> Html {
        let client = self.client.clone();
        let link = ctx.link().to_owned();
        let sync_lists = Callback::from(move |_| link.send_future(lists(client.clone())));

        let logout = ctx.props().logout.clone();
        let on_logout = Callback::from(move |_| logout.emit(()));

        let client = self.client.clone();
        let link = ctx.link().to_owned();

        let l = link.clone();
        let on_newlist = Callback::from(move |name: String| {
            let client = client.clone();
            l.send_future(async move {
                match client.create_list(&name).await {
                    Ok(_) => lists(client).await,
                    Err(e) => HomeMessage::Error(format!("Could not create new list: {:?}", e)),
                }
            })
        });

        let client = self.client.clone();
        let history = link.history().unwrap();
        let on_delete = Callback::from(move |id: Uuid| {
            let client = client.clone();
            let history = history.clone();
            link.send_future(async move {
                match client.delete_list(&id).await {
                    Ok(_) => {
                        history.push(Route::Home);
                        lists(client).await
                    }
                    Err(e) => HomeMessage::Error(format!("Could not delete list: {:?}", e)),
                }
            })
        });

        html! {
          <ContextProvider<Token> context={Token(ctx.props().token.clone())}>
            <div class="bg-dark text-bg-dark bodylike-container">
              <Sidebar
                username={ctx.props().username.clone()}
                selected={ctx.props().list_id}
                {on_delete}
                {on_logout}
                {on_newlist}
                lists={self.lists.clone()}
                token={ctx.props().token.clone()}
                {sync_lists}
              />
              if let Some(err) = &self.error {
                <div class="alert alert-danger alert-dismissible fade show container-sm">
                  <strong>{"Error!"}</strong>{err}
                  <button
                    type="button"
                    class="btn-close"
                    data-bs-dismiss="alert"
                    onclick={ctx.link().callback(|_| HomeMessage::ResetError)}>
                  </button>
                </div>
              }
              if let Some(uuid) = ctx.props().list_id {
                <List token={ctx.props().token.clone()} {uuid}/>
              }
            </div>
          </ContextProvider<Token>>
        }
    }
}
