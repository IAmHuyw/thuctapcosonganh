use master
go
create database QLyDonHang
go
use QLyDonHang
go

Create table [KHACH_HANG] (
	[Ma_KH] Char(10) NOT NULL,
	[Ho_Ten] Nvarchar(40) NULL,
	[Dia_Chi] Nvarchar(30) NULL,
	[SDT] Char(15) NULL,
Primary Key  ([Ma_KH])
) 

Create table [QUAN_LY] (
	[Ma_QL] Char(10) NOT NULL,
	[Ho_Ten] Nvarchar(40) NULL,
	[SDT] Char(15) NULL,
Primary Key  ([Ma_QL])
) 

Create table [DON_HANG] (
	[Ma_DH] Char(10) NOT NULL,
	[Ma_KH] Char(10) NOT NULL,
	[Ngay_Dat] Datetime NULL,
	[Trang_Thai] Nvarchar(30) NULL,
Primary Key  ([Ma_DH])
) 

Create table [SAN_PHAM] (
	[Ma_SP] Char(10) NOT NULL,
	[Ten_SP] Nvarchar(40) NULL,
	[Don_Gia] Money NULL,
	[Mo_Ta] Nvarchar(50) NULL,
	[Tinh_Trang] Nvarchar(30) NULL,
	[So_Luong] Integer NULL,
Primary Key  ([Ma_SP])
) 

Create table [CHI_TIET_DON_HANG] (
	[Ma_DH] Char(10) NOT NULL,
	[Ma_SP] Char(10) NOT NULL,
	[So_Luong] Integer NULL,
	[Don_Gia] Money NULL,
Primary Key  ([Ma_DH],[Ma_SP])
) 

Create table [QUAN_LY_DON_HANG] (
	[Ma_DH] Char(10) NOT NULL,
	[Ma_QL] Char(10) NOT NULL,
	[Xu_Ly_Don_Hang] Nvarchar(30) NULL,
Primary Key  ([Ma_DH],[Ma_QL])
) 

Create table [THANH_TOAN] (
	[Ma_HD] Char(10) NOT NULL,
	[Ngay_Thanh_Toan] Datetime NULL,
	[So_Tien] Money NULL,
	[Phuong_Thuc] Nvarchar(30) NULL,
	[Trang_Thai_TT] Nvarchar(30) NULL,
	[Ma_DH] Char(10) NOT NULL,
Primary Key  ([Ma_HD])
) 

Create table [GIAO_HANG] (
	[Ma_GH] Char(10) NOT NULL,
	[Ngay_Giao] Datetime NULL,
	[Trang_Thai] Nvarchar(30) NULL,
	[Nguoi_GIao] Nvarchar(40) NULL,
	[Ma_DH] Char(10) NOT NULL,
Primary Key  ([Ma_GH])
) 

Create table [TAI_KHOAN] (
	[Ma_TK] Char(10) NOT NULL,
	[Ten_Dang_Nhap] Nvarchar(40) NULL,
	[Mat_Khau] Nchar(20) NULL,
	[Ma_QL] Char(10) NULL,
	[Loai_TK] Nvarchar(15) NULL,
	[Ma_KH] Char(10) NULL,
Primary Key  ([Ma_TK])  
) 


Alter table [DON_HANG] add  foreign key([Ma_KH]) references [KHACH_HANG] ([Ma_KH]) 
go
Alter table [TAI_KHOAN] add  foreign key([Ma_KH]) references [KHACH_HANG] ([Ma_KH]) 
go
Alter table [QUAN_LY_DON_HANG] add  foreign key([Ma_QL]) references [QUAN_LY] ([Ma_QL]) 
go
Alter table [TAI_KHOAN] add  foreign key([Ma_QL]) references [QUAN_LY] ([Ma_QL]) 
go
Alter table [CHI_TIET_DON_HANG] add  foreign key([Ma_DH]) references [DON_HANG] ([Ma_DH]) 
go
Alter table [QUAN_LY_DON_HANG] add  foreign key([Ma_DH]) references [DON_HANG] ([Ma_DH]) 
go
Alter table [THANH_TOAN] add  foreign key([Ma_DH]) references [DON_HANG] ([Ma_DH]) 
go
Alter table [GIAO_HANG] add  foreign key([Ma_DH]) references [DON_HANG] ([Ma_DH]) 
go
Alter table [CHI_TIET_DON_HANG] add  foreign key([Ma_SP]) references [SAN_PHAM] ([Ma_SP]) 
go
ALTER TABLE TAI_KHOAN
ADD CONSTRAINT CK_TAI_KHOAN_Loai_TK
CHECK (
    (Loai_TK = N'QUẢN LÝ' AND Ma_QL IS NOT NULL AND Ma_KH IS NULL)
    OR
    (Loai_TK = N'KHÁCH HÀNG' AND Ma_KH IS NOT NULL AND Ma_QL IS NULL)
);
ALTER TABLE TAI_KHOAN
ADD CONSTRAINT CK_TAI_KHOAN_Loai_TK_GiaTri
CHECK (Loai_TK IN (N'QUẢN LÝ', N'KHÁCH HÀNG'));

go
INSERT INTO QUAN_LY VALUES ('QL001', N'Nguyễn Văn An', '0901000001')
INSERT INTO QUAN_LY VALUES ('QL002', N'Trần Thị Bình', '0901000002')
INSERT INTO QUAN_LY VALUES ('QL003', N'Phạm Văn Cương', '0901000003')
INSERT INTO QUAN_LY VALUES ('QL004', N'Lê Thị Dào', '0901000004')
INSERT INTO QUAN_LY VALUES ('QL005', N'Hoàng Văn Nam', '0901000005')
INSERT INTO QUAN_LY VALUES ('QL006', N'Đặng Thị Hoa', '0901000006')
INSERT INTO QUAN_LY VALUES ('QL007', N'Nguyễn Văn Giàu', '0901000007')
INSERT INTO QUAN_LY VALUES ('QL008', N'Bùi Thị Hồng', '0901000008')
INSERT INTO QUAN_LY VALUES ('QL009', N'Trần Văn Hưng', '0901000009')
INSERT INTO QUAN_LY VALUES ('QL010', N'Nguyễn Thị Kiều', '0901000010')
INSERT INTO QUAN_LY VALUES ('QL011', N'Phạm Văn Long', '0901000011')
INSERT INTO QUAN_LY VALUES ('QL012', N'Nguyễn Thị Minh', '0901000012')
INSERT INTO QUAN_LY VALUES ('QL013', N'Lê Văn Nhân', '0901000013')
INSERT INTO QUAN_LY VALUES ('QL014', N'Nguyễn Thị Oanh', '0901000014')
INSERT INTO QUAN_LY VALUES ('QL015', N'Hoàng Văn Phúc', '0901000015')
INSERT INTO QUAN_LY VALUES ('QL016', N'Trần Văn Quyền', '0901000016')
INSERT INTO QUAN_LY VALUES ('QL017', N'Hồ Diên Sang', '0901000017')
INSERT INTO QUAN_LY VALUES ('QL018', N'Hồ Thị Tâm', '0901000018')
INSERT INTO QUAN_LY VALUES ('QL019', N'Hồ Công Tuyên', '0901000019')
INSERT INTO QUAN_LY VALUES ('QL020', N'Hoàng Yến Vy', '0901000020')

INSERT INTO KHACH_HANG VALUES ('KH001', N'Nguyễn Văn An', N'15 Láng Hạ, Ba Đình, HN', '0912345678')
INSERT INTO KHACH_HANG VALUES ('KH002', N'Trần Thị Bích Ngọc', N'45 Lê Lợi, Q.1, HCM', '0987654321')
INSERT INTO KHACH_HANG VALUES ('KH003', N'Lê Minh Tuấn', N'98 Hà Huy Tập, Đà Nẵng', '0901122334')
INSERT INTO KHACH_HANG VALUES ('KH004', N'Phạm Thị Mai Lan', N'8 3/2, Ninh Kiều, CT', '0933445566')
INSERT INTO KHACH_HANG VALUES ('KH005', N'Hồ Quốc Hưng', N'32 Lạch Tray, Hải Phòng', '0944556677')
INSERT INTO KHACH_HANG VALUES ('KH006', N'Ngô Thị Hồng Nhung', N'B12 Phú Hồng Thịnh', '0977888999')
INSERT INTO KHACH_HANG VALUES ('KH007', N'Dương Thanh Phong', N'25 Hồng Hải, Quảng Ninh', '0922233445')
INSERT INTO KHACH_HANG VALUES ('KH008', N'Đặng Thị Thu Hà', N'12 Trần Hưng Đạo, ĐL', '0955667788')
INSERT INTO KHACH_HANG VALUES ('KH009', N'Vũ Anh Dũng', N'7 Trần Đăng Ninh, NĐ', '0966778899')
INSERT INTO KHACH_HANG VALUES ('KH010', N'Bùi Thị Kim Oanh', N'Đoàn Kết, Tân Mỹ', '0933221144')
INSERT INTO KHACH_HANG VALUES ('KH011', N'Mai Văn Đức', N'18 Nguyễn Du, Hà Tĩnh', '0988776655')
INSERT INTO KHACH_HANG VALUES ('KH012', N'Tạ Thị Ngọc Bích', N'Phú Thành, Vĩnh Long', '0911999888')
INSERT INTO KHACH_HANG VALUES ('KH013', N'Hoàng Gia Bảo', N'3 Phan Đình Phùng', '0900554433')
INSERT INTO KHACH_HANG VALUES ('KH014', N'Đoàn Thị Phương Thảo', N'78 Nguyễn Hội, PT', '0944223355')
INSERT INTO KHACH_HANG VALUES ('KH015', N'La Công Minh', N'27 Lê Hồng Phong', '0933112233')
INSERT INTO KHACH_HANG VALUES ('KH016', N'Trịnh Thị Bảo Trân', N'5 Tân Quang, TQ', '0922113344')
INSERT INTO KHACH_HANG VALUES ('KH017', N'Tôn Văn Lâm', N'9 Bắc Sơn, HY', '0977334466')
INSERT INTO KHACH_HANG VALUES ('KH018', N'Tống Thị Tuyết Mai', N'36 Trường Thi, TH', '0955778899')
INSERT INTO KHACH_HANG VALUES ('KH019', N'Lương Hoàng Nam', N'5 Nguyễn Huệ, TH', '0966443322')
INSERT INTO KHACH_HANG VALUES ('KH020', N'Phùng Thị Khánh Linh', N'Châu Thành, BL', '0900332211')

