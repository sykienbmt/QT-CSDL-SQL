use QLDA
go

create proc TaoPhongban @ten nvarchar(15),@maphg int,@trgph nvarchar(9),@ngayNhanChuc date
as
insert into Phongban values (@ten,@maphg,@trgph,@ngayNhanChuc) 


begin try
	exec TaoPhongban N'Kinh tế',12,'007','2021-12-12'
end try
begin catch
	SET NOCOUNT OFF
	select	ERROR_MESSAGE() error,
			ERROR_NUMBER() errNum,
			ERROR_LINE() line,
			ERROR_SEVERITY() severity,
			ERROR_STATE() errState,
			ERROR_PROCEDURE() errProc
end catch


begin try
	select 10/0
end try
begin catch
	select	ERROR_MESSAGE() error,
			ERROR_NUMBER() errNum,
			ERROR_LINE() line,
			ERROR_SEVERITY() severity,
			ERROR_STATE() errState,
			ERROR_PROCEDURE() errProc
end catch

--Transaction

begin transaction
begin try
	select 10/0
	exec TaoPhongban N'Kinh tế',15,'007','2021-12-12'
end try
begin catch
	select	ERROR_MESSAGE() error,
			ERROR_NUMBER() errNum,
			ERROR_LINE() line,
			ERROR_SEVERITY() severity,
			ERROR_STATE() errState,
			ERROR_PROCEDURE() errProc
	if(@@TRANCOUNT >0) rollback transaction;
end catch

if (@@TRANCOUNT >0) commit transaction;
go

--exercise
--1 try catch xóa đề án có mã đề án là 1
alter proc xoaDeAn @mada int
as
delete DEAN where MADA =@mada

begin try
	exec xoaDeAn 1
end try
begin catch
	select	ERROR_MESSAGE() error,
			ERROR_NUMBER() errNum,
			ERROR_LINE() line,
			ERROR_SEVERITY() severity,
			ERROR_STATE() errState,
			ERROR_PROCEDURE() errProc
end catch

--2 xóa nhân viên có mã nv =1
go
alter proc xoaNhanVien @manv nvarchar(15)
as
delete NHANVIEN where MANV =@manv


begin try
	delete NHANVIEN where MANV ='007'
end try
begin catch
	select	ERROR_MESSAGE() error,
			ERROR_NUMBER() errNum,
			ERROR_LINE() line,
			ERROR_SEVERITY() severity,
			ERROR_STATE() errState,
			ERROR_PROCEDURE() errProc
end catch

--3 transaction		- xóa đề án =1 bảng phân công
--					- xóa công việc của bảng cv có mada =1
--					- cập nhật bảng phancong có mada =1 -> 5
go
create proc sp_transaction 