use qlda

go
create function s_tong (@a int, @b int)
returns int
as
begin
	return (@a+@b) 
end

print cast( (dbo.s_tong(1,2)) as char) 

go
alter function s_tong_nv(@mapb int)
returns int
as
begin
return (select count(*) from NHANVIEN where PHG=@mapb);
end

print dbo.s_tong_nv(5)

print dbo.fDemnv()

-- viết function trả về tên của nv mã 001

alter function fTenNv (@manv nvarchar(9) ='005')
returns nvarchar(50)
as
begin
	return (select concat(honv,' ',tenlot,' ',tennv) from NHANVIEN where MANV = @manv)
end

print dbo.ftennv(default)


--
alter function fNhanVien1(@pb int)
returns @tennv table (ten nvarchar(15),manv int,phg int)
as
begin
if @pb is null
	begin
		insert into @tennv select tennv,manv,phg from NHANVIEN 
	end
else
	begin
		insert into @tennv select tennv,manv,phg from NHANVIEN where phg = @pb
	end
return
end

select * from fnhanvien1(5)