INSERT INTO SAN_PHAM VALUES ('SP001', N'Áo thun cotton', 150000, N'Áo thun nam/nữ, chất liệu cotton thoáng mát', N'Còn hàng', 500)
INSERT INTO SAN_PHAM VALUES ('SP002', N'Quần jeans', 250000, N'Quần jeans dài, nhiều kiểu dáng', N'Còn hàng', 300)
INSERT INTO SAN_PHAM VALUES ('SP003', N'Giày thể thao', 350000, N'Giày sneaker năng động', N'Còn hàng', 250)
INSERT INTO SAN_PHAM VALUES ('SP004', N'Ba lô du lịch', 200000, N'Ba lô cỡ vừa, nhiều ngăn', N'Còn hàng', 400)
INSERT INTO SAN_PHAM VALUES ('SP005', N'Mũ lưỡi trai', 80000, N'Mũ lưỡi trai thời trang', N'Còn hàng', 600)
INSERT INTO SAN_PHAM VALUES ('SP006', N'Kính râm', 120000, N'Kính mát chống tia UV', N'Còn hàng', 550)
INSERT INTO SAN_PHAM VALUES ('SP007', N'Đồng hồ đeo tay', 450000, N'Đồng hồ quartz, nhiều mẫu', N'Còn hàng', 150)
INSERT INTO SAN_PHAM VALUES ('SP008', N'Ví da', 180000, N'Ví da nam/nữ', N'Còn hàng', 350)
INSERT INTO SAN_PHAM VALUES ('SP009', N'Dây lưng', 100000, N'Dây lưng da', N'Còn hàng', 450)
INSERT INTO SAN_PHAM VALUES ('SP010', N'Khăn choàng', 90000, N'Khăn choàng lụa mềm mại', N'Còn hàng', 500)
INSERT INTO SAN_PHAM VALUES ('SP011', N'Sách tiểu thuyết', 80000, N'Tiểu thuyết trinh thám', N'Còn hàng', 200)
INSERT INTO SAN_PHAM VALUES ('SP012', N'Truyện tranh', 25000, N'Bộ truyện tranh nổi tiếng', N'Còn hàng', 700)
INSERT INTO SAN_PHAM VALUES ('SP013', N'Vở học sinh', 10000, N'Quyển vở 200 trang', N'Còn hàng', 1000)
INSERT INTO SAN_PHAM VALUES ('SP014', N'Bút bi', 5000, N'Chiếc bút bi mực xanh', N'Còn hàng', 2000)
INSERT INTO SAN_PHAM VALUES ('SP015', N'Máy tính cầm tay', 150000, N'Máy tính khoa học', N'Còn hàng', 10)
INSERT INTO SAN_PHAM VALUES ('SP016', N'Tai nghe', 120000, N'Tai nghe có dây', N'Còn hàng', 300)
INSERT INTO SAN_PHAM VALUES ('SP017', N'Loa Bluetooth', 280000, N'Loa di động nhỏ gọn', N'Còn hàng', 180)
INSERT INTO SAN_PHAM VALUES ('SP018', N'Pin sạc dự phòng', 220000, N'Pin dung lượng 10000mAh', N'Còn hàng', 220)
INSERT INTO SAN_PHAM VALUES ('SP019', N'Cáp sạc điện thoại', 30000, N'Cáp USB Type-C', N'Còn hàng', 800)
INSERT INTO SAN_PHAM VALUES ('SP020', N'Ốp lưng điện thoại', 50000, N'Ốp lưng silicon', N'Còn hàng', 650)

INSERT INTO TAI_KHOAN VALUES ('TK001', N'XIAOCHAOAN', N'PASSWORD001', 'QL001', N'QUẢN LÝ', null)
INSERT INTO TAI_KHOAN VALUES ('TK002', N'BINHMESSI', 'PASSWORD002', 'QL002', N'QUẢN LÝ',null)
INSERT INTO TAI_KHOAN VALUES ('TK003', N'CUONGRONADOL', 'PASSWORD003', 'QL003', N'QUẢN LÝ', null)
INSERT INTO TAI_KHOAN VALUES ('TK004', N'CRISSDAO', 'PASSWORD004', 'QL004', N'QUẢN LÝ', null)
INSERT INTO TAI_KHOAN VALUES ('TK005', N'NAMTNT', 'PASSWORD005', 'QL005', N'QUẢN LÝ', null)
INSERT INTO TAI_KHOAN VALUES ('TK006', N'HOABEUTY', 'PASSWORD006', 'QL006', N'QUẢN LÝ', null)
INSERT INTO TAI_KHOAN VALUES ('TK007', N'NGUYENRICH', 'PASSWORD007', 'QL002', N'QUẢN LÝ', null)
INSERT INTO TAI_KHOAN VALUES ('TK008', N'HONGROSE', 'PASSWORD008', 'QL007', N'QUẢN LÝ', null)
INSERT INTO TAI_KHOAN VALUES ('TK009', N'HUNG LUKAKU', 'PASSWORD009', 'QL008', N'QUẢN LÝ', null)
INSERT INTO TAI_KHOAN VALUES ('TK010', N'KIEUXINGGAI', 'PASSWORD010', 'QL009', N'QUẢN LÝ', null)
INSERT INTO TAI_KHOAN VALUES ('TK011', N'LONGKAKA', 'PASSWORD011', 'QL010', N'QUẢN LÝ', null)
INSERT INTO TAI_KHOAN VALUES ('TK012', N'MINHBECLING', 'PASSWORD012', 'QL011', N'QUẢN LÝ', null)
INSERT INTO TAI_KHOAN VALUES ('TK013', N'NHANBUSQUE', 'PASSWORD013', 'QL012', N'QUẢN LÝ', null)
INSERT INTO TAI_KHOAN VALUES ('TK014', N'OANH37', 'PASSWORD0014', 'QL013', N'QUẢN LÝ', null)
INSERT INTO TAI_KHOAN VALUES ('TK015', N'PHUCDU', 'PASSWORD0015', 'QL014', N'QUẢN LÝ', null)
INSERT INTO TAI_KHOAN VALUES ('TK016', N'QUYENSINGER', 'PASSWORD016', 'QL015', N'QUẢN LÝ', null)
INSERT INTO TAI_KHOAN VALUES ('TK017', N'SANGLOSER', 'PASSWORD017', 'QL016', N'QUẢN LÝ', null)
INSERT INTO TAI_KHOAN VALUES ('TK018', N'THITAM', 'PASSWORD0018', 'QL017', N'QUẢN LÝ', null)
INSERT INTO TAI_KHOAN VALUES ('TK019', N'HOTUYEN', 'PASSWORD0019', 'QL018', N'QUẢN LÝ', null)
INSERT INTO TAI_KHOAN VALUES ('TK020', N'VYXINGGAI', 'PASSWORD0020', 'QL019', N'QUẢN LÝ', null)

INSERT INTO DON_HANG VALUES ('DH001', 'KH001', '2025-03-01', N'Đã đặt')
INSERT INTO DON_HANG VALUES ('DH002', 'KH001', '2025-03-02', N'Đang giao')
INSERT INTO DON_HANG VALUES ('DH003', 'KH002', '2025-03-01', N'Hoàn thành')
INSERT INTO DON_HANG VALUES ('DH004', 'KH003', '2025-03-02', N'Đã hủy')
INSERT INTO DON_HANG VALUES ('DH005', 'KH003', '2025-03-02', N'Đã đặt')
INSERT INTO DON_HANG VALUES ('DH006', 'KH003', '2025-03-06', N'Đang giao')
INSERT INTO DON_HANG VALUES ('DH007', 'KH003', '2025-03-03', N'Hoàn thành')
INSERT INTO DON_HANG VALUES ('DH008', 'KH004', '2025-03-03', N'Đã hủy')
INSERT INTO DON_HANG VALUES ('DH009', 'KH004', '2025-03-23', N'Đã đặt');
INSERT INTO DON_HANG VALUES ('DH010', 'KH004', '2025-03-10', N'Đang giao')
INSERT INTO DON_HANG VALUES ('DH011', 'KH005', '2025-03-19', N'Hoàn thành')
INSERT INTO DON_HANG VALUES ('DH012', 'KH005', '2025-03-02', N'Đã hủy')
INSERT INTO DON_HANG VALUES ('DH013', 'KH006', '2025-03-13', N'Đã đặt');
INSERT INTO DON_HANG VALUES ('DH014', 'KH007', '2025-03-18', N'Đang giao')
INSERT INTO DON_HANG VALUES ('DH015', 'KH007', '2025-03-15', N'Hoàn thành')
INSERT INTO DON_HANG VALUES ('DH016', 'KH007', '2025-03-16', N'Đã hủy')
INSERT INTO DON_HANG VALUES ('DH017', 'KH008', '2025-03-07', N'Đã đặt');
INSERT INTO DON_HANG VALUES ('DH018', 'KH009', '2025-03-18', N'Đang giao')
INSERT INTO DON_HANG VALUES ('DH019', 'KH010', '2025-03-29', N'Hoàn thành')
INSERT INTO DON_HANG VALUES ('DH020', 'KH010', '2025-03-20', N'Đã hủy')
INSERT INTO DON_HANG VALUES ('DH021', 'KH010', '2025-03-21', N'Đã đặt');
INSERT INTO DON_HANG VALUES ('DH022', 'KH011', '2025-03-22', N'Đang giao')
INSERT INTO DON_HANG VALUES ('DH023', 'KH012', '2025-03-03', N'Hoàn thành')
INSERT INTO DON_HANG VALUES ('DH024', 'KH012', '2025-03-24', N'Đã hủy')
INSERT INTO DON_HANG VALUES ('DH025', 'KH013', '2025-03-25', N'Đã đặt');
INSERT INTO DON_HANG VALUES ('DH026', 'KH014', '2025-03-26', N'Đang giao')
INSERT INTO DON_HANG VALUES ('DH027', 'KH014', '2025-03-07', N'Hoàn thành')
INSERT INTO DON_HANG VALUES ('DH028', 'KH014', '2025-03-28', N'Đã hủy')
INSERT INTO DON_HANG VALUES ('DH029', 'KH015', '2025-03-17', N'Đã đặt')
INSERT INTO DON_HANG VALUES ('DH030', 'KH016', '2025-03-30', N'Hoàn thành')
INSERT INTO DON_HANG VALUES ('DH031', 'KH016', '2025-03-31', N'Hoàn thành')
INSERT INTO DON_HANG VALUES ('DH032', 'KH017', '2025-03-10', N'Đã đặt')
INSERT INTO DON_HANG VALUES ('DH033', 'KH018', '2025-03-30', N'Đang giao')
INSERT INTO DON_HANG VALUES ('DH034', 'KH018', '2025-03-20', N'Hoàn thành')
INSERT INTO DON_HANG VALUES ('DH035', 'KH019', '2025-03-13', N'Đã đặt')
INSERT INTO DON_HANG VALUES ('DH036', 'KH020', '2025-03-29', N'Hoàn thành')
INSERT INTO DON_HANG VALUES ('DH037', 'KH020', '2025-03-21', N'Đang giao')

