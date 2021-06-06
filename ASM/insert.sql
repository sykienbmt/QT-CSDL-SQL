use QLNHATRO_PK01738


--1
insert into Tinh values ('HCM',N'Tp. Hồ Chí Minh')
insert into Tinh values ('BMT',N'Đăk Lăk')
insert into Tinh values ('HN',N'Hà Nội')
insert into Tinh values ('DN',N'Đà Nẵng')
insert into Tinh values ('BD',N'Bình Dương')

--2
insert into Quan_Huyen values ('Q1',N'Quận 1','HCM')
insert into Quan_Huyen values ('Q3',N'Quận 3','HCM')
insert into Quan_Huyen values ('Q7',N'Quận 7','HCM')
insert into Quan_Huyen values ('CMG',N'CưMgar','BMT')
insert into Quan_Huyen values ('LAK',N'Krong nang','BMT')

--3
insert into Xa_Phuong values ('001',N'Thống Nhất','Q1')
insert into Xa_Phuong values ('002',N'Giải Phóng','Q3')
insert into Xa_Phuong values ('003',N'Linh Trung','Q7')
insert into Xa_Phuong values ('004',N'Tân An','CMG')
insert into Xa_Phuong values ('005',N'Hoà Bình','LAK')

--4
insert into Loai_NgDung values ('Admin',N'Admin')
insert into Loai_NgDung values ('Manager',N'Quản Lý')
insert into Loai_NgDung values ('Member',N'Thành viên')


--5
insert into Nguoi_Dung values (N'Nguyễn Sỹ Kiên','Admin',1,'kienvippro@gmail.com','0964111111','1990-01-01','001',N'123-Tôn Đức Thắng','https://drive.google.com/anh1.jpg')
insert into Nguoi_Dung values (N'Lưu Thị Hạnh','Manager',0,'hanh456@gmail.com','0964222222','1994-02-02','002',N'23-Nguyễn Trãi','https://drive.google.com/anh2.jpg')
insert into Nguoi_Dung values (N'Nông Văn Thoan','Member',1,'Thoan336@gmail.com','0964333333','1985-03-03','003',N'254-Y Ngông','https://drive.google.com/anh3.jpg')
insert into Nguoi_Dung values (N'Trần Văn Mạnh','Member',1,'manh22@gmail.com','0964444444','1991-04-04','004',N'23-Kha Vạn Cân','https://drive.google.com/anh4.jpg')
insert into Nguoi_Dung values (N'Hà Thị Tiên','Member',0,'tien123@gmail.com','0964555555','1999-05-05','005',N'89-NGuyễn Đức Cảnh','https://drive.google.com/anh5.jpg')
insert into Nguoi_Dung values (N'Trần Anh Tuấn','Member',1,'tuan123@gmail.com','0964666666','1988-05-05','001',N'500-Nguyễn Tất Thành','https://drive.google.com/anh6.jpg')
insert into Nguoi_Dung values (N'Võ Thị Hà','Member',0,'ha123@gmail.com','0964777777','1999-05-05','001',N'123-Hà Huy Tập','https://drive.google.com/anh7.jpg')
insert into Nguoi_Dung values (N'NGuyễn Đông Sơn','Member',1,'dong123@gmail.com','0964888888','1988-01-09','004',N'13-Lý THường Kiệt','https://drive.google.com/anh8.jpg')

--6
insert into Goi_DangTin values (1,N'Không Giới Hạn',1000000000,1000000000)
insert into Goi_DangTin values (2,N'100 Bài Đăng',5000000,100)
insert into Goi_DangTin values (3,N'10 Bài Đăng',100000,10)
insert into Goi_DangTin values (4,N'1 Bài Đăng',110000,1)

--7
insert into QL_GoiDang values (10,1,1000000000)
insert into QL_GoiDang values (11,1,1000000000)
insert into QL_GoiDang values (12,2,99)
insert into QL_GoiDang values (13,4,5)
insert into QL_GoiDang values (14,4,5)
insert into QL_GoiDang values (15,2,100)

--8
insert into Loai_Nha values ('TC',N'Trung Cư')
insert into Loai_Nha values ('NR',N'Nhà Riêng')
insert into Loai_Nha values ('PTKK',N'Phòng Trọ Khép Kín')
insert into Loai_Nha values ('NN',N'Nhà Nghỉ')

--9
insert into HinhThucThue values ('GIO',N'Thuê Theo Giờ')
insert into HinhThucThue values ('NGAY',N'Thuê Theo Ngày')
insert into HinhThucThue values ('THANG',N'Thuê Theo Tháng')
insert into HinhThucThue values ('QUY',N'Thuê Theo Quý')
insert into HinhThucThue values ('NAM',N'Thuê Theo Năm')

