# KPI API (REST)

This folder exposes the curated KPI layer as a simple REST API.

## Purpose
- Demonstrate how dashboards, services, or customer applications can consume KPIs
- Keep KPI logic in the database (views), and expose it through endpoints

## Endpoints
- GET /health
- GET /kpi/utilization
- GET /kpi/fuel-efficiency
- GET /kpi/overheat-events

Each endpoint reads from the curated SQL views:
- vw_kpi_utilization
- vw_kpi_fuel_efficiency
- vw_kpi_overheat_events

## Run locally
1) Copy `.env.example` → `.env` and set your Azure SQL connection
2) Install dependencies:
   ```bash
   pip install -r requirements.txt


## Personal Note
The API is layered: routes → repository → database connection. KPI logic stays in SQL views so all consumers use the same definitions.