INSERT INTO QUAN_LY_DON_HANG VALUES ('DH001', 'QL001', N'Chưa xử lý')
INSERT INTO QUAN_LY_DON_HANG VALUES ('DH002', 'QL001', N'Đang xử lý')
INSERT INTO QUAN_LY_DON_HANG VALUES ('DH003', 'QL001', N'Xử lý thành công')
INSERT INTO QUAN_LY_DON_HANG VALUES ('DH004', 'QL002', N'Xử lý thành công')
INSERT INTO QUAN_LY_DON_HANG VALUES ('DH005', 'QL002', N'Chưa xử lý')
INSERT INTO QUAN_LY_DON_HANG VALUES ('DH006', 'QL003', N'Đang xử lý')
INSERT INTO QUAN_LY_DON_HANG VALUES ('DH007', 'QL003', N'Xử lý thành công')
INSERT INTO QUAN_LY_DON_HANG VALUES ('DH008', 'QL004', N'Xử lý thành công')
INSERT INTO QUAN_LY_DON_HANG VALUES ('DH009', 'QL005', N'Chưa xử lý')
INSERT INTO QUAN_LY_DON_HANG VALUES ('DH010', 'QL005', N'Đang xử lý')
INSERT INTO QUAN_LY_DON_HANG VALUES ('DH011', 'QL005', N'Xử lý thành công')
INSERT INTO QUAN_LY_DON_HANG VALUES ('DH012', 'QL005', N'Xử lý thành công')
INSERT INTO QUAN_LY_DON_HANG VALUES ('DH013', 'QL006', N'Chưa xử lý')
INSERT INTO QUAN_LY_DON_HANG VALUES ('DH014', 'QL006', N'Đang xử lý')
INSERT INTO QUAN_LY_DON_HANG VALUES ('DH015', 'QL007', N'Xử lý thành công')
INSERT INTO QUAN_LY_DON_HANG VALUES ('DH016', 'QL007', N'Xử lý thành công')
INSERT INTO QUAN_LY_DON_HANG VALUES ('DH017', 'QL008', N'Chưa xử lý')
INSERT INTO QUAN_LY_DON_HANG VALUES ('DH018', 'QL009', N'Đang xử lý')
INSERT INTO QUAN_LY_DON_HANG VALUES ('DH019', 'QL010', N'Xử lý thành công')
INSERT INTO QUAN_LY_DON_HANG VALUES ('DH020', 'QL011', N'Xử lý thành công')
INSERT INTO QUAN_LY_DON_HANG VALUES ('DH021', 'QL011', N'Chưa xử lý')
INSERT INTO QUAN_LY_DON_HANG VALUES ('DH022', 'QL012', N'Đang xử lý')
INSERT INTO QUAN_LY_DON_HANG VALUES ('DH023', 'QL013', N'Xử lý thành công')
INSERT INTO QUAN_LY_DON_HANG VALUES ('DH024', 'QL014', N'Xử lý thành công')
INSERT INTO QUAN_LY_DON_HANG VALUES ('DH025', 'QL015', N'Chưa xử lý')
INSERT INTO QUAN_LY_DON_HANG VALUES ('DH026', 'QL015', N'Đang xử lý')
INSERT INTO QUAN_LY_DON_HANG VALUES ('DH027', 'QL015', N'Xử lý thành công')
INSERT INTO QUAN_LY_DON_HANG VALUES ('DH028', 'QL015', N'Xử lý thành công')
INSERT INTO QUAN_LY_DON_HANG VALUES ('DH029', 'QL016', N'Chưa xử lý')
INSERT INTO QUAN_LY_DON_HANG VALUES ('DH030', 'QL016', N'Xử lý thành công')
INSERT INTO QUAN_LY_DON_HANG VALUES ('DH031', 'QL017', N'Xử lý thành công')
INSERT INTO QUAN_LY_DON_HANG VALUES ('DH032', 'QL017', N'Chưa xử lý')
INSERT INTO QUAN_LY_DON_HANG VALUES ('DH033', 'QL018', N'Đang xử lý')
INSERT INTO QUAN_LY_DON_HANG VALUES ('DH034', 'QL018', N'Xử lý thành công')
INSERT INTO QUAN_LY_DON_HANG VALUES ('DH035', 'QL018', N'Chưa xử lý')
INSERT INTO QUAN_LY_DON_HANG VALUES ('DH036', 'QL019', N'Xử lý thành công')
INSERT INTO QUAN_LY_DON_HANG VALUES ('DH037', 'QL020', N'Đang xử lý')

INSERT INTO CHI_TIET_DON_HANG VALUES ('DH001', 'SP001', 1, 150000)
INSERT INTO CHI_TIET_DON_HANG VALUES ('DH002', 'SP002', 1, 250000)
INSERT INTO CHI_TIET_DON_HANG VALUES ('DH003', 'SP003', 1, 350000)
INSERT INTO CHI_TIET_DON_HANG VALUES ('DH004', 'SP004', 1, 200000)
INSERT INTO CHI_TIET_DON_HANG VALUES ('DH005', 'SP005', 1, 80000)
INSERT INTO CHI_TIET_DON_HANG VALUES ('DH006', 'SP006', 1, 120000)
INSERT INTO CHI_TIET_DON_HANG VALUES ('DH007', 'SP007', 1, 450000)
INSERT INTO CHI_TIET_DON_HANG VALUES ('DH008', 'SP008', 1, 180000)
INSERT INTO CHI_TIET_DON_HANG VALUES ('DH009', 'SP009', 1, 100000)
INSERT INTO CHI_TIET_DON_HANG VALUES ('DH010', 'SP010', 1, 90000)
INSERT INTO CHI_TIET_DON_HANG VALUES ('DH011', 'SP011', 1, 80000)
INSERT INTO CHI_TIET_DON_HANG VALUES ('DH012', 'SP012', 1, 25000)
INSERT INTO CHI_TIET_DON_HANG VALUES ('DH013', 'SP013', 1, 10000)
INSERT INTO CHI_TIET_DON_HANG VALUES ('DH014', 'SP014', 1, 5000)
INSERT INTO CHI_TIET_DON_HANG VALUES ('DH015', 'SP015', 1, 150000)
INSERT INTO CHI_TIET_DON_HANG VALUES ('DH016', 'SP016', 1, 120000)
INSERT INTO CHI_TIET_DON_HANG VALUES ('DH017', 'SP017', 1, 280000)
INSERT INTO CHI_TIET_DON_HANG VALUES ('DH018', 'SP018', 1, 220000)
INSERT INTO CHI_TIET_DON_HANG VALUES ('DH019', 'SP019', 1, 30000)
INSERT INTO CHI_TIET_DON_HANG VALUES ('DH020', 'SP020', 1, 50000)

INSERT INTO THANH_TOAN VALUES ('TT001', '2025-03-05', 180000, N'THANH TOÁN KHI NHẬN HÀNG', N'CHỜ XÁC NHẬN', 'DH001');
INSERT INTO THANH_TOAN VALUES ('TT002', '2025-03-06', 220000, N'THANH TOÁN TRỰC TUYẾN', N'ĐÃ HỦY', 'DH002');
INSERT INTO THANH_TOAN VALUES ('TT003', '2025-03-07', 130000, N'THANH TOÁN KHI NHẬN HÀNG', N'ĐANG GIAO', 'DH003');
INSERT INTO THANH_TOAN VALUES ('TT004', '2025-03-08', 250000, N'THANH TOÁN TRỰC TUYẾN', N'HOÀN THÀNH', 'DH004');
INSERT INTO THANH_TOAN VALUES ('TT005', '2025-03-09', 190000, N'THANH TOÁN KHI NHẬN HÀNG', N'CHỜ XÁC NHẬN', 'DH005');
INSERT INTO THANH_TOAN VALUES ('TT006', '2025-03-10', 175000, N'THANH TOÁN TRỰC TUYẾN', N'ĐÃ HỦY', 'DH006');
INSERT INTO THANH_TOAN VALUES ('TT007', '2025-03-11', 160000, N'THANH TOÁN KHI NHẬN HÀNG', N'ĐANG GIAO', 'DH007');
INSERT INTO THANH_TOAN VALUES ('TT008', '2025-03-12', 210000, N'THANH TOÁN TRỰC TUYẾN', N'HOÀN THÀNH', 'DH008');
INSERT INTO THANH_TOAN VALUES ('TT009', '2025-03-13', 145000, N'THANH TOÁN KHI NHẬN HÀNG', N'CHỜ XÁC NHẬN', 'DH009');
INSERT INTO THANH_TOAN VALUES ('TT010', '2025-03-14', 230000, N'THANH TOÁN TRỰC TUYẾN', N'ĐÃ HỦY', 'DH010');
INSERT INTO THANH_TOAN VALUES ('TT011', '2025-03-15', 140000, N'THANH TOÁN KHI NHẬN HÀNG', N'ĐANG GIAO', 'DH011');
INSERT INTO THANH_TOAN VALUES ('TT012', '2025-03-16', 200000, N'THANH TOÁN TRỰC TUYẾN', N'HOÀN THÀNH', 'DH012');
INSERT INTO THANH_TOAN VALUES ('TT013', '2025-03-17', 185000, N'THANH TOÁN KHI NHẬN HÀNG', N'CHỜ XÁC NHẬN', 'DH013');
INSERT INTO THANH_TOAN VALUES ('TT014', '2025-03-18', 240000, N'THANH TOÁN TRỰC TUYẾN', N'ĐÃ HỦY', 'DH014');
INSERT INTO THANH_TOAN VALUES ('TT015', '2025-03-19', 150000, N'THANH TOÁN KHI NHẬN HÀNG', N'ĐANG GIAO', 'DH015');
INSERT INTO THANH_TOAN VALUES ('TT016', '2025-03-20', 180000, N'THANH TOÁN TRỰC TUYẾN', N'HOÀN THÀNH', 'DH016');
INSERT INTO THANH_TOAN VALUES ('TT017', '2025-03-21', 220000, N'THANH TOÁN KHI NHẬN HÀNG', N'CHỜ XÁC NHẬN', 'DH017');
INSERT INTO THANH_TOAN VALUES ('TT018', '2025-03-22', 130000, N'THANH TOÁN TRỰC TUYẾN', N'ĐÃ HỦY', 'DH018');
INSERT INTO THANH_TOAN VALUES ('TT019', '2025-03-23', 250000, N'THANH TOÁN KHI NHẬN HÀNG', N'ĐANG GIAO', 'DH019');
INSERT INTO THANH_TOAN VALUES ('TT020', '2025-03-24', 190000, N'THANH TOÁN TRỰC TUYẾN', N'HOÀN THÀNH', 'DH020');
INSERT INTO THANH_TOAN VALUES ('TT021', '2025-03-25', 175000, N'THANH TOÁN KHI NHẬN HÀNG', N'CHỜ XÁC NHẬN', 'DH021');
INSERT INTO THANH_TOAN VALUES ('TT022', '2025-03-26', 160000, N'THANH TOÁN TRỰC TUYẾN', N'ĐÃ HỦY', 'DH022');
INSERT INTO THANH_TOAN VALUES ('TT023', '2025-03-27', 210000, N'THANH TOÁN KHI NHẬN HÀNG', N'ĐANG GIAO', 'DH023');
INSERT INTO THANH_TOAN VALUES ('TT024', '2025-03-28', 145000, N'THANH TOÁN TRỰC TUYẾN', N'HOÀN THÀNH', 'DH024');
INSERT INTO THANH_TOAN VALUES ('TT025', '2025-03-29', 230000, N'THANH TOÁN KHI NHẬN HÀNG', N'CHỜ XÁC NHẬN', 'DH025');
INSERT INTO THANH_TOAN VALUES ('TT026', '2025-03-30', 140000, N'THANH TOÁN TRỰC TUYẾN', N'ĐÃ HỦY', 'DH026');
INSERT INTO THANH_TOAN VALUES ('TT027', '2025-03-31', 200000, N'THANH TOÁN KHI NHẬN HÀNG', N'ĐANG GIAO', 'DH027');
INSERT INTO THANH_TOAN VALUES ('TT028', '2025-04-01', 185000, N'THANH TOÁN TRỰC TUYẾN', N'HOÀN THÀNH', 'DH028');
INSERT INTO THANH_TOAN VALUES ('TT029', '2025-04-02', 240000, N'THANH TOÁN KHI NHẬN HÀNG', N'CHỜ XÁC NHẬN', 'DH029');
INSERT INTO THANH_TOAN VALUES ('TT030', '2025-04-03', 150000, N'THANH TOÁN TRỰC TUYẾN', N'ĐÃ HỦY', 'DH030');
INSERT INTO THANH_TOAN VALUES ('TT031', '2025-04-04', 180000, N'THANH TOÁN KHI NHẬN HÀNG', N'ĐANG GIAO', 'DH031');
INSERT INTO THANH_TOAN VALUES ('TT032', '2025-04-05', 220000, N'THANH TOÁN TRỰC TUYẾN', N'HOÀN THÀNH', 'DH032');
INSERT INTO THANH_TOAN VALUES ('TT033', '2025-04-06', 130000, N'THANH TOÁN KHI NHẬN HÀNG', N'CHỜ XÁC NHẬN', 'DH033');
INSERT INTO THANH_TOAN VALUES ('TT034', '2025-04-07', 250000, N'THANH TOÁN TRỰC TUYẾN', N'ĐÃ HỦY', 'DH034');
INSERT INTO THANH_TOAN VALUES ('TT035', '2025-04-08', 190000, N'THANH TOÁN KHI NHẬN HÀNG', N'ĐANG GIAO', 'DH035');
INSERT INTO THANH_TOAN VALUES ('TT036', '2025-04-09', 175000, N'THANH TOÁN TRỰC TUYẾN', N'HOÀN THÀNH', 'DH036');
INSERT INTO THANH_TOAN VALUES ('TT037', '2025-04-10', 160000, N'THANH TOÁN KHI NHẬN HÀNG', N'CHỜ XÁC NHẬN', 'DH037');

