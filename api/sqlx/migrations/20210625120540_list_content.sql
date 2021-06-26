-- Add migration script here
CREATE TABLE lists_content (
	id SERIAL PRIMARY KEY,
	list uuid REFERENCES lists(id),
	name TEXT NOT NULL,
	amount TEXT
);
