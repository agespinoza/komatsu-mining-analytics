-- 02_create_dimensions.sql
-- Dimensions: truck, site, time

IF OBJECT_ID('dbo.dim_truck', 'U') IS NOT NULL DROP TABLE dbo.dim_truck;
IF OBJECT_ID('dbo.dim_site',  'U') IS NOT NULL DROP TABLE dbo.dim_site;
IF OBJECT_ID('dbo.dim_time',  'U') IS NOT NULL DROP TABLE dbo.dim_time;
GO

CREATE TABLE dbo.dim_truck (
  truck_id    int          NOT NULL PRIMARY KEY,
  truck_name  varchar(64)  NOT NULL,
  model       varchar(64)  NULL
);

CREATE TABLE dbo.dim_site (
  site_id     int          NOT NULL PRIMARY KEY,
  site_name   varchar(64)  NOT NULL,
  region      varchar(64)  NULL
);

-- Hourly grain
-- time_key format: yyyymmddhh (e.g., 2026021509)
CREATE TABLE dbo.dim_time (
  time_key    int         NOT NULL PRIMARY KEY,
  full_date   date        NOT NULL,
  [year]      int         NOT NULL,
  [month]     int         NOT NULL,
  [day]       int         NOT NULL,
  hour_of_day int         NOT NULL
);
GO
