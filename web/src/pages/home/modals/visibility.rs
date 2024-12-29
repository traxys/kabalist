use crate::{modal::Modal, endpoint};
use kabalist_client::Uuid;
use yew::prelude::*;

pub struct ListVisibility {
    client: kabalist_client::Client,
    public: bool,
}

pub enum ListVisibilityMessage {
    TogglePublic,
}

#[derive(PartialEq, Clone, Properties)]
pub struct ListVisibilityProps {
    pub modal_id: String,
    pub id: Uuid,
    pub token: String,
    pub on_toggle: Callback<()>,
    pub public: bool,
}

impl Component for ListVisibility {
    type Message = ListVisibilityMessage;
    type Properties = ListVisibilityProps;

    fn create(ctx: &Context<Self>) -> Self {
        let client = kabalist_client::Client::new(endpoint(), ctx.props().token.clone());

        Self {
            client,
            public: ctx.props().public,
        }
    }

    fn changed(&mut self, ctx: &yew::Context<Self>, _old_props: &Self::Properties) -> bool {
        self.client = kabalist_client::Client::new(endpoint(), ctx.props().token.clone());
        self.public = ctx.props().public;
        true
    }

    fn update(&mut self, _: &Context<Self>, msg: Self::Message) -> bool {
        match msg {
            ListVisibilityMessage::TogglePublic => self.public = !self.public,
        }
        true
    }

    fn view(&self, ctx: &Context<Self>) -> Html {
        let on_toggle = ctx.props().on_toggle.clone();
        let public = self.public;
        let client = self.client.clone();
        let id = ctx.props().id;
        let on_validated = Callback::from(move |_| {
            let c = client.clone();
            let on_toggle = on_toggle.clone();
            wasm_bindgen_futures::spawn_local(async move {
                if public {
                    let _ = c.set_public(&id).await;
                } else {
                    let _ = c.remove_public(&id).await;
                }
                on_toggle.emit(());
            });
        });

        html! {
          <Modal
            id={ctx.props().modal_id.clone()}
            title="Update List Visibility"
            validate="Update"
            {on_validated}
          >
            if public {
                <p>
                  {"Public link is: "}
                  <a>{format!("{}/public/{}", crate::endpoint().trim(), id)}</a>
                </p>
            }
            <label>
              <input
                type="checkbox"
                value="remember-me"
                checked={public}
                onclick={ctx.link().callback(move |_| ListVisibilityMessage::TogglePublic)}
              />
              {" Public List"}
            </label>
          </Modal>
        }
    }
}
