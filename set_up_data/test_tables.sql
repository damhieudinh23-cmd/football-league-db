SELECT table_name AS Ten_Bang
FROM information_schema.tables
WHERE table_schema = 'football_db'
ORDER BY table_name;