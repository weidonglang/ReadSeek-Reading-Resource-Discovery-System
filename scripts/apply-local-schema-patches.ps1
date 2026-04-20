[CmdletBinding()]
param(
    [string]$ContainerName = 'readseek-db',
    [string]$Database = 'book_recommendation_system',
    [string]$User = 'postgres'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Write-Step {
    param([string]$Message)
    Write-Host "== $Message ==" -ForegroundColor Cyan
}

function Invoke-PostgresSql {
    param([string]$Sql)

    $tempFile = Join-Path $env:TEMP ("readseek-schema-patch-{0}.sql" -f ([guid]::NewGuid()))
    Set-Content -LiteralPath $tempFile -Value $Sql -NoNewline -Encoding UTF8
    try {
        docker cp $tempFile "${ContainerName}:/tmp/readseek-schema-patch.sql" | Out-Null
        docker exec $ContainerName psql -v ON_ERROR_STOP=1 -U $User -d $Database -f /tmp/readseek-schema-patch.sql | Out-Null
    } finally {
        Remove-Item -LiteralPath $tempFile -ErrorAction SilentlyContinue
        docker exec $ContainerName rm -f /tmp/readseek-schema-patch.sql 2>$null | Out-Null
    }
}

$containerId = docker ps --filter "name=^/${ContainerName}$" --format '{{.ID}}' | Select-Object -First 1
if ([string]::IsNullOrWhiteSpace($containerId)) {
    throw "PostgreSQL container '$ContainerName' is not running."
}

Write-Step 'Applying local schema patches'

Invoke-PostgresSql @'
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
    PRIMARY KEY (id)
) TABLESPACE pg_default;

DO $$
BEGIN
    IF to_regclass('public.user') IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = 'recommendation_event_user_id_fk'
    ) THEN
        ALTER TABLE public.recommendation_event
            ADD CONSTRAINT recommendation_event_user_id_fk
            FOREIGN KEY (user_id) REFERENCES public.user (id)
            ON DELETE SET NULL;
    END IF;

    IF to_regclass('public.book') IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = 'recommendation_event_book_id_fk'
    ) THEN
        ALTER TABLE public.recommendation_event
            ADD CONSTRAINT recommendation_event_book_id_fk
            FOREIGN KEY (book_id) REFERENCES public.book (id)
            ON DELETE SET NULL;
    END IF;
END $$;

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
'@

Write-Host 'Local schema patches applied.' -ForegroundColor Green
