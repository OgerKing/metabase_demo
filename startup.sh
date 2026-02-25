#!/usr/bin/env bash
set -euo pipefail

# Project root (directory containing this script and docker-compose.yml)
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${ROOT}"

# Docker Compose command
if command -v docker-compose >/dev/null 2>&1; then
  DC="docker-compose"
else
  DC="docker compose"
fi

echo "=== Metabase Demo first-time startup ==="

# 1. Create .env from .env.example if missing
if [[ ! -f .env ]]; then
  echo "Creating .env from .env.example ..."
  cp .env.example .env
  echo "Edit .env to set POSTGRES_PASSWORD and MB_SITE_URL if needed."
else
  echo ".env already exists, skipping."
fi

# 2. Start the stack (Postgres + Metabase)
echo "Starting Docker stack ..."
${DC} up -d

# 3. Wait for Postgres to be ready
echo "Waiting for Postgres to be ready ..."
for i in $(seq 1 30); do
  if ${DC} exec -T postgres pg_isready -U apiary >/dev/null 2>&1; then
    echo "Postgres is ready."
    break
  fi
  if [[ $i -eq 30 ]]; then
    echo "Timeout waiting for Postgres." >&2
    exit 1
  fi
  sleep 2
done

# 4. Hydrate databases if seed file exists
SEED_SQL="${ROOT}/seed/hub_analytics.sql"
if [[ -f "${SEED_SQL}" ]]; then
  echo "Seeding database 'apiary' from hub_analytics.sql ..."
  ${DC} exec -T postgres bash -c "psql -v ON_ERROR_STOP=1 -U apiary -d apiary -f /seed/hub_analytics.sql"
  echo "Seeding database 'hub' from hub_analytics.sql ..."
  ${DC} exec -T postgres bash -c "psql -v ON_ERROR_STOP=1 -U apiary -d hub -f /seed/hub_analytics.sql"
  echo "Databases hydrated."
else
  echo "No seed/hub_analytics.sql found; skipping database hydration."
fi

echo ""
echo "=== Startup complete ==="
echo "Metabase: http://localhost:3030"
echo "Postgres:  localhost:5433 (user apiary, databases apiary, hub)"
echo ""
echo "Run: ${DC} logs -f metabase   to follow Metabase logs."
