USE football_db;

INSERT IGNORE INTO HLV (MaHLV, TenHLV, QuocTich, VaiTro, MaCLB)
VALUES
    ('HLV_01', 'Lê Đức Tuấn', 'Việt Nam', 'HLV Trưởng', 'CLB_HN'),
    ('HLV_02', 'Alexandre Polking', 'Đức', 'HLV Trưởng', 'CLB_CAHN'),
    ('HLV_03', 'Nguyễn Đức Thắng', 'Việt Nam', 'HLV Trưởng', 'CLB_TCVT'),
    ('HLV_04', 'Vũ Hồng Việt', 'Việt Nam', 'HLV Trưởng', 'CLB_TXND'),
    ('HLV_05', 'Chu Đình Nghiêm', 'Việt Nam', 'HLV Trưởng', 'CLB_HP'),
    ('HLV_06', 'Velizar Popov', 'Bulgaria', 'HLV Trưởng', 'CLB_DATH'),
    ('HLV_07', 'Phạm Anh Tuấn', 'Việt Nam', 'HLV Trưởng', 'CLB_SLNA'),
    ('HLV_08', 'Hoàng Anh Tuấn', 'Việt Nam', 'HLV Trưởng', 'CLB_BBD'),
    ('HLV_09', 'Phùng Thanh Phương', 'Việt Nam', 'HLV Trưởng', 'CLB_HCM'),
    ('HLV_10', 'Lê Quang Trãi', 'Việt Nam', 'HLV Trưởng', 'CLB_HAGL'),
    ('HLV_11', 'Bùi Đoàn Quang Huy', 'Việt Nam', 'HLV Trưởng', 'CLB_QNB'),
    ('HLV_12', 'Đào Quang Hùng', 'Việt Nam', 'HLV Trưởng', 'CLB_SHB'),
    ('HLV_13', 'Văn Sỹ Sơn', 'Việt Nam', 'HLV Trưởng', 'CLB_QN'),
    ('HLV_14', 'Nguyễn Thành Công', 'Việt Nam', 'HLV Trưởng', 'CLB_HLHT'),
    ('HLV_15', 'Trần Tiến Dũng', 'Việt Nam', 'Trợ lý HLV', 'CLB_HN'),
    ('HLV_16', 'Luis Viegas', 'Bồ Đào Nha', 'Trợ lý HLV', 'CLB_CAHN'),
    ('HLV_17', 'Nguyễn Hải Biên', 'Việt Nam', 'Trợ lý HLV', 'CLB_TCVT'),
    ('HLV_18', 'Nguyễn Văn Đàn', 'Việt Nam', 'Trợ lý HLV', 'CLB_TXND'),
    ('HLV_19', 'Lê Quốc Vượng', 'Việt Nam', 'Trợ lý HLV', 'CLB_HP'),
    ('HLV_20', 'Mai Xuân Hợp', 'Việt Nam', 'Trợ lý HLV', 'CLB_DATH'),
    ('HLV_21', 'Nguyễn Huy Hoàng', 'Việt Nam', 'Trợ lý HLV', 'CLB_SLNA'),
    ('HLV_22', 'Nguyễn Thanh Sơn', 'Việt Nam', 'Trợ lý HLV', 'CLB_BBD'),
    ('HLV_23', 'Lư Đình Tuấn', 'Việt Nam', 'Trợ lý HLV', 'CLB_HCM'),
    ('HLV_24', 'Bùi Xuân Hiếu', 'Việt Nam', 'Trợ lý HLV', 'CLB_HAGL'),
    ('HLV_25', 'Nguyễn Tuấn Phong', 'Việt Nam', 'Trợ lý HLV', 'CLB_QNB'),
    ('HLV_26', 'Trần Trọng Bình', 'Việt Nam', 'Trợ lý HLV', 'CLB_SHB'),
    ('HLV_27', 'Phạm Bùi Minh', 'Việt Nam', 'Trợ lý HLV', 'CLB_QN'),
    ('HLV_28', 'Nguyễn Đức Khởi', 'Việt Nam', 'Trợ lý HLV', 'CLB_HLHT');
    
select * from hlv;