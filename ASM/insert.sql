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
insert into QL_GoiDang values (1,1,1000000000)
insert into QL_GoiDang values (2,1,1000000000)
insert into QL_GoiDang values (3,2,99)
insert into QL_GoiDang values (4,4,5)
insert into QL_GoiDang values (5,4,5)
insert into QL_GoiDang values (6,2,100)

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

--update QL_GoiDang set luotCon =5 where idNgDung=13
--delete from Nha_Tro

insert into Nha_Tro values ('Ban Mai',3,'TC','THANG',2,25,2000000,'001',N'01-Tôn Đức Thắng','2021-03-06',1,'0999111111',N'Gần Công Viên,Khu Mua Sắm')
insert into Nha_Tro values ('Penthouse',4,'TC','QUY',4,100,4000000,'002',N'03-Trần Cao Vân','2021-03-07',1,'0999222222',N'Có khu Thương mại, hồ bơi')
insert into Nha_Tro values (N'Nhà Cao Cấp',5,'NR','NAM',3,120,3500000,'003',N'99-Lý Thái Tổ','2021-03-08',1,'0999333333',N'Thoáng mát vệ sinh sạch sẽ')
insert into Nha_Tro values (N'Nhà Cao Cấp 2',5,'NR','NAM',2,60,3000000,'003',N'102-Lý Thái Tổ','2021-03-08',1,'0999333333',N'Thoáng mát vệ sinh sạch sẽ')
insert into Nha_Tro values (N'Phòng Trọ Cao Cấp',6,'PTKK','THANG',1,50,1500000,'004',N'333-Trần Cao Vân','2021-03-08',1,'0999444444',N'Gần Công viên')
insert into Nha_Tro values (N'Phòng Trọ Cao Cấp 2',6,'PTKK','THANG',1,80,1300000,'004',N'335-Trần Cao Vân','2021-03-08',1,'0999444444',N'Gần Công viên')

--11
insert into Hinh_Tro values (1,'https://drive.google.com/anh99.jpg')
insert into Hinh_Tro values (1,'https://drive.google.com/anh100.jpg')
insert into Hinh_Tro values (2,'https://drive.google.com/anh101.jpg')
insert into Hinh_Tro values (3,'https://drive.google.com/anh1011.jpg')
insert into Hinh_Tro values (4,'https://drive.google.com/anh102.jpg')
insert into Hinh_Tro values (5,'https://drive.google.com/anh103.jpg')
insert into Hinh_Tro values (5,'https://drive.google.com/anh104.jpg')
insert into Hinh_Tro values (6,'https://drive.google.com/anh105.jpg')
insert into Hinh_Tro values (6,'https://drive.google.com/anh106.jpg')

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
insert into CT_Tien_Nghi values (1,1,1,1)
insert into CT_Tien_Nghi values (1,3,1,1)
insert into CT_Tien_Nghi values (2,1,4,1)
insert into CT_Tien_Nghi values (3,1,3,1)
insert into CT_Tien_Nghi values (3,4,1,1)
insert into CT_Tien_Nghi values (4,9,1,1)
insert into CT_Tien_Nghi values (4,1,2,1)
insert into CT_Tien_Nghi values (5,1,1,1)
insert into CT_Tien_Nghi values (6,1,1,1)

--14 
insert into Danh_Gia values (1,1,1,5,N'Nhà trọ đẹp','192.168.1.1')
insert into Danh_Gia values (2,1,1,4,N'Nhà trọ bt','192.168.1.7')
insert into Danh_Gia values (2,2,0,1,N'Chán','192.168.1.6')
insert into Danh_Gia values (3,3,0,3,N'Hơi nhỏ','192.168.1.9')
insert into Danh_Gia values (4,4,1,5,N'Tốt','192.168.1.10')
insert into Danh_Gia values (5,4,1,5,N'Tốt','192.168.1.11')
insert into Danh_Gia values (6,5,0,3,N'Thiếu tiện nghi','192.168.1.99')
insert into Danh_Gia values (6,6,1,4,N'Được','192.168.1.100')

delete from Danh_Gia


