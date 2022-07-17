use crate::{
    modal::Modal,
    text_input::{self, TextInput},
};
use yew::prelude::*;

pub enum AddPantryItemMessage {
    Name(String),
    Target(String),
    Clear,
}

#[derive(Clone, PartialEq, Properties)]
pub struct AddPantryItemProps {
    pub modal_id: String,
    pub on_add_item: Callback<(String, String)>,
}

pub struct AddPantryItem {
    name: String,
    target: String,
}

impl Component for AddPantryItem {
    type Message = AddPantryItemMessage;
    type Properties = AddPantryItemProps;

    fn create(_: &Context<Self>) -> Self {
        Self {
            name: String::new(),
            target: String::new(),
        }
    }

    fn update(&mut self, _: &Context<Self>, msg: Self::Message) -> bool {
        match msg {
            AddPantryItemMessage::Name(n) => {
                self.name = n;
            }
            AddPantryItemMessage::Target(t) => {
                self.target = t;
            }
            AddPantryItemMessage::Clear => {
                self.name.clear();
                self.target.clear();
            }
        }
        true
    }

    fn view(&self, ctx: &Context<Self>) -> Html {
        let on_name_change = ctx.link().callback(AddPantryItemMessage::Name);
        let on_target_change = ctx.link().callback(AddPantryItemMessage::Target);

        let name = self.name.clone();
        let target = self.target.clone();
        let on_add_item = ctx.props().on_add_item.clone();
        let on_validated = ctx.link().callback(move |_| {
            on_add_item.emit((name.clone(), target.clone()));
            AddPantryItemMessage::Clear
        });

        html! {
          <Modal
            id={ctx.props().modal_id.clone()}
            title="Add Pantry Item"
            validate="Add"
            {on_validated}
          >
           <div class="form-add-item">
             <div class="form-floating">
               <TextInput
                ty={text_input::Type::Text}
                id="floatingAddItemName"
                placeholder="Item"
                class="form-control bg-dark text-bg-dark"
                value={self.name.clone()}
                on_change={on_name_change}
               />
               <label for="floatingAddItemName">{"Item"}</label>
             </div>
             <div class="form-floating">
              <TextInput
                ty={text_input::Type::Number}
                id="floatingAddItemTarget"
                placeholder="Target"
                class="form-control bg-dark text-bg-dark"
                value={self.target.clone()}
                on_change={on_target_change}
              />
              <label for="floatingAddItemTarget">{"Target"}</label>
             </div>
           </div>
          </Modal>
        }
    }
}
