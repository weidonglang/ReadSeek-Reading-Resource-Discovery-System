# AI Catalog Enrichment

`scripts/enrich_catalog_ai.py` enriches existing ReadSeek books through an OpenAI-compatible chat API.

It updates only semantic metadata:

- `description`
- `tags`

It does not invent ISBN, publisher, publish date, page count, price, or cover URL.

## Provider Setup

Recommended: keep the API key in your shell environment.

```powershell
$env:DASHSCOPE_API_KEY="your-rotated-api-key"
```

Optional local provider config:

```powershell
Copy-Item scripts\ai-providers.example.json scripts\ai-providers.local.json
notepad scripts\ai-providers.local.json
```

`scripts\ai-providers.local.json` is ignored by Git.

## Dry Run

Generate a preview for 10 books without writing to ReadSeek:

```powershell
python scripts\enrich_catalog_ai.py `
  --ai-model qwen3.5-omni-plus-2026-03-15 `
  --limit 10 `
  --parallel 3
```

Use a local provider config:

```powershell
python scripts\enrich_catalog_ai.py `
  --provider-config scripts\ai-providers.local.json `
  --provider-name aliyun-bailian-qwen3.5-omni-plus-2026-03-15 `
  --ai-model qwen3.5-omni-plus-2026-03-15 `
  --limit 10 `
  --parallel 3
```

Preview output:

```text
scripts/generated/catalog_ai_enrichment_preview.json
```

## Apply

After reviewing the preview:

```powershell
python scripts\enrich_catalog_ai.py `
  --provider-config scripts\ai-providers.local.json `
  --provider-name aliyun-bailian-qwen3.5-omni-plus-2026-03-15 `
  --ai-model qwen3.5-omni-plus-2026-03-15 `
  --limit 50 `
  --parallel 3 `
  --apply `
  --rebuild-index
```

The script logs in with the admin account from `.env`, creates missing tags through `/api/tag`, updates books through `/api/resources`, and optionally rebuilds the search index.

## Useful Options

- `--limit 20`: process at most 20 books.
- `--only-missing` / `--no-only-missing`: enrich only incomplete books or all books.
- `--min-description-length 80`: treat shorter descriptions as incomplete.
- `--min-tags 2`: treat books with fewer tags as incomplete.
- `--max-tags 8`: cap generated tags per book.
- `--parallel 3`: send up to 3 AI requests at the same time; database writes still run sequentially.
- `--http-timeout 150`: wait longer for slower models.
- `--retries 2`: retry timeout/network failures.
- `--min-apply-confidence 0.65`: skip low-confidence records during `--apply`.
- `--apply`: write changes.
- `--rebuild-index`: rebuild Elasticsearch/vector index after applying changes.

## Safety Notes

- Rotate any API key that was pasted into chat or committed accidentally.
- Start with `--limit 10` and inspect the preview.
- Prefer AI enrichment for tags and descriptions only; use book-data APIs for factual metadata such as ISBN and publisher.
