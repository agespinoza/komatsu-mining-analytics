-- 02_load_dimensions.sql
-- Upsert dimensions: truck, site, time.

-- Trucks
MERGE dbo.dim_truck AS tgt
USING (
  SELECT DISTINCT truck_id
  FROM dbo.stg_telemetry
) AS src
ON tgt.truck_id = src.truck_id
WHEN NOT MATCHED THEN
  INSERT (truck_id, truck_name, model)
  VALUES (src.truck_id, CONCAT('TRUCK-', src.truck_id), 'UNKNOWN');

-- Sites
MERGE dbo.dim_site AS tgt
USING (
  SELECT DISTINCT site_id
  FROM dbo.stg_telemetry
) AS src
ON tgt.site_id = src.site_id
WHEN NOT MATCHED THEN
  INSERT (site_id, site_name, region)
  VALUES (src.site_id, CONCAT('SITE-', src.site_id), 'UNKNOWN');

-- Time dimension (hourly grain)
-- We generate time rows from staging event_time.
;WITH times AS (
  SELECT DISTINCT
    CAST(event_time AS date) AS full_date,
    DATEPART(hour, event_time) AS hour_of_day
  FROM dbo.stg_telemetry
)
MERGE dbo.dim_time AS tgt
USING (
  SELECT
    CONVERT(int, FORMAT(full_date, 'yyyyMMdd')) * 100 + hour_of_day AS time_key,
    full_date,
    YEAR(full_date) AS [year],
    MONTH(full_date) AS [month],
    DAY(full_date) AS [day],
    hour_of_day
  FROM times
) AS src
ON tgt.time_key = src.time_key
WHEN NOT MATCHED THEN
  INSERT (time_key, full_date, [year], [month], [day], hour_of_day)
  VALUES (src.time_key, src.full_date, src.[year], src.[month], src.[day], src.hour_of_day);
GO
