declare @so1 int,@so2 int, @tich int
set @so1 = 5
set @so2 = 10
set @tich = @so1 * @so2
select @tich

declare @luong1 int
set @luong1=30000
print 'my luong' + convert (varchar(12),@luong1)
select * from NHANVIEN where LUONG=@luong1

--nv ở hcm
declare @tinh nvarchar(10)
set @tinh='%hcm'
select * from NHANVIEN where DCHI like @tinh

--luong cao nhất
declare @luongMax float
select  @luongMax= max(luong) from NHANVIEN
print 'Luong cao nhat la: ' + convert (varchar(12),@luongMax)

--dien tich chu nhat
declare @cdai int =50
declare @crong int =100
print 'Dien tich la: ' + convert (varchar(12),@cdai*@crong)

--table
declare @nhanVien_hcm table(TENNV nvarchar(15),MANV nvarchar(9))
insert into @nhanVien_hcm select TENNV,MANV from NHANVIEN where DCHI like '%hcm'
select * from @nhanVien_hcm

--nhân viên thuộc phòng nghiên cứu

declare @nhanVien table(TENNV nvarchar(15),PHG int,TENPHG nvarchar(15))
insert into @nhanVien select nv.TENNV,nv.PHG,pb.TENPHG from NHANVIEN as nv 
join PHONGBAN as pb on nv.PHG=pb.MAPHG 
where pb.TENPHG like N'%Nghiên Cứu%'
select * from @nhanVien


-- tổng nhân viên theo phòng ban có lương >=30000
declare @TongNhanVien table(PhongBan int,soluong int)
insert into @TongNhanVien select PHG,count(MANV) as soluong from NHANVIEN where luong>=30000 group by PHG
select * from @TongNhanVien

select D