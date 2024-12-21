use std::io;

use clap::{Args, CommandFactory, Parser, Subcommand};
use clap_complete::{generate, Shell};
use itertools::Itertools;
use kabalist_client::{Client, Uuid};
use yansi::Paint;

#[derive(Args, Debug)]
struct ListCommands {
    #[clap(short, long, env = "LIST_TOKEN")]
    token: String,
    list: String,
    #[clap(subcommand)]
    action: Option<ListAction>,
}

impl ListCommands {
    async fn run(self, url: String) -> color_eyre::Result<()> {
        let client = Client::new(url.clone(), self.token);
        let searched = client.search(&self.list).await?.results;
        let list = match searched.len() {
            0 => {
                println!("Could not read list: {}", yansi::Paint::red("No such list"));
                return Ok(());
            }
            1 => searched.into_keys().next().unwrap(),
            _ => {
                println!(
                    "Multiple matches: {}",
                    searched.into_values().map(|n| n.name).join(",")
                );
                return Ok(());
            }
        };

        match self.action {
            None => {
                let rsp = client.read(&list).await?;
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
            Some(ListAction::Delete) => {
                client.delete_list(&list).await?;
            }
            Some(ListAction::Add { name, amount }) => {
                client
                    .add(&list, &name, amount.as_ref().map(|s| -> &str { s }))
                    .await?;
            }
            Some(ListAction::Item { item, action }) => {
                action.run(client, list, item).await?;
            }
            Some(ListAction::Share { action }) => {
                ShareAction::run(action, client, list).await?;
            }
            Some(ListAction::Public(p)) => {
                p.run(&url, client, list).await?;
            }
            Some(ListAction::History { search }) => {
                let results = client
                    .search_history(&list, search.as_ref().map(|s| -> &str { s }).unwrap_or(""))
                    .await?;
                for result in results.matches {
                    println!(" - {}", result);
                }
            }
            Some(ListAction::Pantry { action }) => {
                PantryAction::run(action, client, list).await?;
            }
        }
        Ok(())
    }
}

#[derive(Subcommand, Debug)]
enum ListAction {
    Delete,
    Add {
        name: String,
        amount: Option<String>,
    },
    Item {
        item: String,
        #[clap(subcommand)]
        action: ItemAction,
    },
    Share {
        #[clap(subcommand)]
        action: Option<ShareAction>,
    },
    #[clap(subcommand)]
    Public(PublicAction),
    History {
        search: Option<String>,
    },
    Pantry {
        #[clap(subcommand)]
        action: Option<PantryAction>,
    },
}

#[derive(Subcommand, Debug)]
enum ItemAction {
    Tick,
    Update {
        name: Option<String>,
        amount: Option<String>,
    },
}

impl ItemAction {
    async fn run(self, client: Client, list: Uuid, item: String) -> color_eyre::Result<()> {
        let items = client.read(&list).await?;
        let pat = item.to_lowercase();
        let items: Vec<_> = items
            .items
            .iter()
            .filter(|item| item.name.to_lowercase().contains(&pat))
            .collect();
        let selected: i32 = match items.len().cmp(&1) {
            std::cmp::Ordering::Less => return Ok(()),
            std::cmp::Ordering::Equal => items[0].id,
            std::cmp::Ordering::Greater => {
                println!("Multiple matches, choose item:");
                for (id, item) in items.iter().enumerate() {
                    println!("  {}) {}", id, item.name)
                }
                let idx: usize = promptly::prompt("Item")?;
                items[idx].id
            }
        };

        match self {
            ItemAction::Tick => {
                client.delete_item(&list, selected).await?;
            }
            ItemAction::Update { name, amount } => {
                client
                    .update_item(&list, selected, name.as_deref(), amount.as_deref())
                    .await?;
            }
        }

        Ok(())
    }
}

#[derive(Subcommand, Debug)]
enum ShareAction {
    Add {
        name: String,
        #[clap(short, long)]
        readonly: bool,
    },
    Delete {
        #[clap(long)]
        all: bool,
        names: Vec<String>,
    },
}

impl ShareAction {
    async fn run(this: Option<Self>, client: Client, list: Uuid) -> color_eyre::Result<()> {
        match this {
            Some(a) => match a {
                ShareAction::Add { name, readonly } => {
                    let account = client.search_account(&name).await?.id;
                    client.share(&list, &account, readonly).await?;
                }
                ShareAction::Delete { names, all } => {
                    if all {
                        client.delete_share(&list).await?;
                    } else {
                        for name in names {
                            let account = client.search_account(&name).await?.id;
                            client.unshare_with(&list, &account).await?;
                        }
                    }
                }
            },
            None => {
                let rsp = client.get_shares(&list).await?;
                println!(
                    "Shares{}:",
                    match rsp.public_link {
                        Some(link) => format!(" (public link: {})", link),
                        None => "".into(),
                    }
                );
                for (account, readonly) in rsp.shared_with {
                    let account_name = client.account_name(&account).await?.username;
                    print!("  - {}", Paint::new(account_name).underline());
                    if readonly {
                        print!(" (readonly)");
                    }
                    println!()
                }
            }
        }

        Ok(())
    }
}

#[derive(Subcommand, Debug)]
enum PublicAction {
    Set,
    Remove,
}

impl PublicAction {
    async fn run(self, url: &str, client: Client, list: Uuid) -> color_eyre::Result<()> {
        match self {
            PublicAction::Set => {
                client.set_public(&list).await?;
                println!("Public url is: {}/list/{}/public", url, list);
            }
            PublicAction::Remove => {
                client.remove_public(&list).await?;
            }
        }

        Ok(())
    }
}

#[derive(Subcommand, Debug)]
enum PantryAction {
    Add {
        name: String,
        target: i32,
    },
    Edit {
        #[clap(short, long)]
        target: Option<i32>,
        #[clap(short, long)]
        amount: Option<i32>,
        item: i32,
    },
    Delete {
        item: i32,
    },
    Refill,
}

impl PantryAction {
    async fn run(this: Option<PantryAction>, client: Client, list: Uuid) -> color_eyre::Result<()> {
        match this {
            None => {
                let rsp = client.pantry(list).await?.items;
                println!("Pantry:");
                for item in rsp {
                    print!("  - {}", Paint::new(&item.name).underline());
                    println!(" ({}/{})", item.amount, item.target);
                }
            }
            Some(PantryAction::Refill) => {
                client.refill_pantry(list).await?;
            }
            Some(PantryAction::Add { name, target }) => {
                client.add_to_pantry(list, name, target).await?;
            }
            Some(PantryAction::Delete { item }) => {
                client.delete_pantry_item(list, item).await?;
            }
            Some(PantryAction::Edit {
                target,
                amount,
                item,
            }) => {
                client.edit_pantry_item(list, item, amount, target).await?;
            }
        }

        Ok(())
    }
}

#[derive(Subcommand, Debug)]
enum AccountCommands {
    Login {
        name: String,
        password: Option<String>,
    },
    Recover {
        id: Uuid,
        password: Option<String>,
    },
    Register {
        id: Uuid,
        username: String,
        password: Option<String>,
    },
}

impl AccountCommands {
    async fn run(self, url: String) -> color_eyre::Result<()> {
        match self {
            AccountCommands::Login { name, password } => {
                let password = password
                    .map(Ok)
                    .unwrap_or_else(|| rpassword::prompt_password(("password: ")))?;
                let token = kabalist_client::login(&url, &name, &password).await?;
                println!("Token: {}", token.token);
                println!("You can export in as LIST_TOKEN or pass it as parameters");
            }
            AccountCommands::Recover { id, password } => {
                let account_name = kabalist_client::recover_info(&url, &id).await?.username;
                println!("Recovery for {}", account_name);
                let password = password
                    .map(Ok)
                    .unwrap_or_else(|| rpassword::prompt_password(("password: ")))?;
                kabalist_client::recover_password(&url, &id, &password).await?;
            }
            AccountCommands::Register {
                id,
                username,
                password,
            } => {
                let password = password
                    .map(Ok)
                    .unwrap_or_else(|| rpassword::prompt_password("password: "))?;
                kabalist_client::register(&url, id, &username, &password).await?;
            }
        }

        Ok(())
    }
}

#[derive(Subcommand, Debug)]
enum ListsActions {
    Create { list: String },
}

#[derive(Subcommand, Debug)]
enum Commands {
    #[clap(subcommand)]
    Account(AccountCommands),
    List(ListCommands),
    Lists {
        #[clap(short, long, env = "LIST_TOKEN")]
        token: String,
        #[clap(subcommand)]
        actions: Option<ListsActions>,
    },
    Completions {
        shell: Shell,
    },
}

#[derive(Parser, Debug)]
struct Opts {
    #[clap(short, long, env = "LIST_URL")]
    url: String,
    #[clap(subcommand)]
    command: Commands,
}

#[tokio::main]
async fn main() -> color_eyre::Result<()> {
    color_eyre::install()?;
    let args = Opts::parse();

    match args.command {
        Commands::Account(a) => {
            a.run(args.url).await?;
        }
        Commands::List(l) => l.run(args.url).await?,
        Commands::Lists { token, actions } => {
            let client = Client::new(args.url, token);
            match actions {
                Some(ListsActions::Create { list }) => {
                    client.create_list(&list).await?;
                }
                None => {
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
            }
        }
        Commands::Completions { shell } => {
            let mut cmd = Opts::command();
            let name = cmd.get_name().to_string();
            generate(shell, &mut cmd, name, &mut io::stdout());
        }
    };

    Ok(())
}
