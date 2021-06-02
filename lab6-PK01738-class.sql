use qlda 
go

--➢1 Ràng buộc khi thêm mới nhân viên thì mức lương phải lớn hơn 15000,
--nếu vi phạm thì xuất thông báo “luong phải >15000’ 
create trigger them_nv40000 on Nhanvien for insert as
if (select luong from inserted)<40000
begin
	print N'Lương phải lớn hơn 40000'
	rollback transaction
end

insert into NHANVIEN values('nguyen','van','cong','111','1996-03-03','bmt','nam',10000,'005',4)

--➢2 Ràng buộc khi thêm mới nhân viên thì độ tuổi phải nằm trong khoảng 18 <= tuổi <=65. 
go
create trigger check_tuoi on Nhanvien for insert as
if (select year(getdate())-year(ngSinh) from inserted)>55 or 
(select year(getdate())-year(ngSinh) from inserted)<18
begin
	print N'Tuổi phải trong khoảng từ 18-55'
	rollback transaction
end

--➢3 xóa công việc khi xóa đề án

go
create trigger xoa_dean_cv on dean instead of delete as
begin
	declare @mada nvarchar(15)
	select @mada = mada from deleted
	delete from PHANCONG where mada = @mada
	delete from congviec where mada =@mada
	delete from dean where mada = 1
end

delete from DEAN where mada =1

--➢4 cập nhật các nv đang làm cv của dean 1 chuyển qua dean 2 khi xóa dean 1
go
create trigger capnhat_dean on dean instead of delete as
if exists(select mada from deleted where mada=1)
begin
	update phancong set mada = 2 where mada = 1
	delete CONGVIEC where mada = 1
	delete from dean where mada = 1
end

delete from DEAN where mada =1

--➢5 hiển thị tổng số dean thi thêm 1 dean mới
go 
create trigger tongso_dean on dean after insert as
begin
	declare @num char
	select @num =count(mada) from dean
	print N'Số lượng đề án là : ' + @num
end

insert into dean values (N'Ko làm gì',11,N'Bmt',4)

--➢6 hiển thị tổng số nhân viên khi xóa nhân viên có tuổi lớn hơn 55
go
alter trigger tong_nv on nhanvien after delete as
begin
	if (select count(*) from deleted where (year(GETDATE())-year(ngsinh)) >=55)>0
	begin
		declare @num char
		select @num =(select count(*) from deleted)
		print N'Số nv xóa mà tuổi trên 55 là '+ @num
	end
end

insert into NHANVIEN values('nguyen','van','cong','155','1960-03-03','bmt','nam',50000,'005',4)
insert into NHANVIEN values('nguyen','van','cong','157','1997-03-03','bmt','nam',55000,'005',4)

delete from NHANVIEN where MANV ='157'

--➢7 hiển thị tổng lương phải trả thêm, toonge số nv cập nhật lương nếu lượng <=30000 +500
go
create trigger luong_update on nhanvien for update as
if update(luong)
begin
	declare @num int, @tong int
	select @num =count(*) from inserted
	set @tong = @num*500
	print N'Tổng số lương trả thêm: ' + cast(@tong as char)
	print N'Tổng số nhân viên được cập nhật : ' + cast(@num as char)
end

update NHANVIEN set luong= luong+500 where luong<=30000

--➢8 thêm nhân viên thì tự động thêm công việc có mada = 2
go
alter trigger phancong_nvMoi on nhanvien after insert as
begin
	insert into PHANCONG values ((select manv from inserted),2,1,66)
end

insert into NHANVIEN values('nguyen','van','cong','161','1997-03-03','bmt','nam',16000,'005',4)

--➢9 xóa  nhân viên  có mã 02 thì xóa công việc có manv = 2 tham gia
go
alter trigger xoanv_Congviec on nhanvien instead of delete as
begin
	declare @manv nvarchar(15)
	set @manv =(select manv from deleted)
	delete from PHANCONG where MA_NVIEN = @manv
	delete from THANNHAN where MA_NVIEN = @manv
	delete from NHANVIEN where manv = @manv
end

insert into NHANVIEN values('nguyen','van','cong','161','1997-03-03','bmt','nam',16000,'005',4)
delete from nhanvien where MANV ='161'

--➢10 thêm đề án ở pb nào thì đếm đề án ở pb đó

go
create trigger dem_dean on dean after insert as
begin
	declare @phongban int,@dem int
	select @phongban = phong from inserted
	select @dem = count(*) from DEAN where PHONG=@phongban
	print N'Số lượng đề án mà phòng :' + cast(@phongban as char) + ' tham gia là : '+cast(@dem as char) 
end

insert into dean values (N'Ăn chơi',5,'BMT',5)