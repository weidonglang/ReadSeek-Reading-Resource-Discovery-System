# Historical Analytics Seed

These scripts generate repeatable historical behavior data from the books, users, categories, authors, publishers, and tags that already exist in the current database.

They are safe to rerun because they only delete and recreate rows where:

- `created_by = 'history-seed-script'`

They do **not** touch your real search logs, behavior logs, or real loans.

## What gets seeded

- `search_log`
- `user_behavior_log`
- `book_loan`

The seeded data is spread across:

- last 7 days
- days 8 to 30
- days 31 to 90
- older than 90 days

That lets the admin analytics page and the recommendations page show visible differences when you switch between:

- 7 days
- 30 days
- 90 days
- all time

## Run the seed

```powershell
$env:PGPASSWORD=$env:POSTGRES_PASSWORD
& "D:\PostgreSQL\18\bin\psql.exe" -h localhost -p 5043 -U postgres -d book_recommendation_system -f scripts/seed_historical_analytics.sql
Remove-Item Env:PGPASSWORD
```

## Remove the seeded history

```powershell
$env:PGPASSWORD=$env:POSTGRES_PASSWORD
& "D:\PostgreSQL\18\bin\psql.exe" -h localhost -p 5043 -U postgres -d book_recommendation_system -f scripts/clear_historical_analytics.sql
Remove-Item Env:PGPASSWORD
```

## How to verify in the UI

1. Restart the backend if it is already running.
2. Run `seed_historical_analytics.sql`.
3. Open `admin.html` and click `Reload Analytics`.
4. Switch the analytics window between `7`, `30`, `90`, and `All time`.
5. Open `recommendations.html` and switch `Popular Window`.

You should see:

- different top clicked books between windows
- different top borrowed books between windows
- non-empty top categories / authors / tags / publishers if your DB already has those relations
- more obvious variation between 7-day and 30-day popular shelves
