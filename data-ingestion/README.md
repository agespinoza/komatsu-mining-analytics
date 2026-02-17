# Data Ingestion

This folder represents the **ingestion layer** for mining telemetry data.

In production, telemetry may arrive via:
- Batch files (CSV/Parquet) dropped into cloud storage (ADLS/S3)
- Streaming events (Kafka / Event Hubs)

For this sample, ingestion is simulated using:
- A small CSV dataset (sample-data/)
- A generator script that creates realistic telemetry rows
- A validation step that checks schema and basic data quality rules

## Output contract (what downstream expects)
Telemetry records must include:
- truck_id, site_id, event_time
- status (ACTIVE/IDLE/DOWN)
- fuel_rate, payload, engine_temp
- optional duration_seconds (recommended)

Downstream layers:
- ETL loads data into the curated model (Azure SQL star schema)
- KPI views and dashboards consume the curated layer (not raw data)

## Data quality checks (sample)
- Required fields not null
- Valid status values
- Numeric ranges (fuel_rate >= 0, payload >= 0, temp within expected bounds)
- Event time not in the future (optional)

## Personal note
Reliable ingestion is the foundation of the platform — it ensures traceability, scalability, and consistent data for all analytics workloads.
