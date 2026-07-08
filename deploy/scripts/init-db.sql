SELECT 'CREATE DATABASE accesosport_prod'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'accesosport_prod')\gexec

SELECT 'CREATE DATABASE accesosport_staging'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'accesosport_staging')\gexec
