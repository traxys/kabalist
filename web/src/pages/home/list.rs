use super::modals::{
    add_item::AddItem, add_pantry_item::AddPantryItem, edit_item::EditItem,
    edit_pantry_item::EditPantryItem,
};
use kabalist_client::{Item, PantryItem, Uuid};
use std::borrow::Cow;
use yew::prelude::*;

use crate::endpoint;

pub struct List {
    client: kabalist_client::Client,
    items: Vec<Item>,
    pantry: Vec<PantryItem>,
    error: Option<String>,
}

#[derive(Clone, PartialEq, Properties)]
pub struct Props {
    pub token: String,
    pub uuid: Uuid,
}

#[derive(Debug)]
pub enum ListMessage {
    SetContent(Vec<Item>),
    SetPantry(Vec<PantryItem>),
    Multiple(Box<ListMessage>, Box<ListMessage>),
    Error(String),
}

impl Component for List {
    type Message = ListMessage;
    type Properties = Props;

    fn create(ctx: &Context<Self>) -> Self {
        let client = kabalist_client::Client::new(endpoint(), ctx.props().token.clone());

        let c = client.clone();
        let id = ctx.props().uuid;

        ctx.link().send_future(async move {
            match c.read(&id).await {
                Err(e) => ListMessage::Error(format!("Could not get list: {:?}", e)),
                Ok(v) => ListMessage::SetContent(v.items),
            }
        });

        let c = client.clone();

        ctx.link().send_future(async move {
            match c.pantry(id).await {
                Err(e) => ListMessage::Error(format!("Could not get pantry: {:?}", e)),
                Ok(v) => ListMessage::SetPantry(v.items),
            }
        });

        Self {
            client,
            items: Vec::new(),
            pantry: Vec::new(),
            error: None,
        }
    }

    fn update(&mut self, ctx: &Context<Self>, msg: Self::Message) -> bool {
        match msg {
            ListMessage::SetContent(c) => {
                self.items = c;
                true
            }
            ListMessage::SetPantry(p) => {
                self.pantry = p;
                true
            }
            ListMessage::Error(e) => {
                self.error = Some(e);
                true
            }
            ListMessage::Multiple(a, b) => {
                self.update(ctx, *a);
                self.update(ctx, *b);
                true
            }
        }
    }

    fn changed(&mut self, ctx: &Context<Self>) -> bool {
        let c = self.client.clone();
        let id = ctx.props().uuid;
        ctx.link().send_future(async move {
            match c.read(&id).await {
                Err(e) => ListMessage::Error(format!("Could not get list: {:?}", e)),
                Ok(v) => ListMessage::SetContent(v.items),
            }
        });

        let c = self.client.clone();

        ctx.link().send_future(async move {
            match c.pantry(id).await {
                Err(e) => ListMessage::Error(format!("Could not get pantry: {:?}", e)),
                Ok(v) => ListMessage::SetPantry(v.items),
            }
        });
        true
    }

