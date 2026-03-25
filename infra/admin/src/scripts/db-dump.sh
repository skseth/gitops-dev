#!/usr/bin/env bash
# Configuration
. "$(dirname "$0")/db-script.sh"

SCRIPT_DIR="$(dirname "$0")"

DB_USER="appuser"
DB_PASSWORD="app_password"

DB_NAME="world"


wait_for_db_ready 

db_dump $DB_NAME "$SCRIPT_DIR/${DB_NAME}/dump.sql"