-- Add migration script here

CREATE TABLE pantry_content (
	item SERIAL UNIQUE NOT NULL,
	list uuid REFERENCES lists(id) NOT NULL,
	name VARCHAR NOT NULL,
	target integer NOT NULL,
	amount integer NOT NULL DEFAULT 0,
	PRIMARY KEY (item, list)
);

ALTER TABLE lists_content 
	ADD COLUMN from_pantry integer REFERENCES pantry_content(item);