    fn view(&self, ctx: &Context<Self>) -> Html {
        let link = ctx.link().to_owned();
        let c = self.client.clone();
        let id = ctx.props().uuid;
        let on_delete = Callback::from(move |item: i32| {
            let c = c.clone();
            link.send_future(async move {
                match c.delete_item(&id, item).await {
                    Ok(_) => match (c.read(&id).await, c.pantry(id).await) {
                        (Err(e1), Err(e2)) => {
                            ListMessage::Error(format!("Two errors: {:?}, {:?}", e1, e2))
                        }
                        (Err(e), _) => ListMessage::Error(format!("Could not get list: {:?}", e)),
                        (_, Err(e)) => ListMessage::Error(format!("Could not get pantry: {:?}", e)),
                        (Ok(c), Ok(p)) => ListMessage::Multiple(
                            Box::new(ListMessage::SetContent(c.items)),
                            Box::new(ListMessage::SetPantry(p.items)),
                        ),
                    },
                    Err(e) => ListMessage::Error(format!("Could not add item: {:?}", e)),
                }
            })
        });

        let c = self.client.clone();
        let on_edit_item =
            ctx.link()
                .callback_future(move |(item_id, name, amount): (_, String, String)| {
                    let c = c.clone();
                    async move {
                        match c
                            .update_item(
                                &id,
                                item_id,
                                Some(&name),
                                if amount.is_empty() {
                                    None
                                } else {
                                    Some(&amount)
                                },
                            )
                            .await
                        {
                            Ok(_) => match c.read(&id).await {
                                Err(e) => {
                                    ListMessage::Error(format!("Could not get list: {:?}", e))
                                }
                                Ok(v) => ListMessage::SetContent(v.items),
                            },
                            Err(e) => ListMessage::Error(format!("Could not edit item: {:?}", e)),
                        }
                    }
                });

        let items = self
            .items
            .iter()
            .map(|item| render_item(item, on_delete.clone(), on_edit_item.clone()));

        let link = ctx.link().to_owned();
        let c = self.client.clone();
        let id = ctx.props().uuid;
        let add_list = Callback::from(move |(name, amount): (String, String)| {
            let c = c.clone();
            link.send_future(async move {
                match c
                    .add(
                        &id,
                        &name,
                        if amount.is_empty() {
                            None
                        } else {
                            Some(&amount)
                        },
                    )
                    .await
                {
                    Ok(_) => match c.read(&id).await {
                        Err(e) => ListMessage::Error(format!("Could not get list: {:?}", e)),
                        Ok(v) => ListMessage::SetContent(v.items),
                    },
                    Err(e) => ListMessage::Error(format!("Could not add item: {:?}", e)),
                }
            })
        });

        let c = self.client.clone();

        let on_pantry_delete = ctx.link().callback_future(move |item: i32| {
            let c = c.clone();
            async move {
                match c.delete_pantry_item(id, item).await {
                    Ok(_) => match (c.read(&id).await, c.pantry(id).await) {
                        (Err(e1), Err(e2)) => {
                            ListMessage::Error(format!("Two errors: {:?}, {:?}", e1, e2))
                        }
                        (Err(e), _) => ListMessage::Error(format!("Could not get list: {:?}", e)),
                        (_, Err(e)) => ListMessage::Error(format!("Could not get pantry: {:?}", e)),
                        (Ok(c), Ok(p)) => ListMessage::Multiple(
                            Box::new(ListMessage::SetContent(c.items)),
                            Box::new(ListMessage::SetPantry(p.items)),
                        ),
                    },
                    Err(e) => ListMessage::Error(format!("Could not delete pantry item: {:?}", e)),
                }
            }
        });

        let c = self.client.clone();
        let on_edit_pantry_item =
            ctx.link()
                .callback_future(move |(item_id, amount, target): (_, String, String)| {
                    let c = c.clone();
                    async move {
                        let (target, amount) = match (target.parse(), amount.parse()) {
                            (Ok(t), Ok(a)) => (t, a),
                            _ => {
                                return ListMessage::Error("Target/Amount where not numbers".into())
                            }
                        };

                        match c
                            .edit_pantry_item(id, item_id, Some(amount), Some(target))
                            .await
                        {
                            Ok(_) => match c.pantry(id).await {
                                Err(e) => {
                                    ListMessage::Error(format!("Could not get list: {:?}", e))
                                }
                                Ok(v) => ListMessage::SetPantry(v.items),
                            },
                            Err(e) => ListMessage::Error(format!("Could not edit item: {:?}", e)),
                        }
                    }
                });

        let pantry_items = self.pantry.iter().map(move |item| {
            render_pantry_item(item, on_pantry_delete.clone(), on_edit_pantry_item.clone())
        });

        let c = self.client.clone();
        let on_refill = ctx.link().callback_future_once(move |_| async move {
            match c.refill_pantry(id).await {
                Ok(_) => match c.read(&id).await {
                    Err(e) => ListMessage::Error(format!("Could not get list: {:?}", e)),
                    Ok(v) => ListMessage::SetContent(v.items),
                },
                Err(e) => ListMessage::Error(format!("Could not add item: {:?}", e)),
            }
        });

        let c = self.client.clone();

        let add_pantry =
            ctx.link()
                .callback_future_once(move |(name, target): (String, String)| async move {
                    let target: i32 = match target.parse() {
                        Ok(t) => t,
                        Err(_) => {
                            return ListMessage::Error("Expected number for target".to_string())
                        }
                    };
                    match c.add_to_pantry(id, name, target).await {
                        Ok(_) => match c.pantry(id).await {
                            Err(e) => ListMessage::Error(format!("Could not get pantry: {:?}", e)),
                            Ok(v) => ListMessage::SetPantry(v.items),
                        },
                        Err(e) => ListMessage::Error(format!("Could not add item: {:?}", e)),
                    }
                });

        html! {
            <div
              class="container centering shadow m-5 border border-3 rounded-3 d-flex flex-column"
              id="list"
            >
                <ul class="nav nav-pills mb-3" id="pills-tab" role="tablist">
                    <li class="nav-item pe-3" role="presentation">
                        <button
                            class="nav-link active"
                            id="pills-list-tab"
                            data-bs-toggle="pill"
                            type="button"
                            role="tab"
                            data-bs-target="#pills-list"
                            aria-controls="pills-list"
                            aria-selected="true"
                        >
                        {"List"}
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button
                            class="nav-link"
                            id="pills-pantry-tab"
                            data-bs-toggle="pill"
                            type="button"
                            role="tab"
                            data-bs-target="#pills-pantry"
                            aria-controls="pills-pantry"
                            aria-selected="false"
                        >
                        {"Pantry"}
                        </button>
                    </li>
                </ul>
                <div class="tab-content overflow-scroll container-fluid mb-auto" id="pills-tabContent">
                  <div
                    class="tab-pane fade active show"
                    id="pills-list"
                    role="tabpanel"
                    aria-labelledby="pills-list-tab"
                    tabindex="0"
                  >
                    <div class="container-fluid mb-auto">
                      {items.collect::<Html>()}
                    </div>
                    <div class="container-fluid text-end p-2">
                      <button
                        class="btn btn-primary"
                        data-bs-toggle="modal"
                        data-bs-target="#addItemModal"
                      >
                        <i class="bi-journal-plus"></i>
                      </button>
                      <AddItem modal_id="addItemModal" on_add_item={add_list}/>
                    </div>
                  </div>
                  <div
                    class="tab-pane fade"
                    id="pills-pantry"
                    role="tabpanel"
                    aria-labelledby="pills-pantry-tab"
                    tabindex="0"
                  >
                    <div class="container-fluid mb-auto">
                      {pantry_items.collect::<Html>()}
                    </div>
                    <div class="container-fluid text-end p-2">
                      <button
                        class="btn btn-primary m-1"
                        data-bs-toggle="modal"
                        data-bs-target="#addPantryItemModal"
                      >
                        <i class="bi-journal-plus"></i>
                      </button>
                      <AddPantryItem modal_id="addPantryItemModal" on_add_item={add_pantry}/>
                      <button
                        class="btn btn-primary m-1"
                        onclick={on_refill}
                      >
                        <i class="bi-cart-plus"></i>
                      </button>
                    </div>
                  </div>
                </div>
            </div>
        }
    }
}

