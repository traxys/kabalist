use crate::{
    text_input::{self, TextInput},
    ENDPOINT,
};
use yew::prelude::*;

pub enum Message {
    EditPassword(String),
    EditUsername(String),
    EditId(String),
    DoRegister,
    RegisterDone(Result<(), String>),
}

#[derive(Clone, PartialEq, Properties)]
pub struct Props {
    pub registration_id: String,
}

pub struct Register {
    id: String,
    username: String,
    password: String,
    redirect_login: bool,
    error: Option<String>,
}

impl Component for Register {
    type Message = Message;
    type Properties = Props;

    fn create(ctx: &Context<Self>) -> Self {
        Register {
            id: ctx.props().registration_id.clone(),
            username: String::new(),
            password: String::new(),
            redirect_login: false,
            error: None,
        }
    }

    fn changed(&mut self, ctx: &Context<Self>) -> bool {
        self.id = ctx.props().registration_id.clone();
        true
    }

    fn update(&mut self, ctx: &Context<Self>, msg: Self::Message) -> bool {
        match msg {
            Message::EditPassword(p) => self.password = p,
            Message::EditUsername(u) => self.username = u,
            Message::EditId(i) => self.id = i,
            Message::RegisterDone(response) => match response {
                Err(e) => self.error = Some(e),
                Ok(_) => self.redirect_login = true,
            },
            Message::DoRegister => {
                let id = match self.id.parse() {
                    Ok(id) => id,
                    Err(_) => {
                        self.error = Some("Invalid registration id".into());
                        return true;
                    }
                };
                let username = self.username.clone();
                let password = self.password.clone();

                ctx.link().send_future(async move {
                    let resp =
                        match kabalist_client::register(ENDPOINT, id, &username, &password).await {
                            Ok(_) => Ok(()),
                            Err(kabalist_client::Error::Api(e)) => Err(format!("{}", e)),
                            Err(kabalist_client::Error::Http(e)) => {
                                Err(format!("Connection error: {}", e))
                            }
                        };

                    Message::RegisterDone(resp)
                });
            }
        }
        true
    }

    fn view(&self, ctx: &Context<Self>) -> Html {
        let password_on_change = ctx.link().callback(Message::EditPassword);
        let username_on_change = ctx.link().callback(Message::EditUsername);
        let register_id_on_change = ctx.link().callback(Message::EditId);

        html! {
          <div class="text-center bodylike-container centering bg-dark text-bg-dark">
            <main class="form-login w-100 m-auto">
              <form
                onsubmit={ctx.link().callback(|_|Message::DoRegister)}
                action="javascript:void(0);"
              >
                <h1 class="h3 mb-3 fw-normal">{"Register"}</h1>

                  <div class="form-floating">
                    <TextInput
                      ty={text_input::Type::Text}
                      value={self.id.clone()}
                      class="form-control bg-dark text-bg-dark"
                      placeholder="register-id"
                      on_change={register_id_on_change}
                      id="floatingRegister"
                    />
                    <label for="floatingRegister">{"Register id"}</label>
                  </div>

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

                  <button
                    class="w-100 btn btn-lg btn-primary"
                    type="submit"
                  >
                    {"Register"}
                  </button>
              </form>
            </main>
          </div>
        }
    }
}
