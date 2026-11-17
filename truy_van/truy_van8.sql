WITH KetQuaTranDau AS (
    -- Bước 1: Dùng Subquery đếm số bàn thắng của Đội Nhà và Đội Khách trong từng trận
    SELECT 
        td.MaTran,
        td.MaDoiNha,
        td.MaDoiKhach,
        (SELECT COUNT(*) FROM BAN_THANG bt JOIN CAU_THU ct ON bt.MaCT_GhiBan = ct.MaCT 
         WHERE bt.MaTran = td.MaTran AND ct.MaCLB = td.MaDoiNha) AS BanNha,
        (SELECT COUNT(*) FROM BAN_THANG bt JOIN CAU_THU ct ON bt.MaCT_GhiBan = ct.MaCT 
         WHERE bt.MaTran = td.MaTran AND ct.MaCLB = td.MaDoiKhach) AS BanKhach
    FROM TRAN_DAU td
),
BangDiem AS (
    -- Bước 2: Dựa vào số bàn thắng để tính điểm (Thắng 3, Hòa 1, Thua 0)
    SELECT 
        MaTran,
        MaDoiNha,
        MaDoiKhach,
        CASE WHEN BanNha > BanKhach THEN 3 WHEN BanNha = BanKhach THEN 1 ELSE 0 END AS DiemNha,
        CASE WHEN BanKhach > BanNha THEN 3 WHEN BanKhach = BanNha THEN 1 ELSE 0 END AS DiemKhach
    FROM KetQuaTranDau
)
-- Bước 3: Dùng Subquery tương quan ở mệnh đề SELECT và WHERE để đối chiếu điểm số
SELECT 
    c.MaCLB,
    c.TenCLB,
    IFNULL((SELECT SUM(DiemNha) FROM BangDiem WHERE MaDoiNha = c.MaCLB), 0) AS TongDiemSanNha,
    IFNULL((SELECT SUM(DiemKhach) FROM BangDiem WHERE MaDoiKhach = c.MaCLB), 0) AS TongDiemSanKhach
FROM CLB c
WHERE 
    -- Điều kiện chốt: Tổng điểm sân khách phải LỚN HƠN tổng điểm sân nhà
    IFNULL((SELECT SUM(DiemKhach) FROM BangDiem WHERE MaDoiKhach = c.MaCLB), 0) > 
    IFNULL((SELECT SUM(DiemNha) FROM BangDiem WHERE MaDoiNha = c.MaCLB), 0)
ORDER BY 
    TongDiemSanKhach DESC;