INSERT INTO GIAO_HANG VALUES ('GH001', '2025/04/01', N'Thành công', N'Hồ Công Huy', 'DH001')
INSERT INTO GIAO_HANG VALUES ('GH002', '2025/04/02', N'Đang giao', N'Nguyễn Hữu Trường', 'DH002')
INSERT INTO GIAO_HANG VALUES ('GH003', '2025/04/03', N'Chưa giao', N'Nguyễn Duy Việt', 'DH003')
INSERT INTO GIAO_HANG VALUES ('GH004', '2025/04/04', N'Thành công', N'Nguyễn Thái Đạt', 'DH004')
INSERT INTO GIAO_HANG VALUES ('GH005', '2025/04/05', N'Đang giao', N'Đặng Bá Tuấn Anh', 'DH005')
INSERT INTO GIAO_HANG VALUES ('GH006', '2025/04/06', N'Thành công', N'Nguyễn Nam Trường', 'DH006')
INSERT INTO GIAO_HANG VALUES ('GH007', '2025/04/07', N'Chưa giao', N'Đào Quang Tùng', 'DH007')
INSERT INTO GIAO_HANG VALUES ('GH008', '2025/04/08', N'Thành công', N'Phạm Thị Phương', 'DH008')
INSERT INTO GIAO_HANG VALUES ('GH009', '2025/04/09', N'Đang giao', N'Nguyễn Thị Oanh', 'DH009')
INSERT INTO GIAO_HANG VALUES ('GH010', '2025/04/10', N'Thành công', N'Vũ Thị Phượng', 'DH010')
INSERT INTO GIAO_HANG VALUES ('GH011', '2025/04/11', N'Đang giao', N'Nguyễn Thị Thanh', 'DH011')
INSERT INTO GIAO_HANG VALUES ('GH012', '2025/04/12', N'Thành công', N'Nguyễn Thị Minh', 'DH012')
INSERT INTO GIAO_HANG VALUES ('GH013', '2025/04/13', N'Chưa giao', N'Đào Duy Sơn', 'DH013')
INSERT INTO GIAO_HANG VALUES ('GH014', '2025/04/14', N'Đang giao', N'Hồ Công Huy', 'DH014')
INSERT INTO GIAO_HANG VALUES ('GH015', '2025/04/15', N'Thành công', N'Nguyễn Thị Thanh', 'DH015')
INSERT INTO GIAO_HANG VALUES ('GH016', '2025/04/16', N'Thành công', N'Nguyễn Hữu Trường', 'DH016')
INSERT INTO GIAO_HANG VALUES ('GH017', '2025/04/17', N'Đang giao', N'Phạm Thị Phương', 'DH017')
INSERT INTO GIAO_HANG VALUES ('GH018', '2025/04/18', N'Thành công', N'Nguyễn Duy Việt', 'DH018')
INSERT INTO GIAO_HANG VALUES ('GH019', '2025/04/19', N'Chưa giao', N'Nguyễn Thị Oanh', 'DH019')
INSERT INTO GIAO_HANG VALUES ('GH020', '2025/04/20', N'Đang giao', N'Phạm Thị Phương', 'DH020')

CREATE INDEX IX_KhACH_HANG_SDT on KHACH_HANG(SDT)
CREATE INDEX IX_KHACH_HANG_HoTen ON KHACH_HANG(Ho_Ten)

CREATE INDEX IX_QUAN_LY_SDT ON QUAN_LY(SDT)
CREATE INDEX IX_QUAN_LY_HoTen ON QUAN_LY(Ho_Ten)

CREATE INDEX IX_DON_HANG_MaKH ON DON_HANG(Ma_KH)
CREATE INDEX IX_DON_HANG_NgayDat ON DON_HANG(Ngay_Dat)
CREATE INDEX IX_DON_HANG_TrangThai ON DON_HANG(Trang_Thai)

CREATE INDEX IX_SAN_PHAM_TenSP ON SAN_PHAM(Ten_SP)
CREATE INDEX IX_SAN_PHAM_DonGia ON SAN_PHAM(Don_Gia)
CREATE INDEX IX_SAN_PHAM_TinhTrang ON SAN_PHAM(Tinh_Trang)

CREATE INDEX IX_CTDH_MaSP ON CHI_TIET_DON_HANG(Ma_SP)
CREATE INDEX IX_CTDH_SoLuong ON CHI_TIET_DON_HANG(So_Luong)

CREATE INDEX IX_QLDH_MaQL ON QUAN_LY_DON_HANG(Ma_QL)
CREATE INDEX IX_QLDH_XuLy ON QUAN_LY_DON_HANG(Xu_ly_don_hang)

CREATE INDEX IX_THANH_TOAN_MaDH ON THANH_TOAN(Ma_DH)
CREATE INDEX IX_THANH_TOAN_NgayTT ON THANH_TOAN(Ngay_Thanh_Toan)
CREATE INDEX IX_THANH_TOAN_TrangThaiTT ON THANH_TOAN(Trang_Thai_TT)
CREATE INDEX IX_THANH_TOAN_PhuongThuc ON THANH_TOAN(Phuong_Thuc)

CREATE INDEX IX_GIAO_HANG_MaDH ON GIAO_HANG(Ma_DH)
CREATE INDEX IX_GIAO_HANG_NgayGiao ON GIAO_HANG(Ngay_Giao)
CREATE INDEX IX_GIAO_HANG_TrangThai ON GIAO_HANG(Trang_Thai)

CREATE INDEX IX_TAI_KHOAN_MaTK ON TAI_KHOAN(Ma_TK)
CREATE INDEX IX_TAI_KHOAN_TenDangNhap ON TAI_KHOAN(Ten_Dang_Nhap)
CREATE INDEX IX_TAI_KHOAN_MaQL ON TAI_KHOAN(Ma_QL) WHERE Ma_QL IS NOT NULL
CREATE INDEX IX_TAI_KHOAN_MaKH ON TAI_KHOAN(Ma_KH) WHERE Ma_KH IS NOT NULL
CREATE INDEX IX_TAI_KHOAN_LoaiTK ON TAI_KHOAN(Loai_TK)

-- Chỉ mục kết hợp cho bảng DON_HANG (thường xuyên truy vấn theo cả trạng thái và ngày)
CREATE INDEX IX_DON_HANG_TrangThai_NgayDat ON DON_HANG(Trang_Thai, Ngay_Dat)

-- Chỉ mục kết hợp cho bảng CHI_TIET_DON_HANG (thường xuyên tính toán tổng tiền)
CREATE INDEX IX_CTDH_MaDH_SoLuong_DonGia ON CHI_TIET_DON_HANG(Ma_DH, So_Luong, Don_Gia)

-- Chỉ mục bao phủ cho các báo cáo thống kê
CREATE INDEX IX_THANH_TOAN_TrangThaiTT_NgayTT_SoTien ON THANH_TOAN(Trang_Thai_TT, Ngay_Thanh_Toan, So_Tien)

--lấy danh sách khách hàng từ Hà Nội
SELECT Ma_KH, Ho_Ten, SDT 
FROM KHACH_HANG 
WHERE Dia_Chi LIKE N'%HN%';
--đếm số đơn hàng theo trạng thái
SET STATISTICS TIME ON;
GO
SELECT Trang_Thai, COUNT(*) AS SoLuongDonHang
FROM DON_HANG
GROUP BY Trang_Thai;
GO
SET STATISTICS TIME OFF;
--tính tổng số tiền thanh toán theo phương thức
SET STATISTICS TIME ON;
GO
SELECT Phuong_Thuc, SUM(So_Tien) AS TongTien
FROM THANH_TOAN
GROUP BY Phuong_Thuc;
GO
SET STATISTICS TIME OFF;
--Lấy sản phẩm có giá từ 100.000 đến 200.000
SELECT Ma_SP, Ten_SP, Don_Gia
FROM SAN_PHAM
WHERE Don_Gia BETWEEN 100000 AND 200000
ORDER BY Don_Gia DESC;
---Truy vấn JOIN giữa các bảng
--Lấy thông tin đơn hàng kèm thông tin khách hàng
SELECT dh.Ma_DH, dh.Ngay_Dat, dh.Trang_Thai, 
       kh.Ho_Ten AS TenKhachHang, kh.SDT, kh.Dia_Chi
FROM DON_HANG dh
JOIN KHACH_HANG kh ON dh.Ma_KH = kh.Ma_KH;
--Lấy chi tiết đơn hàng với tên snar phẩm
SELECT ctdh.Ma_DH, sp.Ten_SP, ctdh.So_Luong, ctdh.Don_Gia, 
       (ctdh.So_Luong * ctdh.Don_Gia) AS ThanhTien
FROM CHI_TIET_DON_HANG ctdh
JOIN SAN_PHAM sp ON ctdh.Ma_SP = sp.Ma_SP;
--Lấy thông tin đơn hàng, quản lý xử lý và trạng thái giao hàng
SELECT dh.Ma_DH, dh.Ngay_Dat, 
       ql.Ho_Ten AS QuanLyXuLy, qldh.Xu_Ly_Don_Hang,
       gh.Trang_Thai AS TrangThaiGiaoHang, gh.Ngay_Giao
FROM DON_HANG dh
JOIN QUAN_LY_DON_HANG qldh ON dh.Ma_DH = qldh.Ma_DH
JOIN QUAN_LY ql ON qldh.Ma_QL = ql.Ma_QL
LEFT JOIN GIAO_HANG gh ON dh.Ma_DH = gh.Ma_DH;
--Tính tổng doanh thu theo khách hàng
SELECT kh.Ma_KH, kh.Ho_Ten, SUM(tt.So_Tien) AS TongChiTieu
FROM KHACH_HANG kh
JOIN DON_HANG dh ON kh.Ma_KH = dh.Ma_KH
JOIN THANH_TOAN tt ON dh.Ma_DH = tt.Ma_DH
WHERE tt.Trang_Thai_TT = N'HOÀN THÀNH'
GROUP BY kh.Ma_KH, kh.Ho_Ten
ORDER BY TongChiTieu DESC;



--Ðang ký tài khoản
CREATE PROC sp_DangKyTaiKhoan
    @Ma_TK CHAR(10),
    @Ten_Dang_Nhap NVARCHAR(40),
    @Mat_Khau NCHAR(20),
    @Loai_TK NVARCHAR(15),
    @Ma_KH CHAR(10) = NULL,
    @Ma_QL CHAR(10) = NULL
