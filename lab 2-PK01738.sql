use QLDA
go


--ktra trong bảng phòng ban 
create proc ThemPB @tenphong nvarchar(15),@maphong int,@truongphong nvarchar(9),@ngaynhanchuc date
as
if exists (select * from PHONGBAN where MAPHG=@maphong)
begin
	print 'Phong ban da ton tai'
end
else insert into PHONGBAN values (@tenphong,@maphong,@truongphong,@ngaynhanchuc)

exec ThemPB 'CNTT',6,'005','2021-03-03'
go

--2 viết proc nhập vào năm sinh xuất ra tên các năm sinh

create proc TimNamSinh @namSinh int = 1995
as
select * from NHANVIEN where year(NGSINH) =@namSinh

exec TimNamSinh 1967
go

--3 Tổng thân nhân của nv có mã nhập vào
create proc TongThanNhan @maNhanVien nvarchar(9)='001'
as
select count(*) from THANNHAN where MA_NVIEN=@maNhanVien

exec TongThanNhan '005'
go

--4 nếu nhân viên có mức luong dưới trung bình cập  nhật lương = lương +200

create proc capNhatLuong @them int
as
update NHANVIEN set LUONG=LUONG+@them where luong< (select avg(luong) from NHANVIEN)

exec capNhatLuong 500
go

--5 HIển thị tuổi của nv có tên nhập vào

create proc TuoiNhanVien @tenNv nvarchar(15)
as
select tuoi=year(getdate())-year(NGSINH) from NHANVIEN where TENNV= @tenNv

exec TuoiNhanVien N'Như'
go

--6 HIển thị công việc của nhân viên có mã nv nhập vào

create proc CongViecNv @MAnv nvarchar(9)
as
select cv.TEN_CONG_VIEC from NHANVIEN as nv join PHANCONG as pc on pc.MA_NVIEN=nv.MANV
join CONGVIEC as cv on cv.MADA=pc.MADA
where MANV=@MAnv

exec CongViecNv '005'
go

--7 Hiển thị tổng dự án của phòng nghiên cứu

create proc TongDuAn @tenPHong nvarchar(15)
as
select pb.TENPHG,count(MADA) as sl from PHONGBAN as pb join DEAN on pb.MAPHG=dean.PHONG
group by pb.TENPHG having TENPHG like @tenPHong

exec TongDuAn N'Nghiên cứu'
go

--8 Tổng thời gian hoàn thành mỗi dự án, mã dự án nhập vào
create proc ThoiGianxong @mada int
as
select d.MADA,sum(pc.THOIGIAN) as TGhoanThanh from DEAn as d join CONGVIEC as cv on d.MADA=cv.MADA
join PHANCONG as pc on cv.MADA=pc.MADA
group by d.MADA having d.MADA=@mada

exec ThoiGianxong 1
go

--9 hiển thị nhân viên có lương cao nhất
create proc NhanVienLuongMax
as
select concat(HONV,' ',TENLOT,' ',TENNV) as ten,luong from NHANVIEN where LUONG =(select max(LUONG) from NHANVIEN)

exec NhanVienLuongMax
go

--10 Tính lương của nv nhập vào nếu lương >40000 thì thuế 0.1
create proc ThueNV @manv nvarchar(15),@luong int=40000,@thue float =0.1
as
select TENNV,luong,thue=luong*@thue,tongLuong=luong-luong*@thue from NHANVIEN where  LUONG>@luong and MANV = @manv

exec THueNV '001',20000,0.1