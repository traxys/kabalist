use web_sys::HtmlInputElement as InputElement;
use yew::prelude::*;

#[derive(Clone, Copy, PartialEq)]
pub enum Type {
    Password,
    Text,
}

impl Type {
    pub fn as_str(&self) -> &'static str {
        match self {
            Type::Password => "password",
            Type::Text => "text",
        }
    }
}

#[derive(Clone, PartialEq, Properties)]
pub struct Props {
    pub value: String,
    pub on_change: Callback<String>,
    pub ty: Type,
    pub id: String,
    #[prop_or_default]
    pub class: String,
    pub placeholder: String,
}

fn get_value_from_input_event(e: InputEvent) -> String {
    let input_element: InputElement = e.target_unchecked_into();
    input_element.value()
}

#[function_component(TextInput)]
pub fn text_input(props: &Props) -> Html {
    let Props {
        value,
        on_change,
        ty,
        id,
        class,
        placeholder,
    } = props.clone();

    let oninput = Callback::from(move |input_event: InputEvent| {
        on_change.emit(get_value_from_input_event(input_event))
    });

    html! {
        <input type={ty.as_str()} {value} {oninput} {id} {class} {placeholder}/>
    }
}
