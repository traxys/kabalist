-- Add migration script here
ALTER TABLE accounts ALTER COLUMN name TYPE CITEXT;
