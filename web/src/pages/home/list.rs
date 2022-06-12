use super::modals::{add_item::AddItem, edit_item::EditItem};
use kabalist_client::{Item, Uuid};
use std::borrow::Cow;
use yew::prelude::*;

use crate::ENDPOINT;

pub struct List {
    client: kabalist_client::Client,
    items: Vec<Item>,
    error: Option<String>,
}

#[derive(Clone, PartialEq, Properties)]
pub struct Props {
    pub token: String,
    pub uuid: Uuid,
}

pub enum ListMessage {
    SetContent(Vec<Item>),
    Error(String),
}

impl Component for List {
    type Message = ListMessage;
    type Properties = Props;

    fn create(ctx: &Context<Self>) -> Self {
        let client = kabalist_client::Client::new(ENDPOINT.to_string(), ctx.props().token.clone());

        let c = client.clone();
        let id = ctx.props().uuid;

        ctx.link().send_future(async move {
            match c.read(&id).await {
                Err(e) => ListMessage::Error(format!("Could not get list: {:?}", e)),
                Ok(v) => ListMessage::SetContent(v.items),
            }
        });

        Self {
            client,
            items: Vec::new(),
            error: None,
        }
    }

    fn update(&mut self, _ctx: &Context<Self>, msg: Self::Message) -> bool {
        match msg {
            ListMessage::SetContent(c) => {
                self.items = c;
                true
            }
            ListMessage::Error(e) => {
                self.error = Some(e);
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
                    Ok(_) => match c.read(&id).await {
                        Err(e) => ListMessage::Error(format!("Could not get list: {:?}", e)),
                        Ok(v) => ListMessage::SetContent(v.items),
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

        html! {
            <div
              class="container centering shadow m-5 border border-3 rounded-3 d-flex flex-column"
              id="list"
            >
                <div class="overflow-scroll container-fluid mb-auto">
                    {items.collect::<Html>()}
                </div>
                <div class="container-fluid text-end p-2">
                    <button
                      class="btn btn-primary"
                      data-bs-toggle="modal"
                      data-bs-target="#addItemModal"
                    >
                      <i class="bi-cart-plus"></i>
                    </button>
                    <AddItem modal_id="addItemModal" on_add_item={add_list}/>
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
