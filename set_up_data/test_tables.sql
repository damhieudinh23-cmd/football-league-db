SELECT table_name AS Ten_Bang
FROM information_schema.tables
WHERE table_schema = 'football_db'
ORDER BY table_name;

USE football_db;

DROP TABLE IF EXISTS MUA_GIAI;

SHOW TABLES;

SHOW TRIGGERS FROM football_db;




-- ============================================================================
-- RESET DATABASE FOOTBALL_DB
-- XOA DATABASE CU VA TAO LAI DATABASE MOI
-- ============================================================================

-- 1. Xoa database cu (bao gom tat ca cac bang va du lieu)
DROP DATABASE IF EXISTS football_db;

-- 2. Tao lai database
CREATE DATABASE football_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

-- 3. Chon database
USE football_db;

-- 4. Kiem tra database
SELECT DATABASE();

-- 5. Kiem tra cac bang (luc nay chua co bang)
SHOW TABLES;


USE football_db;
SHOW TABLES;