AS
BEGIN
    -- Kiểm tra trùng mã tài khoản
    IF EXISTS (SELECT 1 FROM TAI_KHOAN WHERE Ma_TK = @Ma_TK)
    BEGIN
        PRINT 'Lỗi: Mã tài khoản đã tồn tại! Vui lòng nhập mã khác.'
        RETURN
    END
    
    -- Kiểm tra trùng tên đăng nhập
    IF EXISTS (SELECT 1 FROM TAI_KHOAN WHERE Ten_Dang_Nhap = @Ten_Dang_Nhap)
    BEGIN
        PRINT 'Lỗi: Tên đăng nhập đã tồn tại! Vui lòng chọn tên khác.'
        RETURN
    END
    
    -- Kiểm tra loại tài khoản hợp lệ
    IF @Loai_TK NOT IN (N'Khách hàng', N'Quản lý')
    BEGIN
        PRINT 'Lỗi: Loại tài khoản không hợp lệ. Chỉ chấp nhận: Khách hàng hoặc Quản lý'
        RETURN
    END
    
    -- Kiểm tra ràng buộc theo loại tài khoản
    IF @Loai_TK = N'Khách hàng'
    BEGIN
        IF @Ma_QL IS NOT NULL
        BEGIN
            PRINT 'Lỗi: Tài khoản khách hàng không được có mã quản lý!'
            RETURN
        END
        
        IF @Ma_KH IS NOT NULL AND NOT EXISTS (SELECT 1 FROM KHACH_HANG WHERE Ma_KH = @Ma_KH)
        BEGIN
            PRINT 'Lỗi: Mã khách hàng không tồn tại trong hệ thống!'
            RETURN
        END
    END
    ELSE -- Tài khoản quản lý
    BEGIN
        IF @Ma_KH IS NOT NULL
        BEGIN
            PRINT 'Lỗi: Tài khoản quản lý không được có mã khách hàng!'
            RETURN
        END
    END
    
    -- Thêm tài khoản mới
    INSERT INTO TAI_KHOAN (Ma_TK, Ten_Dang_Nhap, Mat_Khau, Ma_QL, Loai_TK, Ma_KH)
    VALUES (@Ma_TK, @Ten_Dang_Nhap, @Mat_Khau, @Ma_QL, @Loai_TK, @Ma_KH)
    
    PRINT 'Đăng ký tài khoản thành công!'
END

INSERT INTO KHACH_HANG VALUES('KH100', N'La Công Linh', N'27 Lê Hồng Phong', '0933112233')

EXEC sp_DangKyTaiKhoan
     @Ma_TK = 'TK100',
     @Ten_Dang_Nhap = N'LaLinh123',
     @Mat_Khau = N'pass123',
     @Ma_QL = NULL,
     @Loai_TK = N'Khách hàng',
     @Ma_KH = 'KH100'

SELECT * FROM TAI_KHOAN

-- Đăng nhập
CREATE PROCEDURE sp_DangNhap
    @Ma_TK CHAR(10),
    @Ten_Dang_Nhap NVARCHAR(40),
    @Mat_Khau NCHAR(20)
AS
BEGIN
    -- Kiểm tra tài khoản tồn tại
    IF NOT EXISTS (
        SELECT 1 
        FROM TAI_KHOAN 
        WHERE Ma_TK = @Ma_TK 
        AND Ten_Dang_Nhap = @Ten_Dang_Nhap
    )
    BEGIN
        PRINT 'Đăng nhập thất bại: Tài khoản không tồn tại'
        RETURN
    END
    
    -- Kiểm tra mật khẩu
    IF NOT EXISTS (
        SELECT 1 
        FROM TAI_KHOAN 
        WHERE Ma_TK = @Ma_TK 
        AND Ten_Dang_Nhap = @Ten_Dang_Nhap
        AND Mat_Khau = @Mat_Khau
    )
    BEGIN
        PRINT 'Đăng nhập thất bại: Mật khẩu không chính xác'
        RETURN
    END
    
    -- Đăng nhập thành công
    PRINT 'Đăng nhập thành công'
END

-- Test case 1: Đăng nhập thành công
EXEC sp_DangNhap
     @Ma_TK = 'TK100',
     @Ten_Dang_Nhap = N'LaLinh123',
     @Mat_Khau = N'pass123'

-- Test case 2: Đăng nhập thất bại (sai tên đăng nhập và mật khẩu)
EXEC sp_DangNhap
     @Ma_TK = 'TK100',
     @Ten_Dang_Nhap = N'LaMinh123',
     @Mat_Khau = N'pass1234'

-- Quản lý sản phẩm
CREATE PROCEDURE sp_ThemSanPham
    @Ma_SP CHAR(10),
    @Ten_SP NVARCHAR(40) = NULL,
    @Don_Gia MONEY = NULL,
    @Mo_Ta NVARCHAR(50) = NULL,
    @Tinh_Trang NVARCHAR(30) = NULL,
    @So_Luong INT = NULL
AS
BEGIN
    -- Kiểm tra trùng mã sản phẩm
    IF EXISTS (SELECT * FROM SAN_PHAM WHERE Ma_SP = @Ma_SP)
    BEGIN
        PRINT 'Lỗi: Mã sản phẩm đã tồn tại!'
        RETURN
    END
    
    -- Thêm sản phẩm mới
    INSERT INTO SAN_PHAM (Ma_SP, Ten_SP, Don_Gia, Mo_Ta, Tinh_Trang, So_Luong)
    VALUES (@Ma_SP, @Ten_SP, @Don_Gia, @Mo_Ta, @Tinh_Trang, @So_Luong)
    
    PRINT 'Thêm sản phẩm thành công!'
END

-- Thêm sản phẩm thành công
EXEC sp_ThemSanPham
    @Ma_SP = 'SP100', 
    @Ten_SP = N'Điện thoại X', 
    @Don_Gia = 10000000,
    @Mo_Ta = N'Dung lượng 128GB',
    @Tinh_Trang = N'Còn hàng',
    @So_Luong = 50

SELECT * FROM SAN_PHAM

CREATE PROCEDURE sp_SuaSanPham
    @Ma_SP CHAR(10),
    @Ten_SP NVARCHAR(40) = NULL,
    @Don_Gia MONEY = NULL,
    @Mo_Ta NVARCHAR(50) = NULL,
    @Tinh_Trang NVARCHAR(30) = NULL,
    @So_Luong INT = NULL
AS
BEGIN
    -- Kiểm tra sản phẩm tồn tại
    IF NOT EXISTS (SELECT * FROM SAN_PHAM WHERE Ma_SP = @Ma_SP)
    BEGIN
        PRINT 'Lỗi: Sản phẩm không tồn tại!'
        RETURN
    END
    
    -- Cập nhật thông tin
    UPDATE SAN_PHAM
    SET 
        Ten_SP = ISNULL(@Ten_SP, Ten_SP),
        Don_Gia = ISNULL(@Don_Gia, Don_Gia),
        Mo_Ta = ISNULL(@Mo_Ta, Mo_Ta),
        Tinh_Trang = ISNULL(@Tinh_Trang, Tinh_Trang),
        So_Luong = ISNULL(@So_Luong, So_Luong)
    WHERE Ma_SP = @Ma_SP
    
    PRINT 'Cập nhật sản phẩm thành công!'
END

-- Cập nhật thành công
EXEC sp_SuaSanPham
    @Ma_SP = 'SP100', 
    @Ten_SP = N'Điện thoại X', 
    @Don_Gia = 9000000,
    @Mo_Ta = N'Dung lượng 128GB',
    @Tinh_Trang = N'Còn hàng',
    @So_Luong = 10

SELECT * FROM SAN_PHAM

CREATE PROCEDURE sp_XoaSanPham
    @Ma_SP CHAR(10)
AS
BEGIN
    -- Kiểm tra sản phẩm tồn tại
    IF NOT EXISTS (SELECT * FROM SAN_PHAM WHERE Ma_SP = @Ma_SP)
    BEGIN
        PRINT 'Lỗi: Sản phẩm không tồn tại!'
        RETURN
    END
    
    -- Xóa sản phẩm
    DELETE FROM SAN_PHAM WHERE Ma_SP = @Ma_SP
    
    PRINT 'Xóa sản phẩm thành công!'
END

-- Xóa sản phẩm thành công
EXEC sp_XoaSanPham 'SP100'

SELECT * FROM SAN_PHAM

CREATE PROCEDURE sp_XemSanPham
    @Ma_SP CHAR(10) = NULL
AS
BEGIN
    IF @Ma_SP IS NULL
        -- Xem tất cả sản phẩm
        SELECT * FROM SAN_PHAM
    ELSE
        -- Xem sản phẩm cụ thể
        SELECT * FROM SAN_PHAM WHERE Ma_SP = @Ma_SP
END

-- Xem tất cả sản phẩm
EXEC sp_XemSanPham

-- Xem sản phẩm cụ thể
EXEC sp_XemSanPham 'SP100'

-- Đặt hàng
-- Trigger cập nhật tồn kho khi thêm chi tiết đơn hàng
CREATE TRIGGER trg_Dathang
ON CHI_TIET_DON_HANG
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @ErrorMsg NVARCHAR(2000);
    
    BEGIN TRANSACTION;
    BEGIN TRY
        -- 1. Giảm số lượng tồn kho
        UPDATE sp
        SET sp.So_Luong = sp.So_Luong - i.So_Luong
        FROM SAN_PHAM sp
        INNER JOIN inserted i ON sp.Ma_SP = i.Ma_SP;
        
        -- 2. Kiểm tra số lượng không âm
        IF EXISTS (
            SELECT 1 
            FROM SAN_PHAM sp
            JOIN inserted i ON sp.Ma_SP = i.Ma_SP
            WHERE sp.So_Luong < 0
        )
        BEGIN
            SET @ErrorMsg = N'Không đủ hàng trong kho. Số lượng tồn không thể âm';
            RAISERROR(@ErrorMsg, 16, 1);
        END
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        SET @ErrorMsg = N'Lỗi trong trigger trg_ThemChiTietDonHang: ' + ERROR_MESSAGE();
        RAISERROR(@ErrorMsg, 16, 1);
    END CATCH
END;

-- Thêm đơn hàng mới
INSERT INTO DON_HANG VALUES ('DH101', 'KH100', '2025-03-02', N'Đang đặt')

-- Thêm chi tiết đơn hàng (sẽ kích hoạt trigger)
INSERT INTO CHI_TIET_DON_HANG VALUES ('DH101', 'SP100', 1, 9000000)

-- Kiểm tra số lượng sản phẩm sau khi đặt hàng
SELECT * FROM SAN_PHAM

