use QLDA
go

declare @BangThongKe table (maDuAn int, thoiGian float)
insert into @BangThongKe select MADA,THOIGIAN from PHANCONG

select b.TENDEAN,cast(thoiGian as decimal(6,2)) as ThoiGianDemical from @BangThongKe as a join Dean as b on a.maDuAn=b.MADA

select b.TENDEAN,convert(decimal(6,2),thoiGian) as ThoiGianDemical from @BangThongKe as a join Dean as b on a.maDuAn=b.MADA

--làm tròn
select mada,sum(THOIGIAN),CEILING(sum(THOIGIAN)),FLOOR(sum(THOIGIAN)),ROUND(sum(THOIGIAN),2) from PHANCONG group by MADA

---nhân viên có lương > lương tb ở phòng nghiên cứu
select TENNV,TENLOT,HONV,luong from NHANVIEN 
where luong > (select avg(luong) from NHANVIEN where PHG in 
(select MAPHG from PHONGBAN where TENPHG like N'Nghiên Cứu'))

--ds nhân viên có trên 2 thân nhân
select HONV,TENLOT,TENNV,count(tn.MA_NVIEN) as sl from THANNHAN as tn 
join NHANVIEN as nv on tn.MA_NVIEN=nv.MANV
group by HONV,TENLOT,TENNV having count(tn.MA_NVIEN)>=2

-- lấy ra tt nv có mã là số chẵn
declare @slnv int,@num int =1;
select @slnv = cast(max(MANV) as int) from NHANVIEN
while @num <= @slnv
begin
	if @num=4
	begin
		set @num = @num+1;
		continue;
	end

	if (@num %2 =0)
	begin
		select HONV,TENLOT,TENNV from NHANVIEN where cast(MANV as int)=@num
	end
	set @num = @num +1;
end

--chèn dữ liệu thông báo lỗi
select * from NHANVIEN

begin try
	insert into PHONGBAN values (N'',5,'008','2021-03-20')
	print N'ADD dữ liệu thành công'
end try
begin catch
	print N'Add dữ liệu thất bại'
end catch
