use qlda
go

--Nhập vào số nguyên @n. In ra tổng các số chẵn từ 1 đến @n. 
create proc TinhTongChan @n int
as
begin
	declare @dem int =1,@tong int =0
	while @dem<=@n
	begin
		if(@dem %2 =0)
		begin
			set @tong=@tong+ @dem
		end
		set @dem =@dem+1
	end
	print @tong
end

exec TinhTongChan 10
go

--Nhập vào 2 số. In ra ước chung lớn nhất của chúng 
create proc ucln @a int, @b int
as
begin
	declare @tam int;
	if @a>@b
	begin
		select @tam=@a,
				@a=@b,
				@b=@tam
	end
	while @b % @a !=0
	begin
		select @tam=@a,
				@a=@b % @a,
				@b=@tam;
	end
	print N'Ước chung ln :' + cast(@a as varchar)

end

exec ucln 9,8
go

----Nhập vào 2 số. In ra ước chung lớn nhất của chúng 
create proc ucln2 @a int,@b int
as
begin
	declare @tam int,@dem int =2
	if @a>@b
	begin
		select @tam=@a,@a=@b,@b=@tam
	end
	while @dem<=@b
	begin
		if @a%@dem=0 and @b%@dem=0
		break;
		else
		set @dem=@dem+1
	end
	if @dem >@b
	set @dem=1
	print @dem
end

exec ucln2 9,8
go

----Nhập vào @Trphg (mã trưởng phòng), xuất thông tin các nhân viên có trưởng phòng là @Trphg và các nhân viên này không có thân nhân
create proc Timnv @Trphg nvarchar(9)
as
begin
	SELECT * from NHANVIEN as nv join PHONGBAN as pb on nv.PHG=pb.MAPHG
	where pb.TRPHG =@Trphg and not exists (select * from THANNHAN where MANV=nv.MANV)
end

exec Timnv '005'
