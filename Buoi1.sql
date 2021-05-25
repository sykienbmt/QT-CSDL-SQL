create database NhanVien_DuAn

use NhanVien_DuAn

create table DuAn(
	MaDuAn tinyint identity primary key,
	TenDuAn nvarchar(50) not null,
	ThoiGianBD datetime not null,
	ThoiGianKT datetime not null
)
insert into DuAn values(N'ThietKeWeb','2021-3-29','2021-4-7')
insert into DuAn values(N'ThietKeApp','2021-3-30','2021-4-15')

create table NhanVien(
	MaNV tinyint identity primary key,
	TenNV nvarchar(50) not null,
	CMND nchar(9) not null unique,
	SDT nchar(10) not null,
	Luong float not null,
	MaPB tinyint not null
)
insert into NhanVien values('Dong','241548795','0964787458',5000000,1),
('t.Anh','241548796','0964787498',4900000,0)


create table NVien_DAn(
	MaDuAn tinyint foreign key references DuAn,
	MaNV tinyint foreign key references NhanVien,
	CongViec nvarchar(500),
	ChucVu bit
)

insert into NVien_DAn values(1,1,'ThietKeTrangChu')
insert into NVien_DAn values(1,2,'ThietKeTrangPhu')
