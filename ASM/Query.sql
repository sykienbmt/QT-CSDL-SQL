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
create proc sp_Them_NgDung (@tenNgDung nvarchar(50),@idLoaiNgDung varchar(10),@gioiTinh bit,@email varchar(50)
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
create proc sp_them_tro (@tenTro nvarchar(50),@idNgDung int,@idLoaiNha nvarchar(10),@idHinhThuc nvarchar(10),@soPhong tinyint,@dienTich float
		   ,@gia float,@idXaPhuong varchar(5),@diaChi nvarchar(150),@ngayDangTin date,@tinhTrang bit,@sdtTro char(10),@moTa nvarchar(200))
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
		values (@tenTro,@idNgDung,@idLoaiNha,@idHinhThuc,@soPhong,@dienTich,@gia,@idXaPhuong,@diaChi,@ngayDangTin,@tinhTrang,@sdtTro,@moTa);
	end
end

exec sp_them_tro null,13,'TC','THANG',2,25,2000000,'001',N'01-Tôn Đức Thắng','2021-03-06',1,'0999111111',N'Gần Công Viên,Khu Mua Sắm'

--o SP thứ ba thực hiện chèn dữ liệu vào bảng DANHGIA 

go
create proc sp_them_danhGia (@idNgDung int,@idTro int,@danhGia bit,@sao tinyint, @comment nvarchar(150),@ip varchar(50))
as
begin
	if @idNgDung is null or @idTro  is null or @danhGia  is null or  @comment  is null or @ip  is null or @sao is null
	begin
		print N'id người dùng, id trọ, đánh giá, comment, ip, số sao không được để trống'
		print N'Thêm thất bại!'
	end
	else
	begin
		insert into [dbo].[Danh_Gia] values (@idNgDung, @idTro, @danhGia, @sao,  @comment, @ip);
		print N'Thêm đánh giá thành công!'
	end
end

exec sp_them_danhGia 16,21,1,null,N'Tốt','192.168.1.11'


--2. Truy vấn thông tin
--		a. Viết một SP với các tham số đầu vào phù hợp. SP thực hiện tìm kiếm thông tin các
--		   phòng trọ thỏa mãn điều kiện tìm kiếm theo: Quận, phạm vi diện tích, phạm vi ngày đăng
--		   tin, khoảng giá tiền, loại hình nhà trọ.
--		   SP này trả về thông tin các phòng trọ, gồm các cột có định dạng sau:
--		o Cột thứ nhất: có định dạng ‘Cho thuê phòng trọ tại’ + <Địa chỉ phòng trọ>
--		  + <Tên quận/Huyện>
--		o Cột thứ hai: Hiển thị diện tích phòng trọ dưới định dạng số theo chuẩn Việt Nam +
--		  m2. Ví dụ 30,5 m2
--		o Cột thứ ba: Hiển thị thông tin giá phòng dưới định dạng số theo định dạng chuẩn
--		  Việt Nam. Ví dụ 1.700.000
--		o Cột thứ tư: Hiển thị thông tin mô tả của phòng trọ
--		o Cột thứ năm: Hiển thị ngày đăng tin dưới định dạng chuẩn Việt Nam.
--		  Ví dụ: 27-02-2012
--		o Cột thứ sáu: Hiển thị thông tin người liên hệ dưới định dạng sau:
--		▪ Nếu giới tính là Nam. Hiển thị: A. + tên người liên hệ. Ví dụ A. Thắng
--		▪ Nếu giới tính là Nữ. Hiển thị: C. + tên người liên hệ. Ví dụ C. Lan
--		o Cột thứ bảy: Số điện thoại liên hệ
--		o Cột thứ tám: Địa chỉ người liên hệ
---			Viết hai lời gọi cho SP này


go
alter proc sp_Tim_Tro @diachi nvarchar(50) = '%',@dienTichMin float = null,@dienTichmax float = null,@ngayDangTin date = null,
					@ngayDangTinend date = null,@giaTienMin float =null,@giaTienMax float = null,@loaiHinhTro nvarchar(10) = '%'
as
begin
select N'Cho thuê phòng trọ tại '+nt.diaChi +' - '+ x.tenXaPhuong+' - '+qh.tenHuyen+' - '+t.tenTinh 'Địa chỉ'
,format(dienTich,'N','vi-VN') N'Diện Tích',
format(gia,'N','vi-VN') N'Giá phòng',moTa N'Mô tả',convert(varchar,nt.ngayDangTin,105) N'Ngày Đăng Tin',
iif(nd.gioiTinh=1,'Anh '+ nd.tenNgDung,N'Chị '+ nd.tenNgDung) N'Liên lạc',nt.sdtTro N'SỐ đt liên hệ',
nd.diaChi +' - '+ x.tenXaPhuong+' - '+qh.tenHuyen+' - '+t.tenTinh 'Đ/c Liên hệ'
from Nha_Tro nt join Xa_Phuong x on nt.idXaPhuong=x.idXaPhuong
join Quan_Huyen qh on x.idHuyen= qh.idHuyen
join Tinh t on t.idTinh = qh.idTinh
join Nguoi_Dung nd on nd.idNgDung=nt.idNgDung
where @dienTichMin <=nt.dienTich and nt.dienTich<=@dienTichmax and @ngayDangTin<=nt.ngayDangTin and nt.ngayDangTin<=@ngayDangTinend
and @giaTienMin<= nt.gia and nt.gia<=@giaTienMax
end

exec sp_Tim_Tro '',0,1000,'2021-03-03','2021-03-07',0,5000000,''


--b. Viết một hàm có các tham số đầu vào tương ứng với tất cả các cột của bảng
--NGUOIDUNG. Hàm này trả về mã người dùng (giá trị của cột khóa chính của bảng
--NGUOIDUNG) thỏa mãn các giá trị được truyền vào tham số.

