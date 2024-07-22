#!/bin/bash
DB_HOST=
DB_USERNAME=
DB_NAME=
while getopts "a:b:c:" opt; do
  # shellcheck disable=SC2220
  case "$opt" in
  a) DB_HOST="$OPTARG" ;;
  b) DB_USERNAME="$OPTARG" ;;
  c) DB_NAME="$OPTARG" ;;
  esac
done

psql -h "$DB_HOST" -U "$DB_USERNAME" -d "$DB_NAME"
