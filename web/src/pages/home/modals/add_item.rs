use crate::{
    modal::Modal,
    text_input::{self, TextInput},
};
use yew::prelude::*;

pub enum AddItemMessage {
    Name(String),
    Amount(String),
    Clear,
}

#[derive(Clone, PartialEq, Properties)]
pub struct AddItemProps {
    pub modal_id: String,
    pub on_add_item: Callback<(String, String)>,
}

pub struct AddItem {
    name: String,
    amount: String,
}

impl Component for AddItem {
    type Message = AddItemMessage;
    type Properties = AddItemProps;

    fn create(_: &Context<Self>) -> Self {
        Self {
            name: String::new(),
            amount: String::new(),
        }
    }

    fn update(&mut self, _: &Context<Self>, msg: Self::Message) -> bool {
        match msg {
            AddItemMessage::Name(n) => {
                self.name = n;
            }
            AddItemMessage::Amount(a) => {
                self.amount = a;
            }
            AddItemMessage::Clear => {
                self.name.clear();
                self.amount.clear();
            }
        }
        true
    }

    fn view(&self, ctx: &Context<Self>) -> Html {
        let on_name_change = ctx.link().callback(AddItemMessage::Name);
        let on_amount_change = ctx.link().callback(AddItemMessage::Amount);

        let name = self.name.clone();
        let amount = self.amount.clone();
        let on_add_item = ctx.props().on_add_item.clone();
        let on_validated = ctx.link().callback(move |_| {
            on_add_item.emit((name.clone(), amount.clone()));
            AddItemMessage::Clear
        });

        html! {
          <Modal
            id={ctx.props().modal_id.clone()}
            title="Add Item"
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
                ty={text_input::Type::Text}
                id="floatingAddItemAmount"
                placeholder="Amount"
                class="form-control bg-dark text-bg-dark"
                value={self.amount.clone()}
                on_change={on_amount_change}
              />
              <label for="floatingAddItemAmount">{"Amount"}</label>
             </div>
           </div>
          </Modal>
        }
    }
}
