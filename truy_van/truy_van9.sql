WITH KetQuaTranDau AS (
    -- Bước 1: Tính số bàn thắng của đội nhà và đội khách trong từng trận (Đến vòng 26)
    SELECT 
        td.MaTran,
        td.MaDoiNha,
        td.MaDoiKhach,
        (SELECT COUNT(*) FROM BAN_THANG bt JOIN CAU_THU ct ON bt.MaCT_GhiBan = ct.MaCT 
         WHERE bt.MaTran = td.MaTran AND ct.MaCLB = td.MaDoiNha) AS BanNha,
        (SELECT COUNT(*) FROM BAN_THANG bt JOIN CAU_THU ct ON bt.MaCT_GhiBan = ct.MaCT 
         WHERE bt.MaTran = td.MaTran AND ct.MaCLB = td.MaDoiKhach) AS BanKhach
    FROM TRAN_DAU td
    WHERE td.VongDau <= 26
),
ThanhTichTungDoi AS (
    -- Bước 2: Tách thành tích của đội nhà (Quy đổi Thắng 3đ, Hòa 1đ, Thua 0đ)
    SELECT 
        MaDoiNha AS MaCLB,
        BanNha AS BanThang,
        BanKhach AS BanThua,
        CASE WHEN BanNha > BanKhach THEN 3 WHEN BanNha = BanKhach THEN 1 ELSE 0 END AS Diem
    FROM KetQuaTranDau
    UNION ALL
    -- Ghép nối với thành tích của đội khách
    SELECT 
        MaDoiKhach AS MaCLB,
        BanKhach AS BanThang,
        BanNha AS BanThua,
        CASE WHEN BanKhach > BanNha THEN 3 WHEN BanKhach = BanNha THEN 1 ELSE 0 END AS Diem
    FROM KetQuaTranDau
),
TongHopXepHang AS (
    -- Bước 3: Tổng hợp (SUM, COUNT) tổng điểm, hiệu số của từng CLB
    SELECT 
        c.MaCLB,
        c.TenCLB,
        COUNT(t.MaCLB) AS SoTran,
        IFNULL(SUM(t.Diem), 0) AS Diem,
        IFNULL(SUM(t.BanThang), 0) AS SoBanThang,
        IFNULL(SUM(t.BanThua), 0) AS SoBanThua,
        IFNULL(SUM(t.BanThang) - SUM(t.BanThua), 0) AS HieuSo
    FROM CLB c
    LEFT JOIN ThanhTichTungDoi t ON c.MaCLB = t.MaCLB
    GROUP BY c.MaCLB, c.TenCLB
)
-- Bước 4: Dùng Window Function (ROW_NUMBER) để tạo thứ hạng tự động
SELECT 
    ROW_NUMBER() OVER(ORDER BY Diem DESC, HieuSo DESC, SoBanThang DESC) AS XepHang,
    TenCLB,
    SoTran,
    Diem,
    HieuSo,
    SoBanThang,
    SoBanThua
FROM TongHopXepHang
ORDER BY XepHang;