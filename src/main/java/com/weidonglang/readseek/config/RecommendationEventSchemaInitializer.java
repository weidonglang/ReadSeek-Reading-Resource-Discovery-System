package com.weidonglang.readseek.config;

import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@Profile("!test")
public class RecommendationEventSchemaInitializer implements ApplicationRunner {
    private final JdbcTemplate jdbcTemplate;

    public RecommendationEventSchemaInitializer(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @Override
    public void run(ApplicationArguments args) {
        try {
            jdbcTemplate.execute("""
                    CREATE SEQUENCE IF NOT EXISTS public.recommendation_event_id_sequence
                        INCREMENT 1
                        START 1
                        MINVALUE 1
                        MAXVALUE 9223372036854775807
                        CACHE 1
                    """);
            jdbcTemplate.execute("""
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
                    )
                    """);
            jdbcTemplate.execute("CREATE INDEX IF NOT EXISTS recommendation_event_user_id_idx ON public.recommendation_event (user_id)");
            jdbcTemplate.execute("CREATE INDEX IF NOT EXISTS recommendation_event_book_id_idx ON public.recommendation_event (book_id)");
            jdbcTemplate.execute("CREATE INDEX IF NOT EXISTS recommendation_event_event_type_idx ON public.recommendation_event (event_type)");
            jdbcTemplate.execute("CREATE INDEX IF NOT EXISTS recommendation_event_feedback_type_idx ON public.recommendation_event (feedback_type)");
            jdbcTemplate.execute("CREATE INDEX IF NOT EXISTS recommendation_event_created_date_idx ON public.recommendation_event (created_date)");
            jdbcTemplate.execute("""
                    CREATE SEQUENCE IF NOT EXISTS public.qa_event_id_sequence
                        INCREMENT 1
                        START 1
                        MINVALUE 1
                        MAXVALUE 9223372036854775807
                        CACHE 1
                    """);
            jdbcTemplate.execute("""
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
                    )
                    """);
            jdbcTemplate.execute("CREATE INDEX IF NOT EXISTS qa_event_event_type_idx ON public.qa_event (event_type)");
            jdbcTemplate.execute("CREATE INDEX IF NOT EXISTS qa_event_user_id_idx ON public.qa_event (user_id)");
            jdbcTemplate.execute("CREATE INDEX IF NOT EXISTS qa_event_book_id_idx ON public.qa_event (book_id)");
            jdbcTemplate.execute("CREATE INDEX IF NOT EXISTS qa_event_created_date_idx ON public.qa_event (created_date)");
        } catch (Exception exception) {
            log.warn("RecommendationEventSchemaInitializer: skip schema initialization because {}", exception.getMessage());
        }
    }
}
