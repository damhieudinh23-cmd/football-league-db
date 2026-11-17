USE football_db;

-- ============================================================================
-- DỮ LIỆU LICH_SU_CHUYEN_NHUONG - V.LEAGUE 2025/2026
-- Khớp chính xác MaCT <-> MaCLB của 14 CLB trong CAU_THU & THONG_KE_THI_DAU
-- ============================================================================

INSERT INTO LICH_SU_CHUYEN_NHUONG (MaCN, MuaGiai, NgayChuyen, MaCLBCu, MaCLBMoi, MaCT) VALUES
    -- 1. Chuyển nhượng nội bộ V.League trước thềm Vòng 1 (01/07/2025 - 12/08/2025)
    ('CN_001', '2025/2026', '2025-07-02', 'CLB_SLNA', 'CLB_CAHN', 'CT_031'),
    ('CN_002', '2025/2026', '2025-07-04', 'CLB_HAGL', 'CLB_CAHN', 'CT_035'),
    ('CN_003', '2025/2026', '2025-07-05', 'CLB_HLHT', 'CLB_HN',   'CT_139'),
    ('CN_004', '2025/2026', '2025-07-07', 'CLB_HP',   'CLB_HN',   'CT_144'),
    ('CN_005', '2025/2026', '2025-07-08', 'CLB_DATH', 'CLB_TXND', 'CT_222'),
    ('CN_006', '2025/2026', '2025-07-10', 'CLB_BBD',  'CLB_TXND', 'CT_226'),
    ('CN_007', '2025/2026', '2025-07-11', 'CLB_QN',   'CLB_TCVT', 'CT_209'),
    ('CN_008', '2025/2026', '2025-07-12', 'CLB_SHB',  'CLB_TCVT', 'CT_214'),
    ('CN_009', '2025/2026', '2025-07-14', 'CLB_HCM',  'CLB_BBD',  'CT_004'),
    ('CN_010', '2025/2026', '2025-07-15', 'CLB_QNB',  'CLB_BBD',  'CT_010'),
    ('CN_011', '2025/2026', '2025-07-17', 'CLB_TCVT', 'CLB_DATH', 'CT_055'),
    ('CN_012', '2025/2026', '2025-07-18', 'CLB_HN',   'CLB_HP',   'CT_153'),
    ('CN_013', '2025/2026', '2025-07-20', 'CLB_TXND', 'CLB_HLHT', 'CT_120'),
    ('CN_014', '2025/2026', '2025-07-22', 'CLB_BBD',  'CLB_HCM',  'CT_100'),
    ('CN_015', '2025/2026', '2025-07-24', 'CLB_CAHN', 'CLB_SHB',  'CT_181'),
    ('CN_016', '2025/2026', '2025-07-25', 'CLB_DATH', 'CLB_QN',   'CT_167'),
    ('CN_017', '2025/2026', '2025-07-27', 'CLB_HAGL', 'CLB_QNB',  'CT_234'),
    ('CN_018', '2025/2026', '2025-07-29', 'CLB_SLNA', 'CLB_HAGL', 'CT_080'),
    ('CN_019', '2025/2026', '2025-07-30', 'CLB_HLHT', 'CLB_SLNA', 'CT_195'),

    -- 2. Ký mới cầu thủ tự do / ngoại binh / đôn từ đội trẻ (MaCLBCu IS NULL)
    ('CN_020', '2025/2026', '2025-08-01', NULL, 'CLB_BBD',  'CT_025'),
    ('CN_021', '2025/2026', '2025-08-02', NULL, 'CLB_CAHN', 'CT_049'),
    ('CN_022', '2025/2026', '2025-08-03', NULL, 'CLB_DATH', 'CT_074'),
    ('CN_023', '2025/2026', '2025-08-04', NULL, 'CLB_HAGL', 'CT_094'),
    ('CN_024', '2025/2026', '2025-08-05', NULL, 'CLB_HCM',  'CT_114'),
    ('CN_025', '2025/2026', '2025-08-06', NULL, 'CLB_HLHT', 'CT_134'),
    ('CN_026', '2025/2026', '2025-08-07', NULL, 'CLB_HN',   'CT_148'),
    ('CN_027', '2025/2026', '2025-08-08', NULL, 'CLB_HP',   'CT_162'),
    ('CN_028', '2025/2026', '2025-08-09', NULL, 'CLB_QN',   'CT_176'),
    ('CN_029', '2025/2026', '2025-08-10', NULL, 'CLB_SHB',  'CT_190'),
    ('CN_030', '2025/2026', '2025-08-11', NULL, 'CLB_SLNA', 'CT_204'),
    ('CN_031', '2025/2026', '2025-08-12', NULL, 'CLB_TCVT', 'CT_218'),
    ('CN_032', '2025/2026', '2025-08-13', NULL, 'CLB_TXND', 'CT_228'),
    ('CN_033', '2025/2026', '2025-08-14', NULL, 'CLB_QNB',  'CT_248'),

    -- 3. Chuyển nhượng 2 chiều giữa đúng 2 CLB trong cùng mùa (vẫn hợp lệ <= 2 CLB)
    ('CN_034', '2025/2026', '2025-07-03', 'CLB_HN',   'CLB_QN',   'CT_141'),
    ('CN_035', '2025/2026', '2025-08-10', 'CLB_QN',   'CLB_HN',   'CT_141'),
    ('CN_036', '2025/2026', '2025-07-06', 'CLB_TCVT', 'CLB_HLHT', 'CT_211'),
    ('CN_037', '2025/2026', '2025-08-12', 'CLB_HLHT', 'CLB_TCVT', 'CT_211');

-- Kiểm tra dữ liệu đã thêm
SELECT * FROM LICH_SU_CHUYEN_NHUONG ORDER BY MaCN;