--10
go
alter trigger insert_NhaTro on Nha_Tro for insert as
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

update QL_GoiDang set luotCon =5 where idNgDung=13
delete from Nha_Tro

insert into Nha_Tro values ('Ban Mai',13,'TC','THANG',2,25,'001',N'01-Tôn Đức Thắng','2021-03-06',1,'0999111111',N'Gần Công Viên,Khu Mua Sắm',2000000)
insert into Nha_Tro values ('Penthouse',14,'TC','QUY',4,100,'002',N'03-Trần Cao Vân','2021-03-07',1,'0999222222',N'Có khu Thương mại, hồ bơi',4000000)
insert into Nha_Tro values (N'Nhà Cao Cấp',15,'NR','NAM',3,120,'003',N'99-Lý Thái Tổ','2021-03-08',1,'0999333333',N'Thoáng mát vệ sinh sạch sẽ',3500000)
insert into Nha_Tro values (N'Nhà Cao Cấp 2',15,'NR','NAM',2,60,'003',N'102-Lý Thái Tổ','2021-03-08',1,'0999333333',N'Thoáng mát vệ sinh sạch sẽ',3000000)
insert into Nha_Tro values (N'Phòng Trọ Cao Cấp',12,'PTKK','THANG',1,50,'004',N'333-Trần Cao Vân','2021-03-08',1,'0999444444',N'Gần Công viên',1500000)
insert into Nha_Tro values (N'Phòng Trọ Cao Cấp 2',12,'PTKK','THANG',1,80,'004',N'335-Trần Cao Vân','2021-03-08',1,'0999444444',N'Gần Công viên',1300000)

--11
insert into Hinh_Tro values (18,'https://drive.google.com/anh99.jpg')
insert into Hinh_Tro values (18,'https://drive.google.com/anh100.jpg')
insert into Hinh_Tro values (19,'https://drive.google.com/anh101.jpg')
insert into Hinh_Tro values (19,'https://drive.google.com/anh1011.jpg')
insert into Hinh_Tro values (20,'https://drive.google.com/anh102.jpg')
insert into Hinh_Tro values (21,'https://drive.google.com/anh103.jpg')
insert into Hinh_Tro values (22,'https://drive.google.com/anh104.jpg')
insert into Hinh_Tro values (23,'https://drive.google.com/anh105.jpg')
insert into Hinh_Tro values (23,'https://drive.google.com/anh106.jpg')

--12
insert into Tien_Nghi values (N'Giường')
insert into Tien_Nghi values (N'Bàn')
insert into Tien_Nghi values (N'Ghế')
insert into Tien_Nghi values (N'Tủ Lạnh')
insert into Tien_Nghi values (N'Tivi')
insert into Tien_Nghi values (N'Bồn cầu')
insert into Tien_Nghi values (N'Bồn tắm')
insert into Tien_Nghi values (N'Tủ Đứng')
insert into Tien_Nghi values (N'Máy giặt')
insert into Tien_Nghi values (N'Máy lạnh')

--13
insert into CT_Tien_Nghi values (18,1,1,1)
insert into CT_Tien_Nghi values (18,3,1,1)
insert into CT_Tien_Nghi values (19,1,4,1)
insert into CT_Tien_Nghi values (20,1,3,1)
insert into CT_Tien_Nghi values (20,4,1,1)
insert into CT_Tien_Nghi values (20,9,1,1)
insert into CT_Tien_Nghi values (21,1,2,1)
insert into CT_Tien_Nghi values (22,1,1,1)
insert into CT_Tien_Nghi values (23,1,1,1)

--14 
insert into Danh_Gia values (16,18,1,N'Nhà trọ đẹp','192.168.1.1',5)
insert into Danh_Gia values (18,18,1,N'Nhà trọ bt','192.168.1.7',4)
insert into Danh_Gia values (16,19,0,N'Chán','192.168.1.6',1)
insert into Danh_Gia values (18,19,0,N'Hơi nhỏ','192.168.1.9',3)
insert into Danh_Gia values (15,20,1,N'Tốt','192.168.1.10',5)
insert into Danh_Gia values (16,21,1,N'Tốt','192.168.1.11',5)
insert into Danh_Gia values (14,22,0,N'Thiếu tiện nghi','192.168.1.99',3)
insert into Danh_Gia values (14,23,1,N'Được','192.168.1.100',4)

delete from Danh_Gia


