
-- ============================================================================
-- HE THONG QUAN LY GIAI DAU BONG DA CHUYEN NGHIEP
-- File: 01_create_tables.sql
-- ============================================================================

-- 1. KHOI TAO DATABASE
CREATE DATABASE IF NOT EXISTS football_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE football_db;

-- ============================================================================
-- NHOM 1: CAC BANG DOC LAP
-- ============================================================================

-- 1. BANG SAN VAN DONG
CREATE TABLE IF NOT EXISTS SAN_VAN_DONG (
    MaSan   VARCHAR(10)  PRIMARY KEY,
    TenSan  VARCHAR(100) NOT NULL UNIQUE,
    SucChua INT          NOT NULL CHECK (SucChua > 0),
    DiaChi  VARCHAR(255) NOT NULL
) ENGINE=InnoDB;

-- 2. BANG TRONG TAI
CREATE TABLE IF NOT EXISTS TRONG_TAI (
    MaTT     VARCHAR(10)  PRIMARY KEY,
    TenTT    VARCHAR(100) NOT NULL,
    QuocTich VARCHAR(50)  NOT NULL
) ENGINE=InnoDB;

-- 3. BANG MUA GIAI
CREATE TABLE IF NOT EXISTS MUA_GIAI (
    MaMuaGiai   VARCHAR(10) PRIMARY KEY,
    TenMuaGiai  VARCHAR(20) NOT NULL UNIQUE,
    NgayBatDau  DATE NOT NULL,
    NgayKetThuc DATE NOT NULL,

    CONSTRAINT chk_ngay_mua_giai
        CHECK (NgayKetThuc > NgayBatDau)
) ENGINE=InnoDB;

-- ============================================================================
-- NHOM 2: CAC BANG CAP 1
-- ============================================================================

