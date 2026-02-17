# ETL (Raw → Curated)

This folder contains the ETL logic that transforms ingested telemetry (raw CSV / staging) into a curated analytics model in Azure SQL.

## ETL steps
1) Load raw telemetry into staging tables (stg_*)
2) Normalize and standardize fields (types, status, timestamps)
3) Upsert dimensions (truck, site, time)
4) Insert fact rows (telemetry events)
5) Run data quality checks (freshness, nulls, ranges)

## Design notes
- Idempotent: staging can be truncated and reloaded safely
- Curated layer uses surrogate keys/time keys for analytics
- KPI views should read from curated tables (not staging)


## Personal Note:
I separate raw landing (staging) from the curated star schema. The ETL is repeatable, and I include basic data quality checks so KPIs remain trusted.