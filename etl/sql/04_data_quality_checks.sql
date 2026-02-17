-- 04_data_quality_checks.sql
-- Minimal data quality checks

-- 1) Null checks
IF EXISTS (
  SELECT 1
  FROM dbo.fact_telemetry
  WHERE truck_id IS NULL OR site_id IS NULL OR time_key IS NULL
)
  THROW 50001, 'DQ FAIL: NULL keys in fact_telemetry', 1;

-- 2) Status domain check
IF EXISTS (
  SELECT 1
  FROM dbo.fact_telemetry
  WHERE status NOT IN ('ACTIVE','IDLE','DOWN')
)
  THROW 50002, 'DQ FAIL: invalid status values', 1;

-- 3) Range checks
IF EXISTS (
  SELECT 1
  FROM dbo.fact_telemetry
  WHERE fuel_rate < 0 OR payload < 0 OR engine_temp < 0 OR engine_temp > 200
)
  THROW 50003, 'DQ FAIL: numeric range issue', 1;

-- 4) Freshness (optional): latest event not older than X days
-- (Adjust as needed)
-- SELECT MAX(event_time) AS latest_event_time FROM dbo.fact_telemetry;
GO
