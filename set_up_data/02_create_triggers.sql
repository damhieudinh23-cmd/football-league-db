-- ============================================================================
-- HE THONG QUAN LY GIAI DAU BONG DA CHUYEN NGHIEP
-- File: 02_create_triggers.sql
-- Muc dich: Cai dat cac rang buoc nghiep vu (Business Rules) bang Trigger
-- ============================================================================
SET NAMES utf8mb4;

USE football_db;

DELIMITER $$

-- ============================================================================
-- TRIGGER BO TRO: Kiem tra tinh hop le cua the phat trong cung 1 tran dau
-- (Khong cho phep 1 cau thu nhan qua 2 the vang hoac nhan them the sau khi bi do truc tiep)
-- ============================================================================

DROP TRIGGER IF EXISTS trg_kiem_tra_the_phat_insert$$
CREATE TRIGGER trg_kiem_tra_the_phat_insert
BEFORE INSERT ON THE_PHAT
FOR EACH ROW
BEGIN
    DECLARE v_the_vang INT DEFAULT 0;
    DECLARE v_the_do_tt INT DEFAULT 0;
    DECLARE v_loai_the VARCHAR(50);
    DECLARE v_msg VARCHAR(128);

    SET v_loai_the = LOWER(TRIM(NEW.LoaiThe));

    -- Kiem tra gia tri LoaiThe hop le
    IF v_loai_the NOT IN ('vàng', 'thẻ vàng', 'đỏ trực tiếp', 'thẻ đỏ trực tiếp') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Loi du lieu: LoaiThe chi chap nhan "Vàng" hoac "Đỏ trực tiếp"!';
    END IF;

    -- Dem so the hien tai cua cau thu trong chinh tran dau do
    SELECT 
        COALESCE(SUM(CASE WHEN LOWER(TRIM(LoaiThe)) IN ('vàng', 'thẻ vàng') THEN 1 ELSE 0 END), 0),
        COALESCE(SUM(CASE WHEN LOWER(TRIM(LoaiThe)) IN ('đỏ trực tiếp', 'thẻ đỏ trực tiếp') THEN 1 ELSE 0 END), 0)
    INTO v_the_vang, v_the_do_tt
    FROM THE_PHAT
    WHERE MaTran = NEW.MaTran AND MaCT = NEW.MaCT;

    IF v_the_do_tt >= 1 OR v_the_vang >= 2 THEN
        SET v_msg = LEFT(CONCAT('Loi nghiep vu: Cau thu ', NEW.MaCT, ' da bi truat quyen thi dau trong tran ', NEW.MaTran, '!'), 128);
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = v_msg;
    END IF;
END$$

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
    DECLARE v_msg VARCHAR(128);

    SELECT VongDau INTO v_vong_hien_tai
    FROM TRAN_DAU
    WHERE MaTran = NEW.MaTran;

    IF v_vong_hien_tai > 1 THEN
        SELECT 
            COALESCE(SUM(CASE WHEN LOWER(TRIM(tp.LoaiThe)) IN ('vàng', 'thẻ vàng') THEN 1 ELSE 0 END), 0),
            COALESCE(SUM(CASE WHEN LOWER(TRIM(tp.LoaiThe)) IN ('đỏ trực tiếp', 'thẻ đỏ trực tiếp') THEN 1 ELSE 0 END), 0)
        INTO v_the_vang, v_the_do_tt
        FROM THE_PHAT tp
        JOIN TRAN_DAU td ON tp.MaTran = td.MaTran
        WHERE tp.MaCT = NEW.MaCT
          AND td.VongDau = v_vong_hien_tai - 1;

        IF v_the_vang >= 2 OR v_the_do_tt >= 1 THEN
            SET v_msg = LEFT(CONCAT('Loi nghiep vu: Cau thu ', NEW.MaCT, ' bi treo gio o vong ', v_vong_hien_tai, ' do nhan the phat vong truoc!'), 128);
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = v_msg;
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
    DECLARE v_msg VARCHAR(128);

    IF NEW.MaCT <> OLD.MaCT OR NEW.MaTran <> OLD.MaTran THEN
        SELECT VongDau INTO v_vong_hien_tai
        FROM TRAN_DAU
        WHERE MaTran = NEW.MaTran;

        IF v_vong_hien_tai > 1 THEN
            SELECT 
                COALESCE(SUM(CASE WHEN LOWER(TRIM(tp.LoaiThe)) IN ('vàng', 'thẻ vàng') THEN 1 ELSE 0 END), 0),
                COALESCE(SUM(CASE WHEN LOWER(TRIM(tp.LoaiThe)) IN ('đỏ trực tiếp', 'thẻ đỏ trực tiếp') THEN 1 ELSE 0 END), 0)
            INTO v_the_vang, v_the_do_tt
            FROM THE_PHAT tp
            JOIN TRAN_DAU td ON tp.MaTran = td.MaTran
            WHERE tp.MaCT = NEW.MaCT
              AND td.VongDau = v_vong_hien_tai - 1;

            IF v_the_vang >= 2 OR v_the_do_tt >= 1 THEN
                SET v_msg = LEFT(CONCAT('Loi nghiep vu: Cau thu ', NEW.MaCT, ' bi treo gio o vong ', v_vong_hien_tai, ' do nhan the phat vong truoc!'), 128);
                SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = v_msg;
            END IF;
        END IF;
    END IF;
