use qlda
go

create trigger Check_name on Nhanvien for insert
as 
if (select len(tennv) from inserted) <6
begin
print N'Dữ liệu nhập sai'
rollback transaction
end


go
create trigger check_luong on nhanvien for insert 
as
if (select luong from inserted) <5000
begin
print N'Lương phải lớn hơn 5000'
rollback transaction
end

insert into NHANVIEN values ('nguyen','van','thađnh','022','1992-12-12','tp hcm','nam',7000,'006',5)


--trigger delete

go
alter trigger delele_manv on nhanvien for delete
as
begin
	declare @manv int, @tennv nvarchar(15)
	select @manv = MANV,@tennv=TENNV from deleted
	print @manv
	print @tennv
end

delete from NHANVIEN where MANV='021'

--không được xóa nhân viên ở tp hcm


go
create trigger delete_tphcm on nhanvien for delete
as
if(select count(*) from deleted where dchi like '%tp hcm') >0
begin
	print N'Không được xóa nv ở Tp Hcm'
	rollback transaction
end

delete from NHANVIEN where MANV='022'

--cap nhat nhân viên có lương 30000 + thêm 500

go
create trigger update_luong_count on nhanvien 
for update as
begin
	declare @dem int
	select @dem=COUNT(*) from inserted
	print N'số nhân viên đc cập nhật lương :' + @dem
end

-- update NHANVIEN set LUONG=luong+500 where luong =8500

--không xóa nv có mã nv = 2

go
alter trigger update_nv2 on nhanvien
for update as
begin
	if (select manv from inserted where MANV = '002')>0
	begin
		print N'không được cập nhật nv có mã nv = 002'
		rollback transaction
	end
end

--alter trigger
go
create trigger xlter_luong_count on nhanvien 
after update as
begin
	declare @dem int
	select @dem=COUNT(*) from inserted
	print N'số nhân viên đc cập nhật lương :' + cast(@dem as nvarchar(15))
end

update NHANVIEN set LUONG=luong+500 where luong =8500

update NHANVIEN set LUONG=luong+100 where luong =31200
