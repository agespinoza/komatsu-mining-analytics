#!/usr/bin/env bash
set -e

echo "Run ETL SQL scripts in order:"
echo "1) 01_stage_tables.sql"
echo "2) 02_load_dimensions.sql"
echo "3) 03_load_fact.sql"
echo "4) 04_data_quality_checks.sql"

echo "Use Azure Data Studio or sqlcmd to execute:"
echo "sqlcmd -S <server> -d <db> -U <user> -P <password> -i etl/sql/01_stage_tables.sql"
