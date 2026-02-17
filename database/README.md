# Database (Curated Analytics Layer)

This folder contains the curated analytics model in **Azure SQL**.

## What is included
- Dimensional model (star schema):
  - dim_truck, dim_site, dim_time
  - fact_telemetry
- Indexes to support analytical queries
- KPI views used by dashboards and APIs:
  - utilization, fuel efficiency, overheat events

## Key design choices
- Curated layer is separate from staging (raw)
- KPI views provide a stable semantic contract for BI and services
- Time is modeled at an hourly grain using a time_key (yyyymmddhh)


## Personal note 
The curated layer is a star schema optimized for analytics, and KPI views provide a stable semantic contract. Dashboards and APIs consume the KPI layer, not the raw data.