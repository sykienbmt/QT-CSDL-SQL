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
alter trigger check_tuoi on Nhanvien for insert as
if (select year(getdate())-year(ngSinh) from inserted)>55 or 
(select year(getdate())-year(ngSinh) from inserted)<18
begin
	print N'Tuổi phải trong khoảng từ 18-55'
	rollback transaction
end

insert into NHANVIEN values('nguyen','van','cong','111','1900-03-03','bmt','nam',16000,'005',4)

--➢3 Ràng buộc khi cập nhật nhân viên thì không được cập nhật những nhân viên ở TP HCM 
go
create trigger check_nvTpbmt on nhanvien for update as
if (select count(*) from inserted where dchi like '%tp hcm')>0
begin
	print N'Không được cập nhật nhân viên ở Tp Hcm'
	rollback transaction
end

update NHANVIEN set luong=30000 where MANV='001'

--➢4 Hiển thị tổng số lượng nhân viên nữ, tổng số lượng nhân viên nam 
--mỗi khi có hành động thêm mới nhân viên. 
go
create trigger count_insert_nv on nhanvien after insert as
begin
declare @numMale char,@numFemale char 
select @numMale=count(manv) from NHANVIEN where PHAI = N'nam'
print N'Số lượng nhân viên nam: '+ @numMale
select @numFemale=count(manv) from NHANVIEN where PHAI= N'nữ'
print N'Số lượng nhân viên nữ: '+ @numFemale
end

insert into NHANVIEN values('nguyen','van','cong','154','1997-03-03','bmt','nam',16000,'005',4)

--➢5 Hiển thị tổng số lượng nhân viên nữ, tổng số lượng nhân viên nam 
--mỗi khi có hành động cập nhật phần giới tính nhân viên
go
create trigger count_GioiTinh on nhanvien after update as
begin
	if update(phai)
	begin
		declare @numMale char,@numFemale char 
		select @numMale=count(*) from NHANVIEN where PHAI like 'Nam'
		select @numFemale=count(*) from NHANVIEN where PHAI like N'Nữ'
		print N'Số lượng nhân viên nam: '+ @numMale
		print N'Số lượng nhân viên nữ: '+ @numfemale
	end
end

update NHANVIEN set phai=N'nữ' where MANV='006'
update NHANVIEN set TENNV='thai' where MANV='004'

--➢6 Hiển thị tổng số lượng đề án mà mỗi nhân viên đã làm khi có hành động xóa trên bảng DEAN
go
create trigger xoa_dean on dean after delete as
begin
select MA_NVIEN,count(MA_NVIEN) N'Sl dự án Tham gia' from PHANCONG group by MA_NVIEN
end

--➢7 Xóa các thân nhân trong bảng thân nhân có liên quan khi thực hiện hành động xóa nhân viên 
--trong bảng nhân viên. 
go
create trigger thanNhan_nv_delete on nhanvien instead of delete as
begin
	delete from THANNHAN where MA_NVIEN in (select MANV from deleted)
	delete from NHANVIEN where MANV in (select MANV from deleted)
end

delete from NHANVIEN where MANV like '154'

--➢8 Khi thêm một nhân viên mới thì tự động phân công cho nhân viên làm đề án có MADA là 1
go
create trigger phancong_nvMoi on nhanvien instead of insert as
begin
	insert into PHANCONG values ((select manv from inserted),1,1,66)
end

insert into NHANVIEN values('nguyen','van','cong','155','1997-03-03','bmt','nam',16000,'005',4)


go
create trigger tb_test on nhanvien after delete as
begin
	delete from THANNHAN where MA_NVIEN = (select manv from deleted)
	delete from NHANVIEN where manv = (select manv from deleted)
end
delete from NHANVIEN where MANV like '154'