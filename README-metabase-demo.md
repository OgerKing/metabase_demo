## Metabase Demo Stack

This directory defines a minimal Metabase + Postgres stack that can be run locally and mirrored on an EC2 instance.

- `docker-compose.yml`: Runs `postgres` and `metabase` services.
- `.env`: Local configuration (copy from `.env.example` and adjust as needed).
- `seed/`: Holds `metabase.db` (Metabase H2 app DB) and `hub_analytics.sql` (Postgres dump from Apiary).
- `scripts/export-from-apiary.ps1`: Exports seed data from `C:\Sites\Apiary` into `seed/`.
- `scripts/import-to-local.ps1`: Imports `seed/hub_analytics.sql` into the local `postgres` container.

### Usage: local

1. From PowerShell, export seeds from the Apiary stack:
   - Ensure `C:\Sites\Apiary` stack is up: `cd C:\Sites\Apiary; docker compose up -d`.
   - Run: `cd C:\Sites\metabase_demo; .\scripts\export-from-apiary.ps1`.
2. Start the local Metabase stack:
   - `cd C:\Sites\metabase_demo`
   - `docker compose up -d`
3. Import analytics data into local Postgres:
   - `.\scripts\import-to-local.ps1`
4. Open Metabase at `http://localhost:3030` and point the `hub` database connection at `postgres:5432` using the credentials from `.env`.

