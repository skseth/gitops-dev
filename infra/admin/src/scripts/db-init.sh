#!/usr/bin/env bash
# Configuration
. "$(dirname "$0")/db-script.sh"

SCRIPT_DIR="$(dirname "$0")"

DB_NAME="world"
SQL_FILE="$SCRIPT_DIR/world/init.sql"
APP_USER="appuser"
APP_PASSWORD="app_password"

wait_for_db_ready
echo "Database is ready! Running initialization script..."

if [ "$FORCE" == "--force" ]; then
    echo "Force flag detected. Deleting database if it exists..."
    db_statement "DROP DATABASE IF EXISTS $DB_NAME"
fi

RESULT=$(db_value_from_sql "SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME='$DB_NAME'")
echo "Database schema exists: $RESULT"

if [ -z "$RESULT" ]; then
    echo "Database $DB_NAME does not exist. Initializing..."
    db_load_script $SQL_FILE
else
    echo "Database $RESULT exists already. Not initializing."
fi

db_new_user $APP_USER $APP_PASSWORD

db_grant_all_privileges $APP_USER $DB_NAME

echo "Database initialization complete."
