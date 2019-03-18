#!/usr/bin/env bash
set -e

echo "This will delete and restore the sampledb database. Type 'CONFIRM' if this is okay"
read SURE
if [ "$SURE" != "CONFIRM" ]; then
  echo "You didn't confirm, so we're aborting."
  exit
fi

# Create database if not exists
createdb sampledb || true

# Install to DB in single transaction
psql -X1v ON_ERROR_STOP=1 sampledb -f scripts/schema_pg.sql

