-- Add migration script here

CREATE TABLE mail_to_uuid (
	id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
	mail text UNIQUE,
	account uuid REFERENCES accounts(id)
);
