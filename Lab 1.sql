use QLDA 
go

--1. Cho biết  lương cao nhất trong công ty
declare @maxLuong1 int
select @maxLuong1= max(LUONG) from NHANVIEN
select TENNV,@maxLuong1 as 'Luong cao nhat' from NHANVIEN where LUONG = @maxLuong1

--2. Cho biết họ tên đầy đủ của các nhân viên ở TP HCM
declare @diaChi nvarchar(50)
set @diaChi = '%TP HCM'
select distinct concat(HONV,' ',TENLOT,' ',TENNV) as tenNV,DCHI as HoTen from NHANVIEN where DCHI like @diaChi

--3. Cho biết họ tên nhân viên (HONV, TENLOT, TENNV)  có mức lương trên mức lương trung bình
declare @tbLuong float
select @tbLuong = avg(LUONG) from NHANVIEN
select concat(HONV,' ',TENLOT,' ',TENNV) as Hoten,LUONG,pb.TENPHG 
from PHONGBAN as pb join NHANVIEN as nv on pb.MAPHG=nv.PHG
where LUONG>=@tbLuong

--4. Với các phòng ban có mức lương trung bình trên 30000 liệt kê tên phòng ban và số lượng nhân viên phòng ban đó
declare @LuongTheoPhong table (MAPhong int,LuongTB float,Sl int)
insert into @LuongTheoPhong select PHG,avg(LUONG),count(*) as 'luong TB cua Phong' from NHANVIEN 
group by PHG having AVG(LUONG)>30000
select TENPHG,LuongTB,Sl from @LuongTheoPhong as a join PHONGBAN on a.MAPhong=PHONGBAN.MAPHG

--5. Hiển thị tổng dự án của mỗi phòng ban.
declare @SLDeAn table (tenPhongBan nvarchar(15),SoLuongDuAn int)
insert into @SLDeAn select pb.TENPHG,slDuAn=count(*) from PHONGBAN as pb join DEAN on pb.MAPHG=DEAN.PHONG group by pb.TENPHG
select * from @SlDeAn

--6. Hiển thị tổng thân nhân của mỗi nhân viên.
declare @ThanNhan table (MaNV nvarchar(15),SoThanNhan int)
insert into @ThanNhan select tn.MA_NVIEN,count(*) from NHANVIEN as nv join THANNHAN as tn on nv.MANV=tn.MA_NVIEN group by MA_NVIEN
select * from @ThanNhan

--7. Tính tổng thời gian hoàn thành của mỗi dự án
declare @BangThongKe table (maDuAn nvarchar(50), thoiGian float)
insert into @BangThongKe select TENDEAN,sum(pc.THOIGIAN) as TGhoanThanh from DEAn as d join CONGVIEC as cv on d.MADA=cv.MADA
join PHANCONG as pc on cv.MADA=pc.MADA
group by TENDEAN
select * from @BangThongKe

--8. Hiển thị thông tin nhân viên gồm cột thứ 1 là
--TenNV, cột thứ 2 nhận giá trị.
--- “TangLuong” nếu lương hiện tại của nhân viên nhở hơn trung bình lương trong
--phòng mà nhân viên đó đang làm việc.
--- “KhongTangLuong “ nếu lương hiện tại của nhân viên lớn hơn trung bình lương
--trong phòng mà nhân viên đó đang làm việc.
declare @TTnv table (TenNv nvarchar(50),ChuThich nvarchar(50))
select TENNV,ChuThich = case
	when LUONG<d.tbluong then 'Tang luong'
	else 'Khong tang luong'
end
from NHANVIEN as nv 
join (select MAPHG,avg(luong) as tbluong from NHANVIEN as nv join PHONGBAN as pb on nv.PHG=pb.MAPHG group by MAPHG) as d on nv.PHG=d.MAPHG


--9. Hiển thị thông tin nhân viên và phân loại nhân viên dựa vào mức lương.
---  Nếu lương nhân viên nhỏ hơn trung bình lương mà nhân viên đó đang làm việc thì
--xếp loại “nhanvien”, ngược lại xếp loại “truongphong”
declare @TTnv2 table (TenNv nvarchar(50),ChuThich nvarchar(50))
select TENNV,ChuThich = case
	when LUONG<d.tbluong then 'Nhan Vien'
	else 'Truong phong'
end
from NHANVIEN as nv 
join (select MAPHG,avg(luong) as tbluong from NHANVIEN as nv join PHONGBAN as pb on nv.PHG=pb.MAPHG group by MAPHG) as d on nv.PHG=d.MAPHG


--10. Hiển thị thông tin nhân viên và thêm cột thuế, thuế mà nhân viên phải đóng theo công thức:
--- 0<luong<25000 thì đóng 10% tiền lương
--- 25000<luong<30000 thì đóng 12% tiền lương
--- 30000<luong<40000 thì đóng 15% tiền lương
--- 40000<luong<50000 thì đóng 20% tiền lương
--- Luong>50000 đóng 25% tiền lương
declare @BangThue table (TENNV nvarchar(15),MANV nvarchar(9),NGSINH datetime,LUONG float,Thue float)
insert into @BangThue select TENNV,MANV,NGSINH,LUONG,thue=case
when LUONG between 0 and 25000 then LUONG*0.1
when LUONG between 25000 and 30000 then LUONG*0.12
when LUONG between 30000 and 40000 then LUONG*0.15
when LUONG between 40000 and 50000 then LUONG*0.2
else LUONG*0.25
end
from NHANVIEN
select * from @BangThue