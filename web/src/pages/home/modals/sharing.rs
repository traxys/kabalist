use std::collections::{HashMap, HashSet};

use crate::{
    endpoint,
    modal::Modal,
    text_input::{self, TextInput},
};
use kabalist_client::Uuid;
use yew::prelude::*;

pub struct ListSharing {
    client: kabalist_client::Client,
    shares: HashMap<Uuid, Share>,
    updates: HashMap<Uuid, Share>,
    deleted: HashSet<Uuid>,
    share_with: String,
}

#[derive(Debug, Clone)]
pub struct Share {
    name: String,
    readonly: bool,
}

pub enum ListSharingMessage {
    SetShares(HashMap<Uuid, Share>),
    AddShareEdit(String),
    SetWriteReadonly(Uuid, bool),
    Delete(Uuid),
    AddShare,
    Clear,
    Commit,
}

#[derive(PartialEq, Clone, Properties)]
pub struct ListSharingProps {
    pub modal_id: String,
    pub id: Uuid,
    pub token: String,
}

async fn get_shares(client: kabalist_client::Client, id: Uuid) -> ListSharingMessage {
    let shares = match client.get_shares(&id).await {
        Err(e) => {
            gloo::console::error!(format!("Could not get shares: {:?}", e));
            return ListSharingMessage::SetShares(HashMap::new());
        }
        Ok(v) => v,
    };

    let mut named_shares = HashMap::new();

    for (account_id, readonly) in shares.shared_with {
        match client.account_name(&account_id).await {
            Err(e) => {
                gloo::console::error!(format!("Could not get account name: {:?}", e));
                continue;
            }
            Ok(n) => named_shares.insert(
                account_id,
                Share {
                    readonly,
                    name: n.username,
                },
            ),
        };
    }

    ListSharingMessage::SetShares(named_shares)
}

impl Component for ListSharing {
    type Message = ListSharingMessage;
    type Properties = ListSharingProps;

    fn create(ctx: &Context<Self>) -> Self {
        let client = kabalist_client::Client::new(endpoint(), ctx.props().token.clone());

        let c = client.clone();
        let id = ctx.props().id;
        ctx.link().send_future(get_shares(c, id));

        Self {
            client,
            shares: HashMap::new(),
            updates: HashMap::new(),
            deleted: HashSet::new(),
            share_with: String::new(),
        }
    }

    fn changed(&mut self, ctx: &yew::Context<Self>, _old_props: &Self::Properties) -> bool {
        self.client = kabalist_client::Client::new(endpoint(), ctx.props().token.clone());
        let c = self.client.clone();
        let id = ctx.props().id;
        ctx.link().send_future(get_shares(c, id));
        true
    }

    fn update(&mut self, ctx: &Context<Self>, msg: Self::Message) -> bool {
        match msg {
            ListSharingMessage::SetShares(s) => self.shares = s,
            ListSharingMessage::Clear => {
                self.deleted.clear();
                self.updates.clear();
            }
            ListSharingMessage::AddShareEdit(s) => self.share_with = s,
            ListSharingMessage::AddShare => {
                let name = std::mem::take(&mut self.share_with);
                let id = ctx.props().id;
                let c = self.client.clone();
                let link = ctx.link().to_owned();
                wasm_bindgen_futures::spawn_local(async move {
                    let account_id = match c.search_account(&name).await {
                        Ok(r) => r.id,
                        Err(e) => {
                            gloo::console::log!(format!("Error: {:?}", e));
                            return;
                        }
                    };

                    match c.share(&id, &account_id, false).await {
                        Err(e) => {
                            gloo::console::log!(format!("Error: {:?}", e));
                        }
                        Ok(_) => link.send_future(get_shares(c, id)),
                    }
                });
            }
            ListSharingMessage::Delete(account) => {
                self.deleted.insert(account);
                self.updates.remove(&account);
            }
            ListSharingMessage::SetWriteReadonly(account, readonly) => {
                self.updates
                    .entry(account)
                    .or_insert_with(|| self.shares.get(&account).unwrap().clone())
                    .readonly = readonly;
            }
            ListSharingMessage::Commit => {
                let c = self.client.clone();
                let id = ctx.props().id;
                let sync = ctx.link().callback_future({
                    let c = c.clone();
                    move |_| get_shares(c.clone(), id)
                });
                for account in self.deleted.drain() {
                    let c = self.client.clone();
                    let s = sync.clone();
                    wasm_bindgen_futures::spawn_local(async move {
                        if c.unshare_with(&id, &account).await.is_ok() {
                            s.emit(());
                        }
                    });
                }

                for (account, share) in self
                    .updates
                    .drain()
                    .filter(|(acc, s)| Some(s.readonly) != self.shares.get(acc).map(|s| s.readonly))
                {
                    let readonly = share.readonly;
                    let c = self.client.clone();
                    let s = sync.clone();
                    wasm_bindgen_futures::spawn_local(async move {
                        let _ = c.unshare_with(&id, &account).await;
                        if c.share(&id, &account, readonly).await.is_ok() {
                            s.emit(());
                        }
                    });
                }
            }
        }
        true
    }

    fn view(&self, ctx: &Context<Self>) -> Html {
        let on_validated = ctx.link().callback(|_| ListSharingMessage::Commit);
        let clear = ctx.link().callback(|_| ListSharingMessage::Clear);
        let on_cancel = Callback::from(move |_| clear.emit(()));

        let share_with_on_change = ctx.link().callback(ListSharingMessage::AddShareEdit);
        let add_share = ctx.link().callback(|_| ListSharingMessage::AddShare);

        let shares = self
            .shares
            .iter()
            .filter(|(account_id, _)| !self.deleted.contains(account_id))
            .map(|(&account_id, share)| {
                let share = self.updates.get(&account_id).unwrap_or(share);
                let on_deleted = ctx
                    .link()
                    .callback(move |_| ListSharingMessage::Delete(account_id));

                let readonly = share.readonly;
                let on_readonly_change = ctx
                    .link()
                    .callback(move |_| ListSharingMessage::SetWriteReadonly(account_id, !readonly));
                html! {
                    <>
                    <div class="checkbox mb-3 d-flex">
                      <p class="me-1">{share.name.clone()} {":"}</p>
                      <label class="me-auto">
                        <input
                          type="checkbox"
                          value="readonly"
                          checked={share.readonly}
                          onclick={on_readonly_change}
                        />
                        {" readonly"}
                      </label>
                      <button class="btn btn-danger" onclick={on_deleted}>
                        <i class="bi-trash"></i>
                      </button>
                    </div>
                    <hr />
                    </>
                }
            });

        html! {
          <Modal
            id={ctx.props().modal_id.clone()}
            title="Update List Sharing"
            validate="Update"
            {on_cancel}
            {on_validated}
          >
            {shares.collect::<Html>()}
            <div class="d-flex">
              <div class="form-floating me-auto">
                <TextInput
                  ty={text_input::Type::Text}
                  value={self.share_with.clone()}
                  class="form-control w-100 bg-dark text-bg-dark"
                  placeholder="username"
                  on_change={share_with_on_change}
                  id="addShare"
                />
                <label for="addShare">{"Username"}</label>
              </div>
              <button class="btn btn-primary" onclick={add_share}>
                {"Share With"}
              </button>
            </div>
          </Modal>
        }
    }
}
