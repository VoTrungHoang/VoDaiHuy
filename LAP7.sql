------bài 1
select YEAR(getdate())-YEAR(NGSINH) as N'Tuoi' from NHANVIEN where MANV = '001'


if OBJECT_ID('fn_TuoiNV') is not null
	drop function fn_TuoiNV

go
create function fn_TuoiNV(@MaNV nvarchar(9))
returns int
as
begin
	return(select YEAR(getdate())-YEAR(NGSINH) as N'Tuổi'
	from NHANVIEN where MANV = @MaNV)
END
------- 2

select COUNT(MADA) from PHANCONG  where MA_NVIEN = '004'

if OBJECT_ID('fn_DemDeAnNV')is not null
	drop function fn_DemDeAnNV
go
create function fn_DemDeAnNV(@MaNV varchar(9))
returns int
as
	begin
		return(select COUNT(MADA) from PHANCONG where MA_NVIEN=@MaNV)
	end
-----	-----3
select * from NHANVIEN
select COUNT (*) from NHANVIEN where PHAI like 'Nam'
select COUNT (*) from NHANVIEN where PHAI like N'Nữ'


create function fn_DemNV_Phai(@Phai nvarchar(5)=N'%')
returns int
as
	begin
		return(select COUNT(*) from NHANVIEN where PHAI like @Phai)
	end
--------------4
select PHG,TENPHG, AVG(LUONG) from NHANVIEN
inner join PHONGBAN on PHONGBAN.MAPHG= NHANVIEN.PHG
group by PHG, TENPHG

select AVG(LUONG) from NHANVIEN
inner join PHONGBAN on PHONGBAN.MAPHG = NHANVIEN.PHG
where TENPHG = 'IT'

if OBJECT_ID ('fn_NhanVien_PB')is not null
	drop function fn_Luong_NhanVien_PB
go
create function fn_Luong_NhanVien_PB(@TenPhongBan nvarchar(20))
returns @tbLuongNV table(fullname Nvarchar(50), luong float)
as
	begin
		DECLARE @LuongTB float
		select @LuongTB = AVG(LUONG) from NHANVIEN
		inner join PHONGBAN on PHONGBAN.MAPHG = NHANVIEN.PHG
		where TENPHG = @TenPhongBan

		insert into @tbLuongNV
			select HONV+' '+TENLOT+' '+TENNV, LUONG from NHANVIEN
			where LUONG > @luongTB
		return
	end
-------------5
select TENPHG,TRPHG,HONV+' '+TENLOT+' '+TENNV as 'Ten Truong Phong',COUNT(MADA) as 'SoLuongDeAn'
from PHONGBAN
inner join DEAN on DEAN.PHONG = PHONGBAN.MAPHG
inner join NHANVIEN on NHANVIEN.MANV = PHONGBAN.TRPHG
where PHONGBAN.MAPHG ='001'
group by TENPHG,TRPHG,TENNV,HONV,TENLOT


create function fn_SoLuongDeAnTheoPB(@MaPB int)
returns @tbListPB table(TenPB nvarchar(20), MaTB nvarchar(10), TenTB nvarchar(50), soLuong int)
as
begin
	insert into @tbListPB
	select TENPHG,TRPHG,HONV+' '+TENLOT+' '+TENNV as ' Ten Truong Phong',
	COUNT(MADA) as 'SoluongDeAn'from PHONGBAN
		INNER JOIN DEAN ON DEAN.PHONG = PHONGBAN.MAPHG
		INNER JOIN NHANVIEN ON NHANVIEN.MANV = PHONGBAN.TRPHG
		where PHONGBAN.MAPHG = @MaPB
		group by TENPHG,TRPHG,TENNV,HONV,TENLOT
	return
end
---------------BÀI 2
select HONV,TENNV,TENPHG, DIADIEM from PHONGBAN
inner join DIADIEM_PHG on DIADIEM_PHG.MAPHG = PHONGBAN.MAPHG
Inner join NHANVIEN on NHANVIEN.PHG = PHONGBAN.MAPHG

CREATE view v_DD_PhongBan
as
select HONV,TENNV,TENPHG, DIADIEM from PHONGBAN
inner join DIADIEM_PHG on DIADIEM_PHG.MAPHG = PHONGBAN.MAPHG
Inner join NHANVIEN on NHANVIEN.PHG = PHONGBAN.MAPHG

select * from v_DD_PhongBan

---------2b
select TENNV,LUONG,YEAR(GETDATE())-YEAR(NGSINH) as 'Tuoi' from NHANVIEN


create view v_TuoiNV
as
select  TENNV,LUONG,YEAR(GETDATE())-YEAR(NGSINH) as 'Tuoi' from NHANVIEN
 select * from v_TuoiNV

 ----------------2c
 create view v_TopSoLuongNV_PB
 as
 select top(1) TENPHG,TRPHG,B.HONV+' '+B.TENLOT+' '+B.TENNV as 'TenTB',count(A.MANV) as 'SoLuongNV'
 from NHANVIEN A
 inner join PHONGBAN on PHONGBAN.MAPHG=A.PHG
 inner join NHANVIEN B on B.MANV=PHONGBAN.TRPHG
 group by TENPHG,TRPHG,B.TENNV,B.HONV,B.TENLOT
 order by SoLuongNV desc

 select * from v_TopSoLuongNV_PB

 





