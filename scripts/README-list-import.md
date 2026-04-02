`scripts/generate-list-import-sql.js` builds an incremental PostgreSQL import from:

- `list/authors.raw.json`
- `list/books.raw.json`

It generates:

- `scripts/generated/import_from_list_raw.sql`

What the generated SQL does:

1. Inserts missing authors by name
2. Inserts missing categories by name
3. Inserts missing books by `(name, author, category)`
4. Keeps existing data intact
5. Fills required fallback values for blank dates, blank images, blank country, and blank descriptions

Category handling:

- `Adventure` is mapped to `Action and Adventure`
- `Romance` is mapped to `Romantic`
- Other category names are inserted as-is if they do not already exist

Run:

```powershell
node scripts/generate-list-import-sql.js
$env:PGPASSWORD="20041117"
$env:PGCLIENTENCODING="UTF8"
& "D:\PostgreSQL\18\bin\psql.exe" -h localhost -p 5043 -U postgres -d book_recommendation_system -f scripts/generated/import_from_list_raw.sql
Remove-Item Env:PGPASSWORD
Remove-Item Env:PGCLIENTENCODING
```

Notes:

- This is additive. It does not truncate existing authors or books.
- `books.failed.json` is not imported because it only contains unresolved fetch failures, not complete book rows.
- Blank cover URLs are replaced with `/book-service/book-covers/default-book-cover.svg`.
