SELECT table_name AS Ten_Bang
FROM information_schema.tables
WHERE table_schema = 'football_db'
ORDER BY table_name;

USE football_db;

DROP TABLE IF EXISTS MUA_GIAI;

SHOW TABLES;

SHOW TRIGGERS FROM football_db;