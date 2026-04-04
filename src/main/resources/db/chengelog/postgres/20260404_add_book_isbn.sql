-- liquibase formatted sql

-- changeset codex:20260404_add_book_isbn
ALTER TABLE public.book
    ADD COLUMN IF NOT EXISTS isbn CHARACTER VARYING(32);

