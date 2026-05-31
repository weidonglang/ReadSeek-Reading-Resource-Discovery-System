-- liquibase formatted sql

-- changeset codex:20260531_create_qa_event
CREATE SEQUENCE IF NOT EXISTS public.qa_event_id_sequence
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

CREATE TABLE IF NOT EXISTS public.qa_event
(
    id                    BIGINT                  NOT NULL DEFAULT nextval('qa_event_id_sequence'::regclass),
    event_type            CHARACTER VARYING(40)   NOT NULL,
    user_id               BIGINT                  NULL,
    book_id               BIGINT                  NULL,
    question              CHARACTER VARYING(1000) NULL,
    answer_mode           CHARACTER VARYING(80)   NULL,
    rag_mode              CHARACTER VARYING(40)   NULL,
    provider              CHARACTER VARYING(80)   NULL,
    model                 CHARACTER VARYING(160)  NULL,
    answerable            BOOLEAN                 NULL,
    evidence_count        INTEGER                 NULL,
    citation_count        INTEGER                 NULL,
    retrieval_strategy    CHARACTER VARYING(160)  NULL,
    fallback_applied      BOOLEAN                 NULL,
    fallback_reason       CHARACTER VARYING(1000) NULL,
    confidence            DOUBLE PRECISION        NULL,
    retrieval_latency_ms  BIGINT                  NULL,
    generation_latency_ms BIGINT                  NULL,
    total_latency_ms      BIGINT                  NULL,
    referenced_book_ids   CHARACTER VARYING(1000) NULL,
    citation              CHARACTER VARYING(80)   NULL,
    created_date          TIMESTAMP               NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_date         TIMESTAMP               NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by            CHARACTER VARYING(100)  NOT NULL DEFAULT 'anonymous',
    modified_by           CHARACTER VARYING(100)  NOT NULL DEFAULT 'anonymous',
    marked_as_deleted     BOOLEAN                 NOT NULL DEFAULT FALSE,
    PRIMARY KEY (id),
    CONSTRAINT qa_event_user_id_fk FOREIGN KEY (user_id) REFERENCES public.user (id),
    CONSTRAINT qa_event_book_id_fk FOREIGN KEY (book_id) REFERENCES public.book (id)
);

CREATE INDEX IF NOT EXISTS qa_event_event_type_idx
    ON public.qa_event (event_type);

CREATE INDEX IF NOT EXISTS qa_event_user_id_idx
    ON public.qa_event (user_id);

CREATE INDEX IF NOT EXISTS qa_event_book_id_idx
    ON public.qa_event (book_id);

CREATE INDEX IF NOT EXISTS qa_event_created_date_idx
    ON public.qa_event (created_date);
