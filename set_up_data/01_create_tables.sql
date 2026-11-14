-- ============================================================================
-- HỆ THỐNG QUẢN LÝ GIẢI ĐẤU BÓNG ĐÁ CHUYÊN NGHIỆP
-- File: 01_create_tables.sql
-- ============================================================================

-- 1. Khởi tạo Database (an toàn khi chạy lại nhiều lần, hỗ trợ tiếng Việt có dấu)
CREATE DATABASE IF NOT EXISTS football_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE football_db;

-- ============================================================================
-- NHÓM 1: CÁC BẢNG ĐỘC LẬP (KHÔNG CHỨA KHÓA NGOẠI)
-- ============================================================================

CREATE TABLE IF NOT EXISTS SAN_VAN_DONG (
    MaSan   VARCHAR(10)  PRIMARY KEY,
    TenSan  VARCHAR(100) NOT NULL,
    SucChua INT          NOT NULL CHECK (SucChua > 0),
    DiaChi  VARCHAR(255) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS TRONG_TAI (
    MaTT     VARCHAR(10)  PRIMARY KEY,
    TenTT    VARCHAR(100) NOT NULL,
    QuocTich VARCHAR(50)  NOT NULL
) ENGINE=InnoDB;

-- ============================================================================
-- NHÓM 2: CÁC BẢNG CẤP 1 (PHỤ THUỘC VÀO NHÓM 1)
-- ============================================================================

CREATE TABLE IF NOT EXISTS CLB (
    MaCLB  VARCHAR(10)  PRIMARY KEY,
    TenCLB VARCHAR(100) NOT NULL UNIQUE,
    MaSan  VARCHAR(10)  NOT NULL,
    CONSTRAINT fk_clb_san FOREIGN KEY (MaSan) REFERENCES SAN_VAN_DONG(MaSan)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ============================================================================
-- NHÓM 3: CÁC BẢNG CẤP 2 (PHỤ THUỘC VÀO CLB & SÂN VẬN ĐỘNG)
-- ============================================================================

CREATE TABLE IF NOT EXISTS HLV (
    MaHLV    VARCHAR(10)  PRIMARY KEY,
    TenHLV   VARCHAR(100) NOT NULL,
    QuocTich VARCHAR(50)  NOT NULL,
    VaiTro   VARCHAR(50)  NOT NULL,
    MaCLB    VARCHAR(10)  NOT NULL,
    CONSTRAINT fk_hlv_clb FOREIGN KEY (MaCLB) REFERENCES CLB(MaCLB)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS CAU_THU (
    MaCT     VARCHAR(10)  PRIMARY KEY,
    TenCT    VARCHAR(100) NOT NULL,
    SoAo     INT          NOT NULL CHECK (SoAo BETWEEN 1 AND 99),
    ViTri    VARCHAR(50)  NOT NULL,
    QuocTich VARCHAR(50)  NOT NULL,
    MaCLB    VARCHAR(10)  NOT NULL,
    CONSTRAINT fk_ct_clb FOREIGN KEY (MaCLB) REFERENCES CLB(MaCLB)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS TRAN_DAU (
    MaTran     VARCHAR(10) PRIMARY KEY,
    VongDau    INT         NOT NULL CHECK (VongDau > 0),
    NgayThiDau DATETIME    NOT NULL,
    MaDoiNha   VARCHAR(10) NOT NULL,
    MaDoiKhach VARCHAR(10) NOT NULL,
    MaSan      VARCHAR(10) NOT NULL,
    CONSTRAINT fk_td_doinha   FOREIGN KEY (MaDoiNha)   REFERENCES CLB(MaCLB)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_td_doikhach FOREIGN KEY (MaDoiKhach) REFERENCES CLB(MaCLB)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_td_san      FOREIGN KEY (MaSan)      REFERENCES SAN_VAN_DONG(MaSan)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ============================================================================
-- NHÓM 4: CÁC BẢNG QUAN HỆ N-N & BẢNG SỰ KIỆN TRẬN ĐẤU / CHUYỂN NHƯỢNG
-- ============================================================================

CREATE TABLE IF NOT EXISTS PHAN_CONG_TRONG_TAI (
    MaTT   VARCHAR(10) NOT NULL,
    MaTran VARCHAR(10) NOT NULL,
    VaiTro VARCHAR(50) NOT NULL,
    PRIMARY KEY (MaTT, MaTran),
    CONSTRAINT fk_pctt_tt   FOREIGN KEY (MaTT)   REFERENCES TRONG_TAI(MaTT)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_pctt_tran FOREIGN KEY (MaTran) REFERENCES TRAN_DAU(MaTran)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS THONG_KE_THI_DAU (
    MaCT         VARCHAR(10) NOT NULL,
    MaTran       VARCHAR(10) NOT NULL,
    SoPhutThiDau INT         NOT NULL DEFAULT 0 CHECK (SoPhutThiDau BETWEEN 0 AND 130),
    PRIMARY KEY (MaCT, MaTran),
    CONSTRAINT fk_tktd_ct   FOREIGN KEY (MaCT)   REFERENCES CAU_THU(MaCT)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tktd_tran FOREIGN KEY (MaTran) REFERENCES TRAN_DAU(MaTran)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS THE_PHAT (
    MaThe    VARCHAR(10) PRIMARY KEY,
    LoaiThe  VARCHAR(20) NOT NULL,
    PhutPhat INT         NOT NULL CHECK (PhutPhat > 0),
    MaTran   VARCHAR(10) NOT NULL,
    MaCT     VARCHAR(10) NOT NULL,
    CONSTRAINT fk_tp_tran FOREIGN KEY (MaTran) REFERENCES TRAN_DAU(MaTran)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_tp_ct   FOREIGN KEY (MaCT)   REFERENCES CAU_THU(MaCT)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS THAY_NGUOI (
    MaTN     VARCHAR(10) PRIMARY KEY,
    PhutThay INT         NOT NULL CHECK (PhutThay > 0),
    MaCT_Vao VARCHAR(10) NOT NULL,
    MaCT_Ra  VARCHAR(10) NOT NULL,
    MaTran   VARCHAR(10) NOT NULL,
    CONSTRAINT fk_tn_ctvao FOREIGN KEY (MaCT_Vao) REFERENCES CAU_THU(MaCT)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tn_ctra  FOREIGN KEY (MaCT_Ra)  REFERENCES CAU_THU(MaCT)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tn_tran  FOREIGN KEY (MaTran)   REFERENCES TRAN_DAU(MaTran)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS BAN_THANG (
    MaBT         VARCHAR(10) PRIMARY KEY,
    PhutGhiBan   INT         NOT NULL CHECK (PhutGhiBan > 0),
    LoaiBanThang VARCHAR(50) NOT NULL,
    MaCT_GhiBan  VARCHAR(10) NOT NULL,
    MaCT_KienTao VARCHAR(10) NULL,
    MaTran       VARCHAR(10) NOT NULL,
    CONSTRAINT fk_bt_ghiban  FOREIGN KEY (MaCT_GhiBan)  REFERENCES CAU_THU(MaCT)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_bt_kientao FOREIGN KEY (MaCT_KienTao) REFERENCES CAU_THU(MaCT)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_bt_tran    FOREIGN KEY (MaTran)       REFERENCES TRAN_DAU(MaTran)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS CHAN_THUONG (
    MaCTh          VARCHAR(10)  PRIMARY KEY,
    NgayBaoCao     DATE         NOT NULL,
    LoaiChanThuong VARCHAR(100) NOT NULL,
    TGNghiDuKien   VARCHAR(50)  NOT NULL,
    MaTran         VARCHAR(10)  NULL,
    MaCT           VARCHAR(10)  NOT NULL,
    CONSTRAINT fk_cth_tran FOREIGN KEY (MaTran) REFERENCES TRAN_DAU(MaTran)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_cth_ct   FOREIGN KEY (MaCT)   REFERENCES CAU_THU(MaCT)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS LICH_SU_CHUYEN_NHUONG (
    MaCN       VARCHAR(10) PRIMARY KEY,
    MuaGiai    VARCHAR(20) NOT NULL,
    NgayChuyen DATE        NOT NULL,
    MaCLBCu    VARCHAR(10) NULL,
    MaCLBMoi   VARCHAR(10) NOT NULL,
    MaCT       VARCHAR(10) NOT NULL,
    CONSTRAINT fk_cn_clbcu  FOREIGN KEY (MaCLBCu)  REFERENCES CLB(MaCLB)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_cn_clbmoi FOREIGN KEY (MaCLBMoi) REFERENCES CLB(MaCLB)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_cn_ct     FOREIGN KEY (MaCT)     REFERENCES CAU_THU(MaCT)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;