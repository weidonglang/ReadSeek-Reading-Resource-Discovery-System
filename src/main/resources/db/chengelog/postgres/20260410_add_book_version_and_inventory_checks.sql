-- liquibase formatted sql

-- changeset codex:20260410_add_book_version_and_inventory_checks splitStatements:false
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = 'public'
          AND table_name = 'book'
          AND column_name = 'version'
    ) THEN
        ALTER TABLE public.book
            ADD COLUMN version BIGINT NOT NULL DEFAULT 0;
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'book_inventory_non_negative_chk'
    ) THEN
        ALTER TABLE public.book
            ADD CONSTRAINT book_inventory_non_negative_chk
                CHECK (available_copies >= 0);
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'book_inventory_range_chk'
    ) THEN
        ALTER TABLE public.book
            ADD CONSTRAINT book_inventory_range_chk
                CHECK (available_copies <= total_copies);
    END IF;
END $$;
