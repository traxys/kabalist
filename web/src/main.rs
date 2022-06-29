use gloo::storage::{errors::StorageError, Storage};
use kabalist_client::Uuid;
use yew::prelude::*;
use yew_router::prelude::*;

use pages::{home::Home, login::Login, register::Register};

#[cfg(feature = "standalone")]
pub(crate) fn endpoint() -> String {
    include_str!("../../endpoint.url").into()
}

#[cfg(not(feature = "standalone"))]
pub(crate) fn endpoint() -> String {
    let mut root = web_sys::window().unwrap().location().origin().unwrap();
    root += "/api";
    root
}

#[derive(Clone, Copy, Routable, PartialEq)]
enum Route {
    #[at("/")]
    Root,
    #[at("/home")]
    Home,
    #[at("/home/:id")]
    List { id: Uuid },
    #[at("/login")]
    Login,
    #[at("/register")]
    Register,
    #[at("/register/:id")]
    RegisterPrefill { id: Uuid },
    #[at("/404")]
    #[not_found]
    NotFound,
}

mod button_redirect;
mod modal;
mod pages;
mod text_input;

enum AppMessage {
    Login(AccountInfo),
    Logout,
}

#[derive(serde::Serialize, serde::Deserialize, Clone, PartialEq)]
pub struct AccountInfo {
    username: String,
    token: String,
}

struct App {
    account_info: Option<AccountInfo>,
}

fn route_switch(
    route: &Route,
    on_login: Callback<AccountInfo>,
    logout: Callback<()>,
    token: Option<AccountInfo>,
) -> Html {
    match (route, token) {
        (Route::Home | Route::List { .. }, Some(info)) => {
            let list_id = match route {
                Route::Home => None,
                Route::List { id } => Some(*id),
                _ => unreachable!(),
            };
            html! { <Home token={info.token} username={info.username} {logout} {list_id} /> }
        }
        (Route::Home | Route::Root | Route::List { .. }, None) => {
            html! { <Redirect<Route> to={Route::Login} />}
        }
        (Route::Login | Route::Root, Some(_)) => html! { <Redirect<Route> to={Route::Home}/> },
        (Route::Register, _) => html! { <Register registration_id={""} /> },
        (Route::RegisterPrefill { id }, _) => {
            html! { <Register registration_id={id.to_string()} /> }
        }
        (Route::Login, None) => html! { <Login {on_login}/> },
        (Route::NotFound, _) => html! { <h1>{"404"}</h1> },
    }
}

impl Component for App {
    type Message = AppMessage;
    type Properties = ();

    fn create(_ctx: &Context<Self>) -> Self {
        match gloo::storage::LocalStorage::get("account_info") {
            Ok(info) => Self {
                account_info: Some(info),
            },
            Err(StorageError::KeyNotFound(_)) => Self { account_info: None },
            Err(e) => {
                gloo::console::error!(format!("Error fetching account info: {:?}", e));
                Self { account_info: None }
            }
        }
    }

    fn update(&mut self, _ctx: &Context<Self>, msg: Self::Message) -> bool {
        match msg {
            AppMessage::Login(token) => {
                self.account_info = Some(token);
            }
            AppMessage::Logout => {
                self.account_info = None;
                gloo::storage::LocalStorage::delete("account_info");
            }
        }
        true
    }

    fn view(&self, ctx: &Context<Self>) -> Html {
        let on_login = ctx.link().callback(AppMessage::Login);
        let logout = ctx.link().callback(|()| AppMessage::Logout);
        let account_info = self.account_info.clone();
        let render = Switch::render(move |r| {
            route_switch(r, on_login.clone(), logout.clone(), account_info.clone())
        });

        //let link = ctx.link();
        html! {<>
            <script
                src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/js/bootstrap.bundle.min.js"
                integrity="sha384-pprn3073KE6tl6bjs2QrFaJGz5/SUsLqktiwsUTF55Jfv3qYSDhgCecCxMW52nD2"
                crossorigin="anonymous"
            >
            </script>

            <BrowserRouter>
                <Switch<Route> {render} />
            </BrowserRouter>
        </>}
    }
}

fn main() {
    yew::start_app::<App>();
}
