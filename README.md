# KabaList

A set of utilities to manage shared lists

## Features

 - Lists of items with optionally amounts
 - Sharing of lists read/write or readonly
 - History of entered items to support autocompletion
 - Enable public (readonly) viewing of lists

### Planned
 
 - Make wishlists where items ticked to not appear ticked to the wisher
 - Make pantries in order to restock all items under a target in a list

## Utilities

 - [API Server](api) powering the different clients
 - [CLI](cli)
 - [Web App](web)
 - [Android Application](flutter)
 - [Admin Tool](admin) used to manage the database without the API server

No public instance is available, in order to understand how to run your instance you should read the [Building](#building), [Deploy](#deploy) and [Administration](#administration) sections. 

## Extending KabaList

In case you want to build more tools with kabalist there are some helpers: 

 - [Crate for common Types](types)
 - [Rust HTTP client crate](client)
 - [Dart HTTP client](dart-client) (auto-generated from the OpenAPI documentation)

## Documentation

Right now the rust crates are not documented, and the `dart-client` documentation is only auto-generated.

The OpenAPI specification for the API server is queryable from the server, at the route `<domain>/openapi.json`. There are two rendered documentations at the routes `<domain>/swagger_ui/index.html` and `rapidoc/index.html`, they show the same information.

## Building

Right now the target instance is *not* configurable. The instance is determined at compile time, so you will need to setup some files in order to build the different components

### Prequisites

 - rust & cargo
 - PostgreSQL
 - sqlx cli
 - trunk (only for the web app)
 - flutter (only for the android application)

### Database

You will then need to create a PostgreSQL database, and export the variable `DATABASE_URL=postgres://<user>:<password>@localhost/<db-name>`.

You will need to activate the following postgres extensions: `pgcrypto`, `citext`, `uuid-ossp` (you can run `CREATE EXTENSION [IF NOT EXISTS ] <name>`).

You will then need to apply the migrations using `sqlx migrate run` in the [api/sqlx](api/sqlx) directory.

### Domain

You will need to edit the endpoint definition file [endpoint definition](endpoint.url).

This is only needed for:
 
 - The android application
 - The Web Application if it is not served from the same domain as the API Server

### Building the API server

You can then run a `cargo build --release` to generate the CLI, API Server and Admin Tool. This will _require_ the `DATABASE_URL` variable, as SQL queries are checked against the DB at compile time.

### Building the Web App

You can build the web application simply by running `trunk build --release` in the [web](web) directory. This will produce a `dist` directory that can be deployed (see the [Deploy](#deploy) section)

### Building the Android Application

You will need to go in the [flutter](flutter) directory and execute the `prepare.sh` script in order take into account the endpoint.

You can then run `flutter build apk --no-tree-shake-icons` to build the android application (the output will indicate the built apk location).

## Deploy

### Api Server

You will need to deploy the binary and [api/public](api/public) to a location. You will also need to provide a `Rocket.toml`, you can use the [example file](api/Rocket.toml.example).

You should have something like this:

```
/opt/kabalist
├── kabalist_api
├── public
│   └── public_list.html.tera
└── Rocket.toml
```

### Web Application

You should put the `dist` directory on a server, for example at the location `/usr/share/nginx/kabalist`, giving something like:

```
/usr/share/nginx/kabalist
├── index.html
├── kabalist-d741b2826776e6b4.css
├── web-9a0319286040f46a_bg.wasm
└── web-9a0319286040f46a.js
```

### Example Nginx Configuration

You will then be able to deploy both the web application and api server on the same domain using nginx, for example:

```nginx
server {
    server_name example.com;

    root /usr/share/nginx/kabalist;
    location /api {
		proxy_pass http://127.0.0.1:8080/;
    }

    location / {
	   try_files $uri $uri/ /index.html;
    }

    listen [::]:80;
    listen 80;
}
```

You should then use something like `certbot` to generate a SSL certificate.

## Administration

By default no users are available, and no registration is possible. In order to create users you will need to use the `kb_admin` tool.

You can run `kb_admin registration new` to create a registration, and use the link `<domain>/register/<id>`, or just go to `<domain>` and click register, using the id.

The administration tool can also list registrations & users.
