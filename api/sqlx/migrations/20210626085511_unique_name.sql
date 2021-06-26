-- Add migration script here
ALTER TABLE accounts ADD UNIQUE(name);
