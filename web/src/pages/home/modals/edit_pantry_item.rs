use crate::{
    modal::Modal,
    text_input::{self, TextInput},
};
use yew::prelude::*;

pub enum EditPantryItemMessage {
    Amount(String),
    Target(String),
    Clear,
}

#[derive(Clone, PartialEq, Properties)]
pub struct EditPantryItemProps {
    pub modal_id: String,
    pub amount: String,
    pub target: String,
    pub on_edit_item: Callback<(String, String)>,
}

pub struct EditPantryItem {
    amount: String,
    target: String,
}

impl Component for EditPantryItem {
    type Message = EditPantryItemMessage;
    type Properties = EditPantryItemProps;

    fn create(ctx: &Context<Self>) -> Self {
        Self {
            target: ctx.props().target.clone(),
            amount: ctx.props().amount.clone(),
        }
    }

    fn changed(&mut self, ctx: &yew::Context<Self>, _old_props: &Self::Properties) -> bool {
        self.target = ctx.props().target.clone();
        self.amount = ctx.props().amount.clone();
        true
    }

    fn update(&mut self, _: &Context<Self>, msg: Self::Message) -> bool {
        match msg {
            EditPantryItemMessage::Target(n) => {
                self.target = n;
            }
            EditPantryItemMessage::Amount(a) => {
                self.amount = a;
            }
            EditPantryItemMessage::Clear => {
                self.target.clear();
                self.amount.clear();
            }
        }
        true
    }

    fn view(&self, ctx: &Context<Self>) -> Html {
        let on_target_change = ctx.link().callback(EditPantryItemMessage::Target);
        let on_amount_change = ctx.link().callback(EditPantryItemMessage::Amount);

        let target = self.target.clone();
        let amount = self.amount.clone();
        let on_edit_item = ctx.props().on_edit_item.clone();
        let on_validated = ctx.link().callback(move |_| {
            on_edit_item.emit((amount.clone(), target.clone()));
            EditPantryItemMessage::Clear
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
                ty={text_input::Type::Number}
                id="floatingEditItemAmount"
                placeholder="Amount"
                class="form-control bg-dark text-bg-dark"
                value={self.amount.clone()}
                on_change={on_amount_change}
              />
              <label for="floatingEditItemAmount">{"Amount"}</label>
             </div>
             <div class="form-floating">
               <TextInput
                ty={text_input::Type::Number}
                id="floatingEditItemTarget"
                placeholder="Item"
                class="form-control bg-dark text-bg-dark"
                value={self.target.clone()}
                on_change={on_target_change}
               />
               <label for="floatingEditItemTarget">{"Target"}</label>
             </div>
           </div>
          </Modal>
        }
    }
}
