USE football_db;

INSERT IGNORE INTO SAN_VAN_DONG (MaSan, TenSan, SucChua, DiaChi)
VALUES
    ('SVD_HD', 'Sân vận động Hàng Đẫy', 22500, 'Hà Nội'),
    ('SVD_TT', 'Sân vận động Thiên Trường', 30000, 'Nam Định'),
    ('SVD_LT', 'Sân vận động Lạch Tray', 30000, 'Hải Phòng'),
    ('SVD_TN', 'Sân vận động Thống Nhất', 15000, 'TP. Hồ Chí Minh'),
    ('SVD_PLK', 'Sân vận động Pleiku', 12000, 'Gia Lai'),
    ('SVD_VIN', 'Sân vận động Vinh', 18000, 'Nghệ An'),
    ('SVD_GD', 'Sân vận động Gò Đậu', 18250, 'Bình Dương'),
    ('SVD_HX', 'Sân vận động Hòa Xuân', 20500, 'Đà Nẵng'),
    ('SVD_QN', 'Sân vận động Quy Nhơn', 20000, 'Bình Định'),
    ('SVD_TH', 'Sân vận động Thanh Hóa', 14000, 'Thanh Hóa'),
    ('SVD_MD', 'Sân vận động Mỹ Đình', 40192, 'Hà Nội'),
    ('SVD_HT', 'Sân vận động Hà Tĩnh', 15000, 'Hà Tĩnh');
    
    
SELECT * FROM SAN_VAN_DONG;