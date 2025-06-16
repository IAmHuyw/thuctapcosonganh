DELIMITER //
CREATE PROCEDURE sp_DangNhap(
    IN p_Ten_Dang_Nhap VARCHAR(50),
    IN p_Mat_Khau VARCHAR(50)
)
BEGIN
    SELECT Ma_TK, Loai_TK
    FROM tai_khoan
    WHERE Ten_Dang_Nhap = p_Ten_Dang_Nhap
    AND Mat_Khau = p_Mat_Khau;
END //
DELIMITER ;