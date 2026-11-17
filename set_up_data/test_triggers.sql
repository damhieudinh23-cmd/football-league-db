-- Lệnh này sẽ bị Trigger chặn với thông báo: "Loi nghiep vu: Cau thu CT_031 da tham gia qua 2 CLB trong mua giai 2025/2026!"
INSERT INTO LICH_SU_CHUYEN_NHUONG (MaCN, MuaGiai, NgayChuyen, MaCLBCu, MaCLBMoi, MaCT)
VALUES ('CN_999', '2025/2026', '2026-01-20', 'CLB_CAHN', 'CLB_HN', 'CT_031');



USE football_db;

SELECT 
    cn.MaCN,
    cn.NgayChuyen,
    cn.MaCT,
    ct.TenCT,
    cn.MaCLBCu   AS CLB_Truoc_Chuyen_Nhuong,
    cn.MaCLBMoi  AS CLB_Dich_Trong_Lich_Su,
    ct.MaCLB     AS CLB_Hien_Tai_Trong_CAU_THU,
    ct.SoAo      AS So_Ao_Hien_Tai,
    CASE 
        WHEN cn.MaCLBMoi = ct.MaCLB THEN 'DA DONG BO THANH CONG'
        ELSE 'CHUA KHOP'
    END AS TrangThai
FROM LICH_SU_CHUYEN_NHUONG cn
JOIN CAU_THU ct ON cn.MaCT = ct.MaCT
ORDER BY cn.MaCN;