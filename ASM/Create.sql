create database QLNHATRO_PK01738
use [QLNHATRO_PK01738]
go

--1
create table Tinh (
	idTinh varchar(5) primary key,
	tenTinh nvarchar(20) not null
)

--2
create table Quan_Huyen(
	idHuyen varchar(5) primary key,
	tenHuyen nvarchar(20) not null,
	idTinh varchar(5) not null foreign key references TINH
)


--3
create table Xa_Phuong(
	idXaPhuong varchar(5) primary key,
	tenXaPhuong nvarchar(20) not null,
	idHuyen varchar(5) not null foreign key references QUAN_HUYEN
)


--4
create table Loai_NgDung(
	idLoaiNgDung varchar(10) primary key,
	tenLoai varchar(20) not null,
)

--5
create table Nguoi_Dung(
	idNgDung int identity primary key,
	tenNgDung nvarchar(50) not null,
	idLoaiNgDung varchar(10) not null foreign key references LOAI_NGDUNG,
	gioiTinh bit not null,
	email varchar(50) not null unique,
	sdtNgDung char(10) not null unique,
	ngSinh date not null check (year(ngSinh)<year(getdate())),
	idXaPhuong varchar(5) not null foreign key references XA_PHUONG,
	diaChi nvarchar(100),
	idAnh nvarchar(150) not null unique
)

--6
create table Goi_DangTin(
	idGoi int primary key,
	tenGoi nvarchar(50) not null,
	gia float not null,
	soLuotDang float not null
)

--7
create table QL_GoiDang(
	idNgDung int foreign key references NGUOI_DUNG,
	idGoi int foreign key references Goi_DangTin,
	luotCon int not null
)

--8
create table Loai_Nha(
	idLoaiNha nvarchar(10) primary key,
	tenLoaiNha nvarchar(50) not null
)

--9
create table HinhThucThue(
	idHinhThuc nvarchar(10) primary key,
	tenHinhThuc nvarchar(50) not null,
)

--10
create table Nha_Tro(
	idTro int identity primary key,
	tenTro nvarchar(50) not null,
	idNgDung int not null foreign key references Nguoi_Dung,
	idLoaiNha nvarchar(10) not null foreign key references Loai_Nha,
	idHinhThuc nvarchar(10) not null foreign key references HinhThucThue,
	soPhong tinyint not null,
	dienTich float not null,
	gia float not null,
	idXaPhuong varchar(5) not null foreign key references Xa_Phuong,
	diaChi nvarchar(150) not null,
	ngayDangTin date not null check (ngayDangTin <= getdate()),
	tinhTrang bit default 1 not null,
	sdtTro char(10) not null,
	moTa nvarchar(200),
	rate tinyint default null check (rate>=1 and rate <=5),
	maTro varchar(5) default '001' not null 
)

--11
create table Hinh_Tro(
	idTro int not null foreign key references Nha_Tro,
	hinhTro nvarchar(150) not null unique 
)

--12
create table Tien_Nghi(
	idTienNghi int identity primary key,
	tenTienNghi nvarchar(50) not null,
)

--13
create table CT_Tien_Nghi(
	idTro int not null foreign key references Nha_Tro,
	idTienNghi  int not null foreign key references Tien_Nghi,
	soLuong int not null,
	tinhTrang bit not null
)

--14
create table Danh_Gia (
	idNgDung int not null foreign key references Nguoi_Dung,
	idTro int not null foreign key references Nha_Tro,
	danhGia bit not null,
	soSao tinyint not null default 5 check (0<=soSao and soSao<=5),
	comment nvarchar(150) not null,
	ipAddress varchar(50) not null
)

--15
create table comment (
	
)
--drop table Danh_Gia
--drop table CT_Tien_Nghi
--drop table Tien_Nghi
--drop table Hinh_Tro
--drop table Nha_Tro
--drop table HinhThucThue
--drop table Loai_Nha
--drop table QL_GoiDang
--drop table Goi_DangTin
--drop table Nguoi_Dung
--drop table Loai_NgDung
--drop table Xa_Phuong
--drop table Quan_Huyen
--drop table Tinh