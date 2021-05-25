
-------------Nhan vien co luong tren 30000
if exists(select count(*) from NHANVIEN where LUONG>30000)
begin
	select * from NHANVIEN where LUONG>30000
end
else
	print 'khong co'


-----------------------------------------------
declare @diem int=9
SELECT @diem,
case
	when @diem between 0 and 4.5 then 'yeu'
	when @diem between 4.6 and 6.5 then 'trung binh'
	when @diem between 7 and 7.5  then 'kha'
	else 'gioi'
end

-----------------------------------------------
select TENNV,LUONG,pb.TENPHG,thue =case 
when LUONG >=30000 then LUONG*0.1
else 0
end
from NHANVIEN as nv join PHONGBAN as pb on nv.PHG=pb.MAPHG where pb.TENPHG=N'Nghiên Cứu'
order by thue desc

----------------------------------------------
select TENNV,newName= case 
when PHAI=N'Nam' then 'Mr '+TENNV
else 'Ms '+TENNV
end
from NHANVIEN
----------------------------------------

declare @num int=1,@tong int=0
while @num<=10
	begin
		if(@num =5) break
		set @tong=@tong+@num
		set @num=@num+1
	end;
print @tong
go
----------------------------------------
declare @num1 int=1,@tongChan int=0
while @num1<=10
begin
	set @tongChan=@tongChan+@num1
	set @num1=@num1+1
end;
print @tong
go
----------------------------------------

select nv.TENNV,count(MANV)as sl,thuong=case
when count(MANV) >=2 then 500000
else 0
end
from NHANVIEN as nv join PHANCONG as pc on nv.MANV=pc.MA_NVIEN group by nv.TENNV

----------------------------------------
select pb.TENPHG,nv.TENNV,luong,luongThuong=case
	when nv.MANV=pb.TRPHG then luong+2000
end
from PHONGBAN as pb join NHANVIEN as nv on pb.TRPHG=nv.MANV


-----------------------------------------
select nv.TENNV,luong,TongLuong=luong+case
	when nv.MANV=pb.TRPHG then 2000
	else 0
end
from PHONGBAN as pb join NHANVIEN as nv on pb.MAPHG=nv.PHG

-----------------------------------------
declare @tong int =0;
set @tong=(select sum(LUONG) from NHANVIEN)+ (select count(*) from PHONGBAN)*2000
print @tong

-----------------------------------------