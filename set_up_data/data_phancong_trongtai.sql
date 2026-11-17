
USE football_db;

INSERT IGNORE INTO PHAN_CONG_TRONG_TAI (MaTT, MaTran, VaiTro)
SELECT 
    CONCAT('TT_', LPAD(((CAST(SUBSTRING(td.MaTran, 4) AS UNSIGNED) * 4 - vt.offset) % 30) + 1, 2, '0')) AS MaTT,
    td.MaTran,
    vt.VaiTro
FROM TRAN_DAU td
CROSS JOIN (
    SELECT 4 AS offset, 'Trọng tài chính' AS VaiTro
    UNION ALL SELECT 3, 'Trợ lý trọng tài 1'
    UNION ALL SELECT 2, 'Trợ lý trọng tài 2'
    UNION ALL SELECT 1, 'Trọng tài bàn'
) vt
ORDER BY td.MaTran, vt.offset DESC;

SELECT * FROM PHAN_CONG_TRONG_TAI; -- Kết quả trả về 728 dòng