#!/usr/bin/env bash

if [ -z "$ROOT_DB_USER" ]; then
  export ROOT_DB_USER="root"
fi

if [ -z "$ROOT_DB_PASSWORD" ]; then
  export ROOT_DB_PASSWORD="strong_password"
fi

if [ -z "$DB_USER" ]; then
  export DB_USER="root"
fi

if [ -z "$DB_PASSWORD" ]; then
  export DB_PASSWORD=$ROOT_DB_PASSWORD
fi


if [ -z "$DB_HOST" ]; then
  export DB_HOST="localhost"
fi

if [ -z "$DB_PORT" ]; then
  export DB_PORT=3306
fi

echo "Database environment variables set: "
echo "ROOT_DB_USER: $ROOT_DB_USER"
echo "ROOT_DB_PASSWORD: $ROOT_DB_PASSWORD"
echo "DB_USER: $DB_USER"
echo "DB_PASSWORD: $DB_PASSWORD"
echo "DB_HOST: $DB_HOST"
echo "DB_PORT: $DB_PORT"
