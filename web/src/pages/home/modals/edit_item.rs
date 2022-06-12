use crate::{
    modal::Modal,
    text_input::{self, TextInput},
};
use yew::prelude::*;

pub enum EditItemMessage {
    Name(String),
    Amount(String),
    Clear,
}

#[derive(Clone, PartialEq, Properties)]
pub struct EditItemProps {
    pub modal_id: String,
    pub name: String,
    pub amount: String,
    pub on_edit_item: Callback<(String, String)>,
}

pub struct EditItem {
    name: String,
    amount: String,
}

impl Component for EditItem {
    type Message = EditItemMessage;
    type Properties = EditItemProps;

    fn create(ctx: &Context<Self>) -> Self {
        Self {
            name: ctx.props().name.clone(),
            amount: ctx.props().amount.clone(),
        }
    }

    fn changed(&mut self, ctx: &Context<Self>) -> bool {
        self.name = ctx.props().name.clone();
        self.amount = ctx.props().amount.clone();
        true
    }

    fn update(&mut self, _: &Context<Self>, msg: Self::Message) -> bool {
        match msg {
            EditItemMessage::Name(n) => {
                self.name = n;
            }
            EditItemMessage::Amount(a) => {
                self.amount = a;
            }
            EditItemMessage::Clear => {
                self.name.clear();
                self.amount.clear();
            }
        }
        true
    }

    fn view(&self, ctx: &Context<Self>) -> Html {
        let on_name_change = ctx.link().callback(EditItemMessage::Name);
        let on_amount_change = ctx.link().callback(EditItemMessage::Amount);

        let name = self.name.clone();
        let amount = self.amount.clone();
        let on_edit_item = ctx.props().on_edit_item.clone();
        let on_validated = ctx.link().callback(move |_| {
            on_edit_item.emit((name.clone(), amount.clone()));
            EditItemMessage::Clear
        });

        html! {
          <Modal
            id={ctx.props().modal_id.clone()}
            title="Edit Item"
            validate="Edit"
            {on_validated}
          >
           <div class="form-add-item">
             <div class="form-floating">
               <TextInput
                ty={text_input::Type::Text}
                id="floatingEditItemName"
                placeholder="Item"
                class="form-control bg-dark text-bg-dark"
                value={self.name.clone()}
                on_change={on_name_change}
               />
               <label for="floatingEditItemName">{"Item"}</label>
             </div>
             <div class="form-floating">
              <TextInput
                ty={text_input::Type::Text}
                id="floatingEditItemAmount"
                placeholder="Amount"
                class="form-control bg-dark text-bg-dark"
                value={self.amount.clone()}
                on_change={on_amount_change}
              />
              <label for="floatingEditItemAmount">{"Amount"}</label>
             </div>
           </div>
          </Modal>
        }
    }
}
