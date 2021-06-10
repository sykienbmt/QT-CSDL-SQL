use QLNHATRO_PK01738
go

--1 thêm lượt vào user khi add user
create trigger sp_addLuot on Nguoi_Dung after insert as
begin
	insert into QL_GoiDang values ((select idNgDung from inserted),5,1)
end

--2 Nếu thêm vào ds ko có ngày trả thì set tình trạng thành 0
go
create trigger sp_update_TinhTrang on LS_Thue after insert as
begin
	declare @date date
	select @date = (select ngayTra from inserted);
	if @date=null
	begin
		update Nha_Tro set tinhTrang=0 where idTro = (select idTro from inserted)
	end
end

--3 nếu sửa lại ngày trả thì set lại trạng thái 1
go 
create trigger sp_update_TinhTrang2 on LS_Thue after update as
begin
	if update(ngayTra)
	begin
		update Nha_Tro set tinhTrang=1 where idTro = (select idTro from inserted)
	end
end

--4 Nếu thêm đánh giá set lại rate trong nhà trọ
go
create trigger sp_update_rate on danh_gia after insert as
begin
	declare @rate int 
	select @rate = avg(soSao) from Danh_Gia group by idTro having idTro = (select idTro from inserted) 
	update Nha_Tro set rate = @rate where idTro =(select idTro from inserted)
end

--5 trừ lượt-ktra lượt đăng
go
create trigger insert_NhaTro on Nha_Tro for insert as
begin
	declare @id int,@luot int
	select @id= idNgDung from inserted
	select @luot =luotcon from QL_GoiDang where @id = idNgDung
	if  exists (select idNgDung from QL_GoiDang where idNgDung=@id)
	begin
		if @luot=0
		begin
			print N'Đăng tin Thất bại lượt đăng tin còn 0 vui lòng mua thêm!'
			rollback transaction
		end
		else
		begin
			update QL_GoiDang set luotCon = luotCon -1 where @id = idNgDung
			set @luot = @luot -1
			print N'Đăng tin Thành công!' 
			print N'Người dùng'+cast(@id as char(3))+N' Còn ' + cast (@luot as char(9)) + N' Lượt đăng'
		end
	end
	else
	begin
		print N'Người dùng  '+cast(@id as char(3))+N' không có quyền đăng tin vui lòng mua gói!'
		rollback transaction
	end
end

--6 check mã trọ 

go
alter trigger sp_DayTin on Nha_Tro for insert as
if (select count(maTro) from Nha_Tro where maTro = (select maTro from inserted))>1
begin
	print N'Tin của bạn đã đc đưa lên top! '
	rollback transaction
end
else
	print N'Thêm Thành Công!'

insert into Nha_Tro values (N'Phòng Trọ Cao Cấp 2',6,'PTKK','THANG',1,80,1300000,'004',N'335-Trần Cao Vân','2021-03-08',
1,'0999444444',N'Gần Công viên',default,'009')
