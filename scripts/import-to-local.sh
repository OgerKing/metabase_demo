#!/usr/bin/env bash
set -euo pipefail

# Directory containing docker-compose.yml (defaults to repo root)
COMPOSE_DIR=${COMPOSE_DIR:-"$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"}

# Path to the seed SQL file *inside* the postgres container
SEED_SQL_PATH_IN_CONTAINER=${SEED_SQL_PATH_IN_CONTAINER:-"/seed/hub_analytics.sql"}

# Database/user to import into (matches mirror-from-Apiary setup)
DB_NAME=${DB_NAME:-"apiary"}
DB_USER=${DB_USER:-"apiary"}

echo "Importing ${SEED_SQL_PATH_IN_CONTAINER} into Postgres database '${DB_NAME}' ..."

cd "${COMPOSE_DIR}"

# Support both 'docker compose' and 'docker-compose'
if command -v docker-compose >/dev/null 2>&1; then
  DC="docker-compose"
else
  DC="docker compose"
fi

${DC} exec -T postgres bash -c "psql -U ${DB_USER} -d ${DB_NAME} -f ${SEED_SQL_PATH_IN_CONTAINER}"

echo "Import completed."