-- Thanh toán
CREATE TRIGGER trg_ThanhToan
ON THANH_TOAN
INSTEAD OF INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @ErrorMsg NVARCHAR(2000);
    
    -- Bắt đầu transaction
    BEGIN TRANSACTION;
    BEGIN TRY
        -- 1. Thêm dữ liệu thanh toán
        INSERT INTO THANH_TOAN (
            Ma_HD, 
            Ngay_Thanh_Toan, 
            So_Tien, 
            Phuong_Thuc, 
            Trang_Thai_TT, 
            Ma_DH
        )
        SELECT
            i.Ma_HD,
            CASE 
                WHEN i.Trang_Thai_TT = 'Đã thanh toán' THEN ISNULL(i.Ngay_Thanh_Toan, GETDATE())
                ELSE NULL 
            END,
            i.So_Tien,
            i.Phuong_Thuc,
            i.Trang_Thai_TT,
            i.Ma_DH
        FROM inserted i;
        
        -- 2. Cập nhật trạng thái đơn hàng nếu thanh toán thành công
        IF EXISTS (SELECT 1 FROM inserted WHERE Trang_Thai_TT = 'Đã thanh toán')
        BEGIN
            UPDATE DON_HANG
            SET Trang_Thai = 'Đã thanh toán'
            WHERE Ma_DH IN (
                SELECT Ma_DH FROM inserted
                WHERE Trang_Thai_TT = 'Đã thanh toán'
            );
            
            -- Kiểm tra số dòng ảnh hưởng
            IF @@ROWCOUNT = 0
            BEGIN
                SET @ErrorMsg = N'Không tìm thấy đơn hàng tương ứng để cập nhật trạng thái';
                RAISERROR(@ErrorMsg, 16, 1);
            END
        END
        
        -- Commit transaction nếu thành công
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Rollback nếu có lỗi
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        -- Thông báo lỗi chi tiết
        SET @ErrorMsg = N'Lỗi trong trigger trg_ThanhToan: ' + ERROR_MESSAGE();
        RAISERROR(@ErrorMsg, 16, 1);
    END CATCH
END

-- Thêm thanh toán (không cần truyền Ngay_Thanh_Toan)
INSERT INTO THANH_TOAN (Ma_HD, So_Tien, Phuong_Thuc, Trang_Thai_TT, Ma_DH)
VALUES ('HD002', 1000000, 'Chuyển khoản', 'Đã thanh toán', 'DH101')

-- Kiểm tra kết quả
SELECT * FROM THANH_TOAN WHERE Ma_HD = 'HD002';
SELECT * FROM DON_HANG WHERE Ma_DH = 'DH101';

-- Hủy đơn hàng
CREATE TRIGGER trg_HuyDonHang_CapNhatSoLuong
ON DON_HANG
AFTER UPDATE
AS
BEGIN
    -- Chỉ xử lý khi trạng thái chuyển sang 'Đã hủy'
    IF EXISTS (SELECT 1 FROM inserted WHERE Trang_Thai = N'Đã hủy')
    BEGIN
        DECLARE @Ma_SP CHAR(10), @So_Luong INT
        DECLARE @ErrorMsg NVARCHAR(1000)
        
        -- Bắt đầu transaction
        BEGIN TRANSACTION
        BEGIN TRY
            -- Dùng cursor để duyệt qua từng sản phẩm trong đơn hàng bị hủy
            DECLARE cur CURSOR FOR
            SELECT CT.Ma_SP, CT.So_Luong
            FROM inserted I
            JOIN CHI_TIET_DON_HANG CT ON I.Ma_DH = CT.Ma_DH
            WHERE I.Trang_Thai = N'Đã hủy'
            
            OPEN cur
            FETCH NEXT FROM cur INTO @Ma_SP, @So_Luong
            
            WHILE @@FETCH_STATUS = 0
            BEGIN
                -- Cập nhật số lượng tồn kho cho từng sản phẩm
                UPDATE SAN_PHAM
                SET So_Luong = So_Luong + @So_Luong
                WHERE Ma_SP = @Ma_SP
                
                -- Kiểm tra lỗi sau mỗi lần cập nhật
                IF @@ERROR <> 0
                BEGIN
                    SET @ErrorMsg = N'Lỗi khi cập nhật số lượng cho sản phẩm ' + @Ma_SP
                    RAISERROR(@ErrorMsg, 16, 1)
                END
                
                FETCH NEXT FROM cur INTO @Ma_SP, @So_Luong
            END
            
            CLOSE cur
            DEALLOCATE cur
            
            -- Nếu mọi thứ thành công, commit transaction
            COMMIT TRANSACTION
        END TRY
        BEGIN CATCH
            -- Nếu có lỗi, rollback và thông báo lỗi
            IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION
                
            CLOSE cur
            DEALLOCATE cur
            
            SET @ErrorMsg = N'Lỗi trong trigger trg_HuyDonHang_CapNhatSoLuong: ' + ERROR_MESSAGE()
            RAISERROR(@ErrorMsg, 16, 1)
        END CATCH
    END
END

-- Test hủy đơn hàng
UPDATE DON_HANG
SET Trang_Thai = N'Đã hủy'
WHERE Ma_DH = 'DH101';

-- Kiểm tra kết quả
SELECT * FROM SAN_PHAM;
SELECT * FROM DON_HANG;
SELECT Ma_SP, So_Luong FROM SAN_PHAM;

-- Quản lý đơn hàng
CREATE PROCEDURE sp_QL_XemDonHang
    @Ma_DH CHAR(10) = NULL,
    @Ma_KH CHAR(10) = NULL,
    @Trang_Thai NVARCHAR(30) = NULL,
    @Ngay_BatDau DATE = NULL,
    @Ngay_KetThuc DATE = NULL,
    @Page INT = 1,
    @PageSize INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Tính toán phân trang
    DECLARE @StartRow INT = (@Page - 1) * @PageSize + 1;
    DECLARE @EndRow INT = @Page * @PageSize;
    
    -- Query với điều kiện lọc
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
            (@Ma_DH IS NULL OR dh.Ma_DH = @Ma_DH)
            AND (@Ma_KH IS NULL OR dh.Ma_KH = @Ma_KH)
            AND (@Trang_Thai IS NULL OR dh.Trang_Thai = @Trang_Thai)
            AND (@Ngay_BatDau IS NULL OR dh.Ngay_Dat >= @Ngay_BatDau)
            AND (@Ngay_KetThuc IS NULL OR dh.Ngay_Dat <= @Ngay_KetThuc)
    )
    SELECT 
        Ma_DH,
        CONVERT(VARCHAR, Ngay_Dat, 103) AS Ngay_Dat_Formatted,
        Trang_Thai,
        Ma_KH,
        Ten_KH,
        SDT,
        So_SanPham,
        FORMAT(Tong_Tien, 'N0') AS Tong_Tien_Formatted
    FROM 
        FilteredOrders
    WHERE 
        RowNum BETWEEN @StartRow AND @EndRow
    ORDER BY 
        Ngay_Dat DESC;
    
    -- Tổng số đơn (để phân trang)
    SELECT COUNT(*) AS TotalOrders
    FROM DON_HANG dh
    WHERE 
        (@Ma_DH IS NULL OR dh.Ma_DH = @Ma_DH)
        AND (@Ma_KH IS NULL OR dh.Ma_KH = @Ma_KH)
        AND (@Trang_Thai IS NULL OR dh.Trang_Thai = @Trang_Thai)
        AND (@Ngay_BatDau IS NULL OR dh.Ngay_Dat >= @Ngay_BatDau)
        AND (@Ngay_KetThuc IS NULL OR dh.Ngay_Dat <= @Ngay_KetThuc);
END

-- Thực thi stored procedure
EXEC sp_QL_XemDonHang 
    @Page = 1, 
    @PageSize = 20

EXEC sp_QL_XemDonHang 
    @Trang_Thai = N'Đã hủy',
    @Page = 1,
    @PageSize = 10

-- Trigger xóa đơn hàng
CREATE TRIGGER trg_QL_XoaDonHang
ON DON_HANG
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        -- 1. Cộng lại số lượng sản phẩm
        UPDATE sp
        SET sp.So_Luong = sp.So_Luong + ct.So_Luong
        FROM SAN_PHAM sp
        JOIN CHI_TIET_DON_HANG ct ON sp.Ma_SP = ct.Ma_SP
        JOIN deleted d ON ct.Ma_DH = d.Ma_DH;
        
        -- 2. Xóa chi tiết đơn hàng
        DELETE FROM CHI_TIET_DON_HANG
        WHERE Ma_DH IN (SELECT Ma_DH FROM deleted);
        
        -- 3. Xóa đơn hàng chính
        DELETE FROM DON_HANG
        WHERE Ma_DH IN (SELECT Ma_DH FROM deleted);
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR('Lỗi khi xóa đơn hàng: %s', 16, 1, @ErrorMessage);
    END CATCH
END

-- Test xóa đơn hàng
DELETE FROM DON_HANG WHERE Ma_DH = 'DH100'

-- Kiểm tra kết quả
SELECT * FROM SAN_PHAM;
SELECT * FROM CHI_TIET_DON_HANG;

-- Quản lý người dùng
CREATE PROC sp_QL_ThemTaiKhoan
    @Ma_TK CHAR(10),
    @Ten_Dang_Nhap NVARCHAR(40),
    @Mat_Khau NCHAR(20),
    @Loai_TK NVARCHAR(15),  -- Có thể là 'KHÁCH HÀNG' hoặc 'QUẢN LÝ'
    @Ma_KH CHAR(10) = NULL,  -- Chỉ điền nếu là KH
    @Ma_QL CHAR(10) = NULL   -- Chỉ điền nếu là QL
AS
BEGIN
    -- Kiểm tra quyền admin (có thể thêm logic kiểm tra quyền ở đây)
    
    -- Kiểm tra trùng mã/tên đăng nhập
    IF EXISTS (SELECT 1 FROM TAI_KHOAN WHERE Ma_TK = @Ma_TK OR Ten_Dang_Nhap = @Ten_Dang_Nhap)
    BEGIN
        RAISERROR('Mã tài khoản hoặc tên đăng nhập đã tồn tại!', 16, 1)
        RETURN
    END
    
    -- Kiểm tra loại tài khoản hợp lệ
    IF @Loai_TK NOT IN (N'KHÁCH HÀNG', N'QUẢN LÝ')
    BEGIN
        RAISERROR('Loại tài khoản không hợp lệ!', 16, 1)
        RETURN
    END
    
    -- Xử lý theo từng loại tài khoản
    IF @Loai_TK = N'KHÁCH HÀNG'
    BEGIN
        -- Kiểm tra mã KH
        IF @Ma_KH IS NULL OR NOT EXISTS (SELECT 1 FROM KHACH_HANG WHERE Ma_KH = @Ma_KH)
        BEGIN
            RAISERROR('Mã khách hàng không hợp lệ!', 16, 1)
            RETURN
        END
        
        -- Thêm tài khoản KH
        INSERT INTO TAI_KHOAN (Ma_TK, Ten_Dang_Nhap, Mat_Khau, Ma_KH, Loai_TK)
        VALUES (@Ma_TK, @Ten_Dang_Nhap, @Mat_Khau, @Ma_KH, N'KHÁCH HÀNG')
    END
    ELSE -- QUẢN LÝ
    BEGIN
        -- Kiểm tra mã QL
        IF @Ma_QL IS NULL OR NOT EXISTS (SELECT 1 FROM QUAN_LY WHERE Ma_QL = @Ma_QL)
        BEGIN
            RAISERROR('Mã quản lý không hợp lệ!', 16, 1)
            RETURN
        END
        
        -- Thêm tài khoản QL
        INSERT INTO TAI_KHOAN (Ma_TK, Ten_Dang_Nhap, Mat_Khau, Ma_QL, Loai_TK)
        VALUES (@Ma_TK, @Ten_Dang_Nhap, @Mat_Khau, @Ma_QL, N'QUẢN LÝ')
    END
    
    PRINT 'Thêm tài khoản thành công!'
END

