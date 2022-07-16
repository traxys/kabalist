#!/usr/bin/env bash

set -x

if [ -n "$1" ]; then
	cd "$1" || exit 1
fi

psql -d "$POSTGRES_DB" -U "$POSTGRES_USER" -c '
	CREATE EXTENSION IF NOT EXISTS citext;
	CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
	CREATE EXTENSION IF NOT EXISTS pgcrypto;
'

if [ -z "$DATABASE_URL" ]; then
	DATABASE_URL=postgres:///$POSTGRES_DB
fi

sqlx migrate run --database-url "$DATABASE_URL" 
