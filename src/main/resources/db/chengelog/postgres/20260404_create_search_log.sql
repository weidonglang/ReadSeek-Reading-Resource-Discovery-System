-- liquibase formatted sql

-- changeset codex:20260404_create_search_log
CREATE SEQUENCE IF NOT EXISTS public.search_log_id_sequence
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

CREATE TABLE IF NOT EXISTS public.search_log
(
    id                BIGINT                 NOT NULL DEFAULT nextval('search_log_id_sequence'::regclass),
    user_id           BIGINT                 NULL,
    keyword           CHARACTER VARYING(255) NULL,
    source            CHARACTER VARYING(120) NULL,
    reason            TEXT                   NULL,

    created_date      TIMESTAMP              NOT NULL,
    modified_date     TIMESTAMP              NOT NULL,
    created_by        CHARACTER VARYING(100) NOT NULL,
    modified_by       CHARACTER VARYING(100) NOT NULL,
    marked_as_deleted BOOLEAN                NOT NULL DEFAULT FALSE,

    PRIMARY KEY (id),
    CONSTRAINT search_log_user_id_fk FOREIGN KEY (user_id) REFERENCES public.user (id)
) TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS search_log_user_id_idx
    ON public.search_log (user_id);

CREATE INDEX IF NOT EXISTS search_log_created_date_idx
    ON public.search_log (created_date);

CREATE INDEX IF NOT EXISTS search_log_keyword_idx
    ON public.search_log (keyword);
