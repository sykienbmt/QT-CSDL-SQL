use QLDA
go


------TB lương của công ty
declare @maxLuong int;
select @maxLuong = avg(luong)
from NHANVIEN
print N'Trung bình lương của cả công ty là: '+ cast(@maxLuong as char)

------Khai báo bảng 
declare @bangTest table (MaNV nvarchar(9),TenNv nvarchar(15))
insert into @bangTest select MaNV,TenNV from NHANVIEN
select * from @bangTest

------if else
declare @tbLuong float
select @tbLuong= avg(luong) from NHANVIEN
if
	@tbLuong>30000
	print 'TB luong cao hon 30000'
else
	print 'TB luong nho hon hoac bang 30000'

------ds nhan vien luong >30000
if (select count(*) from NHANVIEN where LUONG>=30000)>0
begin
	print N'Danh sách nhân viên có lương >=30000'
	select TENNV,MANV from NHANVIEN where LUONG>=30000
end
else
	print N'Ko có ai lương trên 30000 -_- '

------ds Nhân viên có lương cao hơn lương trung bình
declare @luongTB float
select @luongTB = avg(LUONG) from NHANVIEN
print N'Những nhân viên có lương trên tb: '
select TENNV,MANV,LUONG from NHANVIEN where LUONG>@luongTB

-----thêm cột thuế cạnh lương
select MANV,LUONG,thue=case
when LUONG <=25000 then LUONG*0.1
when LUONG <=30000 then LUONG*0.2
else LUONG*0.22
end
from NHANVIEN

-----Viết câu truy vấn đếm số lượng nhân viên trong từng phòng ban, 
--nếu số lượng nhân viên nhỏ hơn 3 ➔hiển thị “Thiếu nhân viên”, 
--ngược lại <5 hiển thị “Đủ Nhan Vien”, ngược lại hiển thị”Đông nhân viên

select PHG,count(*) as SL,Chitiet=case
when count(*) <3 then N'Thiếu Nhân Viên'
when count(*) <5 then N'Đủ nhân viên'
else N'Dư Nhân Viên'
end
from NHANVIEN group by PHG

------NHân Viên có mức lương cao nhất
declare @maxLuong1 int
select @maxLuong1= max(LUONG) from NHANVIEN
select TENNV,@maxLuong1 as 'Luong cao nhat' from NHANVIEN where LUONG = @maxLuong1

-----Cho biết họ tên nhân viên (HONV, TENLOT, TENNV) có mức lương trên mức lương trung bình của phòng "Nghiên cứu”
declare @tbLuong1 float
select @tbLuong1 = avg(LUONG) from NHANVIEN
select concat(HONV,' ',TENLOT,' ',TENNV) as Hoten,LUONG,pb.TENPHG 
from PHONGBAN as pb join NHANVIEN as nv on pb.MAPHG=nv.PHG
where LUONG>=@tbLuong1 and pb.TENPHG like N'Nghiên Cứu'

-----Với các phòng ban có mức lương trung bình trên 30,000, liệt kê tên phòng ban và số lượng nhân viên của phòng ban đó. 
declare @LuongTheoPhong table (MAPhong int,LuongTB float,Sl int)
insert into @LuongTheoPhong select PHG,avg(LUONG),count(*) as 'luong TB cua Phong' from NHANVIEN 
group by PHG having AVG(LUONG)>30000
select TENPHG,LuongTB,Sl from @LuongTheoPhong as a join PHONGBAN on a.MAPhong=PHONGBAN.MAPHG

-----Với mỗi phòng ban, cho biết tên phòng ban và số lượng đề án mà phòng ban đó chủ trì
declare @SLDeAn table (tenPhongBan nvarchar(15),SoLuongDuAn int)
insert into @SLDeAn select pb.TENPHG,slDuAn=count(*) from PHONGBAN as pb join DEAN on pb.MAPHG=DEAN.PHONG group by pb.TENPHG
select * from @SlDeAn