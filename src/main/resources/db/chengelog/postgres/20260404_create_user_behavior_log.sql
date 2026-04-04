-- liquibase formatted sql

-- changeset codex:20260404_create_user_behavior_log
CREATE SEQUENCE IF NOT EXISTS public.user_behavior_log_id_sequence
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

CREATE TABLE IF NOT EXISTS public.user_behavior_log
(
    id                BIGINT                 NOT NULL DEFAULT nextval('user_behavior_log_id_sequence'::regclass),
    user_id           BIGINT                 NULL,
    book_id           BIGINT                 NULL,
    action_type       CHARACTER VARYING(40)  NOT NULL,
    keyword           CHARACTER VARYING(255) NULL,
    source            CHARACTER VARYING(120) NULL,
    reason            TEXT                   NULL,

    created_date      TIMESTAMP              NOT NULL,
    modified_date     TIMESTAMP              NOT NULL,
    created_by        CHARACTER VARYING(100) NOT NULL,
    modified_by       CHARACTER VARYING(100) NOT NULL,
    marked_as_deleted BOOLEAN                NOT NULL DEFAULT FALSE,

    PRIMARY KEY (id),
    CONSTRAINT user_behavior_log_user_id_fk FOREIGN KEY (user_id) REFERENCES public.user (id),
    CONSTRAINT user_behavior_log_book_id_fk FOREIGN KEY (book_id) REFERENCES public.book (id)
) TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS user_behavior_log_user_id_idx
    ON public.user_behavior_log (user_id);

CREATE INDEX IF NOT EXISTS user_behavior_log_action_type_idx
    ON public.user_behavior_log (action_type);

CREATE INDEX IF NOT EXISTS user_behavior_log_created_date_idx
    ON public.user_behavior_log (created_date);
