use qlda

--➢1 Nhập vào MaNV cho biết tuổi của nhân viên này.
go
create function fTuoiNv (@manv nvarchar(9))
returns int
as
begin
	return (select DATEDIFF(year,NGSINH,GETDATE()) from NHANVIEN where MANV = @manv)
end

print dbo.fTuoiNv('001')

--➢2 Nhập vào Manv cho biết số lượng đề án nhân viên này đã tham gia
create function fDemDuan (@manv nvarchar(9))
returns int
as
begin
	return (select count(*) from PHANCONG where MA_NVIEN = @manv)
end

print dbo.fDemDuan('001')

--➢3 Truyền tham số vào phái nam hoặc nữ, xuất số lượng nhân viên theo phái

create function fDemGioiTinh (@gt nvarchar(4) = 'Nam')
returns int
as
begin
	return (select count(*) from NHANVIEN where PHAI like @gt)
end

print dbo.fDemGioiTinh(N'Nữ')

--➢4 Truyền tham số đầu vào là tên phòng, tính mức lương trung bình của phòng đó, Cho biết
--họ tên nhân viên (HONV, TENLOT, TENNV) có mức lương trên mức lương trung bình của phòng đó.

create function fLuongTrungBinh(@tenPhg nvarchar(20))
returns int
as
begin
	return (select avg(luong) from NHANVIEN nv join PHONGBAN pb on nv.PHG = pb.MAPHG where TENPHG like @tenPhg)
end

print dbo.fLuongTrungBinh(N'Điều hành')

select HONV,TENLOT,TENNV from NHANVIEN nv join PHONGBAN pb on nv.PHG = pb.MAPHG 
where luong>dbo.fLuongTrungBinh((N'Điều hành')) and pb.TENPHG like N'Điều hành'

--➢5 Tryền tham số đầu vào là Mã Phòng, cho biết tên phòng ban, họ tên người trưởng phòng
--và số lượng đề án mà phòng ban đó chủ trì.

create function fThongTinPB (@maphg int)
returns @tt table (tenpb nvarchar(20),tentrgphg nvarchar(50),slda int)
as
begin
	insert into @tt select pb.TENPHG ,concat(nv.HONV,' ',nv.TENLOT,' ',nv.TENNV) ,
	(select count(*) from DEAN where PHONG =@maphg) from PHONGBAN pb 
	join NHANVIEN nv on nv.manv = pb.TRPHG
	where pb.MAPHG = @maphg;
	return
end

select * from fThongTinPB(4)

--➢ Hiển thị thông tin HoNV,TenNV,TenPHG, DiaDiemPhg.
create view v_ThongTinNv_PHG
as
select honv,TENLOT,TENNV,pb.TENPHG,d.DIADIEM from NHANVIEN nv join PHONGBAN pb on nv.PHG = pb.MAPHG
join DIADIEM_PHG d on d.MAPHG= nv.phg

select * from v_ThongTinNv_PHG

--➢ Hiển thị thông tin TenNv, Lương, Tuổi.
create view v_ThongTinNv
as
select tennv,luong,datediff(year,NGSINH,GETDATE()) tuoi from NHANVIEN

select * from v_ThongTinNv

--➢ Hiển thị tên phòng ban và họ tên trưởng phòng của phòng ban có đông nhân viên nhất

create view v_TruongPhg_NVmax
as
select pb.TENPHG,honv+' '+TENLOT+' '+TENNV trgphg from nhanvien nv join PhongBan pb on nv.MANV = pb.TRPHG where nv.phg in 
(select top 1 count(*) slnv from NHANVIEN group by phg order by slnv desc)

select * from v_TruongPhg_NVmax