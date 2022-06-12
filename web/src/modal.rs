use yew::prelude::*;

#[derive(Clone, PartialEq, Properties)]
pub struct Props {
    pub id: String,
    pub title: String,
    pub validate: String,
    #[prop_or_default]
    pub children: Children,
    pub on_validated: Callback<()>,
    #[prop_or_default]
    pub on_cancel: Option<Callback<()>>,
    #[prop_or_default]
    pub danger: bool,
}

#[function_component(Modal)]
pub fn modal(props: &Props) -> Html {
    let on_validated = props.on_validated.clone();
    let onclick = Callback::from(move |_| on_validated.emit(()));
    let validate_classes = if props.danger {
        "btn btn-danger"
    } else {
        "btn btn-primary"
    };
    let on_cancel = props.on_cancel.clone();
    let oncancel = Callback::from(move |_| {
        if let Some(c) = &on_cancel {
            c.emit(())
        }
    });

    if props.on_cancel.is_some() { 
        html! {
            <div class="modal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" id={props.id.clone()}>
                {modal_content(props, validate_classes.into(), oncancel, onclick)}
            </div>
        }
    } else {
        html! {
            <div class="modal" tabindex="-1" id={props.id.clone()}>
                {modal_content(props, validate_classes.into(), oncancel, onclick)}
            </div>
        }
    }
}

fn modal_content(
    props: &Props,
    validate_classes: Classes,
    oncancel: Callback<MouseEvent>,
    onclick: Callback<MouseEvent>,
) -> Html {
    html! {
        <div class="modal-dialog">
          <div class="modal-content bg-dark">
            <div class="modal-header">
              <h5 class="modal-title">{props.title.clone()}</h5>
              <button
                type="button"
                class="btn-close"
                data-bs-dismiss="modal"
                aria-label="Close"
              ></button>
            </div>
            <div class="modal-body">
              { for props.children.iter() }
            </div>
            <div class="modal-footer">
              <button
                type="button"
                class="btn btn-secondary"
                data-bs-dismiss="modal"
                onclick={oncancel}
              >
                {"Cancel"}
              </button>
              <button type="button" class={validate_classes} data-bs-dismiss="modal" {onclick}>
                {props.validate.clone()}
              </button>
            </div>
          </div>
        </div>
    }
}
