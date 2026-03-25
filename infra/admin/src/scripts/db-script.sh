#!/usr/bin/env bash
# Configuration

. ./set-db-env.sh

DBADMIN=mariadb-admin
DBSQL=mariadb
DBDUMP=mariadb-dump

dbcmd_exec_user() {
    local cmd=$1
    shift
    local CUR_DB_USER=${1:-$DB_USER}
    shift
    local CUR_DB_PASSWORD=${1:-$DB_PASSWORD}
    shift

    $cmd -h $DB_HOST -P $DB_PORT -u$CUR_DB_USER -p$CUR_DB_PASSWORD "$@"
}

dbcmd_exec() {
    local cmd=$1
    shift

    dbcmd_exec_user $cmd $DB_USER $DB_PASSWORD "$@"
}

wait_for_db_ready() {
    until dbcmd_exec $DBADMIN ping --silent > /dev/null; do
        echo "Database is still initializing... (sleeping 2s)"
        sleep 2
    done
    echo "Database is ready!"
}

db_statement() {
    local sql=$1
    local CUR_DB_USER=${2:-$DB_USER}
    local CUR_DB_PASSWORD=${3:-$DB_PASSWORD}
    dbcmd_exec_user $DBSQL $CUR_DB_USER $CUR_DB_PASSWORD --batch -e "$sql"
}

db_load_script() {
    local sql_file=$1
    local CUR_DB_USER=${2:-$DB_USER}
    local CUR_DB_PASSWORD=${3:-$DB_PASSWORD}

    echo "Loading SQL script '$sql_file' into database with user $CUR_DB_USER..."

    dbcmd_exec_user $DBSQL $CUR_DB_USER $CUR_DB_PASSWORD < "$sql_file"
}


db_console() {
    local pod_name=$1
    local CUR_DB_USER=${3:-$DB_USER}
    local CUR_DB_PASSWORD=${4:-$DB_PASSWORD}

    kubectl_exec $pod_name $DBSQL -u$CUR_DB_USER -p$CUR_DB_PASSWORD 
}

db_value_from_sql() {
    local sql=$1
    local CUR_DB_USER=${2:-$DB_USER}
    local CUR_DB_PASSWORD=${3:-$DB_PASSWORD}

    dbcmd_exec_user $DBSQL $CUR_DB_USER $CUR_DB_PASSWORD --batch --skip-column-names -e "$sql"
}

db_dump() {
    local db_name=$1
    local output_file=$2
    local CUR_DB_USER=${3:-$DB_USER}
    local CUR_DB_PASSWORD=${4:-$DB_PASSWORD}

    dbcmd_exec_user $DBDUMP $CUR_DB_USER $CUR_DB_PASSWORD --databases $db_name > $output_file
}

db_user_exists() {
    local username=$1
    local result=$(db_value_from_sql "SELECT User FROM mysql.user WHERE User='$username'" $ROOT_DB_USER $ROOT_DB_PASSWORD)
    [ -n "$result" ]
}

db_new_user() {
    local username=$1
    local password=$2

    if db_user_exists $username; then
        echo "User '$username' already exists. Skipping creation."
        return
    fi
    db_statement "CREATE USER '$username'@'%' IDENTIFIED BY '$password'" $ROOT_DB_USER $ROOT_DB_PASSWORD
}


db_grant_all_privileges() {
    local username=$1
    local schema=$2

    db_statement "GRANT ALL PRIVILEGES ON $schema.* TO '$username'@'%';" $ROOT_DB_USER $ROOT_DB_PASSWORD
}
