-- Add migration script here
CREATE TABLE lists (
	id uuid PRIMARY KEY,
	owner uuid REFERENCES accounts(id) NOT NULL,
	name TEXT NOT NULL
);
