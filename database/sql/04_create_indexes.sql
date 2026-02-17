-- 04_create_indexes.sql
-- Indexes to support analytics queries

CREATE INDEX IX_fact_time_key ON dbo.fact_telemetry(time_key);
CREATE INDEX IX_fact_truck_id ON dbo.fact_telemetry(truck_id);
CREATE INDEX IX_fact_site_id  ON dbo.fact_telemetry(site_id);

-- Common pattern: filter by time + truck/site
CREATE INDEX IX_fact_time_truck ON dbo.fact_telemetry(time_key, truck_id);
CREATE INDEX IX_fact_time_site  ON dbo.fact_telemetry(time_key, site_id);

-- Optional: for overheat queries
CREATE INDEX IX_fact_engine_temp ON dbo.fact_telemetry(engine_temp);
GO
