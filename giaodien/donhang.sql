-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th6 12, 2025 lúc 07:28 PM
-- Phiên bản máy phục vụ: 10.4.32-MariaDB
-- Phiên bản PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `qlydonhang`
--

DELIMITER $$
--
-- Thủ tục
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_DangKyTaiKhoan` (IN `p_Ma_TK` VARCHAR(10), IN `p_Ten_Dang_Nhap` VARCHAR(40), IN `p_Mat_Khau` VARCHAR(20), IN `p_Loai_TK` VARCHAR(15), IN `p_Ma_KH` VARCHAR(10), IN `p_Ma_QL` VARCHAR(10))   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi khi đăng ký tài khoản';
    END;

    IF EXISTS (SELECT 1 FROM TAI_KHOAN WHERE Ma_TK = p_Ma_TK) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Mã tài khoản đã tồn tại!';
    END IF;
    
    IF EXISTS (SELECT 1 FROM TAI_KHOAN WHERE Ten_Dang_Nhap = p_Ten_Dang_Nhap) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Tên đăng nhập đã tồn tại!';
    END IF;
    
    IF p_Loai_TK NOT IN ('KHÁCH HÀNG', 'QUẢN LÝ') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Loại tài khoản không hợp lệ!';
    END IF;
    
    IF p_Loai_TK = 'KHÁCH HÀNG' THEN
        IF p_Ma_QL IS NOT NULL THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Tài khoản khách hàng không được có mã quản lý!';
        END IF;
        IF p_Ma_KH IS NOT NULL AND NOT EXISTS (SELECT 1 FROM KHACH_HANG WHERE Ma_KH = p_Ma_KH) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Mã khách hàng không tồn tại!';
        END IF;
    ELSE
        IF p_Ma_KH IS NOT NULL THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Tài khoản quản lý không được có mã khách hàng!';
        END IF;
        IF p_Ma_QL IS NOT NULL AND NOT EXISTS (SELECT 1 FROM QUAN_LY WHERE Ma_QL = p_Ma_QL) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Mã quản lý không tồn tại!';
        END IF;
    END IF;
    
    INSERT INTO TAI_KHOAN (Ma_TK, Ten_Dang_Nhap, Mat_Khau, Ma_QL, Loai_TK, Ma_KH)
    VALUES (p_Ma_TK, p_Ten_Dang_Nhap, p_Mat_Khau, p_Ma_QL, p_Loai_TK, p_Ma_KH);
    
    SELECT 'Đăng ký tài khoản thành công!' AS Message;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_DangNhap` (IN `p_Ma_TK` VARCHAR(10), IN `p_Ten_Dang_Nhap` VARCHAR(40), IN `p_Mat_Khau` VARCHAR(20))   BEGIN
    IF NOT EXISTS (
        SELECT 1 
        FROM TAI_KHOAN 
        WHERE Ma_TK = p_Ma_TK 
        AND Ten_Dang_Nhap = p_Ten_Dang_Nhap
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Đăng nhập thất bại: Tài khoản không tồn tại';
    END IF;
    
    IF NOT EXISTS (
        SELECT 1 
        FROM TAI_KHOAN 
        WHERE Ma_TK = p_Ma_TK 
        AND Ten_Dang_Nhap = p_Ten_Dang_Nhap
        AND Mat_Khau = p_Mat_Khau
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Đăng nhập thất bại: Mật khẩu không chính xác';
    END IF;
    
    SELECT 'Đăng nhập thành công' AS Message;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_KiemTraKhachHangTrung` (IN `p_SDT` VARCHAR(15), IN `p_Email` VARCHAR(50))   BEGIN
    SELECT Ma_KH, Ho_Ten, SDT, Dia_Chi
    FROM KHACH_HANG
    WHERE SDT = p_SDT
    OR (p_Email IS NOT NULL AND EXISTS (SELECT 1 FROM KHACH_HANG WHERE Email = p_Email));
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_KiemTraSanPhamTrung` (IN `p_TenSP` VARCHAR(50))   BEGIN
    SELECT Ma_SP, Ten_SP, Don_Gia
    FROM SAN_PHAM
    WHERE Ten_SP = p_TenSP;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_QL_SuaTaiKhoan` (IN `p_Ma_TK` VARCHAR(10), IN `p_Ten_Dang_Nhap` VARCHAR(40), IN `p_Mat_Khau` VARCHAR(20), IN `p_Loai_TK` VARCHAR(15), IN `p_Ma_KH` VARCHAR(10), IN `p_Ma_QL` VARCHAR(10))   BEGIN
    IF NOT EXISTS (SELECT 1 FROM TAI_KHOAN WHERE Ma_TK = p_Ma_TK) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Tài khoản không tồn tại!';
    END IF;
    
    IF p_Ten_Dang_Nhap IS NOT NULL AND EXISTS (
        SELECT 1 FROM TAI_KHOAN WHERE Ten_Dang_Nhap = p_Ten_Dang_Nhap AND Ma_TK != p_Ma_TK
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Tên đăng nhập đã tồn tại!';
    END IF;
    
    IF p_Loai_TK IS NOT NULL AND p_Loai_TK NOT IN ('KHÁCH HÀNG', 'QUẢN LÝ') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Loại tài khoản không hợp lệ!';
    END IF;
    
    UPDATE TAI_KHOAN
    SET 
        Ten_Dang_Nhap = COALESCE(p_Ten_Dang_Nhap, Ten_Dang_Nhap),
        Mat_Khau = COALESCE(p_Mat_Khau, Mat_Khau),
        Loai_TK = COALESCE(p_Loai_TK, Loai_TK),
        Ma_KH = COALESCE(p_Ma_KH, Ma_KH),
        Ma_QL = COALESCE(p_Ma_QL, Ma_QL)
    WHERE Ma_TK = p_Ma_TK;
    
    SELECT 'Cập nhật tài khoản thành công!' AS Message;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_QL_ThemTaiKhoan` (IN `p_Ma_TK` VARCHAR(10), IN `p_Ten_Dang_Nhap` VARCHAR(40), IN `p_Mat_Khau` VARCHAR(20), IN `p_Loai_TK` VARCHAR(15), IN `p_Ma_KH` VARCHAR(10), IN `p_Ma_QL` VARCHAR(10))   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi khi thêm tài khoản';
    END;

    IF EXISTS (SELECT 1 FROM TAI_KHOAN WHERE Ma_TK = p_Ma_TK) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Mã tài khoản đã tồn tại!';
    END IF;
    
    IF EXISTS (SELECT 1 FROM TAI_KHOAN WHERE Ten_Dang_Nhap = p_Ten_Dang_Nhap) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Tên đăng nhập đã tồn tại!';
    END IF;
    
    IF p_Loai_TK NOT IN ('KHÁCH HÀNG', 'QUẢN LÝ') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Loại tài khoản không hợp lệ!';
    END IF;
    
    IF p_Loai_TK = 'KHÁCH HÀNG' THEN
        IF p_Ma_QL IS NOT NULL THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Tài khoản khách hàng không được có mã quản lý!';
        END IF;
        IF p_Ma_KH IS NOT NULL AND NOT EXISTS (SELECT 1 FROM KHACH_HANG WHERE Ma_KH = p_Ma_KH) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Mã khách hàng không tồn tại!';
        END IF;
    ELSE
        IF p_Ma_KH IS NOT NULL THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Tài khoản quản lý không được có mã khách hàng!';
        END IF;
        IF p_Ma_QL IS NOT NULL AND NOT EXISTS (SELECT 1 FROM QUAN_LY WHERE Ma_QL = p_Ma_QL) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Mã quản lý không tồn tại!';
        END IF;
    END IF;
    
    INSERT INTO TAI_KHOAN (Ma_TK, Ten_Dang_Nhap, Mat_Khau, Ma_QL, Loai_TK, Ma_KH)
    VALUES (p_Ma_TK, p_Ten_Dang_Nhap, p_Mat_Khau, p_Ma_QL, p_Loai_TK, p_Ma_KH);
    
    SELECT 'Thêm tài khoản thành công!' AS Message;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_QL_XemDonHang` (IN `p_Ma_DH` VARCHAR(10), IN `p_Ma_KH` VARCHAR(10), IN `p_Trang_Thai` VARCHAR(30), IN `p_Ngay_BatDau` DATETIME, IN `p_Ngay_KetThuc` DATETIME, IN `p_Page` INT, IN `p_PageSize` INT)   BEGIN
    DECLARE v_StartRow INT;
    DECLARE v_EndRow INT;
    
    SET v_StartRow = (p_Page - 1) * p_PageSize + 1;
    SET v_EndRow = p_Page * p_PageSize;
    
    SET @sql = '
    WITH FilteredOrders AS (
        SELECT 
            dh.Ma_DH,
            dh.Ngay_Dat,
            dh.Trang_Thai,
            kh.Ma_KH,
            kh.Ho_Ten AS Ten_KH,
            kh.SDT,
            (SELECT COUNT(*) FROM CHI_TIET_DON_HANG WHERE Ma_DH = dh.Ma_DH) AS So_SanPham,
            (SELECT SUM(So_Luong * Don_Gia) FROM CHI_TIET_DON_HANG WHERE Ma_DH = dh.Ma_DH) AS Tong_Tien,
            ROW_NUMBER() OVER (ORDER BY dh.Ngay_Dat DESC) AS RowNum
        FROM 
            DON_HANG dh
            JOIN KHACH_HANG kh ON dh.Ma_KH = kh.Ma_KH
        WHERE 
            (? IS NULL OR dh.Ma_DH = ?)
            AND (? IS NULL OR dh.Ma_KH = ?)
            AND (? IS NULL OR dh.Trang_Thai = ?)
            AND (? IS NULL OR dh.Ngay_Dat >= ?)
            AND (? IS NULL OR dh.Ngay_Dat <= ?)
    )
    SELECT 
        Ma_DH,
        DATE_FORMAT(Ngay_Dat, ''%d/%m/%Y'') AS Ngay_Dat_Formatted,
        Trang_Thai,
        Ma_KH,
        Ten_KH,
        SDT,
        So_SanPham,
        FORMAT(Tong_Tien, 0) AS Tong_Tien_Formatted
    FROM 
        FilteredOrders
    WHERE 
        RowNum BETWEEN ? AND ?
    ORDER BY 
        Ngay_Dat DESC;
    
    SELECT COUNT(*) AS TotalOrders
    FROM DON_HANG dh
    WHERE 
        (? IS NULL OR dh.Ma_DH = ?)
        AND (? IS NULL OR dh.Ma_KH = ?)
        AND (? IS NULL OR dh.Trang_Thai = ?)
        AND (? IS NULL OR dh.Ngay_Dat >= ?)
        AND (? IS NULL OR dh.Ngay_Dat <= ?);
    ';
    
    PREPARE stmt FROM @sql;
    EXECUTE stmt USING 
        p_Ma_DH, p_Ma_DH, 
        p_Ma_KH, p_Ma_KH, 
        p_Trang_Thai, p_Trang_Thai, 
        p_Ngay_BatDau, p_Ngay_BatDau, 
        -- Hoàn thiện stored procedure sp_QL_XemDonHang (bị cắt ở phần trước)
    p_Ngay_KetThuc, p_Ngay_KetThuc,
        v_StartRow, v_EndRow,
        p_Ma_DH, p_Ma_DH, 
        p_Ma_KH, p_Ma_KH, 
        p_Trang_Thai, p_Trang_Thai, 
        p_Ngay_BatDau, p_Ngay_BatDau, 
        p_Ngay_KetThuc, p_Ngay_KetThuc;
    DEALLOCATE PREPARE stmt;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_QL_XemTaiKhoan` (IN `p_Ma_TK` VARCHAR(10))   BEGIN
    IF p_Ma_TK IS NULL THEN
        SELECT Ma_TK, Ten_Dang_Nhap, Loai_TK, Ma_KH, Ma_QL
        FROM TAI_KHOAN;
    ELSE
        SELECT Ma_TK, Ten_Dang_Nhap, Loai_TK, Ma_KH, Ma_QL
        FROM TAI_KHOAN
        WHERE Ma_TK = p_Ma_TK;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_QL_XoaTaiKhoan` (IN `p_Ma_TK` VARCHAR(10))   BEGIN
    IF NOT EXISTS (SELECT 1 FROM TAI_KHOAN WHERE Ma_TK = p_Ma_TK) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Tài khoản không tồn tại!';
    END IF;
    
    DELETE FROM TAI_KHOAN WHERE Ma_TK = p_Ma_TK;
    
    SELECT 'Xóa tài khoản thành công!' AS Message;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_SuaSanPham` (IN `p_Ma_SP` VARCHAR(10), IN `p_Ten_SP` VARCHAR(50), IN `p_Don_Gia` DECIMAL(15,2), IN `p_Mo_Ta` VARCHAR(255), IN `p_Tinh_Trang` VARCHAR(20), IN `p_So_Luong` INT)   BEGIN
    IF NOT EXISTS (SELECT 1 FROM SAN_PHAM WHERE Ma_SP = p_Ma_SP) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Sản phẩm không tồn tại!';
    END IF;
    
    UPDATE SAN_PHAM
    SET 
        Ten_SP = COALESCE(p_Ten_SP, Ten_SP),
        Don_Gia = COALESCE(p_Don_Gia, Don_Gia),
        Mo_ta = COALESCE(p_Mo_Ta, Mo_ta),
        Tinh_trang = COALESCE(p_Tinh_Trang, Tinh_trang),
        So_luong = COALESCE(p_So_Luong, So_luong)
    WHERE Ma_SP = p_Ma_SP;
    
    SELECT 'Cập nhật sản phẩm thành công!' AS Message;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ThemSanPham` (IN `p_Ma_SP` VARCHAR(10), IN `p_Ten_SP` VARCHAR(50), IN `p_Don_Gia` DECIMAL(15,2), IN `p_Mo_Ta` VARCHAR(255), IN `p_Tinh_Trang` VARCHAR(20), IN `p_So_Luong` INT)   BEGIN
    IF EXISTS (SELECT 1 FROM SAN_PHAM WHERE Ma_SP = p_Ma_SP) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Mã sản phẩm đã tồn tại!';
    END IF;
    
    INSERT INTO SAN_PHAM (Ma_SP, Ten_SP, Don_Gia, Mo_ta, Tinh_trang, So_luong)
    VALUES (p_Ma_SP, p_Ten_SP, p_Don_Gia, p_Mo_Ta, p_Tinh_Trang, p_So_Luong);
    
    SELECT 'Thêm sản phẩm thành công!' AS Message;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_XemSanPham` (IN `p_Ma_SP` VARCHAR(10))   BEGIN
    IF p_Ma_SP IS NULL THEN
        SELECT * FROM SAN_PHAM;
    ELSE
        SELECT * FROM SAN_PHAM WHERE Ma_SP = p_Ma_SP;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_XoaSanPham` (IN `p_Ma_SP` VARCHAR(10))   BEGIN
    IF NOT EXISTS (SELECT 1 FROM SAN_PHAM WHERE Ma_SP = p_Ma_SP) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Sản phẩm không tồn tại!';
    END IF;
    
    DELETE FROM SAN_PHAM WHERE Ma_SP = p_Ma_SP;
    
    SELECT 'Xóa sản phẩm thành công!' AS Message;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `chi_tiet_don_hang`
--

CREATE TABLE `chi_tiet_don_hang` (
  `Ma_DH` varchar(10) NOT NULL,
  `Ma_SP` varchar(10) NOT NULL,
  `So_Luong` int(11) DEFAULT NULL,
  `Don_Gia` decimal(15,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `chi_tiet_don_hang`
--

INSERT INTO `chi_tiet_don_hang` (`Ma_DH`, `Ma_SP`, `So_Luong`, `Don_Gia`) VALUES
('DH001', 'SP001', 1, 150000.00),
('DH002', 'SP002', 1, 250000.00),
('DH003', 'SP003', 1, 350000.00),
('DH004', 'SP004', 1, 200000.00),
('DH005', 'SP005', 1, 80000.00),
('DH006', 'SP006', 1, 120000.00),
('DH007', 'SP007', 1, 450000.00),
('DH008', 'SP008', 1, 180000.00),
('DH009', 'SP009', 1, 100000.00),
('DH010', 'SP010', 1, 90000.00),
('DH011', 'SP011', 1, 80000.00),
('DH012', 'SP012', 1, 25000.00),
('DH013', 'SP013', 1, 10000.00),
('DH014', 'SP014', 1, 5000.00),
('DH015', 'SP015', 1, 150000.00),
('DH016', 'SP016', 1, 120000.00),
('DH017', 'SP017', 1, 280000.00),
('DH018', 'SP018', 1, 220000.00),
('DH019', 'SP019', 1, 30000.00),
('DH020', 'SP020', 1, 50000.00);

--
-- Bẫy `chi_tiet_don_hang`
--
DELIMITER $$
CREATE TRIGGER `trg_DatHang` AFTER INSERT ON `chi_tiet_don_hang` FOR EACH ROW BEGIN
    DECLARE v_So_Luong INT;
    
    UPDATE SAN_PHAM
    SET So_luong = So_luong - NEW.So_Luong
    WHERE Ma_SP = NEW.Ma_SP;
    
    SELECT So_luong INTO v_So_Luong
    FROM SAN_PHAM
    WHERE Ma_SP = NEW.Ma_SP;
    
    IF v_So_Luong < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Không đủ hàng trong kho!';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `don_hang`
--

CREATE TABLE `don_hang` (
  `Ma_DH` varchar(10) NOT NULL,
  `Ma_KH` varchar(10) NOT NULL,
  `Ngay_Dat` datetime NOT NULL,
  `Trang_Thai` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `don_hang`
--

INSERT INTO `don_hang` (`Ma_DH`, `Ma_KH`, `Ngay_Dat`, `Trang_Thai`) VALUES
('DH001', 'KH001', '2025-03-01 00:00:00', 'Đã đặt'),
('DH002', 'KH001', '2025-03-02 00:00:00', 'Đang giao'),
('DH003', 'KH002', '2025-03-01 00:00:00', 'Hoàn thành'),
('DH004', 'KH003', '2025-03-02 00:00:00', 'Đã hủy'),
('DH005', 'KH003', '2025-03-02 00:00:00', 'Đã đặt'),
('DH006', 'KH003', '2025-03-06 00:00:00', 'Đang giao'),
('DH007', 'KH003', '2025-03-03 00:00:00', 'Hoàn thành'),
('DH008', 'KH004', '2025-03-03 00:00:00', 'Đã hủy'),
('DH009', 'KH004', '2025-03-23 00:00:00', 'Đã đặt'),
('DH010', 'KH004', '2025-03-10 00:00:00', 'Đang giao'),
('DH011', 'KH005', '2025-03-19 00:00:00', 'Hoàn thành'),
('DH012', 'KH005', '2025-03-02 00:00:00', 'Đã hủy'),
('DH013', 'KH006', '2025-03-13 00:00:00', 'Đã đặt'),
('DH014', 'KH007', '2025-03-18 00:00:00', 'Đang giao'),
('DH015', 'KH007', '2025-03-15 00:00:00', 'Hoàn thành'),
('DH016', 'KH007', '2025-03-16 00:00:00', 'Đã hủy'),
('DH017', 'KH008', '2025-03-07 00:00:00', 'Đã đặt'),
('DH018', 'KH009', '2025-03-18 00:00:00', 'Đang giao'),
('DH019', 'KH010', '2025-03-29 00:00:00', 'Hoàn thành'),
('DH020', 'KH010', '2025-03-20 00:00:00', 'Đã hủy'),
('DH021', 'KH010', '2025-03-21 00:00:00', 'Đã đặt'),
('DH022', 'KH011', '2025-03-22 00:00:00', 'Đang giao'),
('DH023', 'KH012', '2025-03-03 00:00:00', 'Hoàn thành'),
('DH024', 'KH012', '2025-03-24 00:00:00', 'Đã hủy'),
('DH025', 'KH013', '2025-03-25 00:00:00', 'Đã đặt'),
('DH026', 'KH014', '2025-03-26 00:00:00', 'Đang giao'),
('DH027', 'KH014', '2025-03-07 00:00:00', 'Hoàn thành'),
('DH028', 'KH014', '2025-03-28 00:00:00', 'Đã hủy'),
('DH029', 'KH015', '2025-03-17 00:00:00', 'Đã đặt'),
('DH030', 'KH016', '2025-03-30 00:00:00', 'Hoàn thành'),
('DH031', 'KH016', '2025-03-31 00:00:00', 'Hoàn thành'),
('DH032', 'KH017', '2025-03-10 00:00:00', 'Đã đặt'),
('DH033', 'KH018', '2025-03-30 00:00:00', 'Đang giao'),
('DH034', 'KH018', '2025-03-20 00:00:00', 'Hoàn thành'),
('DH035', 'KH019', '2025-03-13 00:00:00', 'Đã đặt'),
('DH036', 'KH020', '2025-03-29 00:00:00', 'Hoàn thành'),
('DH037', 'KH020', '2025-03-21 00:00:00', 'Đang giao');

--
-- Bẫy `don_hang`
--
DELIMITER $$
CREATE TRIGGER `trg_HuyDonHang_CapNhatSoLuong` AFTER UPDATE ON `don_hang` FOR EACH ROW BEGIN
    IF NEW.Trang_Thai = 'Đã hủy' AND OLD.Trang_Thai != 'Đã hủy' THEN
        UPDATE SAN_PHAM sp
        JOIN CHI_TIET_DON_HANG ct ON sp.Ma_SP = ct.Ma_SP
        SET sp.So_luong = sp.So_luong + ct.So_Luong
        WHERE ct.Ma_DH = NEW.Ma_DH;
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_QL_XoaDonHang` BEFORE DELETE ON `don_hang` FOR EACH ROW BEGIN
    UPDATE SAN_PHAM sp
    JOIN CHI_TIET_DON_HANG ct ON sp.Ma_SP = ct.Ma_SP
    SET sp.So_luong = sp.So_luong + ct.So_Luong
    WHERE ct.Ma_DH = OLD.Ma_DH;
    
    DELETE FROM CHI_TIET_DON_HANG WHERE Ma_DH = OLD.Ma_DH;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `giao_hang`
--

CREATE TABLE `giao_hang` (
  `Ma_GH` varchar(10) NOT NULL,
  `Ngay_Giao` datetime DEFAULT NULL,
  `Trang_Thai` varchar(30) DEFAULT NULL,
  `Nguoi_Giao` varchar(40) DEFAULT NULL,
  `Ma_DH` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `giao_hang`
--

INSERT INTO `giao_hang` (`Ma_GH`, `Ngay_Giao`, `Trang_Thai`, `Nguoi_Giao`, `Ma_DH`) VALUES
('GH001', '2025-04-01 00:00:00', 'Thành công', 'Hồ Công Huy', 'DH001'),
('GH002', '2025-04-02 00:00:00', 'Đang giao', 'Nguyễn Hữu Trường', 'DH002'),
('GH003', '2025-04-03 00:00:00', 'Chưa giao', 'Nguyễn Duy Việt', 'DH003'),
('GH004', '2025-04-04 00:00:00', 'Thành công', 'Nguyễn Thái Đạt', 'DH004'),
('GH005', '2025-04-05 00:00:00', 'Đang giao', 'Đặng Bá Tuấn Anh', 'DH005'),
('GH006', '2025-04-06 00:00:00', 'Thành công', 'Nguyễn Nam Trường', 'DH006'),
('GH007', '2025-04-07 00:00:00', 'Chưa giao', 'Đào Quang Tùng', 'DH007'),
('GH008', '2025-04-08 00:00:00', 'Thành công', 'Phạm Thị Phương', 'DH008'),
('GH009', '2025-04-09 00:00:00', 'Đang giao', 'Nguyễn Thị Oanh', 'DH009'),
('GH010', '2025-04-10 00:00:00', 'Thành công', 'Vũ Thị Phượng', 'DH010'),
('GH011', '2025-04-11 00:00:00', 'Đang giao', 'Nguyễn Thị Thanh', 'DH011'),
('GH012', '2025-04-12 00:00:00', 'Thành công', 'Nguyễn Thị Minh', 'DH012'),
('GH013', '2025-04-13 00:00:00', 'Chưa giao', 'Đào Duy Sơn', 'DH013'),
('GH014', '2025-04-14 00:00:00', 'Đang giao', 'Hồ Công Huy', 'DH014'),
('GH015', '2025-04-15 00:00:00', 'Thành công', 'Nguyễn Thị Thanh', 'DH015'),
('GH016', '2025-04-16 00:00:00', 'Thành công', 'Nguyễn Hữu Trường', 'DH016'),
('GH017', '2025-04-17 00:00:00', 'Đang giao', 'Phạm Thị Phương', 'DH017'),
('GH018', '2025-04-18 00:00:00', 'Thành công', 'Nguyễn Duy Việt', 'DH018'),
('GH019', '2025-04-19 00:00:00', 'Chưa giao', 'Nguyễn Thị Oanh', 'DH019'),
('GH020', '2025-04-20 00:00:00', 'Đang giao', 'Phạm Thị Phương', 'DH020');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `khach_hang`
--

CREATE TABLE `khach_hang` (
  `Ma_KH` varchar(10) NOT NULL,
  `Ho_Ten` varchar(50) DEFAULT NULL,
  `Dia_Chi` varchar(50) DEFAULT NULL,
  `SDT` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `khach_hang`
--

INSERT INTO `khach_hang` (`Ma_KH`, `Ho_Ten`, `Dia_Chi`, `SDT`) VALUES
('KH001', 'Nguyễn Văn An', '15 Láng Hạ, Ba Đình, HN', '0912345678'),
('KH002', 'Trần Thị Bích Ngọc', '45 Lê Lợi, Q.1, HCM', '0987654321'),
('KH003', 'Lê Minh Tuấn', '98 Hà Huy Tập, Đà Nẵng', '0901122334'),
('KH004', 'Phạm Thị Mai Lan', '8 3/2, Ninh Kiều, CT', '0933445566'),
('KH005', 'Hồ Quốc Hưng', '32 Lạch Tray, Hải Phòng', '0944556677'),
('KH006', 'Ngô Thị Hồng Nhung', 'B12 Phú Hồng Thịnh', '0977888999'),
('KH007', 'Dương Thanh Phong', '25 Hồng Hải, Quảng Ninh', '0922233445'),
('KH008', 'Đặng Thị Thu Hà', '12 Trần Hưng Đạo, ĐL', '0955667788'),
('KH009', 'Vũ Anh Dũng', '7 Trần Đăng Ninh, NĐ', '0966778899'),
('KH010', 'Bùi Thị Kim Oanh', 'Đoàn Kết, Tân Mỹ', '0933221144'),
('KH011', 'Mai Văn Đức', '18 Nguyễn Thành, Hà Tĩnh', '0988776655'),
('KH012', 'Tạ Thị Ngọc Bích', 'Phú Thành, Vĩnh Long', '0911999888'),
('KH013', 'Hoàng Gia Bảo', '3 Phan Đình Phùng', '0900554433'),
('KH014', 'Đoàn Thị Phương Thảo', '78 Nguyễn Hội, PT', '0944223355'),
('KH015', 'La Công Minh', '27 Lê Hồng Phong', '0933112233'),
('KH016', 'Trịnh Thị Bảo Trân', '5 Tân Quang, TQ', '0922113344'),
('KH017', 'Tôn Văn Lâm', '9 Bắc Sơn, HY', '0977334466'),
('KH018', 'Tống Thị Tuyết Mai', '36 Trường Thi, TH', '0955778899'),
('KH019', 'Lương Hoàng Nam', '5 Nguyễn Huệ, TH', '0966443322'),
('KH020', 'Phùng Thị Khánh Linh', 'Châu Thành, BL', '0900332211');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `quan_ly`
--

CREATE TABLE `quan_ly` (
  `Ma_QL` varchar(10) NOT NULL,
  `Ho_Ten` varchar(50) DEFAULT NULL,
  `SDT` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `quan_ly`
--

INSERT INTO `quan_ly` (`Ma_QL`, `Ho_Ten`, `SDT`) VALUES
('QL001', 'Nguyễn Văn An', '0901000001'),
('QL002', 'Trần Thị Bình', '0901000002'),
('QL003', 'Phạm Văn Cương', '0901000003'),
('QL004', 'Lê Thị Dào', '0901000004'),
('QL005', 'Hoàng Văn Nam', '0901000005'),
('QL006', 'Đặng Thị Hoa', '0901000006'),
('QL007', 'Nguyễn Văn Giàu', '0901000007'),
('QL008', 'Bùi Thị Hồng', '0901000008'),
('QL009', 'Trần Văn Hưng', '0901000009'),
('QL010', 'Nguyễn Thị Kiều', '0901000010'),
('QL011', 'Phạm Văn Long', '0901000011'),
('QL012', 'Nguyễn Thị Minh', '0901000012'),
('QL013', 'Lê Văn Nhân', '0901000013'),
('QL014', 'Nguyễn Thị Oanh', '0901000014'),
('QL015', 'Hoàng Văn Phúc', '0901000015'),
('QL016', 'Trần Văn Quyền', '0901000016'),
('QL017', 'Hồ Diên Sang', '0901000017'),
('QL018', 'Hồ Thị Tâm', '0901000018'),
('QL019', 'Hồ Công Tuyên', '0901000019'),
('QL020', 'Hoàng Yến Vy', '0901000020');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `quan_ly_don_hang`
--

CREATE TABLE `quan_ly_don_hang` (
  `Ma_DH` varchar(10) NOT NULL,
  `Ma_QL` varchar(10) NOT NULL,
  `Xu_Ly_Don_Hang` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `quan_ly_don_hang`
--

INSERT INTO `quan_ly_don_hang` (`Ma_DH`, `Ma_QL`, `Xu_Ly_Don_Hang`) VALUES
('DH001', 'QL001', 'Chưa xử lý'),
('DH005', 'QL002', 'Chưa xử lý'),
('DH009', 'QL005', 'Chưa xử lý'),
('DH013', 'QL006', 'Chưa xử lý'),
('DH017', 'QL008', 'Chưa xử lý'),
('DH021', 'QL011', 'Chưa xử lý'),
('DH025', 'QL015', 'Chưa xử lý'),
('DH029', 'QL016', 'Chưa xử lý'),
('DH032', 'QL017', 'Chưa xử lý'),
('DH035', 'QL018', 'Chưa xử lý'),
('DH002', 'QL001', 'Đang xử lý'),
('DH006', 'QL003', 'Đang xử lý'),
('DH010', 'QL005', 'Đang xử lý'),
('DH014', 'QL006', 'Đang xử lý'),
('DH018', 'QL009', 'Đang xử lý'),
('DH022', 'QL012', 'Đang xử lý'),
('DH026', 'QL015', 'Đang xử lý'),
('DH033', 'QL018', 'Đang xử lý'),
('DH037', 'QL020', 'Đang xử lý'),
('DH003', 'QL001', 'Xử lý thành công'),
('DH004', 'QL002', 'Xử lý thành công'),
('DH007', 'QL003', 'Xử lý thành công'),
('DH008', 'QL004', 'Xử lý thành công'),
('DH011', 'QL005', 'Xử lý thành công'),
('DH012', 'QL005', 'Xử lý thành công'),
('DH015', 'QL007', 'Xử lý thành công'),
('DH016', 'QL007', 'Xử lý thành công'),
('DH019', 'QL010', 'Xử lý thành công'),
('DH020', 'QL011', 'Xử lý thành công'),
('DH023', 'QL013', 'Xử lý thành công'),
('DH024', 'QL014', 'Xử lý thành công'),
('DH027', 'QL015', 'Xử lý thành công'),
('DH028', 'QL015', 'Xử lý thành công'),
('DH030', 'QL016', 'Xử lý thành công'),
('DH031', 'QL017', 'Xử lý thành công'),
('DH034', 'QL018', 'Xử lý thành công'),
('DH036', 'QL019', 'Xử lý thành công');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `san_pham`
--

CREATE TABLE `san_pham` (
  `Ma_SP` varchar(10) NOT NULL,
  `Ten_SP` varchar(50) DEFAULT NULL,
  `Don_Gia` decimal(10,2) DEFAULT NULL,
  `Mo_ta` varchar(255) DEFAULT NULL,
  `Tinh_trang` varchar(20) DEFAULT NULL,
  `So_luong` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `san_pham`
--

INSERT INTO `san_pham` (`Ma_SP`, `Ten_SP`, `Don_Gia`, `Mo_ta`, `Tinh_trang`, `So_luong`) VALUES
('SP001', 'Áo thun cotton', 150000.00, 'Áo thun nam/nữ, chất liệu cotton thoáng mát', 'Còn hàng', 500),
('SP002', 'Quần jeans', 250000.00, 'Quần jeans dài, nhiều kiểu dáng', 'Còn hàng', 300),
('SP003', 'Giày thể thao', 350000.00, 'Giày sneaker năng động', 'Còn hàng', 250),
('SP004', 'Ba lô du lịch', 200000.00, 'Ba lô cỡ vừa, nhiều ngăn', 'Còn hàng', 400),
('SP005', 'Mũ lưỡi trai', 80000.00, 'Mũ lưỡi trai thời trang', 'Còn hàng', 600),
('SP006', 'Kính râm', 120000.00, 'Kính mát chống tia UV', 'Còn hàng', 550),
('SP007', 'Đồng hồ đeo tay', 450000.00, 'Đồng hồ quartz, nhiều mẫu', 'Còn hàng', 150),
('SP008', 'Ví da', 180000.00, 'Ví da nam/nữ', 'Còn hàng', 350),
('SP009', 'Dây lưng', 100000.00, 'Dây lưng da', 'Còn hàng', 450),
('SP010', 'Khăn choàng', 90000.00, 'Khăn choàng lụa mềm mại', 'Còn hàng', 500),
('SP011', 'Sách tiểu thuyết', 80000.00, 'Tiểu thuyết trinh thám', 'Còn hàng', 200),
('SP012', 'Truyện tranh', 25000.00, 'Bộ truyện tranh nổi tiếng', 'Còn hàng', 700),
('SP013', 'Vở học sinh', 10000.00, 'Quyển vở 200 trang', 'Còn hàng', 1000),
('SP014', 'Bút bi', 5000.00, 'Chiếc bút bi mực xanh', 'Còn hàng', 2000),
('SP015', 'Máy tính cầm tay', 150000.00, 'Máy tính khoa học', 'Còn hàng', 100),
('SP016', 'Tai nghe', 120000.00, 'Tai nghe có dây', 'Còn hàng', 300),
('SP017', 'Loa Bluetooth', 280000.00, 'Loa di động nhỏ gọn', 'Còn hàng', 180),
('SP018', 'Pin sạc dự phòng', 220000.00, 'Pin dung lượng 10000mAh', 'Còn hàng', 220),
('SP019', 'Cáp sạc điện thoại', 30000.00, 'Cáp USB Type-C', 'Còn hàng', 800),
('SP020', 'Ốp lưng điện thoại', 50000.00, 'Ốp lưng silicon', 'Còn hàng', 650);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tai_khoan`
--

CREATE TABLE `tai_khoan` (
  `Ma_TK` varchar(10) NOT NULL,
  `Ten_Dang_Nhap` varchar(40) DEFAULT NULL,
  `Mat_Khau` varchar(20) DEFAULT NULL,
  `Ma_QL` varchar(10) DEFAULT NULL,
  `Loai_TK` varchar(15) DEFAULT NULL,
  `Ma_KH` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `tai_khoan`
--

INSERT INTO `tai_khoan` (`Ma_TK`, `Ten_Dang_Nhap`, `Mat_Khau`, `Ma_QL`, `Loai_TK`, `Ma_KH`) VALUES
('TK001', 'XIAOCHAOAN', 'PASSWORD001', 'QL001', 'QUẢN LÝ', NULL),
('TK002', 'BINHMESSI', 'PASSWORD002', 'QL002', 'QUẢN LÝ', NULL),
('TK003', 'CUONGRONADOL', 'PASSWORD003', 'QL003', 'QUẢN LÝ', NULL),
('TK004', 'CRISSDAO', 'PASSWORD004', 'QL004', 'QUẢN LÝ', NULL),
('TK005', 'NAMTNT', 'PASSWORD005', 'QL005', 'QUẢN LÝ', NULL),
('TK006', 'HOABEUTY', 'PASSWORD006', 'QL006', 'QUẢN LÝ', NULL),
('TK007', 'NGUYENRICH', 'PASSWORD007', 'QL007', 'QUẢN LÝ', NULL),
('TK008', 'HONGROSE', 'PASSWORD008', 'QL008', 'QUẢN LÝ', NULL),
('TK009', 'HUNGLUKAKU', 'PASSWORD009', 'QL009', 'QUẢN LÝ', NULL),
('TK010', 'KIEUXINGGAI', 'PASSWORD010', 'QL010', 'QUẢN LÝ', NULL),
('TK011', 'LONGKAKA', 'PASSWORD011', 'QL011', 'QUẢN LÝ', NULL),
('TK012', 'MINHBECLING', 'PASSWORD012', 'QL012', 'QUẢN LÝ', NULL),
('TK013', 'NHANBUSQUE', 'PASSWORD013', 'QL013', 'QUẢN LÝ', NULL),
('TK014', 'OANH37', 'PASSWORD014', 'QL014', 'QUẢN LÝ', NULL),
('TK015', 'PHUCDU', 'PASSWORD015', 'QL015', 'QUẢN LÝ', NULL),
('TK016', 'QUYENSINGER', 'PASSWORD016', 'QL016', 'QUẢN LÝ', NULL),
('TK017', 'SANGLOSER', 'PASSWORD017', 'QL017', 'QUẢN LÝ', NULL),
('TK018', 'THITAM', 'PASSWORD018', 'QL018', 'QUẢN LÝ', NULL),
('TK019', 'HOTUYEN', 'PASSWORD019', 'QL019', 'QUẢN LÝ', NULL),
('TK020', 'VYXINGGAI', 'PASSWORD020', 'QL020', 'QUẢN LÝ', NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `thanh_toan`
--

CREATE TABLE `thanh_toan` (
  `Ma_HD` varchar(10) NOT NULL,
  `Ngay_Thanh_Toan` datetime DEFAULT NULL,
  `So_Tien` decimal(15,2) DEFAULT NULL,
  `Phuong_Thuc` varchar(30) DEFAULT NULL,
  `Trang_Thai_TT` varchar(30) DEFAULT NULL,
  `Ma_DH` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `thanh_toan`
--

INSERT INTO `thanh_toan` (`Ma_HD`, `Ngay_Thanh_Toan`, `So_Tien`, `Phuong_Thuc`, `Trang_Thai_TT`, `Ma_DH`) VALUES
('TT001', '2025-03-05 00:00:00', 180000.00, 'THANH TOÁN KHI NHẬN HÀNG', 'CHỜ XÁC NHẬN', 'DH001'),
('TT002', '2025-03-06 00:00:00', 220000.00, 'THANH TOÁN TRỰC TUYẾN', 'ĐÃ HỦY', 'DH002'),
('TT003', '2025-03-07 00:00:00', 130000.00, 'THANH TOÁN KHI NHẬN HÀNG', 'ĐANG GIAO', 'DH003'),
('TT004', '2025-03-08 00:00:00', 250000.00, 'THANH TOÁN TRỰC TUYẾN', 'HOÀN THÀNH', 'DH004'),
('TT005', '2025-03-09 00:00:00', 190000.00, 'THANH TOÁN KHI NHẬN HÀNG', 'CHỜ XÁC NHẬN', 'DH005'),
('TT006', '2025-03-10 00:00:00', 175000.00, 'THANH TOÁN TRỰC TUYẾN', 'ĐÃ HỦY', 'DH006'),
('TT007', '2025-03-11 00:00:00', 160000.00, 'THANH TOÁN KHI NHẬN HÀNG', 'ĐANG GIAO', 'DH007'),
('TT008', '2025-03-12 00:00:00', 210000.00, 'THANH TOÁN TRỰC TUYẾN', 'HOÀN THÀNH', 'DH008'),
('TT009', '2025-03-13 00:00:00', 145000.00, 'THANH TOÁN KHI NHẬN HÀNG', 'CHỜ XÁC NHẬN', 'DH009'),
('TT010', '2025-03-14 00:00:00', 230000.00, 'THANH TOÁN TRỰC TUYẾN', 'ĐÃ HỦY', 'DH010'),
('TT011', '2025-03-15 00:00:00', 140000.00, 'THANH TOÁN KHI NHẬN HÀNG', 'ĐANG GIAO', 'DH011'),
('TT012', '2025-03-16 00:00:00', 200000.00, 'THANH TOÁN TRỰC TUYẾN', 'HOÀN THÀNH', 'DH012'),
('TT013', '2025-03-17 00:00:00', 185000.00, 'THANH TOÁN KHI NHẬN HÀNG', 'CHỜ XÁC NHẬN', 'DH013'),
('TT014', '2025-03-18 00:00:00', 240000.00, 'THANH TOÁN TRỰC TUYẾN', 'ĐÃ HỦY', 'DH014'),
('TT015', '2025-03-19 00:00:00', 150000.00, 'THANH TOÁN KHI NHẬN HÀNG', 'ĐANG GIAO', 'DH015'),
('TT016', '2025-03-20 00:00:00', 180000.00, 'THANH TOÁN TRỰC TUYẾN', 'HOÀN THÀNH', 'DH016'),
('TT017', '2025-03-21 00:00:00', 220000.00, 'THANH TOÁN KHI NHẬN HÀNG', 'CHỜ XÁC NHẬN', 'DH017'),
('TT018', '2025-03-22 00:00:00', 130000.00, 'THANH TOÁN TRỰC TUYẾN', 'ĐÃ HỦY', 'DH018'),
('TT019', '2025-03-23 00:00:00', 250000.00, 'THANH TOÁN KHI NHẬN HÀNG', 'ĐANG GIAO', 'DH019'),
('TT020', '2025-03-24 00:00:00', 190000.00, 'THANH TOÁN TRỰC TUYẾN', 'HOÀN THÀNH', 'DH020'),
('TT021', '2025-03-25 00:00:00', 175000.00, 'THANH TOÁN KHI NHẬN HÀNG', 'CHỜ XÁC NHẬN', 'DH021'),
('TT022', '2025-03-26 00:00:00', 160000.00, 'THANH TOÁN TRỰC TUYẾN', 'ĐÃ HỦY', 'DH022'),
('TT023', '2025-03-27 00:00:00', 210000.00, 'THANH TOÁN KHI NHẬN HÀNG', 'ĐANG GIAO', 'DH023'),
('TT024', '2025-03-28 00:00:00', 145000.00, 'THANH TOÁN TRỰC TUYẾN', 'HOÀN THÀNH', 'DH024'),
('TT025', '2025-03-29 00:00:00', 230000.00, 'THANH TOÁN KHI NHẬN HÀNG', 'CHỜ XÁC NHẬN', 'DH025'),
('TT026', '2025-03-30 00:00:00', 140000.00, 'THANH TOÁN TRỰC TUYẾN', 'ĐÃ HỦY', 'DH026'),
('TT027', '2025-03-31 00:00:00', 200000.00, 'THANH TOÁN KHI NHẬN HÀNG', 'ĐANG GIAO', 'DH027'),
('TT028', '2025-04-01 00:00:00', 185000.00, 'THANH TOÁN TRỰC TUYẾN', 'HOÀN THÀNH', 'DH028'),
('TT029', '2025-04-02 00:00:00', 240000.00, 'THANH TOÁN KHI NHẬN HÀNG', 'CHỜ XÁC NHẬN', 'DH029'),
('TT030', '2025-04-03 00:00:00', 150000.00, 'THANH TOÁN TRỰC TUYẾN', 'ĐÃ HỦY', 'DH030'),
('TT031', '2025-04-04 00:00:00', 180000.00, 'THANH TOÁN KHI NHẬN HÀNG', 'ĐANG GIAO', 'DH031'),
('TT032', '2025-04-05 00:00:00', 220000.00, 'THANH TOÁN TRỰC TUYẾN', 'HOÀN THÀNH', 'DH032'),
('TT033', '2025-04-06 00:00:00', 130000.00, 'THANH TOÁN KHI NHẬN HÀNG', 'CHỜ XÁC NHẬN', 'DH033'),
('TT034', '2025-04-07 00:00:00', 250000.00, 'THANH TOÁN TRỰC TUYẾN', 'ĐÃ HỦY', 'DH034'),
('TT035', '2025-04-08 00:00:00', 190000.00, 'THANH TOÁN KHI NHẬN HÀNG', 'ĐANG GIAO', 'DH035'),
('TT036', '2025-04-09 00:00:00', 175000.00, 'THANH TOÁN TRỰC TUYẾN', 'HOÀN THÀNH', 'DH036'),
('TT037', '2025-04-10 00:00:00', 160000.00, 'THANH TOÁN KHI NHẬN HÀNG', 'CHỜ XÁC NHẬN', 'DH037');

--
-- Bẫy `thanh_toan`
--
DELIMITER $$
CREATE TRIGGER `trg_ThanhToan` BEFORE INSERT ON `thanh_toan` FOR EACH ROW BEGIN
    IF NEW.Trang_Thai_TT = 'Đã thanh toán' AND NEW.Ngay_Thanh_Toan IS NULL THEN
        SET NEW.Ngay_Thanh_Toan = NOW();
    END IF;
    
    IF NEW.Trang_Thai_TT = 'Đã thanh toán' THEN
        UPDATE DON_HANG
        SET Trang_Thai = 'Đã thanh toán'
        WHERE Ma_DH = NEW.Ma_DH;
    END IF;
END
$$
DELIMITER ;

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `chi_tiet_don_hang`
--
ALTER TABLE `chi_tiet_don_hang`
  ADD PRIMARY KEY (`Ma_DH`,`Ma_SP`),
  ADD KEY `IX_CTDH_MaSP` (`Ma_SP`),
  ADD KEY `IX_CTDH_SoLuong` (`So_Luong`),
  ADD KEY `IX_CTDH_MaDH_SoLuong_DonGia` (`Ma_DH`,`So_Luong`,`Don_Gia`);

--
-- Chỉ mục cho bảng `don_hang`
--
ALTER TABLE `don_hang`
  ADD PRIMARY KEY (`Ma_DH`),
  ADD KEY `IX_DON_HANG_MaKH` (`Ma_KH`),
  ADD KEY `IX_DON_HANG_NgayDat` (`Ngay_Dat`),
  ADD KEY `IX_DON_HANG_TrangThai` (`Trang_Thai`),
  ADD KEY `IX_DON_HANG_TrangThai_NgayDat` (`Trang_Thai`,`Ngay_Dat`);

--
-- Chỉ mục cho bảng `giao_hang`
--
ALTER TABLE `giao_hang`
  ADD PRIMARY KEY (`Ma_GH`),
  ADD KEY `IX_GIAO_HANG_MaDH` (`Ma_DH`),
  ADD KEY `IX_GIAO_HANG_NgayGiao` (`Ngay_Giao`),
  ADD KEY `IX_GIAO_HANG_TrangThai` (`Trang_Thai`);

--
-- Chỉ mục cho bảng `khach_hang`
--
ALTER TABLE `khach_hang`
  ADD PRIMARY KEY (`Ma_KH`),
  ADD KEY `IX_KHACH_HANG_SDT` (`SDT`),
  ADD KEY `IX_KHACH_HANG_HoTen` (`Ho_Ten`);

--
-- Chỉ mục cho bảng `quan_ly`
--
ALTER TABLE `quan_ly`
  ADD PRIMARY KEY (`Ma_QL`),
  ADD KEY `IX_QUAN_LY_SDT` (`SDT`),
  ADD KEY `IX_QUAN_LY_HoTen` (`Ho_Ten`);

--
-- Chỉ mục cho bảng `quan_ly_don_hang`
--
ALTER TABLE `quan_ly_don_hang`
  ADD PRIMARY KEY (`Ma_DH`,`Ma_QL`),
  ADD KEY `IX_QLDH_MaQL` (`Ma_QL`),
  ADD KEY `IX_QLDH_XuLy` (`Xu_Ly_Don_Hang`);

--
-- Chỉ mục cho bảng `san_pham`
--
ALTER TABLE `san_pham`
  ADD PRIMARY KEY (`Ma_SP`),
  ADD KEY `IX_SAN_PHAM_TenSP` (`Ten_SP`),
  ADD KEY `IX_SAN_PHAM_DonGia` (`Don_Gia`),
  ADD KEY `IX_SAN_PHAM_TinhTrang` (`Tinh_trang`);

--
-- Chỉ mục cho bảng `tai_khoan`
--
ALTER TABLE `tai_khoan`
  ADD PRIMARY KEY (`Ma_TK`),
  ADD KEY `fk_taikhoan_khachhang` (`Ma_KH`),
  ADD KEY `fk_taikhoan_quanly` (`Ma_QL`),
  ADD KEY `IX_TAI_KHOAN_MaTK` (`Ma_TK`),
  ADD KEY `IX_TAI_KHOAN_TenDangNhap` (`Ten_Dang_Nhap`),
  ADD KEY `IX_TAI_KHOAN_LoaiTK` (`Loai_TK`);

--
-- Chỉ mục cho bảng `thanh_toan`
--
ALTER TABLE `thanh_toan`
  ADD PRIMARY KEY (`Ma_HD`),
  ADD KEY `IX_THANH_TOAN_MaDH` (`Ma_DH`),
  ADD KEY `IX_THANH_TOAN_NgayTT` (`Ngay_Thanh_Toan`),
  ADD KEY `IX_THANH_TOAN_TrangThaiTT` (`Trang_Thai_TT`),
  ADD KEY `IX_THANH_TOAN_PhuongThuc` (`Phuong_Thuc`),
  ADD KEY `IX_THANH_TOAN_TrangThaiTT_NgayTT_SoTien` (`Trang_Thai_TT`,`Ngay_Thanh_Toan`,`So_Tien`);

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `chi_tiet_don_hang`
--
ALTER TABLE `chi_tiet_don_hang`
  ADD CONSTRAINT `fk_ctdh_donhang` FOREIGN KEY (`Ma_DH`) REFERENCES `don_hang` (`Ma_DH`),
  ADD CONSTRAINT `fk_ctdh_sanpham` FOREIGN KEY (`Ma_SP`) REFERENCES `san_pham` (`Ma_SP`);

--
-- Các ràng buộc cho bảng `don_hang`
--
ALTER TABLE `don_hang`
  ADD CONSTRAINT `fk_donhang_khachhang` FOREIGN KEY (`Ma_KH`) REFERENCES `khach_hang` (`Ma_KH`);

--
-- Các ràng buộc cho bảng `giao_hang`
--
ALTER TABLE `giao_hang`
  ADD CONSTRAINT `fk_giaohang_donhang` FOREIGN KEY (`Ma_DH`) REFERENCES `don_hang` (`Ma_DH`);

--
-- Các ràng buộc cho bảng `quan_ly_don_hang`
--
ALTER TABLE `quan_ly_don_hang`
  ADD CONSTRAINT `fk_qldh_donhang` FOREIGN KEY (`Ma_DH`) REFERENCES `don_hang` (`Ma_DH`),
  ADD CONSTRAINT `fk_qldh_quanly` FOREIGN KEY (`Ma_QL`) REFERENCES `quan_ly` (`Ma_QL`);

--
-- Các ràng buộc cho bảng `tai_khoan`
--
ALTER TABLE `tai_khoan`
  ADD CONSTRAINT `fk_taikhoan_khachhang` FOREIGN KEY (`Ma_KH`) REFERENCES `khach_hang` (`Ma_KH`),
  ADD CONSTRAINT `fk_taikhoan_quanly` FOREIGN KEY (`Ma_QL`) REFERENCES `quan_ly` (`Ma_QL`);

--
-- Các ràng buộc cho bảng `thanh_toan`
--
ALTER TABLE `thanh_toan`
  ADD CONSTRAINT `fk_thanhtoan_donhang` FOREIGN KEY (`Ma_DH`) REFERENCES `don_hang` (`Ma_DH`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
