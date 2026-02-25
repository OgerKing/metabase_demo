-- Create database "apiary" so the copied Metabase connection from Apiary finds it.
-- Init scripts run as the postgres superuser; POSTGRES_USER (apiary) already has access.
CREATE DATABASE apiary;
