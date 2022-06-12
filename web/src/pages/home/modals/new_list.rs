use crate::{
    modal::Modal,
    text_input::{self, TextInput},
};
use yew::prelude::*;

pub enum NewListMessage {
    Name(String),
    Clear,
}

pub struct NewList {
    name: String,
}

#[derive(PartialEq, Clone, Properties)]
pub struct NewListProps {
    pub modal_id: String,
    pub on_newlist: Callback<String>,
}

impl Component for NewList {
    type Message = NewListMessage;
    type Properties = NewListProps;

    fn update(&mut self, _: &Context<Self>, msg: Self::Message) -> bool {
        match msg {
            NewListMessage::Name(n) => self.name = n,
            NewListMessage::Clear => self.name.clear(),
        }
        true
    }

    fn create(_: &Context<Self>) -> Self {
        Self {
            name: String::new(),
        }
    }

    fn view(&self, ctx: &Context<Self>) -> Html {
        let on_change = ctx.link().callback(NewListMessage::Name);

        let value = self.name.clone();
        let on_newlist = ctx.props().on_newlist.clone();
        let on_validated = ctx.link().callback(move |_| {
            on_newlist.emit(value.clone());
            NewListMessage::Clear
        });

        html! {
          <Modal
            id={ctx.props().modal_id.clone()}
            title="Create a new list"
            validate="Create List"
            {on_validated}
          >
           <div class="form-floating">
            <TextInput
              ty={text_input::Type::Text}
              id="floatingNewListName"
              placeholder="List Name"
              class="form-control bg-dark text-bg-dark"
              value={self.name.clone()}
              {on_change}
            />
            <label for="floatingNewListName">{"List Name"}</label>
           </div>
          </Modal>
        }
    }
}