-- Thêm tài khoản khách hàng
EXEC sp_QL_ThemTaiKhoan
    @Ma_TK = 'TK101',
    @Ten_Dang_Nhap = 'khachhang_admin_them',
    @Mat_Khau = 'Pass123!',
    @Loai_TK = N'KHÁCH HÀNG',
    @Ma_KH = 'KH002'

-- Thêm tài khoản quản lý
EXEC sp_QL_ThemTaiKhoan
    @Ma_TK = 'TK102',
    @Ten_Dang_Nhap = 'quantri_moi',
    @Mat_Khau = 'AdminPass!',
    @Loai_TK = N'QUẢN LÝ',
    @Ma_QL = 'QL001'

CREATE PROC sp_QL_SuaTaiKhoan
    @Ma_TK CHAR(10),
    @Ten_Dang_Nhap_Moi NVARCHAR(40) = NULL,
    @Mat_Khau_Moi NCHAR(20) = NULL,
    @Loai_TK_Moi NVARCHAR(15) = NULL,
    @Ma_KH_Moi CHAR(10) = NULL,
    @Ma_QL_Moi CHAR(10) = NULL
AS
BEGIN
    -- Kiểm tra tài khoản tồn tại
    IF NOT EXISTS (SELECT 1 FROM TAI_KHOAN WHERE Ma_TK = @Ma_TK)
    BEGIN
        RAISERROR('Tài khoản không tồn tại!', 16, 1)
        RETURN
    END

    -- Kiểm tra trùng tên đăng nhập mới (nếu có thay đổi)
    IF @Ten_Dang_Nhap_Moi IS NOT NULL 
        AND EXISTS (SELECT 1 FROM TAI_KHOAN WHERE Ten_Dang_Nhap = @Ten_Dang_Nhap_Moi AND Ma_TK <> @Ma_TK)
    BEGIN
        RAISERROR('Tên đăng nhập đã được sử dụng!', 16, 1)
        RETURN
    END

    -- Cập nhật thông tin
    UPDATE TAI_KHOAN SET
        Ten_Dang_Nhap = ISNULL(@Ten_Dang_Nhap_Moi, Ten_Dang_Nhap),
        Mat_Khau = ISNULL(@Mat_Khau_Moi, Mat_Khau),
        Loai_TK = ISNULL(@Loai_TK_Moi, Loai_TK),
        Ma_KH = CASE 
                    WHEN @Loai_TK_Moi = N'KHÁCH HÀNG' THEN @Ma_KH_Moi
                    WHEN @Loai_TK_Moi = N'QUẢN LÝ' THEN NULL
                    ELSE Ma_KH 
                END,
        Ma_QL = CASE 
                    WHEN @Loai_TK_Moi = N'QUẢN LÝ' THEN @Ma_QL_Moi
                    WHEN @Loai_TK_Moi = N'KHÁCH HÀNG' THEN NULL
                    ELSE Ma_QL 
                END
    WHERE Ma_TK = @Ma_TK

    PRINT 'Cập nhật tài khoản thành công!'
END

-- Đổi mật khẩu
EXEC sp_QL_SuaTaiKhoan 
    @Ma_TK = 'TK101',
    @Mat_Khau_Moi = 'NewPass123!'

-- Chuyển thành tài khoản quản lý
EXEC sp_QL_SuaTaiKhoan
    @Ma_TK = 'TK101',
    @Loai_TK_Moi = N'QUẢN LÝ',
    @Ma_QL_Moi = 'QL002'

CREATE PROC sp_PhanQuyen
    @Ma_TK CHAR(10),
    @Loai_TK_Moi NVARCHAR(15),
    @Ma_Quyen CHAR(10) = NULL  -- Ma_KH hoặc Ma_QL tùy loại
AS
BEGIN
    -- Kiểm tra tài khoản tồn tại
    IF NOT EXISTS (SELECT 1 FROM TAI_KHOAN WHERE Ma_TK = @Ma_TK)
    BEGIN
        RAISERROR('Tài khoản không tồn tại!', 16, 1)
        RETURN
    END

    -- Kiểm tra loại tài khoản hợp lệ
    IF @Loai_TK_Moi NOT IN (N'KHÁCH HÀNG', N'QUẢN LÝ')
    BEGIN
        RAISERROR('Loại tài khoản không hợp lệ!', 16, 1)
        RETURN
    END

    -- Kiểm tra mã quyền hợp lệ
    IF @Loai_TK_Moi = N'KHÁCH HÀNG' 
        AND (NOT EXISTS (SELECT 1 FROM KHACH_HANG WHERE Ma_KH = @Ma_Quyen))
    BEGIN
        RAISERROR('Mã khách hàng không hợp lệ!', 16, 1)
        RETURN
    END

    IF @Loai_TK_Moi = N'QUẢN LÝ' 
        AND (NOT EXISTS (SELECT 1 FROM QUAN_LY WHERE Ma_QL = @Ma_Quyen))
    BEGIN
        RAISERROR('Mã quản lý không hợp lệ!', 16, 1)
        RETURN
    END

    -- Cập nhật phân quyền
    UPDATE TAI_KHOAN SET
        Loai_TK = @Loai_TK_Moi,
        Ma_KH = CASE WHEN @Loai_TK_Moi = N'KHÁCH HÀNG' THEN @Ma_Quyen ELSE NULL END,
        Ma_QL = CASE WHEN @Loai_TK_Moi = N'QUẢN LÝ' THEN @Ma_Quyen ELSE NULL END
    WHERE Ma_TK = @Ma_TK

    PRINT 'Phân quyền thành công!'
END
-- Phân quyền thành quản lý
EXEC sp_PhanQuyen
    @Ma_TK = 'TK101',
    @Loai_TK_Moi = N'QUẢN LÝ',
    @Ma_Quyen = 'QL005'

-- Chuyển về khách hàng
EXEC sp_PhanQuyen
    @Ma_TK = 'TK101',
    @Loai_TK_Moi = N'KHÁCH HÀNG',
    @Ma_Quyen = 'KH010'

CREATE PROC sp_QL_XoaTaiKhoan
    @Ma_TK CHAR(10)
AS
BEGIN
    -- Kiểm tra tài khoản tồn tại
    IF NOT EXISTS (SELECT 1 FROM TAI_KHOAN WHERE Ma_TK = @Ma_TK)
    BEGIN
        RAISERROR('Tài khoản không tồn tại!', 16, 1)
        RETURN
    END

    -- Kiểm tra không xóa tài khoản admin chính
    IF EXISTS (SELECT 1 FROM TAI_KHOAN WHERE Ma_TK = @Ma_TK AND Ten_Dang_Nhap = 'admin')
    BEGIN
        RAISERROR('Không thể xóa tài khoản admin chính!', 16, 1)
        RETURN
    END

    -- Thực hiện xóa
    DELETE FROM TAI_KHOAN WHERE Ma_TK = @Ma_TK

    PRINT 'Xóa tài khoản thành công!'
END
EXEC sp_QL_XoaTaiKhoan @Ma_TK = 'TK101'

-- Quản lý giao hàng
CREATE PROCEDURE sp_QL_XemDonCanGiao
    @Page INT = 1,
    @PageSize INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @StartRow INT = (@Page - 1) * @PageSize + 1;
    DECLARE @EndRow INT = @Page * @PageSize;
    
    -- Danh sách đơn cần giao (chưa giao hoặc đang giao)
    WITH OrdersToShip AS (
        SELECT 
            dh.Ma_DH,
            dh.Ngay_Dat,
            kh.Ho_Ten AS Ten_KH,
            kh.Dia_Chi,
            kh.SDT,
            ISNULL(gh.Trang_Thai, N'Chưa giao') AS Trang_Thai_Giao,
            gh.Ngay_Giao,
            gh.Nguoi_Giao,
            ROW_NUMBER() OVER (ORDER BY dh.Ngay_Dat DESC) AS RowNum
        FROM 
            DON_HANG dh
            JOIN KHACH_HANG kh ON dh.Ma_KH = kh.Ma_KH
            LEFT JOIN GIAO_HANG gh ON dh.Ma_DH = gh.Ma_DH
        WHERE 
            dh.Trang_Thai IN (N'Đang giao', N'Đã đặt')
            AND (gh.Trang_Thai IS NULL OR gh.Trang_Thai <> N'Thành công')
    )
    SELECT 
        Ma_DH,
        CONVERT(VARCHAR, Ngay_Dat, 103) AS Ngay_Dat_Formatted,
        Ten_KH,
        Dia_Chi,
        SDT,
        Trang_Thai_Giao,
        CASE 
            WHEN Ngay_Giao IS NULL THEN N'Chưa có'
            ELSE CONVERT(VARCHAR, Ngay_Giao, 103) 
        END AS Ngay_Giao_Formatted,
        ISNULL(Nguoi_Giao, N'Chưa phân công') AS Nguoi_Giao
    FROM 
        OrdersToShip
    WHERE 
        RowNum BETWEEN @StartRow AND @EndRow
    ORDER BY 
        Ngay_Dat DESC;
    
    -- Tổng số đơn cần giao
    SELECT COUNT(*) AS TotalOrders
    FROM DON_HANG dh
    LEFT JOIN GIAO_HANG gh ON dh.Ma_DH = gh.Ma_DH
    WHERE 
        dh.Trang_Thai IN (N'Đang giao', N'Đã đặt')
        AND (gh.Trang_Thai IS NULL OR gh.Trang_Thai <> N'Thành công');
END

-- Xem các đơn cần giao (trang 1, 10 bản ghi/trang)
EXEC sp_QL_XemDonCanGiao 
    @Page = 1,
    @PageSize = 10


CREATE PROCEDURE sp_QL_CapNhatGiaoHang
    @Ma_DH CHAR(10),
    @Nguoi_Giao NVARCHAR(40),
    @Trang_Thai_Moi NVARCHAR(30) = N'Thành công'
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Kiểm tra đơn hàng tồn tại và có trạng thái phù hợp
        IF NOT EXISTS (SELECT 1 FROM DON_HANG WHERE Ma_DH = @Ma_DH AND Trang_Thai IN (N'Đang giao', N'Đã đặt'))
        BEGIN
            RAISERROR(N'Đơn hàng không tồn tại hoặc không thể cập nhật trạng thái giao hàng', 16, 1);
            RETURN;
        END
        
        -- Tạo mã GH ngẫu nhiên nếu cần thêm mới
        DECLARE @Ma_GH CHAR(10);
        
        -- Cập nhật hoặc thêm mới bản ghi giao hàng
        IF EXISTS (SELECT 1 FROM GIAO_HANG WHERE Ma_DH = @Ma_DH)
        BEGIN
            UPDATE GIAO_HANG
            SET 
                Trang_Thai = @Trang_Thai_Moi,
                Ngay_Giao = GETDATE(),
                Nguoi_Giao = @Nguoi_Giao
            WHERE Ma_DH = @Ma_DH;
        END
        ELSE
        BEGIN
            -- Tạo mã GH từ mã DH (ví dụ: thêm 'GH' vào trước mã DH)
            SET @Ma_GH = 'GH' + RIGHT(@Ma_DH, 8);
            
            INSERT INTO GIAO_HANG (Ma_GH, Ngay_Giao, Trang_Thai, Nguoi_Giao, Ma_DH)
            VALUES (@Ma_GH, GETDATE(), @Trang_Thai_Moi, @Nguoi_Giao, @Ma_DH);
        END
        
        -- Cập nhật trạng thái đơn hàng nếu giao thành công
        IF @Trang_Thai_Moi = N'Thành công'
        BEGIN
            UPDATE DON_HANG
            SET Trang_Thai = N'Hoàn thành'
            WHERE Ma_DH = @Ma_DH;
        END
        
        COMMIT TRANSACTION;
        PRINT N'Cập nhật giao hàng thành công!';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(N'Lỗi khi cập nhật giao hàng: %s', 16, 1, @ErrorMessage);
    END CATCH
