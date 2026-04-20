-- liquibase formatted sql

-- changeset codex:20260417_create_recommendation_event
CREATE SEQUENCE IF NOT EXISTS public.recommendation_event_id_sequence
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

CREATE TABLE IF NOT EXISTS public.recommendation_event
(
    id                BIGINT                  NOT NULL DEFAULT nextval('recommendation_event_id_sequence'::regclass),
    user_id           BIGINT                  NULL,
    book_id           BIGINT                  NULL,
    event_type        CHARACTER VARYING(40)   NOT NULL,
    feedback_type     CHARACTER VARYING(40)   NULL,
    overview_title    CHARACTER VARYING(255)  NULL,
    shelf_key         CHARACTER VARYING(80)   NULL,
    shelf_title       CHARACTER VARYING(160)  NULL,
    source            CHARACTER VARYING(120)  NULL,
    reason            TEXT                    NULL,
    reason_type       CHARACTER VARYING(80)   NULL,
    rank_position     INTEGER                 NULL,
    request_context   CHARACTER VARYING(255)  NULL,
    comment           CHARACTER VARYING(500)  NULL,

    created_date      TIMESTAMP               NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_date     TIMESTAMP               NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by        CHARACTER VARYING(100)  NOT NULL DEFAULT 'anonymous',
    modified_by       CHARACTER VARYING(100)  NOT NULL DEFAULT 'anonymous',
    marked_as_deleted BOOLEAN                 NOT NULL DEFAULT FALSE,

    PRIMARY KEY (id),
    CONSTRAINT recommendation_event_user_id_fk FOREIGN KEY (user_id) REFERENCES public.user (id),
    CONSTRAINT recommendation_event_book_id_fk FOREIGN KEY (book_id) REFERENCES public.book (id)
) TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS recommendation_event_user_id_idx
    ON public.recommendation_event (user_id);

CREATE INDEX IF NOT EXISTS recommendation_event_book_id_idx
    ON public.recommendation_event (book_id);

CREATE INDEX IF NOT EXISTS recommendation_event_event_type_idx
    ON public.recommendation_event (event_type);

CREATE INDEX IF NOT EXISTS recommendation_event_feedback_type_idx
    ON public.recommendation_event (feedback_type);

CREATE INDEX IF NOT EXISTS recommendation_event_created_date_idx
    ON public.recommendation_event (created_date);