-- 4. BANG CAU LAC BO
CREATE TABLE IF NOT EXISTS CLB (
    MaCLB  VARCHAR(10)  PRIMARY KEY,
    TenCLB VARCHAR(100) NOT NULL UNIQUE,
    MaSan  VARCHAR(10)  NOT NULL,

    CONSTRAINT fk_clb_san
        FOREIGN KEY (MaSan) REFERENCES SAN_VAN_DONG(MaSan)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ============================================================================
-- NHOM 3: CAC BANG CAP 2
-- ============================================================================

-- 5. BANG HUAN LUYEN VIEN
CREATE TABLE IF NOT EXISTS HLV (
    MaHLV    VARCHAR(10)  PRIMARY KEY,
    TenHLV   VARCHAR(100) NOT NULL,
    QuocTich VARCHAR(50)  NOT NULL,
    VaiTro   VARCHAR(50)  NOT NULL,
    MaCLB    VARCHAR(10)  NOT NULL,

    CONSTRAINT fk_hlv_clb
        FOREIGN KEY (MaCLB) REFERENCES CLB(MaCLB)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- 6. BANG CAU THU
CREATE TABLE IF NOT EXISTS CAU_THU (
    MaCT     VARCHAR(10)  PRIMARY KEY,
    TenCT    VARCHAR(100) NOT NULL,
    SoAo     INT          NOT NULL,
    ViTri    VARCHAR(50)  NOT NULL,
    QuocTich VARCHAR(50)  NOT NULL,
    MaCLB    VARCHAR(10)  NOT NULL,

    CONSTRAINT chk_so_ao
        CHECK (SoAo BETWEEN 1 AND 99),

    CONSTRAINT uq_clb_soao
        UNIQUE (MaCLB, SoAo),

    CONSTRAINT fk_ct_clb
        FOREIGN KEY (MaCLB) REFERENCES CLB(MaCLB)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- 7. BANG TRAN DAU
CREATE TABLE IF NOT EXISTS TRAN_DAU (
    MaTran     VARCHAR(10) PRIMARY KEY,
    VongDau    INT         NOT NULL,
    NgayThiDau DATETIME    NOT NULL,
    MaDoiNha   VARCHAR(10) NOT NULL,
    MaDoiKhach VARCHAR(10) NOT NULL,
    MaSan      VARCHAR(10) NOT NULL,
    MaMuaGiai  VARCHAR(10) NOT NULL,

    CONSTRAINT chk_vong_dau
        CHECK (VongDau > 0),

    CONSTRAINT chk_doi_khac
        CHECK (MaDoiNha <> MaDoiKhach),

    CONSTRAINT fk_td_doinha
        FOREIGN KEY (MaDoiNha) REFERENCES CLB(MaCLB)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_td_doikhach
        FOREIGN KEY (MaDoiKhach) REFERENCES CLB(MaCLB)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_td_san
        FOREIGN KEY (MaSan) REFERENCES SAN_VAN_DONG(MaSan)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_td_muagiai
        FOREIGN KEY (MaMuaGiai) REFERENCES MUA_GIAI(MaMuaGiai)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ============================================================================
-- NHOM 4: CAC BANG QUAN HE N-N VA BANG SU KIEN TRAN DAU
-- ============================================================================

-- 8. BANG PHAN CONG TRONG TAI
CREATE TABLE IF NOT EXISTS PHAN_CONG_TRONG_TAI (
    MaTT   VARCHAR(10) NOT NULL,
    MaTran VARCHAR(10) NOT NULL,
    VaiTro VARCHAR(50) NOT NULL,

    PRIMARY KEY (MaTT, MaTran),

    CONSTRAINT fk_pctt_tt
        FOREIGN KEY (MaTT) REFERENCES TRONG_TAI(MaTT)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_pctt_tran
        FOREIGN KEY (MaTran) REFERENCES TRAN_DAU(MaTran)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- 9. BANG THONG KE THI DAU
CREATE TABLE IF NOT EXISTS THONG_KE_THI_DAU (
    MaCT         VARCHAR(10) NOT NULL,
    MaTran       VARCHAR(10) NOT NULL,
    SoPhutThiDau INT         NOT NULL DEFAULT 0,

    PRIMARY KEY (MaCT, MaTran),

    CONSTRAINT chk_so_phut
        CHECK (SoPhutThiDau BETWEEN 0 AND 130),

    CONSTRAINT fk_tktd_ct
        FOREIGN KEY (MaCT) REFERENCES CAU_THU(MaCT)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_tktd_tran
        FOREIGN KEY (MaTran) REFERENCES TRAN_DAU(MaTran)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- 10. BANG THE PHAT
CREATE TABLE IF NOT EXISTS THE_PHAT (
    MaThe    VARCHAR(10) PRIMARY KEY,
    LoaiThe  VARCHAR(20) NOT NULL,
    PhutPhat INT         NOT NULL,
    MaTran   VARCHAR(10) NOT NULL,
    MaCT     VARCHAR(10) NOT NULL,

    CONSTRAINT chk_phut_phat
        CHECK (PhutPhat BETWEEN 1 AND 120),

    CONSTRAINT chk_loai_the
        CHECK (LoaiThe IN ('VANG', 'DO')),

    CONSTRAINT fk_tp_tran
        FOREIGN KEY (MaTran) REFERENCES TRAN_DAU(MaTran)
        ON UPDATE CASCADE ON DELETE CASCADE,

    CONSTRAINT fk_tp_ct
        FOREIGN KEY (MaCT) REFERENCES CAU_THU(MaCT)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- 11. BANG THAY NGUOI
CREATE TABLE IF NOT EXISTS THAY_NGUOI (
    MaTN     VARCHAR(10) PRIMARY KEY,
    PhutThay INT         NOT NULL,
    MaCT_Vao VARCHAR(10) NOT NULL,
    MaCT_Ra  VARCHAR(10) NOT NULL,
    MaTran   VARCHAR(10) NOT NULL,

    CONSTRAINT chk_phut_thay
        CHECK (PhutThay BETWEEN 1 AND 120),

    CONSTRAINT chk_cau_thu_thay
        CHECK (MaCT_Vao <> MaCT_Ra),

    CONSTRAINT fk_tn_ctvao
        FOREIGN KEY (MaCT_Vao) REFERENCES CAU_THU(MaCT)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_tn_ctra
        FOREIGN KEY (MaCT_Ra) REFERENCES CAU_THU(MaCT)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_tn_tran
        FOREIGN KEY (MaTran) REFERENCES TRAN_DAU(MaTran)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- 12. BANG BAN THANG
CREATE TABLE IF NOT EXISTS BAN_THANG (
    MaBT         VARCHAR(10) PRIMARY KEY,
    PhutGhiBan   INT         NOT NULL,
    LoaiBanThang VARCHAR(50) NOT NULL,
    MaCT_GhiBan  VARCHAR(10) NOT NULL,
    MaCT_KienTao VARCHAR(10) NULL,
    MaTran       VARCHAR(10) NOT NULL,

    CONSTRAINT chk_phut_ghi_ban
        CHECK (PhutGhiBan BETWEEN 1 AND 120),

    CONSTRAINT fk_bt_ghiban
        FOREIGN KEY (MaCT_GhiBan) REFERENCES CAU_THU(MaCT)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_bt_kientao
        FOREIGN KEY (MaCT_KienTao) REFERENCES CAU_THU(MaCT)
        ON UPDATE CASCADE ON DELETE SET NULL,

    CONSTRAINT fk_bt_tran
        FOREIGN KEY (MaTran) REFERENCES TRAN_DAU(MaTran)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- 13. BANG CHAN THUONG
CREATE TABLE IF NOT EXISTS CHAN_THUONG (
    MaCTh          VARCHAR(10)  PRIMARY KEY,
    NgayBaoCao     DATE         NOT NULL,
    LoaiChanThuong VARCHAR(100) NOT NULL,
    TGNghiDuKien   VARCHAR(50)  NOT NULL,
    MaTran         VARCHAR(10)  NULL,
    MaCT           VARCHAR(10)  NOT NULL,

    CONSTRAINT fk_cth_tran
        FOREIGN KEY (MaTran) REFERENCES TRAN_DAU(MaTran)
        ON UPDATE CASCADE ON DELETE SET NULL,

    CONSTRAINT fk_cth_ct
        FOREIGN KEY (MaCT) REFERENCES CAU_THU(MaCT)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- 14. BANG LICH SU CHUYEN NHUONG
CREATE TABLE IF NOT EXISTS LICH_SU_CHUYEN_NHUONG (
    MaCN       VARCHAR(10) PRIMARY KEY,
    NgayChuyen DATE        NOT NULL,
    MaCLBCu    VARCHAR(10) NULL,
    MaCLBMoi   VARCHAR(10) NOT NULL,
    MaCT       VARCHAR(10) NOT NULL,
    MaMuaGiai  VARCHAR(10) NOT NULL,

    CONSTRAINT chk_clb_chuyen_nhuong
        CHECK (MaCLBCu IS NULL OR MaCLBCu <> MaCLBMoi),

    CONSTRAINT fk_cn_clbcu
        FOREIGN KEY (MaCLBCu) REFERENCES CLB(MaCLB)
        ON UPDATE CASCADE ON DELETE SET NULL,

    CONSTRAINT fk_cn_clbmoi
        FOREIGN KEY (MaCLBMoi) REFERENCES CLB(MaCLB)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_cn_ct
        FOREIGN KEY (MaCT) REFERENCES CAU_THU(MaCT)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_cn_muagiai
        FOREIGN KEY (MaMuaGiai) REFERENCES MUA_GIAI(MaMuaGiai)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ============================================================================
-- KET THUC TAO CAC BANG
-- ============================================================================

-- Kiem tra danh sach cac bang
SHOW TABLES;
