-- Add migration script here
CREATE TABLE accounts (
	id uuid PRIMARY KEY,
	name TEXT NOT NULL UNIQUE,
	password TEXT NOT NULL
);
