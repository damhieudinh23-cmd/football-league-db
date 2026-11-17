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