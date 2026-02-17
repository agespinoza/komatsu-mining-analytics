-- 05_create_kpi_views.sql
--Assumes status='ACTIVE' means working.
-- UTILIZATION
CREATE OR ALTER VIEW dbo.vw_kpi_utilization AS
SELECT
  f.time_key,
  t.full_date,
  t.hour_of_day,
  f.site_id,
  s.site_name,
  f.truck_id,
  tr.truck_name,

  -- seconds-based utilization
  SUM(CASE WHEN f.status = 'ACTIVE' THEN f.duration_seconds ELSE 0 END) AS active_seconds,
  SUM(f.duration_seconds) AS total_seconds,
  CAST(
    1.0 * SUM(CASE WHEN f.status = 'ACTIVE' THEN f.duration_seconds ELSE 0 END)
    / NULLIF(SUM(f.duration_seconds), 0)
    AS decimal(10,4)
  ) AS utilization_pct
FROM dbo.fact_telemetry f
JOIN dbo.dim_time  t  ON t.time_key = f.time_key
JOIN dbo.dim_site  s  ON s.site_id  = f.site_id
JOIN dbo.dim_truck tr ON tr.truck_id = f.truck_id
GROUP BY
  f.time_key, t.full_date, t.hour_of_day,
  f.site_id, s.site_name,
  f.truck_id, tr.truck_name;
GO

--Assumes fuel_rate is L/h.
-- FUEL EFFICIENCY (L/ton)
CREATE OR ALTER VIEW dbo.vw_kpi_fuel_efficiency AS
SELECT
  f.time_key,
  t.full_date,
  t.hour_of_day,
  f.site_id,
  s.site_name,
  f.truck_id,
  tr.truck_name,

  -- liters consumed = fuel_rate (L/h) * hours
  SUM( f.fuel_rate * (f.duration_seconds / 3600.0) ) AS fuel_liters,
  SUM( f.payload ) AS payload_tons,
  CAST(
    SUM( f.fuel_rate * (f.duration_seconds / 3600.0) )
    / NULLIF(SUM(f.payload), 0)
    AS decimal(10,4)
  ) AS liters_per_ton
FROM dbo.fact_telemetry f
JOIN dbo.dim_time  t  ON t.time_key = f.time_key
JOIN dbo.dim_site  s  ON s.site_id  = f.site_id
JOIN dbo.dim_truck tr ON tr.truck_id = f.truck_id
GROUP BY
  f.time_key, t.full_date, t.hour_of_day,
  f.site_id, s.site_name,
  f.truck_id, tr.truck_name;
GO

--Threshold hardcoded on view
-- OVERHEAT EVENTS
CREATE OR ALTER VIEW dbo.vw_kpi_overheat_events AS
SELECT
  f.event_time,
  f.time_key,
  t.full_date,
  t.hour_of_day,
  f.site_id,
  s.site_name,
  f.truck_id,
  tr.truck_name,
  f.engine_temp
FROM dbo.fact_telemetry f
JOIN dbo.dim_time  t  ON t.time_key = f.time_key
JOIN dbo.dim_site  s  ON s.site_id  = f.site_id
JOIN dbo.dim_truck tr ON tr.truck_id = f.truck_id
WHERE f.engine_temp > 95;
GO

