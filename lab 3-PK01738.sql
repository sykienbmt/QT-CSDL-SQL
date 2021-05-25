use QLDA
go

--1 In ra dòng ‘Xin chào’ + @ten với @ten là tham số đầu vào là tên Tiếng Việt có dấu của
--bạn. Gợi ý:
--o sử dụng UniKey để gõ Tiếng Việt ♦
--o chuỗi unicode phải bắt đầu bởi N (vd: N’Tiếng Việt’) ♦
--o dùng hàm cast (<biểuThức> as <kiểu>) để đổi thành kiểu <kiểu> của<biểuThức>

create proc Inten @ten nvarchar(50)
as
print N'Xin Chào '+ cast (@ten as nvarchar(50))

exec Inten N'Kiên'
go

--2 Nhập vào 2 số @s1,@s2. In ra câu ‘Tổng là : @tg’ với @tg=@s1+@s2.

create proc Tong2So @a int,@b int
as
declare @tong int = 0
set @tong = @a +@b
print N'Tổng là :' + cast (@tong as nvarchar(50))

exec Tong2So 5,6
go

--3 Nhập vào số nguyên @n. In ra tổng các số chẵn từ 1 đến @n.

create proc TinhTongChan @n int
as
begin
	declare @dem int =1,@tong int =0
	while @dem<=@n
	begin
		if(@dem %2 =0)
		begin
			set @tong=@tong+ @dem
		end
		set @dem =@dem+1
	end
	print @tong
end

exec TinhTongChan 10
go

--4 Nhập vào 2 số. In ra ước chung lớn nhất của chúng

create proc ucln2 @a int,@b int
as
begin
	declare @tam int,@dem int =2
	if @a>@b
	begin
		select @tam=@a,@a=@b,@b=@tam
	end
	while @dem<=@b
	begin
		if @a%@dem=0 and @b%@dem=0
		break;
		else
		set @dem=@dem+1
	end
	if @dem >@b
	set @dem=1
	print N'Ước chung lớn nhất : '+ cast(@dem as nvarchar(50))
end

exec ucln2 2,8
go

--5  Nhập vào @Manv, xuất thông tin các nhân viên theo @Manv

create proc XuatThongTinnv @manv as nvarchar(15)
as
begin
	select * from NHANVIEN where MANV=@manv
end

exec XuatThongTinnv '001'
go

--6 Nhập vào @MaDa (mã đề án), cho biết số lượng nhân viên tham gia đề án đó

create proc Demnv_da @MaDa as int
as
begin
	select MADA,count(MA_NVIEN) as slnv from PHANCONG group by MADA having MADA=@MaDa
end

exec Demnv_da 30
go

--7  Nhập vào @Trphg (mã trưởng phòng), xuất thông tin các nhân viên có trưởng phòng là
--@Trphg và các nhân viên này không có thân nhân.

create proc ttnv_0tn @Trphg nvarchar(9) 
as
begin
	select * from NHANVIEN as nv join PHONGBAN as pb on nv.PHG=pb.MAPHG
	where pb.TRPHG=@Trphg and not exists (select * from THANNHAN where MANV=nv.MANV)
end

exec ttnv_0tn '006'
go

--8 Nhập vào @Manv và @Mapb, kiểm tra nhân viên có mã @Manv có thuộc phòng ban có mã @Mapb hay không

create proc ktnv @manv nvarchar(15),@mapb int
as
begin
	if not exists (select * from NHANVIEN as nv where nv.MANV=@manv and nv.PHG=@mapb)
	print N'Nhân viên không thuộc phòng ban đã nhập'
	else
	print N'Nhân viên thuộc phòng ban đã nhập'
end

exec ktnv '001',4
go

--9 Thêm phòng ban có tên CNTT vào csdl QLDA, các giá trị được thêm vào dưới dạng
--tham số đầu vào, kiếm tra nếu trùng Maphg thì thông báo thêm thất bại.

create proc Them_PB @tenphong nvarchar(15),@maphong int,@truongphong nvarchar(9),@ngaynhanchuc date
as
if exists (select * from PHONGBAN where MAPHG=@maphong)
begin
	print N'Phòng ban đã tồn tại'
end
else insert into PHONGBAN values (@tenphong,@maphong,@truongphong,@ngaynhanchuc)

exec Them_PB 'CNTT',6,'005','2021-03-03'
go
select * from PHONGBAN

--10 Cập nhật phòng ban có tên CNTT thành phòng IT.

create proc update_pb @tenpb nvarchar(15)
as
begin
	update PHONGBAN set TENPHG = 'IT' where TENPHG=@tenpb
end

exec update_pb 'CNTT'
go

--11 Thêm một nhân viên vào bảng NhanVien, tất cả giá trị đều truyền dưới dạng tham số đầu
--vào với điều kiện:
--o nhân viên này trực thuộc phòng IT
--o Nhận @luong làm tham số đầu vào cho cột Luong, nếu @luong<25000 thì nhân
--viên này do nhân viên có mã 009 quản lý, ngươc lại do nhân viên có mã 005 quản
--lý
--o Nếu là nhân viên nam thi nhân viên phải nằm trong độ tuổi 18-65, nếu là nhân
--viên nữ thì độ tuổi phải từ 18-60.

create proc Them_nv @ho nvarchar(15),@tenlot nvarchar(15),@ten nvarchar(15),
@manv nvarchar(9),@nsinh datetime,@dchi nvarchar(30),@phai nvarchar(3),@luong float,@phg int =6
as
begin
declare @trgphg nvarchar(9)
declare @tuoi int = datediff(year,@nsinh,getdate());
if @luong<25000
set @trgphg='009'
else
set @trgphg='005'

if @phai='nam'
	begin
		if @tuoi<18 or @tuoi>65
		print N'Tuổi của nv nam phải từ 18-65'
		else
		insert into NHANVIEN values (@ho,@tenlot,@ten,@manv,@nsinh,@dchi,@phai,@luong,@trgphg,@phg)
	end
if @phai='nu'
	begin
		if @tuoi<18 or @tuoi>60
		print N'Tuổi của nv nam phải từ 18-65'
		else
		insert into NHANVIEN values (@ho,@tenlot,@ten,@manv,@nsinh,@dchi,@phai,@luong,@trgphg,@phg)
	end
end

exec Them_nv 'NGuyen','van','a','020','2009-01-01','199-bmt','nam',30000