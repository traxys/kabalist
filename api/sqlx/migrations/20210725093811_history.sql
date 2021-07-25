-- Add migration script here
CREATE TABLE history (
	list uuid REFERENCES lists(id),
	creator uuid REFERENCES accounts(id),
	name CITEXT NOT NULL,
	last_used timestamp NOT NULL,
	PRIMARY KEY (list, creator, name)
);
