use crate::{
    endpoint,
    text_input::{self, TextInput},
};
use yew::prelude::*;

pub enum Message {
    EditPassword(String),
    EditId(String),
    DoRegister,
    RecoverDone(Result<(), String>),
}

#[derive(Clone, PartialEq, Properties)]
pub struct Props {
    pub recovery_id: String,
}

pub struct Recover {
    id: String,
    password: String,
    redirect_login: bool,
    error: Option<String>,
}

impl Component for Recover {
    type Message = Message;
    type Properties = Props;

    fn create(ctx: &Context<Self>) -> Self {
        Recover {
            id: ctx.props().recovery_id.clone(),
            password: String::new(),
            redirect_login: false,
            error: None,
        }
    }

    fn changed(&mut self, ctx: &yew::Context<Self>, old_props: &Self::Properties) -> bool {
        self.id = ctx.props().recovery_id.clone();
        true
    }

    fn update(&mut self, ctx: &Context<Self>, msg: Self::Message) -> bool {
        match msg {
            Message::EditPassword(p) => self.password = p,
            Message::EditId(i) => self.id = i,
            Message::RecoverDone(response) => match response {
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
                let password = self.password.clone();

                ctx.link().send_future(async move {
                    let resp = match kabalist_client::recover_password(&endpoint(), &id, &password)
                        .await
                    {
                        Ok(_) => Ok(()),
                        Err(kabalist_client::Error::Api(e)) => Err(format!("{}", e)),
                        Err(kabalist_client::Error::Http(e)) => {
                            Err(format!("Connection error: {}", e))
                        }
                    };

                    Message::RecoverDone(resp)
                });
            }
        }
        true
    }

    fn view(&self, ctx: &Context<Self>) -> Html {
        let password_on_change = ctx.link().callback(Message::EditPassword);
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
