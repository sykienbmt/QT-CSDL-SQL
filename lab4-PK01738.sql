use qlda
go

--➢1 Với mỗi đề án, liệt kê tên đề án và tổng số giờ làm việc một tuần của tất cả các nhân viên
--tham dự đề án đó.
	--o Xuất định dạng “tổng số giờ làm việc” kiểu decimal với 2 số thập phân.
	--o Xuất định dạng “tổng số giờ làm việc” kiểu varchar
create proc sp_ThoiGianDuAn
as
declare @BangThongKe table (maDuAn int, thoiGian float)
insert into @BangThongKe select MADA,THOIGIAN from PHANCONG

select b.MADA,b.TENDEAN,cast(thoiGian as decimal(6,2)) as ThoiGianDemical,cast(thoiGian as varchar(50)) as ThoiGianVarchar 
from @BangThongKe as a join Dean as b on a.maDuAn=b.MADA

exec sp_ThoiGianDuAn
go

--➢2 Với mỗi phòng ban, liệt kê tên phòng ban và lương trung bình của những nhân viên làm
--việc cho phòng ban đó.
	--o Xuất định dạng “luong trung bình” kiểu decimal với 2 số thập phân, sử dụng dấu
	--phẩy để phân biệt phần nguyên và phần thập phân.
	--o Xuất định dạng “luong trung bình” kiểu varchar. Sử dụng dấu phẩy tách cứ mỗi 3
	--chữ số trong chuỗi ra, gợi ý dùng thêm các hàm Left, Replace
create proc sp_TBluongPhong
as
select b.TENPHG,avg(n.LUONG) as tbLuong,format(cast(avg(n.LUONG) as decimal(9,2)),'N','vi-VN') as tbLuongPhay,
convert(nvarchar(50),cast(avg(n.LUONG) as money),1) as tbluong2
from PHONGBAN as b join NHANVIEN as n on b.MAPHG=n.PHG
group by b.TENPHG

exec sp_TBluongPhong
go

--➢3 Với mỗi đề án, liệt kê tên đề án và tổng số giờ làm việc một tuần của tất cả các nhân viên
--tham dự đề án đó.
--o Xuất định dạng “tổng số giờ làm việc” với hàm CEILING
--o Xuất định dạng “tổng số giờ làm việc” với hàm FLOOR
--o Xuất định dạng “tổng số giờ làm việc” làm tròn tới 2 chữ số thập phân
create proc sp_thoiGianConvert
as
select d.TENDEAN,sum(THOIGIAN) as ThoiGian,CEILING(sum(THOIGIAN)) as TgCeiling,FLOOR(sum(THOIGIAN)) as TgFloor,ROUND(sum(THOIGIAN),2) as TgRound from PHANCONG as pc 
join dean as d on pc.MADA=d.MADA
group by d.TENDEAN

exec sp_thoiGianConvert
go

--➢4 Cho biết họ tên nhân viên (HONV, TENLOT, TENNV) có mức lương trên mức lương trung bình (làm tròn đến 2 số thập phân) của phòng "Nghiên cứu"

--➢5 Danh sách những nhân viên (HONV, TENLOT, TENNV, DCHI) có trên 2 thân nhân, thỏa các yêu cầu 
--o Dữ liệu cột HONV được viết in hoa toàn bộ 
--o Dữ liệu cột TENLOT được viết chữ thường toàn bộ 
--o Dữ liệu chột TENNV có ký tự thứ 2 được viết in hoa, các ký tự còn lại viết thường( ví dụ: kHanh) 
--o Dữ liệu cột DCHI chỉ hiển thị phần tên đường, không hiển thị các thông tin khác như số nhà hay thành phố.

--➢6 Cho biết tên phòng ban và họ tên trưởng phòng của phòng ban có đông nhân viên nhất, 
--hiển thị thêm một cột thay thế tên trưởng phòng bằng tên “Fpoly” 

--➢7 Cho biết các nhân viên có năm sinh trong khoảng 1960 đến 1965. 

--➢8 Cho biết tuổi của các nhân viên tính đến thời điểm hiện tại. 

--➢9 Dựa vào dữ liệu NGSINH, cho biết nhân viên sinh vào thứ mấy. 

--➢10 Cho biết số lượng nhân viên, tên trưởng phòng, ngày nhận chức trưởng phòng 
--và ngày nhận chức trưởng phòng hiển thi theo định dạng dd-mm-yy (ví dụ 25-04-2019) 


