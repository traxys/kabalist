use clap::Parser;
use comfy_table::Table;
use sqlx::{types::Uuid, Connection, PgConnection};

struct Context {
    conn: PgConnection,
}

impl Context {
    async fn new(args: ContextArgs) -> color_eyre::Result<Self> {
        Ok(Self {
            conn: PgConnection::connect(&args.database_url).await?,
        })
    }
}

#[derive(Parser, Debug)]
struct ContextArgs {
    #[clap(short, long, env)]
    database_url: String,
}

#[derive(Parser, Debug)]
struct Args {
    #[clap(flatten)]
    context: ContextArgs,
    #[clap(subcommand)]
    action: Actions,
}

#[derive(clap::Parser, Debug)]
enum Actions {
    #[clap(subcommand)]
    Users(UserAction),
    #[clap(subcommand)]
    Registration(RegistrationAction),
    #[clap(subcommand)]
    Recovery(RecoveryAction),
}

impl Actions {
    async fn run(self, ctx: Context) -> color_eyre::Result<()> {
        match self {
            Actions::Users(a) => a.run(ctx).await,
            Actions::Registration(a) => a.run(ctx).await,
            Actions::Recovery(a) => a.run(ctx).await,
        }
    }
}

#[derive(clap::Parser, Debug)]
enum UserAction {
    List,
}

impl UserAction {
    async fn run(self, mut ctx: Context) -> color_eyre::Result<()> {
        match self {
            UserAction::List => {
                let users = sqlx::query!("SELECT id, name::text FROM accounts")
                    .fetch_all(&mut ctx.conn)
                    .await?;

                let mut table = Table::new();
                table.set_header(["Name", "Id"]);
                for row in users {
                    if let Some(name) = row.name {
                        table.add_row(&[name, row.id.to_string()]);
                    }
                }

                println!("{table}")
            }
        }

        Ok(())
    }
}

#[derive(clap::Parser, Debug)]
enum RegistrationAction {
    List,
    New,
}

impl RegistrationAction {
    async fn run(self, mut ctx: Context) -> color_eyre::Result<()> {
        match self {
            RegistrationAction::List => {
                let regs = sqlx::query!("SELECT * FROM registrations")
                    .fetch_all(&mut ctx.conn)
                    .await?;

                let mut table = Table::new();
                table.set_header(["Id"]);
                for row in regs {
                    table.add_row([row.id]);
                }

                println!("{table}")
            }
            RegistrationAction::New => {
                let id = sqlx::query!(
                    "INSERT INTO registrations VALUES (uuid_generate_v4()) RETURNING id"
                )
                .fetch_one(&mut ctx.conn)
                .await?
                .id;
                println!("Id = {id}");
            }
        }

        Ok(())
    }
}

#[derive(clap::Parser, Debug)]
enum RecoveryAction {
    New { account: Uuid },
    List,
}

impl RecoveryAction {
    async fn run(self, mut ctx: Context) -> color_eyre::Result<()> {
        match self {
            RecoveryAction::New { account } => {
                let id = sqlx::query!(
                    "INSERT INTO password_reset (id, account) VALUES (uuid_generate_v4(), $1) RETURNING id",
                    account,
                )
                .fetch_one(&mut ctx.conn)
                .await?
                .id;
                println!("Id = {id}");
            }
            RecoveryAction::List => {
                let regs = sqlx::query!(
                    "
                    SELECT password_reset.id,password_reset.account,accounts.name::text
                    FROM password_reset,accounts
                    WHERE password_reset.account = accounts.id
                    "
                )
                .fetch_all(&mut ctx.conn)
                .await?;

                let mut table = Table::new();
                table.set_header(["Id", "Account ID", "Account Name"]);
                for row in regs {
                    table.add_row(&[
                        row.id.to_string(),
                        row.account
                            .as_ref()
                            .map(ToString::to_string)
                            .unwrap_or_default(),
                        row.name.unwrap_or_default(),
                    ]);
                }

                println!("{table}")
            }
        }

        Ok(())
    }
}

#[tokio::main(flavor = "current_thread")]
async fn main() -> color_eyre::Result<()> {
    color_eyre::install()?;

    let args = Args::from_args();
    let ctx = args.context;

    args.action.run(Context::new(ctx).await?).await
}
