-- 03_create_fact.sql
-- Fact table: telemetry events

IF OBJECT_ID('dbo.fact_telemetry', 'U') IS NOT NULL DROP TABLE dbo.fact_telemetry;
GO

CREATE TABLE dbo.fact_telemetry (
  telemetry_id     bigint        IDENTITY(1,1) NOT NULL PRIMARY KEY,
  time_key         int           NOT NULL,
  truck_id         int           NOT NULL,
  site_id          int           NOT NULL,
  event_time       datetime2(0)  NOT NULL,
  status           varchar(16)   NOT NULL,
  fuel_rate        decimal(10,2) NOT NULL,
  payload          decimal(10,2) NOT NULL,
  engine_temp      decimal(10,2) NOT NULL,
  duration_seconds int           NOT NULL DEFAULT 60,

  CONSTRAINT FK_fact_time  FOREIGN KEY (time_key) REFERENCES dbo.dim_time(time_key),
  CONSTRAINT FK_fact_truck FOREIGN KEY (truck_id) REFERENCES dbo.dim_truck(truck_id),
  CONSTRAINT FK_fact_site  FOREIGN KEY (site_id) REFERENCES dbo.dim_site(site_id)
);
GO
