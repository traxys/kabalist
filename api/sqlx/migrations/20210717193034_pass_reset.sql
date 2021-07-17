-- Add migration script here
CREATE TABLE password_reset (
	id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
	account uuid REFERENCES accounts(id)
);