fn render_item(
    item: &Item,
    on_delete_item: Callback<i32>,
    edit_item: Callback<(i32, String, String)>,
) -> Html {
    let text: Cow<_> = match &item.amount {
        Some(v) => format!("{} ({})", item.name, v).into(),
        None => (&item.name).into(),
    };
    let item_id = item.id;
    let onclick_delete = Callback::from(move |_| on_delete_item.emit(item_id));
    let modal_id = format!("editItemModal{}", item.id);
    let edit_item = Callback::from(move |(name, amount)| edit_item.emit((item_id, name, amount)));
    html! {<>
        <div key={item_id} class="d-flex">
            <div class="me-auto">{text}</div>
            <button
              class="btn btn-primary me-1"
              data-bs-toggle="modal"
              data-bs-target={format!("#{}", modal_id)}
            >
              <i class="bi-pencil"></i>
            </button>
            <button class="btn btn-danger" onclick={onclick_delete}>
              <i class="bi-trash"></i>
            </button>
            <EditItem
                {modal_id}
                name={item.name.clone()}
                amount={item.amount.clone().unwrap_or_default()}
                on_edit_item={edit_item}
            />
        </div>
        <hr />
    </>}
}

fn render_pantry_item(
    item: &PantryItem,
    on_delete_item: Callback<i32>,
    edit_item: Callback<(i32, String, String)>,
) -> Html {
    let item_id = item.id;
    let text = format!("{} ({}/{})", item.name, item.amount, item.target);

    let onclick_delete = Callback::from(move |_| on_delete_item.emit(item_id));

    let modal_id = format!("editPantryItemModal{}", item.id);

    let edit_item =
        Callback::from(move |(amount, target)| edit_item.emit((item_id, amount, target)));

    html! {<>
        <div key={item.id} class="d-flex">
            <div class="me-auto">{text}</div>
            <button
              class="btn btn-primary me-1"
              data-bs-toggle="modal"
              data-bs-target={format!("#{}", modal_id)}
            >
              <i class="bi-pencil"></i>
            </button>
            <EditPantryItem
                {modal_id}
                target={item.target.to_string()}
                amount={item.amount.to_string()}
                on_edit_item={edit_item}
            />
            <button class="btn btn-danger" onclick={onclick_delete}>
              <i class="bi-trash"></i>
            </button>
        </div>
        <hr />
    </>}
}
