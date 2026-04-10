-- liquibase formatted sql

-- changeset codex:20260410_add_book_version_and_inventory_checks
ALTER TABLE public.book
    ADD COLUMN version BIGINT NOT NULL DEFAULT 0;

ALTER TABLE public.book
    ADD CONSTRAINT book_inventory_non_negative_chk
        CHECK (available_copies >= 0);

ALTER TABLE public.book
    ADD CONSTRAINT book_inventory_range_chk
        CHECK (available_copies <= total_copies);
