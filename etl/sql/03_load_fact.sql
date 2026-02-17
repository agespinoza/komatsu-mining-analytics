-- 03_load_fact.sql
-- Load fact table from staging + dimension keys.

INSERT INTO dbo.fact_telemetry (
  time_key,
  truck_id,
  site_id,
  status,
  fuel_rate,
  payload,
  engine_temp,
  duration_seconds,
  event_time
)
SELECT
  (CONVERT(int, FORMAT(CAST(s.event_time AS date), 'yyyyMMdd')) * 100) + DATEPART(hour, s.event_time) AS time_key,
  s.truck_id,
  s.site_id,
  s.status,
  s.fuel_rate,
  s.payload,
  s.engine_temp,
  ISNULL(s.duration_seconds, 60) AS duration_seconds,
  s.event_time
FROM dbo.stg_telemetry s;
GO
