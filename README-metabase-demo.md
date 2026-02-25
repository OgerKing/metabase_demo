## Metabase Demo Stack

This directory defines a minimal Metabase + Postgres stack that can be run locally and mirrored on an EC2 instance.

- `docker-compose.yml`: Runs `postgres` and `metabase` services.
- `.env`: Local configuration (copy from `.env.example` and adjust as needed).
- `seed/`: Holds the Metabase application DB (`metabase.db`) and an optional Postgres seed dump (`hub_analytics.sql`).
- `scripts/export-from-apiary.ps1`: Optional helper to export seed data from an existing Apiary stack into `seed/` (not required for this stack to run).
- `scripts/import-to-local.ps1`: Optional helper to import `seed/hub_analytics.sql` into the local `postgres` container.

### Usage: local

**Option A – Fresh install (no Apiary)**

1. From PowerShell, create your local environment file:
   - `cd C:\Sites\metabase_demo`
   - `copy .env.example .env`
   - Edit `.env` and adjust values as needed.
2. Start the local Metabase stack:
   - `docker compose up -d`
3. Open Metabase at `http://localhost:3030`, complete the setup wizard, and add a database connection to `postgres:5432` using the credentials from `.env`.

**Option B – Mirror from Apiary (spin up to look like Apiary)**

1. Ensure the Apiary stack is running and has the data you want:
   - `cd C:\Sites\Apiary; docker compose up -d`
2. From `C:\Sites\metabase_demo`, copy Metabase app DB and Postgres dump from Apiary into `seed/`:
   - `.\scripts\export-from-apiary.ps1`
   - This creates `seed\metabase.db` (dashboards, questions, connections) and `seed\hub_analytics.sql`.
3. Create env and start this stack:
   - `copy .env.example .env` (edit if needed)
   - `docker compose up -d`
4. Import the analytics data into local Postgres so Metabase’s existing connection to database `apiary` has data:
   - `.\scripts\import-to-local.ps1` (imports into database `apiary`)
5. Open Metabase at `http://localhost:3030`. Log in with your Apiary Metabase credentials; dashboards and the Apiary connection will match (pointing at local Postgres database `apiary`).

**If you already ran this stack before** and see Postgres errors like `database "apiary" does not exist`, create the database once then re-import:
- `docker compose exec postgres psql -U apiary -d postgres -c "CREATE DATABASE apiary;"`
- `.\scripts\import-to-local.ps1`

