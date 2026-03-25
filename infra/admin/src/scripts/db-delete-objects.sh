#!/usr/bin/env bash
# Configuration
. "$(dirname "$0")/db-script.sh"

SCRIPT_DIR="$(dirname "$0")"

FORCE="$1"

POD_LABEL="app=mariadb"
DB_NAME="world"
SQL_FILE="$SCRIPT_DIR/world/delete-tables.sql"
# DB_USER="appuser"
# DB_PASSWORD="app_password"

POD_NAME=$(pod_name $POD_LABEL)

db_load_script $POD_NAME $SQL_FILE

