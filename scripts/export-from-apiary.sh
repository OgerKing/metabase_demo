#!/usr/bin/env bash
set -euo pipefail

# Export seed data from the Apiary stack into this project's seed/ directory.
# - Postgres: either full DB dump (seed/hub_analytics.sql) or one schema only (seed/<schema>_schema.sql)
# - Copies the Metabase application DB (metabase.db) from the Apiary volume
#
# To export only the metabase_demo schema (no full hub dump):
#   SCHEMA_NAME=metabase_demo ./scripts/export-from-apiary.sh
#
# To export the full hub database (default):
#   ./scripts/export-from-apiary.sh
#
# Assumptions:
# - Apiary stack is running (at least its postgres and metabase services)
# - This script is run on the host where the Apiary Docker stack lives
#
# Override via env: APIARY_DIR, DB_NAME, DB_USER, SEED_DIR, SCHEMA_NAME

# Directory containing Apiary's docker-compose.yml
APIARY_DIR=${APIARY_DIR:-"/c/Sites/Apiary"}

# Database/user to dump from Apiary
DB_NAME=${DB_NAME:-"hub"}
DB_USER=${DB_USER:-"apiary"}

# If set, dump only this schema (e.g. metabase_demo) to seed/<schema>_schema.sql
SCHEMA_NAME=${SCHEMA_NAME:-}

# Directory in *this* project where seed files live
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SEED_DIR=${SEED_DIR:-"${ROOT_DIR}/seed"}

echo "Apiary directory     : ${APIARY_DIR}"
echo "Seed directory       : ${SEED_DIR}"
echo "Database to dump     : ${DB_NAME}"
echo "Database user        : ${DB_USER}"
if [[ -n "${SCHEMA_NAME:-}" ]]; then
  echo "Schema only           : ${SCHEMA_NAME}"
fi
echo

mkdir -p "${SEED_DIR}"

# Choose docker compose command
if command -v docker-compose >/dev/null 2>&1; then
  DC="docker-compose"
else
  DC="docker compose"
fi

COMPOSE_FILE="${APIARY_DIR}/docker-compose.yml"

if [[ ! -f "${COMPOSE_FILE}" ]]; then
  echo "ERROR: Apiary docker-compose.yml not found at ${COMPOSE_FILE}" >&2
  echo "Set APIARY_DIR to the directory containing Apiary's docker-compose.yml and retry." >&2
  exit 1
fi

if [[ -n "${SCHEMA_NAME:-}" ]]; then
  OUT_FILE="${SCHEMA_NAME}_schema.sql"
  echo "Exporting schema '${SCHEMA_NAME}' from Postgres '${DB_NAME}' to ${SEED_DIR}/${OUT_FILE} ..."
  ${DC} -f "${COMPOSE_FILE}" exec -T postgres bash -lc \
    "pg_dump -U ${DB_USER} -n ${SCHEMA_NAME} ${DB_NAME} > /tmp/${OUT_FILE}"
  ${DC} -f "${COMPOSE_FILE}" cp "postgres:/tmp/${OUT_FILE}" "${SEED_DIR}/${OUT_FILE}"
else
  echo "Exporting full Postgres '${DB_NAME}' to ${SEED_DIR}/hub_analytics.sql ..."
  ${DC} -f "${COMPOSE_FILE}" exec -T postgres bash -lc \
    "pg_dump -U ${DB_USER} ${DB_NAME} > /tmp/hub_analytics.sql"
  ${DC} -f "${COMPOSE_FILE}" cp postgres:/tmp/hub_analytics.sql "${SEED_DIR}/hub_analytics.sql"
  OUT_FILE="hub_analytics.sql"
fi

echo "Postgres dump completed."

echo "Copying Metabase H2 metabase.db from Apiary volume into ${SEED_DIR} ..."

# Copy metabase.db from the named volume used by the Apiary stack.
docker run --rm \
  -v apiary_metabase-data:/metabase-data \
  -v "${SEED_DIR}:/dest" \
  alpine:latest /bin/sh -c "cp /metabase-data/metabase.db /dest/metabase.db"

echo "Done. Seed files in ${SEED_DIR}:"
echo "  - ${OUT_FILE}"
echo "  - metabase.db"
if [[ -n "${SCHEMA_NAME:-}" ]]; then
  echo ""
  echo "To import the schema into metabase_demo Postgres (e.g. into database apiary):"
  echo "  docker compose exec -T postgres psql -U apiary -d apiary -f /seed/${OUT_FILE}"
fi

