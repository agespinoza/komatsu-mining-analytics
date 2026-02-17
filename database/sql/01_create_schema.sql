-- 01_create_schema.sql
-- Create core tables (curated layer) if not exists.

-- If you prefer schemas:
-- IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'curated') EXEC('CREATE SCHEMA curated');
-- This sample uses dbo for simplicity.
GO
