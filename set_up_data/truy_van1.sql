SELECT *
FROM CAU_THU
WHERE ViTri = N'Tiền đạo'
AND QuocTich <> N'Việt Nam';


SELECT 
    CT1.TenCT AS CauThuGhiBan,
    BT.PhutGhiBan,
    CT2.TenCT AS CauThuKienTao,
    BT.LoaiBanThang
FROM BAN_THANG BT
INNER JOIN CAU_THU CT1
    ON BT.MaCT_GhiBan = CT1.MaCT
INNER JOIN CAU_THU CT2
    ON BT.MaCT_KienTao = CT2.MaCT
INNER JOIN TRAN_DAU TD
    ON BT.MaTran = TD.MaTran
INNER JOIN CLB CLB1
    ON TD.MaDoiNha = CLB1.MaCLB
INNER JOIN CLB CLB2
    ON TD.MaDoiKhach = CLB2.MaCLB
WHERE 
    (CLB1.MaCLB = 'CLB_HN' AND CLB2.MaCLB = 'CLB_CAHN')
    OR
    (CLB1.MaCLB = 'CLB_CAHN' AND CLB2.MaCLB = 'CLB_HN');
    
    
SELECT 
    CLB.MaCLB,
    CLB.TenCLB,
    COUNT(BT.MaBT) AS TongSoBanThang
FROM CLB
INNER JOIN CAU_THU CT
    ON CLB.MaCLB = CT.MaCLB
INNER JOIN BAN_THANG BT
    ON CT.MaCT = BT.MaCT_GhiBan
GROUP BY CLB.MaCLB, CLB.TenCLB;


SELECT 
    ct.MaCT, 
    ct.TenCT, 
    clb.TenCLB,
    COUNT(tp.MaThe) AS SoThePhat
FROM CAU_THU ct
-- LEFT JOIN đảm bảo lấy toàn bộ 295 cầu thủ
LEFT JOIN THE_PHAT tp ON ct.MaCT = tp.MaCT
-- (Tùy chọn) JOIN thêm bảng CLB để kết quả hiển thị rõ ràng hơn
LEFT JOIN CLB clb ON ct.MaCLB = clb.MaCLB
GROUP BY 
    ct.MaCT, 
    ct.TenCT, 
    clb.TenCLB
ORDER BY 
    SoThePhat DESC, 
    ct.MaCT ASC;