SELECT 
    ct.MaCT, 
    ct.TenCT, 
    bt.TongBanThang,
    SUM(tk.SoPhutThiDau) AS TongPhut
FROM CAU_THU ct
-- JOIN với bảng dữ liệu thống kê số phút thi đấu
JOIN THONG_KE_THI_DAU tk ON ct.MaCT = tk.MaCT
-- JOIN với một bảng tạm đã đếm sẵn số bàn thắng và lọc bằng HAVING
JOIN (
    SELECT MaCT_GhiBan, COUNT(MaBT) AS TongBanThang
    FROM BAN_THANG
    GROUP BY MaCT_GhiBan
    HAVING COUNT(MaBT) > 10 -- Điều kiện 1: Trên 10 bàn thắng
) bt ON ct.MaCT = bt.MaCT_GhiBan
GROUP BY 
    ct.MaCT, 
    ct.TenCT, 
    bt.TongBanThang
-- Điều kiện 2: Tổng số phút thi đấu dưới 1000
HAVING 
    TongPhut < 1000;