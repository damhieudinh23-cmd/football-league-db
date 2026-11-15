-- ============================================================================
-- HE THONG QUAN LY GIAI DAU BONG DA CHUYEN NGHIEP
-- File: 02_create_triggers.sql
-- Muc dich: Cai dat cac rang buoc nghiep vu (Business Rules) bang Trigger
-- ============================================================================
SET NAMES utf8mb4;

USE football_db;

DELIMITER $$

-- ============================================================================
-- BUSINESS RULE 1: Dinh chi thi dau o tran ke tiep neu nhan 2 the vang 
--                  hoac 1 the do truc tiep o vong truoc
-- ============================================================================

DROP TRIGGER IF EXISTS trg_kiem_tra_treo_gio_insert$$
CREATE TRIGGER trg_kiem_tra_treo_gio_insert
BEFORE INSERT ON THONG_KE_THI_DAU
FOR EACH ROW
BEGIN
    DECLARE v_vong_hien_tai INT;
    DECLARE v_the_vang INT DEFAULT 0;
    DECLARE v_the_do_tt INT DEFAULT 0;

    -- Lay vong dau cua tran dang them du lieu
    SELECT VongDau INTO v_vong_hien_tai
    FROM TRAN_DAU
    WHERE MaTran = NEW.MaTran;

    -- Chi kiem tra neu khong phai vong 1
    IF v_vong_hien_tai > 1 THEN
        SELECT 
            COALESCE(SUM(CASE WHEN tp.LoaiThe = 'Vàng' THEN 1 ELSE 0 END), 0),
            COALESCE(SUM(CASE WHEN tp.LoaiThe = 'Đỏ trực tiếp' THEN 1 ELSE 0 END), 0)
        INTO v_the_vang, v_the_do_tt
        FROM THE_PHAT tp
        JOIN TRAN_DAU td ON tp.MaTran = td.MaTran
        WHERE tp.MaCT = NEW.MaCT
          AND td.VongDau = v_vong_hien_tai - 1;

        IF v_the_vang >= 2 OR v_the_do_tt >= 1 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Loi nghiep vu: Cau thu bi treo gio do nhan 2 the vang hoac 1 the do truc tiep o vong truoc!';
        END IF;
    END IF;
END$$

DROP TRIGGER IF EXISTS trg_kiem_tra_treo_gio_update$$
CREATE TRIGGER trg_kiem_tra_treo_gio_update
BEFORE UPDATE ON THONG_KE_THI_DAU
FOR EACH ROW
BEGIN
    DECLARE v_vong_hien_tai INT;
    DECLARE v_the_vang INT DEFAULT 0;
    DECLARE v_the_do_tt INT DEFAULT 0;

    IF NEW.MaCT <> OLD.MaCT OR NEW.MaTran <> OLD.MaTran THEN
        SELECT VongDau INTO v_vong_hien_tai
        FROM TRAN_DAU
        WHERE MaTran = NEW.MaTran;

        IF v_vong_hien_tai > 1 THEN
            SELECT 
                COALESCE(SUM(CASE WHEN tp.LoaiThe = 'Vàng' THEN 1 ELSE 0 END), 0),
                COALESCE(SUM(CASE WHEN tp.LoaiThe = 'Đỏ trực tiếp' THEN 1 ELSE 0 END), 0)
            INTO v_the_vang, v_the_do_tt
            FROM THE_PHAT tp
            JOIN TRAN_DAU td ON tp.MaTran = td.MaTran
            WHERE tp.MaCT = NEW.MaCT
              AND td.VongDau = v_vong_hien_tai - 1;

            IF v_the_vang >= 2 OR v_the_do_tt >= 1 THEN
                SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Loi nghiep vu: Cau thu bi treo gio do nhan 2 the vang hoac 1 the do truc tiep o vong truoc!';
            END IF;
        END IF;
    END IF;
END$$

-- ============================================================================
-- BUSINESS RULE 2: Mot cau thu khong the chuyen nhuong thi dau cho qua 2 CLB
--                  trong cung 1 mua giai
-- ============================================================================

DROP TRIGGER IF EXISTS trg_gioi_han_chuyen_nhuong_insert$$
CREATE TRIGGER trg_gioi_han_chuyen_nhuong_insert
BEFORE INSERT ON LICH_SU_CHUYEN_NHUONG
FOR EACH ROW
BEGIN
    DECLARE v_so_clb INT DEFAULT 0;

    -- Dem tong so CLB khac nhau (ca CLB cu va CLB moi) ma cau thu tham gia trong mua giai
    SELECT COUNT(*) INTO v_so_clb
    FROM (
        SELECT MaCLBCu AS MaCLB FROM LICH_SU_CHUYEN_NHUONG
        WHERE MaCT = NEW.MaCT AND MuaGiai = NEW.MuaGiai AND MaCLBCu IS NOT NULL
        UNION
        SELECT MaCLBMoi AS MaCLB FROM LICH_SU_CHUYEN_NHUONG
        WHERE MaCT = NEW.MaCT AND MuaGiai = NEW.MuaGiai AND MaCLBMoi IS NOT NULL
        UNION
        SELECT NEW.MaCLBCu AS MaCLB FROM DUAL WHERE NEW.MaCLBCu IS NOT NULL
        UNION
        SELECT NEW.MaCLBMoi AS MaCLB FROM DUAL WHERE NEW.MaCLBMoi IS NOT NULL
    ) AS ds_clb;

    IF v_so_clb > 2 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Loi nghiep vu: Cau thu khong duoc chuyen nhuong thi dau cho qua 2 CLB trong cung 1 mua giai!';
    END IF;
END$$

DROP TRIGGER IF EXISTS trg_gioi_han_chuyen_nhuong_update$$
CREATE TRIGGER trg_gioi_han_chuyen_nhuong_update
BEFORE UPDATE ON LICH_SU_CHUYEN_NHUONG
FOR EACH ROW
BEGIN
    DECLARE v_so_clb INT DEFAULT 0;

    SELECT COUNT(*) INTO v_so_clb
    FROM (
        SELECT MaCLBCu AS MaCLB FROM LICH_SU_CHUYEN_NHUONG
        WHERE MaCT = NEW.MaCT AND MuaGiai = NEW.MuaGiai AND MaCN <> OLD.MaCN AND MaCLBCu IS NOT NULL
        UNION
        SELECT MaCLBMoi AS MaCLB FROM LICH_SU_CHUYEN_NHUONG
        WHERE MaCT = NEW.MaCT AND MuaGiai = NEW.MuaGiai AND MaCN <> OLD.MaCN AND MaCLBMoi IS NOT NULL
        UNION
        SELECT NEW.MaCLBCu AS MaCLB FROM DUAL WHERE NEW.MaCLBCu IS NOT NULL
        UNION
        SELECT NEW.MaCLBMoi AS MaCLB FROM DUAL WHERE NEW.MaCLBMoi IS NOT NULL
    ) AS ds_clb;

    IF v_so_clb > 2 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Loi nghiep vu: Cau thu khong duoc chuyen nhuong thi dau cho qua 2 CLB trong cung 1 mua giai!';
    END IF;
END$$

DELIMITER ;

-- Kiem tra danh sach Trigger da tao thanh cong
SHOW TRIGGERS FROM football_db;