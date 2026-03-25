#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$0")"
. "$SCRIPT_DIR/db-script.sh"

DB_USER="appuser"
DB_PASSWORD="app_password"

DB_NAME="world"
SQL_FILE="$SCRIPT_DIR/world-db/world.sql"


if [ -z "$1" ]; then
    db_console
else
    db_statement "use $DB_NAME; $@"
fi

