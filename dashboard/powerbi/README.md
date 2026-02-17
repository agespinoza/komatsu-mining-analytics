# Power BI Dashboard

This dashboard consumes the curated KPI layer from Azure SQL.

## Data source

Azure SQL views:

- vw_kpi_utilization
- vw_kpi_fuel_efficiency
- vw_kpi_overheat_events

The dashboard does NOT query raw telemetry tables.

This ensures:
- Consistent business definitions
- Better performance
- Reusable semantic model

## Pages

### 1. Fleet Overview
- Utilization %
- Fuel efficiency
- Overheat events
- Filters: Site, Truck, Date

### 2. Utilization Analysis
- Utilization trend by time
- Utilization by truck
- Top / bottom performers

### 3. Fuel Efficiency
- Liters per ton by site
- Truck comparison

### 4. Reliability
- Overheat event table
- Temperature distribution

## How to run

1. Open the `.pbix` file
2. Update Azure SQL connection
3. Refresh the model
