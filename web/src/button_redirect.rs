use std::{borrow::Cow, marker::PhantomData};

use web_sys::MouseEvent;
use yew::{html, virtual_dom::AttrValue, Children, Classes, Component, Context, Html, Properties};
use yew_router::{prelude::RouterScopeExt, Routable};

#[derive(Properties, Clone, PartialEq)]
pub struct RedirectButtonProps<R>
where
    R: Routable,
{
    #[prop_or_default]
    pub class: Classes,
    /// Route that will be pushed when the anchor is clicked.
    pub to: R,
    #[prop_or_default]
    pub disabled: bool,
    #[prop_or_default]
    pub children: Children,
}

pub struct RedirectButton<R>
where
    R: Routable + 'static,
{
    _route: PhantomData<R>,
}

pub enum Msg {
    OnClick,
}

fn route_to_url<R: Routable>(route: R) -> Cow<'static, str> {
    let base = yew_router::utils::base_url();
    let url = route.to_path();

    

    match base {
        Some(base) => {
            let path = format!("{}{}", base, url);
            if path.is_empty() {
                Cow::from("/")
            } else {
                path.into()
            }
        }
        None => url.into(),
    }
}

impl<R> Component for RedirectButton<R>
where
    R: Routable + 'static,
{
    type Message = Msg;
    type Properties = RedirectButtonProps<R>;

    fn create(_ctx: &Context<Self>) -> Self {
        Self {
            _route: PhantomData,
        }
    }

    fn update(&mut self, ctx: &Context<Self>, msg: Self::Message) -> bool {
        match msg {
            Msg::OnClick => {
                let RedirectButtonProps { to, .. } = ctx.props();
                let history = ctx.link().navigator().expect("failed to read history");
                history.push(&to.clone());
                let href: AttrValue = route_to_url(to.clone()).into();
                web_sys::window()
                    .unwrap()
                    .location()
                    .set_href(&href)
                    .unwrap();
                false
            }
        }
    }

    fn view(&self, ctx: &Context<Self>) -> Html {
        let RedirectButtonProps {
            mut class,
            children,
            disabled,
            ..
        } = ctx.props().clone();

        class.push("btn");
        class.push("btn-primary");

        let onclick = ctx.link().callback(|e: MouseEvent| {
            e.prevent_default();
            Msg::OnClick
        });
        html! {
            <button {class}
                {onclick}
                {disabled}
            >
                { children }
            </button>
        }
    }
}
