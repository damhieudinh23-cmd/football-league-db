-- Bước 1: Tạo một bảng tạm (CTE) để tính tổng số bàn thắng của từng cầu thủ
WITH ThongKeBanThang AS (
    SELECT 
        ct.MaCT, 
        ct.TenCT, 
        clb.TenCLB, 
        ct.MaCLB,
        COUNT(bt.MaBT) AS SoBanThang
    FROM CAU_THU ct
    JOIN BAN_THANG bt ON ct.MaCT = bt.MaCT_GhiBan
    JOIN CLB clb ON ct.MaCLB = clb.MaCLB
    GROUP BY ct.MaCT, ct.TenCT, clb.TenCLB, ct.MaCLB
)
-- Bước 2: Dùng Correlated Subquery để tìm cầu thủ có số bàn lớn nhất trong từng CLB
SELECT 
    tk1.TenCLB,
    tk1.MaCT, 
    tk1.TenCT, 
    tk1.SoBanThang
FROM ThongKeBanThang tk1
WHERE tk1.SoBanThang = (
    -- TRUY VẤN CON TƯƠNG QUAN (Correlated Subquery)
    SELECT MAX(tk2.SoBanThang)
    FROM ThongKeBanThang tk2
    WHERE tk2.MaCLB = tk1.MaCLB -- Sự tương quan nằm ở đây
)
ORDER BY tk1.TenCLB, tk1.SoBanThang DESC;