END$$

-- ============================================================================
-- BUSINESS RULE 2: Mot cau thu khong the chuyen nhuong thi dau cho qua 2 CLB
--                  trong cung 1 mua giai + Tu dong dong bo CLB moi
-- ============================================================================

DROP TRIGGER IF EXISTS trg_gioi_han_chuyen_nhuong_insert$$
CREATE TRIGGER trg_gioi_han_chuyen_nhuong_insert
BEFORE INSERT ON LICH_SU_CHUYEN_NHUONG
FOR EACH ROW
BEGIN
    DECLARE v_so_clb INT DEFAULT 0;
    DECLARE v_msg VARCHAR(128);

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
        SET v_msg = LEFT(CONCAT('Loi nghiep vu: Cau thu ', NEW.MaCT, ' da tham gia qua 2 CLB trong mua giai ', NEW.MuaGiai, '!'), 128);
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = v_msg;
    END IF;
END$$

DROP TRIGGER IF EXISTS trg_gioi_han_chuyen_nhuong_update$$
CREATE TRIGGER trg_gioi_han_chuyen_nhuong_update
BEFORE UPDATE ON LICH_SU_CHUYEN_NHUONG
FOR EACH ROW
BEGIN
    DECLARE v_so_clb INT DEFAULT 0;
    DECLARE v_msg VARCHAR(128);

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
        SET v_msg = LEFT(CONCAT('Loi nghiep vu: Cau thu ', NEW.MaCT, ' da tham gia qua 2 CLB trong mua giai ', NEW.MuaGiai, '!'), 128);
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = v_msg;
    END IF;
END$$

-- Tu dong cap nhat MaCLB moi nhat cho cau thu trong bang CAU_THU
DROP TRIGGER IF EXISTS trg_cap_nhat_clb_sau_chuyen_nhuong$$
CREATE TRIGGER trg_cap_nhat_clb_sau_chuyen_nhuong
AFTER INSERT ON LICH_SU_CHUYEN_NHUONG
FOR EACH ROW
BEGIN
    DECLARE v_ngay_moi_nhat DATE;

    SELECT MAX(NgayChuyen) INTO v_ngay_moi_nhat
    FROM LICH_SU_CHUYEN_NHUONG
    WHERE MaCT = NEW.MaCT;

    IF NEW.NgayChuyen >= v_ngay_moi_nhat THEN
        UPDATE CAU_THU
        SET MaCLB = NEW.MaCLBMoi
        WHERE MaCT = NEW.MaCT;
    END IF;
END$$

DELIMITER ;

-- Kiem tra danh sach 6 Trigger da tao thanh cong
SHOW TRIGGERS FROM football_db;