END

-- Cập nhật giao hàng thành công
EXEC sp_QL_CapNhatGiaoHang 
    @Ma_DH = 'DH002',
    @Nguoi_Giao = N'Nguyễn Văn A',
    @Trang_Thai_Moi = N'Thành công';


CREATE PROCEDURE sp_QL_GiaoHangThatBai
    @Ma_DH CHAR(10),
    @LyDo NVARCHAR(100) = NULL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Kiểm tra đơn hàng tồn tại
        IF NOT EXISTS (SELECT 1 FROM DON_HANG WHERE Ma_DH = @Ma_DH)
        BEGIN
            RAISERROR(N'Đơn hàng không tồn tại', 16, 1);
            RETURN;
        END
        
        -- 1. Cập nhật hoặc thêm bản ghi giao hàng thất bại
        IF EXISTS (SELECT 1 FROM GIAO_HANG WHERE Ma_DH = @Ma_DH)
        BEGIN
            UPDATE GIAO_HANG
            SET 
                Trang_Thai = N'Thất bại',
                Ngay_Giao = GETDATE(),
                Nguoi_Giao = ISNULL(Nguoi_Giao, N'Hệ thống')
            WHERE Ma_DH = @Ma_DH;
        END
        ELSE
        BEGIN
            -- Tạo mã GH từ mã DH (ví dụ: thêm 'GH' vào trước mã DH)
            DECLARE @Ma_GH CHAR(10) = 'GH' + RIGHT(@Ma_DH, 8);
            
            INSERT INTO GIAO_HANG (Ma_GH, Ngay_Giao, Trang_Thai, Nguoi_Giao, Ma_DH)
            VALUES (@Ma_GH, GETDATE(), N'Thất bại', N'Hệ thống', @Ma_DH);
        END
        
        -- 2. Cập nhật trạng thái đơn hàng
        UPDATE DON_HANG
        SET Trang_Thai = N'Đã hủy'
        WHERE Ma_DH = @Ma_DH;
        
        -- 3. Hoàn trả số lượng sản phẩm
        UPDATE sp
        SET sp.So_Luong = sp.So_Luong + ct.So_Luong
        FROM SAN_PHAM sp
        JOIN CHI_TIET_DON_HANG ct ON sp.Ma_SP = ct.Ma_SP
        WHERE ct.Ma_DH = @Ma_DH;
        
        -- Ghi chú lý do vào trường Nguoi_Giao nếu không có bảng log
        IF @LyDo IS NOT NULL
        BEGIN
            UPDATE GIAO_HANG
            SET Nguoi_Giao = Nguoi_Giao + ' - ' + @LyDo
            WHERE Ma_DH = @Ma_DH;
        END
        
        COMMIT TRANSACTION;
        PRINT N'Đã xử lý giao hàng thất bại và hoàn trả sản phẩm vào kho!';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(N'Lỗi khi xử lý giao hàng thất bại: %s', 16, 1, @ErrorMessage);
    END CATCH
END

-- Xử lý giao hàng thất bại
EXEC sp_QL_GiaoHangThatBai 
    @Ma_DH = 'DH005',
    @LyDo = N'Khách không nhận hàng';

-- Thống kê số lượng đơn hàng theo trạng thái
CREATE PROCEDURE sp_ThongKeDonHangTheoTrangThai
AS
BEGIN
    SELECT 
        Trang_Thai,
        COUNT(*) AS SoLuong,
        FORMAT(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 'N2') + '%' AS TyLe
    FROM 
        DON_HANG
    GROUP BY 
        Trang_Thai
    ORDER BY 
        SoLuong DESC;
END

-- Thống kê số lượng sản phẩm theo tình trạng kho
CREATE PROCEDURE sp_ThongKeSanPhamTheoTinhTrang
AS
BEGIN
    SELECT 
        Tinh_Trang,
        COUNT(*) AS SoLuong,
        SUM(So_Luong) AS TongSoLuongTon
    FROM 
        SAN_PHAM
    GROUP BY 
        Tinh_Trang;
END

-- Tính tổng doanh thu theo tháng
CREATE PROCEDURE sp_TongDoanhThuTheoThang
    @Nam INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Nếu không chỉ định năm, lấy năm hiện tại
    IF @Nam IS NULL
        SET @Nam = YEAR(GETDATE());
    
    -- Kiểm tra xem có dữ liệu cho năm được chọn không
    IF NOT EXISTS (
        SELECT 1 
        FROM DON_HANG dh
        JOIN THANH_TOAN tt ON dh.Ma_DH = tt.Ma_DH
        WHERE YEAR(dh.Ngay_Dat) = @Nam
        AND tt.Trang_Thai_TT = N'HOÀN THÀNH'
    )
    BEGIN
        SELECT 
            'Thông báo' AS Loai,
            CONCAT('Không có dữ liệu doanh thu cho năm ', @Nam) AS NoiDung;
        RETURN;
    END
    
    -- Truy vấn chính
    SELECT 
        MONTH(dh.Ngay_Dat) AS Thang,
        FORMAT(SUM(tt.So_Tien), 'N0') AS TongDoanhThu,
        COUNT(DISTINCT dh.Ma_DH) AS SoDonHang,
        FORMAT(SUM(tt.So_Tien) / COUNT(DISTINCT dh.Ma_DH), 'N0') AS TrungBinhDonHang
    FROM 
        DON_HANG dh
        JOIN THANH_TOAN tt ON dh.Ma_DH = tt.Ma_DH
    WHERE 
        YEAR(dh.Ngay_Dat) = @Nam
        AND tt.Trang_Thai_TT = N'HOÀN THÀNH'
    GROUP BY 
        MONTH(dh.Ngay_Dat)
    ORDER BY 
        Thang;
END

-- Thống kê sản phẩm bán chạy
CREATE PROCEDURE sp_SanPhamBanChay
    @TopN INT = 10
AS
BEGIN
    SELECT TOP(@TopN)
        sp.Ma_SP,
        sp.Ten_SP,
        SUM(ct.So_Luong) AS SoLuongBan,
        SUM(ct.So_Luong * ct.Don_Gia) AS DoanhThu
    FROM 
        CHI_TIET_DON_HANG ct
        JOIN SAN_PHAM sp ON ct.Ma_SP = sp.Ma_SP
        JOIN DON_HANG dh ON ct.Ma_DH = dh.Ma_DH
        JOIN THANH_TOAN tt ON dh.Ma_DH = tt.Ma_DH
    WHERE 
        tt.Trang_Thai_TT = N'HOÀN THÀNH'
    GROUP BY 
        sp.Ma_SP, sp.Ten_SP
    ORDER BY 
        SoLuongBan DESC;
END

-- Kiểm tra khách hàng trùng
CREATE PROCEDURE sp_KiemTraKhachHangTrung
    @SDT VARCHAR(15)
AS
BEGIN
    SELECT 
        Ma_KH, 
        Ho_Ten, 
        SDT, 
        Dia_Chi
    FROM 
        KHACH_HANG
    WHERE 
        SDT = @SDT
END

-- Kiểm tra sản phẩm trùng
CREATE PROCEDURE sp_KiemTraSanPhamTrung
    @TenSP NVARCHAR(40)
AS
BEGIN
    SELECT 
        Ma_SP, 
        Ten_SP, 
        Don_Gia
    FROM 
        SAN_PHAM
    WHERE 
        Ten_SP = @TenSP;
END


-----
-- Tạo role cho từng loại người dùng
CREATE ROLE db_khachhang;
CREATE ROLE db_quantri;
CREATE ROLE db_baocao;
CREATE ROLE db_giaohang;

-- Cấp quyền cho khách hàng
GRANT SELECT ON KHACH_HANG TO db_khachhang;
GRANT SELECT, INSERT, UPDATE ON DON_HANG TO db_khachhang;
GRANT SELECT, INSERT ON CHI_TIET_DON_HANG TO db_khachhang;
GRANT SELECT ON SAN_PHAM TO db_khachhang;
GRANT EXECUTE ON sp_DangKyTaiKhoan TO db_khachhang;
GRANT EXECUTE ON sp_DangNhap TO db_khachhang;

-- Cấp quyền cho quản trị
-- Cách 1: Cấp quyền cho từng bảng riêng biệt (khuyến nghị)
GRANT SELECT ON KHACH_HANG TO db_quantri;
GRANT SELECT ON QUAN_LY TO db_quantri;
GRANT SELECT ON DON_HANG TO db_quantri;
GRANT SELECT ON SAN_PHAM TO db_quantri;
GRANT SELECT ON CHI_TIET_DON_HANG TO db_quantri;
GRANT SELECT ON QUAN_LY_DON_HANG TO db_quantri;
GRANT SELECT ON THANH_TOAN TO db_quantri;
GRANT SELECT ON GIAO_HANG TO db_quantri;
GRANT SELECT ON TAI_KHOAN TO db_quantri;

-- Cấp quyền cho báo cáo
-- 1. Cấp quyền SELECT cho từng bảng cụ thể
GRANT SELECT ON KHACH_HANG TO db_baocao;
GRANT SELECT ON DON_HANG TO db_baocao;
GRANT SELECT ON SAN_PHAM TO db_baocao;
GRANT SELECT ON CHI_TIET_DON_HANG TO db_baocao;
GRANT SELECT ON THANH_TOAN TO db_baocao;
GRANT SELECT ON GIAO_HANG TO db_baocao;

-- 2. Cấp quyền thực thi stored procedure
GRANT EXECUTE ON sp_ThongKeDonHangTheoTrangThai TO db_baocao;
GRANT EXECUTE ON sp_ThongKeSanPhamTheoTinhTrang TO db_baocao;
GRANT EXECUTE ON sp_TongDoanhThuTheoThang TO db_baocao;
GRANT EXECUTE ON sp_SanPhamBanChay TO db_baocao;

-- Cấp quyền cho nhân viên giao hàng
GRANT SELECT ON DON_HANG TO db_giaohang;
GRANT SELECT ON KHACH_HANG TO db_giaohang;
GRANT SELECT, INSERT, UPDATE ON GIAO_HANG TO db_giaohang;
GRANT EXECUTE ON sp_QL_XemDonCanGiao TO db_giaohang;
GRANT EXECUTE ON sp_QL_CapNhatGiaoHang TO db_giaohang;

-- Tạo login và user mẫu
CREATE LOGIN login_khachhang WITH PASSWORD = 'khachhang@123';
CREATE USER user_khachhang FOR LOGIN login_khachhang;
ALTER ROLE db_khachhang ADD MEMBER user_khachhang;

CREATE LOGIN login_quantri WITH PASSWORD = 'quantri@123';
CREATE USER user_quantri FOR LOGIN login_quantri;
ALTER ROLE db_quantri ADD MEMBER user_quantri;

CREATE LOGIN login_baocao WITH PASSWORD = 'baocao@123';
CREATE USER user_baocao FOR LOGIN login_baocao;
ALTER ROLE db_baocao ADD MEMBER user_baocao;

CREATE LOGIN login_giaohang WITH PASSWORD = 'giaohang@123';
CREATE USER user_giaohang FOR LOGIN login_giaohang;
ALTER ROLE db_giaohang ADD MEMBER user_giaohang;
