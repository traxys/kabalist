use std::collections::HashMap;

use serde::{Deserialize, Serialize};
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
}

#[derive(StructOpt, Debug)]
pub struct Args {
    #[structopt(short, long, env = "LIST_URL")]
    url: String,
    #[structopt(subcommand)]
    command: Commands,
}

async fn login(url: &str, username: &str, password: &str) -> color_eyre::Result<String> {
    #[derive(Serialize)]
    struct LoginRequest<'a> {
        username: &'a str,
        password: &'a str,
    }

    #[derive(Deserialize)]
    struct LoginResponse {
        token: String,
    }

    let client = reqwest::Client::new();
    let token: LoginResponse = client
        .post(format!("{}/login", url))
        .json(&LoginRequest { username, password })
        .send()
        .await?
        .json()
        .await?;

    Ok(token.token)
}

struct Client {
    client: reqwest::Client,
    token: String,
    url: String,
}

#[derive(Deserialize, Debug)]
struct Item {
    amount: Option<String>,
    name: String,
}

#[derive(Debug)]
struct Read {
    items: Vec<Item>,
    readonly: bool,
}

impl Client {
    fn new(url: String, token: String) -> Self {
        Self {
            client: reqwest::Client::new(),
            token,
            url,
        }
    }

    async fn lists(&self) -> color_eyre::Result<Vec<String>> {
        #[derive(Deserialize)]
        struct List {
            results: HashMap<String, String>,
        }

        let lists: List = self
            .client
            .get(&format!("{}/list", self.url))
            .bearer_auth(&self.token)
            .send()
            .await?
            .json()
            .await?;

        let mut res: Vec<_> = lists.results.into_iter().map(|(v, _)| v).collect();
        res.sort_unstable();
        Ok(res)
    }

    async fn search(&self, name: &str) -> color_eyre::Result<HashMap<String, String>> {
        #[derive(Deserialize)]
        struct List {
            results: HashMap<String, String>,
        }

        let lists: List = self
            .client
            .get(&format!("{}/search/list/{}", self.url, name))
            .bearer_auth(&self.token)
            .send()
            .await?
            .json()
            .await?;

        Ok(lists.results)
    }

    async fn read(&self, id: &str) -> color_eyre::Result<Read> {
        #[derive(Deserialize)]
        struct Response {
            items: Vec<Item>,
            readonly: bool,
        }

        let rsp: Response = self
            .client
            .get(&format!("{}/list/{}", self.url, id))
            .bearer_auth(&self.token)
            .send()
            .await?
            .json()
            .await?;

        Ok(Read {
            items: rsp.items,
            readonly: rsp.readonly,
        })
    }

    async fn add(&self, list_id: &str, name: &str, amount: Option<&str>) -> color_eyre::Result<()> {
        #[derive(Serialize)]
        struct Request<'a> {
            name: &'a str,
            amount: Option<&'a str>,
        }

        self.client
            .post(&format!("{}/list/{}", self.url, list_id))
            .bearer_auth(&self.token)
            .json(&Request { name, amount })
            .send()
            .await?
            .error_for_status()?;

        Ok(())
    }

    async fn search_account(&self, name: &str) -> color_eyre::Result<String> {
        #[derive(Deserialize)]
        struct Response {
            id: String,
        }

        let rsp: Response = self
            .client
            .get(&format!("{}/search/account/{}", self.url, name))
            .bearer_auth(&self.token)
            .send()
            .await?
            .json()
            .await?;

        Ok(rsp.id)
    }

    async fn share(&self, list: &str, share_with: &str, readonly: bool) -> color_eyre::Result<()> {
        #[derive(Serialize)]
        struct Request<'a> {
            share_with: &'a str,
            readonly: bool,
        }

        self.client
            .put(&format!("{}/share/{}", self.url, list))
            .bearer_auth(&self.token)
            .json(&Request {
                share_with,
                readonly,
            })
            .send()
            .await?
            .error_for_status()?;

        Ok(())
    }

    async fn unshare(&self, list: &str) -> color_eyre::Result<()> {
        self.client
            .delete(&format!("{}/share/{}", self.url, list))
            .bearer_auth(&self.token)
            .send()
            .await?
            .error_for_status()?;

        Ok(())
    }

    async fn create_list(&self, list_name: &str) -> color_eyre::Result<()> {
        #[derive(Serialize)]
        struct Request<'a> {
            name: &'a str,
        }

        self.client
            .post(&format!("{}/list", self.url))
            .bearer_auth(&self.token)
            .json(&Request { name: list_name })
            .send()
            .await?
            .error_for_status()?;

        Ok(())
    }
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
            let token = login(&args.url, &name, &password).await?;
            println!("Token: {}", token);
            println!("You can export in as LIST_TOKEN or pass it as parameters");
        }
        Commands::Lists { token } => {
            let client = Client::new(args.url, token);
            let lists = client.lists().await?;
            println!("Lists: ");
            for list in lists {
                println!("  - {}", yansi::Paint::new(list).italic());
            }
        }
        Commands::Read { token, name } => {
            let client = Client::new(args.url, token);
            let searched = client.search(&name).await?;
            match searched.get(&name) {
                None => println!("Could not read list: {}", yansi::Paint::red("No such list")),
                Some(id) => {
                    let rsp = client.read(id).await?;
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
            let searched = client.search(&list).await?;
            match searched.get(&list) {
                None => println!("Could add to list: {}", yansi::Paint::red("No such list")),
                Some(id) => {
                    client
                        .add(id, &name, amount.as_ref().map(|s| -> &str { s }))
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
            let searched = client.search(&list).await?;
            match searched.get(&list) {
                None => println!(
                    "Could not share list: {}",
                    yansi::Paint::red("No such list")
                ),
                Some(id) => {
                    client.share(id, &account, readonly).await?;
                }
            }
        }
        Commands::Create { token, name } => {
            let client = Client::new(args.url, token);
            client.create_list(&name).await?;
        }
        Commands::Unshare { token, name } => {
            let client = Client::new(args.url, token);
            let searched = client.search(&name).await?;
            match searched.get(&name) {
                None => println!(
                    "Could not unshare list: {}",
                    yansi::Paint::red("No such list")
                ),
                Some(list) => {
                    client.unshare(list).await?;
                }
            }
        }
    }
    Ok(())
}
