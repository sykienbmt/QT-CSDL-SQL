use [QLNHATRO_PK01738]
go

--1. Thêm thông tin vào các bảng 
--- Tạo ba Stored Procedure (SP) với các tham số đầu vào phù hợp. 
--o SP thứ nhất thực hiện chèn dữ liệu vào bảng NGUOIDUNG 
--o SP thứ hai thực hiện chèn dữ liệu vào bảng NHATRO 
--o SP thứ ba thực hiện chèn dữ liệu vào bảng DANHGIA 
 
--Yêu cầu đối với các SP:  Trong mỗi SP phải kiểm tra giá trị các tham số đầu vào. 
--Với các cột không chấp nhận thuộc tính NULL nếu các tham số đầu vào tương ứng với chúng không được truyền giá trị 
--thì không thực hiện câu lệnh chèn mà in một thông báo yêu cầu người dùng nhập liệu đầy đủ. 
--- Với mỗi SP viết hai lời gọi. Trong đó một lời gọi thực hiện chèn thành công dữ liệu và một lời gọi trả về thông báo lỗi cho người dùng. 

USE [QLNHATRO_PK01738]
GO

--SP thứ nhất thực hiện chèn dữ liệu vào bảng NGUOIDUNG 
alter proc sp_Them_NgDung (@tenNgDung nvarchar(50),@idLoaiNgDung varchar(10),@gioiTinh bit,@email varchar(50)
           ,@sdtNgDung char(10),@ngSinh date,@idXaPhuong varchar(5),@diaChi nvarchar(100),@idAnh nvarchar(150))
as 
begin 
	if @tenNgDung is null or @idLoaiNgDung is null or @gioiTinh is null or @email is null or 
	@sdtNgDung is null or @ngSinh is null or @idXaPhuong is null or @diaChi is null or @idAnh is null
	begin
		print N'Thêm Thất bại!'
		print N'Tên,loại ng dùng, Giới tính, email, sdt, Ngày sinh, xã, địa chỉ, ảnh không được để trống!'
		return;
	end
	else
	begin
		INSERT INTO Nguoi_Dung
		VALUES (@tenNgDung,@idLoaiNgDung,@gioiTinh,@email,@sdtNgDung,@ngSinh,@idXaPhuong,@diaChi,@idAnh);
		print N'Thêm thành công!'
	end
end

exec sp_Them_NgDung null,'Member',1,'son1247@gmail.com','0965000000','1989-01-09','003',N'13-Lý Thái TỔ','https://drive.google.com/anh10.jpg'

--o SP thứ hai thực hiện chèn dữ liệu vào bảng NHATRO 
go
alter proc sp_them_tro (@tenTro nvarchar(50),@idNgDung int,@idLoaiNha nvarchar(10),@idHinhThuc nvarchar(10),@soPhong tinyint,@dienTich float
		   ,@idXaPhuong varchar(5),@diaChi nvarchar(150),@ngayDangTin date,@tinhTrang bit,@sdtTro char(10),@moTa nvarchar(200),@gia float)
as
begin
	if @tenTro is null or @idNgDung is null or @idLoaiNha is null or @idHinhThuc is null or @soPhong is null or @dienTich is null or 
	@idXaPhuong is null or @diaChi is null or @ngayDangTin is null or @tinhTrang is null or @sdtTro is null or @moTa is null or @gia is null
	begin
		print N'Tên trọ, id người dùng, loại nhà, hình thức, số phòng, diện tích, xã, địa chỉ, ngày đăng, tình trạng, sđt, mô tả, giá không được để trống'
		print N'Thêm không thành công!'
	end
	else
	begin
		insert into Nha_tro 
		values (@tenTro,@idNgDung,@idLoaiNha,@idHinhThuc,@soPhong,@dienTich,@idXaPhuong,@diaChi,@ngayDangTin,@tinhTrang,@sdtTro,@moTa,@gia);
	end
end

exec sp_them_tro null,13,'TC','THANG',2,25,'001',N'01-Tôn Đức Thắng','2021-03-06',1,'0999111111',N'Gần Công Viên,Khu Mua Sắm',2000000

--o SP thứ ba thực hiện chèn dữ liệu vào bảng DANHGIA 

go
alter proc sp_them_danhGia (@idNgDung int,@idTro int,@danhGia bit, @comment nvarchar(150),@ip varchar(50),@sao tinyint)
as
begin
	if @idNgDung is null or @idTro  is null or @danhGia  is null or  @comment  is null or @ip  is null or @sao is null
	begin
		print N'id người dùng, id trọ, đánh giá, comment, ip, số sao không được để trống'
		print N'Thêm thất bại!'
	end
	else
	begin
		insert into [dbo].[Danh_Gia] values (@idNgDung, @idTro, @danhGia,  @comment, @ip, @sao);
		print N'Thêm đánh giá thành công!'
	end
end

exec sp_them_danhGia 16,21,1,N'Tốt','192.168.1.11',null


