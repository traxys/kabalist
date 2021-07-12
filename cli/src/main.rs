use kabalist_client::{Client, Uuid};
use structopt::StructOpt;
use yansi::Paint;

#[derive(StructOpt, Debug)]
pub enum Commands {
    Login {
        name: String,
        password: Option<String>,
    },
    Lists {
        #[structopt(short, long, env = "LIST_TOKEN")]
        token: String,
    },
    Read {
        #[structopt(short, long, env = "LIST_TOKEN")]
        token: String,
        name: String,
    },
    Add {
        #[structopt(short, long, env = "LIST_TOKEN")]
        token: String,
        #[structopt(short, long)]
        list: String,
        name: String,
        amount: Option<String>,
    },
    Share {
        #[structopt(short, long, env = "LIST_TOKEN")]
        token: String,
        list: String,
        name: String,
        #[structopt(short, long)]
        readonly: bool,
    },
    Create {
        #[structopt(short, long, env = "LIST_TOKEN")]
        token: String,
        name: String,
    },
    Unshare {
        #[structopt(short, long, env = "LIST_TOKEN")]
        token: String,
        name: String,
    },
    Tick {
        #[structopt(short, long, env = "LIST_TOKEN")]
        token: String,
        list: String,
        item: String,
    },
    Update {
        #[structopt(short, long, env = "LIST_TOKEN")]
        token: String,
        list: String,
        item: String,
        #[structopt(short = "n", long = "name")]
        new_name: Option<String>,
        #[structopt(short = "a", long = "amount")]
        new_amount: Option<String>,
    },
}

#[derive(StructOpt, Debug)]
pub struct Args {
    #[structopt(short, long, env = "LIST_URL")]
    url: String,
    #[structopt(subcommand)]
    command: Commands,
}

#[tokio::main]
async fn main() -> color_eyre::Result<()> {
    color_eyre::install()?;
    let args = Args::from_args();
    match args.command {
        Commands::Login { name, password } => {
            let password = password
                .map(Ok)
                .unwrap_or_else(|| rpassword::read_password_from_tty(Some("password: ")))?;
            let token = kabalist_client::login(&args.url, &name, &password).await?;
            println!("Token: {}", token.token);
            println!("You can export in as LIST_TOKEN or pass it as parameters");
        }
        Commands::Lists { token } => {
            let client = Client::new(args.url, token);
            let lists = client.lists().await?;
            println!("Lists: ");
            let mut lists = lists.results.into_iter().collect::<Vec<_>>();
            lists.sort_unstable_by(|(a, _), (b, _)| a.cmp(b));
            for (list, info) in lists {
                let status = match info.status {
                    kabalist_client::ListStatus::Owned => "owned",
                    kabalist_client::ListStatus::SharedWrite => "readonly",
                    kabalist_client::ListStatus::SharedRead => "shared",
                };
                println!("  - {} ({})", yansi::Paint::new(list).italic(), status);
            }
        }
        Commands::Read { token, name } => {
            let client = Client::new(args.url, token);
            let searched = client.search(&name).await?.results;
            match searched.get(&name) {
                None => println!("Could not read list: {}", yansi::Paint::red("No such list")),
                Some(info) => {
                    let rsp = client.read(&info.id).await?;
                    println!(
                        "Items{}:",
                        if rsp.readonly {
                            Paint::new(" (readonly)").italic()
                        } else {
                            Paint::new("")
                        }
                    );
                    for item in rsp.items {
                        print!("  - {}", Paint::new(&item.name).underline());
                        if let Some(amount) = &item.amount {
                            print!(" ({})", amount);
                        }
                        println!()
                    }
                }
            }
        }
        Commands::Add {
            token,
            list,
            name,
            amount,
        } => {
            let client = Client::new(args.url, token);
            let searched = client.search(&list).await?.results;
            match searched.get(&list) {
                None => println!("Could add to list: {}", yansi::Paint::red("No such list")),
                Some(info) => {
                    client
                        .add(&info.id, &name, amount.as_ref().map(|s| -> &str { s }))
                        .await?;
                }
            }
        }
        Commands::Share {
            token,
            list,
            name,
            readonly,
        } => {
            let client = Client::new(args.url, token);
            let account = client.search_account(&name).await?;
            let searched = client.search(&list).await?.results;
            match searched.get(&list) {
                None => println!(
                    "Could not share list: {}",
                    yansi::Paint::red("No such list")
                ),
                Some(info) => {
                    client.share(&info.id, &account.id, readonly).await?;
                }
            }
        }
        Commands::Create { token, name } => {
            let client = Client::new(args.url, token);
            client.create_list(&name).await?;
        }
        Commands::Unshare { token, name } => {
            let client = Client::new(args.url, token);
            let searched = client.search(&name).await?.results;
            match searched.get(&name) {
                None => println!(
                    "Could not unshare list: {}",
                    yansi::Paint::red("No such list")
                ),
                Some(info) => {
                    client.delete_share(&info.id).await?;
                }
            }
        }
        Commands::Tick { token, list, item } => {
            let client = Client::new(args.url, token);
            let searched = client.search(&list).await?.results;
            match searched.get(&list) {
                None => println!(
                    "Could not unshare list: {}",
                    yansi::Paint::red("No such list")
                ),
                Some(info) => {
                    let items = client.read(&info.id).await?;
                    let pat = item.to_lowercase();
                    let items: Vec<_> = items
                        .items
                        .iter()
                        .filter(|item| item.name.to_lowercase().contains(&pat))
                        .collect();
                    let to_delete: i32 = if items.len() == 1 {
                        items[0].id
                    } else if items.len() > 1 {
                        println!("Choose item to delete:");
                        for (id, item) in items.iter().enumerate() {
                            println!("  {}) {}", id, item.name)
                        }
                        let idx: usize = promptly::prompt("Item to delete")?;
                        items[idx].id
                    } else {
                        return Ok(());
                    };
                    client.delete_item(&info.id, to_delete).await?;
                }
            }
        }
        Commands::Update {
            token,
            list,
            item,
            new_name,
            new_amount,
        } => {
            let client = Client::new(args.url, token);
            let searched = client.search(&list).await?.results;
            match searched.get(&list) {
                None => println!(
                    "Could not unshare list: {}",
                    yansi::Paint::red("No such list")
                ),
                Some(info) => {
                    let items = client.read(&info.id).await?;
                    let pat = item.to_lowercase();
                    let items: Vec<_> = items
                        .items
                        .iter()
                        .filter(|item| item.name.to_lowercase().contains(&pat))
                        .collect();
                    let to_update: i32 = if items.len() == 1 {
                        items[0].id
                    } else if items.len() > 1 {
                        println!("Choose item to update:");
                        for (id, item) in items.iter().enumerate() {
                            println!("  {}) {}", id, item.name)
                        }
                        let idx: usize = promptly::prompt("Item to delete")?;
                        items[idx].id
                    } else {
                        return Ok(());
                    };
                    client
                        .update_item(
                            &info.id,
                            to_update,
                            new_name.as_deref(),
                            new_amount.as_deref(),
                        )
                        .await?;
                }
            }
        }
    }
    Ok(())
}
