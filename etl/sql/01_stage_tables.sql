-- 01_stage_tables.sql
-- Raw landing tables (staging). Safe to TRUNCATE + reload.

IF OBJECT_ID('dbo.stg_telemetry', 'U') IS NOT NULL DROP TABLE dbo.stg_telemetry;
GO

CREATE TABLE dbo.stg_telemetry (
  event_time       datetime2(0)   NOT NULL,
  truck_id         int            NOT NULL,
  site_id          int            NOT NULL,
  status           varchar(16)    NOT NULL,
  fuel_rate        decimal(10,2)  NOT NULL,
  payload          decimal(10,2)  NOT NULL,
  engine_temp      decimal(10,2)  NOT NULL,
  duration_seconds int            NULL
);
GO
