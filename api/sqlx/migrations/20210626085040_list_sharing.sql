-- Add migration script here
CREATE TABLE list_sharing (
	list uuid REFERENCES lists(id),
	shared uuid REFERENCES accounts(id),
	readonly boolean NOT NULL,
	PRIMARY KEY (list, shared)
);
