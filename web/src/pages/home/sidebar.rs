use std::{borrow::Cow, collections::HashMap, marker::PhantomData};

use super::modals::{new_list::NewList, sharing::ListSharing, visibility::ListVisibility};
use crate::{modal::Modal, Route};
use itertools::Itertools;
use kabalist_client::{ListInfo, ListStatus, Uuid};
use yew::{prelude::*, virtual_dom::AttrValue};
use yew_router::prelude::*;

#[derive(Clone, PartialEq)]
pub struct ResolvedListInfo {
    pub info: ListInfo,
    pub  owner: String,
}

#[derive(Clone, PartialEq, Properties)]
pub struct SidebarProps {
    pub on_logout: Callback<()>,
    pub username: String,
    pub token: String,
    pub lists: HashMap<Uuid, ResolvedListInfo>,
    pub selected: Option<Uuid>,
    pub on_newlist: Callback<String>,
    pub on_delete: Callback<Uuid>,
    pub sync_lists: Callback<()>,
}

#[function_component(Sidebar)]
pub fn side_bar(props: &SidebarProps) -> Html {
    let logout = props.on_logout.clone();
    let onclick_logout = Callback::from(move |_| logout.emit(()));

    let delete = props.on_delete.clone();
    let selected_list = props.selected.as_ref().and_then(|&selected| {
        props.lists.get(&selected).map(|info| {
            (
                (selected, info),
                Callback::from(move |_| delete.emit(selected)),
            )
        })
    });

    let lists = props
        .lists
        .iter()
        .sorted_unstable_by_key(|a| a.0)
        .map(|(&id, res_info)| {
            side_bar_list_item(
                id,
                res_info.info.name.clone(),
                res_info.info.status,
                Some(id) == props.selected,
                &res_info.owner,
            )
        });

    html! {
        <div class="d-flex flex-column p-3 sidebar-bg shadow min-vw-20 overflow-auto">
            <p>{"KabaList"}</p>
            <ul class="mb-auto nav nav-pills flex-column">
              {lists.collect::<Html>()}
            </ul>
            <hr />
            <div class="dropdown">
                <a
                  href="#"
                  class="d-flex align-items-center text-decoration-none dropdown-toggle text-white sidebar-bg"
                  id="dropdownUser"
                  data-bs-toggle="dropdown"
                  aria-expanded="false"
                >
                  <strong>{props.username.clone()}</strong>
                </a>
                <ul
                  class="dropdown-menu dropdown-menu-dark text-small shadow"
                  aria-labelledby="dropdownUser"
                >
                if let Some(((_, info), _)) = selected_list {
                  <li>
                    <a
                      class="dropdown-item"
                      href="#"
                      data-bs-toggle="modal"
                      data-bs-target="#listSharingModal"
                    >
                      {"Manage List Sharing"}
                    </a>
                  </li>
                  if let ListStatus::Owned = info.info.status {
                    <li>
                      <a
                        class="dropdown-item"
                        href="#"
                        data-bs-toggle="modal"
                        data-bs-target="#visibilityModal"
                      >
                        {"Manage List Visibility"}
                      </a>
                    </li>
                    <li>
                      <a
                        class="dropdown-item"
                        href="#"
                        data-bs-toggle="modal"
                        data-bs-target="#deleteListModal"
                      >
                        {"Delete List"}
                      </a>
                    </li>
                  }
                  <li><hr class="dropdown-divider" /></li>
                }
                <li>
                  <a
                    class="dropdown-item"
                    href="#"
                    data-bs-toggle="modal"
                    data-bs-target="#newListModal"
                  >
                    {"New List"}
                  </a>
                </li>
                <li><hr class="dropdown-divider" /></li>
                <li><a class="dropdown-item" href="#" onclick={onclick_logout}>{"Logout"}</a></li>
                </ul>
                <NewList modal_id="newListModal" on_newlist={props.on_newlist.clone()} />
                if let Some(((id, info), on_validated)) = selected_list {
                  <ListSharing
                      id={id}
                      token={props.token.clone()}
                      modal_id="listSharingModal"
                  />
                  if let ListStatus::Owned = info.info.status {
                     <ListVisibility
                        modal_id="visibilityModal"
                        id={id}
                        token={props.token.clone()}
                        public={info.info.public}
                        on_toggle={props.sync_lists.clone()}
                    />
                     <Modal
                       id="deleteListModal"
                       title={format!("Delete {}", info.info.name)}
                       validate="Delete List"
                       danger=true
                       {on_validated}
                     >
                       <p>{format!("Are you sure you want to delete {}", info.info.name)}</p>
                     </Modal>
                  }
                }
            </div>
        </div>
    }
}

#[derive(Properties, Clone, PartialEq)]
pub struct LinkProps<R>
where
    R: Routable,
{
    /// CSS classes to add to the anchor element (optional).
    #[prop_or_default]
    pub classes: Classes,
    /// Route that will be pushed when the anchor is clicked.
    pub to: R,
    #[prop_or_default]
    pub disabled: bool,
    #[prop_or_default]
    pub children: Children,
    pub selected: bool,
}

pub struct CustomLink<R>
where
    R: Routable + 'static,
{
    _route: PhantomData<R>,
}

pub enum Msg {
    OnClick,
}

impl<R> Component for CustomLink<R>
where
    R: Routable + 'static,
{
    type Message = Msg;
    type Properties = LinkProps<R>;

    fn create(_ctx: &Context<Self>) -> Self {
        Self {
            _route: PhantomData,
        }
    }

    fn update(&mut self, ctx: &Context<Self>, msg: Self::Message) -> bool {
        match msg {
            Msg::OnClick => {
                let LinkProps { to, .. } = ctx.props();
                let history = ctx.link().navigator().expect("failed to read history");
                history.push(&to.clone());
                false
            }
        }
    }

    fn view(&self, ctx: &Context<Self>) -> Html {
        fn route_to_url<R: Routable>(route: R) -> Cow<'static, str> {
            let base = yew_router::utils::base_url();
            let url = route.to_path();

            let path = match base {
                Some(base) => {
                    let path = format!("{}{}", base, url);
                    if path.is_empty() {
                        Cow::from("/")
                    } else {
                        path.into()
                    }
                }
                None => url.into(),
            };

            path
        }

        let LinkProps {
            classes,
            to,
            children,
            disabled,
            selected,
            ..
        } = ctx.props().clone();
        let onclick = ctx.link().callback(|e: MouseEvent| {
            e.prevent_default();
            Msg::OnClick
        });
        let href: AttrValue = route_to_url(to).into();
        if selected {
            html! {
                <a class={classes}
                    {href}
                    {onclick}
                    {disabled}
                    aria-current="page"
                >
                    { children }
                </a>
            }
        } else {
            html! {
                <a class={classes}
                    {href}
                    {onclick}
                    {disabled}
                >
                    { children }
                </a>
            }
        }
    }
}

fn side_bar_list_item(
    id: Uuid,
    name: String,
    status: ListStatus,
    selected: bool,
    owner: &str,
) -> Html {
    let status: Cow<str> = match status {
        ListStatus::Owned => "owned".into(),
        ListStatus::SharedWrite => format!("shared by {owner}").into(),
        ListStatus::SharedRead => format!("read-only from {owner}").into(),
    };
    let classes = if selected {
        "nav-link active"
    } else {
        "nav-link text-white"
    };
    html! {
        <li class="nav-item">
          <CustomLink<Route> {classes} key={id.as_u128()} to={Route::List{id}} {selected}>
            {format!("{} ({})", name, status)}
          </CustomLink<Route>>
        </li>
    }
}
