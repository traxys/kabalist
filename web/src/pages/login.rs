use crate::{
    text_input::{self, TextInput},
    AccountInfo, ENDPOINT,
};
use gloo::storage::Storage;
use yew::prelude::*;

pub enum Message {
    EditPassword(String),
    EditUsername(String),
    ToggleRemberMe,
    DoLogin,
    LoginResponse(Result<(), String>),
}

#[derive(Clone, PartialEq, Properties)]
pub struct Props {
    pub on_login: Callback<AccountInfo>,
}

pub struct Login {
    username: String,
    password: String,
    remember_me: bool,
    error: Option<String>,
}

impl Component for Login {
    type Message = Message;
    type Properties = Props;

    fn create(_: &Context<Self>) -> Self {
        Login {
            username: String::new(),
            password: String::new(),
            remember_me: false,
            error: None,
        }
    }

    fn update(&mut self, ctx: &Context<Self>, msg: Self::Message) -> bool {
        match msg {
            Message::EditPassword(p) => self.password = p,
            Message::EditUsername(u) => self.username = u,
            Message::ToggleRemberMe => self.remember_me = !self.remember_me,
            Message::LoginResponse(response) => {
                if let Err(e) = response {
                    self.error = Some(e)
                }
            }
            Message::DoLogin => {
                let username = self.username.clone();
                let password = self.password.clone();

                let on_login = ctx.props().on_login.clone();
                let remember_me = self.remember_me;

                ctx.link().send_future(async move {
                    let resp = match kabalist_client::login(ENDPOINT, &username, &password).await {
                        Ok(r) => Ok(r.token),
                        Err(kabalist_client::Error::Api(e)) => Err(format!("{}", e)),
                        Err(kabalist_client::Error::Http(e)) => {
                            Err(format!("Connection error: {}", e))
                        }
                    };
                    match resp {
                        Ok(token) => {
                            let info = AccountInfo { username, token };
                            if remember_me {
                                let _ = gloo::storage::LocalStorage::set("account_info", &info);
                            }
                            on_login.emit(info);
                            Message::LoginResponse(Ok(()))
                        }
                        Err(e) => Message::LoginResponse(Err(e)),
                    }
                });
            }
        }
        true
    }

    fn view(&self, ctx: &Context<Self>) -> Html {
        let password_on_change = ctx.link().callback(Message::EditPassword);
        let username_on_change = ctx.link().callback(Message::EditUsername);

        html! {
          <div class="text-center bodylike-container centering bg-dark text-bg-dark">
            <main class="form-login w-100 m-auto">
              <form
                onsubmit={ctx.link().callback(|_|Message::DoLogin)}
                action="javascript:void(0);"
              >
                <h1 class="h3 mb-3 fw-normal">{"Please login"}</h1>

                  <div class="form-floating">
                    <TextInput
                      ty={text_input::Type::Text}
                      value={self.username.clone()}
                      class="form-control bg-dark text-bg-dark"
                      placeholder="username"
                      on_change={username_on_change}
                      id="floatingInput"
                    />
                    <label for="floatingInput">{"Username"}</label>
                  </div>

                  <div class="form-floating">
                    <TextInput
                      ty={text_input::Type::Password}
                      value={self.password.clone()}
                      class="form-control bg-dark text-bg-dark"
                      placeholder="password"
                      on_change={password_on_change}
                      id="floatingPassword"
                    />
                    <label for="floatingPassword">{"Password"}</label>
                  </div>

                  <div class="checkbox mb-3">
                    <label>
                      <input
                        type="checkbox"
                        value="remember-me"
                        checked={self.remember_me}
                        onclick={ctx.link().callback(move |_| Message::ToggleRemberMe)}
                      />
                      {" Remember me"}
                    </label>
                  </div>

                  <button
                    class="w-100 btn btn-lg btn-primary"
                    type="submit"
                  >
                    {"Sign in"}
                  </button>
              </form>
            </main>
          </div>
        }
    }
}
