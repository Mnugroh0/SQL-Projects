-- data nya cukup akurat tapi terdapat kesalahan dimana setiap int harus dibagi 100 agar datanya 
-- sesuai dengan yang beredar di internet

-- Analisis data deth(kematian covid)

-- banyak kasus covid perbulan
select
	date_format(date, "%M-%Y") as bulan_tahun,
    sum(new_cases div 100) as banyak_kasus_perbulan
from deth
group by 1;

-- banyak korban meninggal disebabkan karna covid per bulannya
select
	date_format(date, "%M-%Y") as bulan_tahun,
    sum(new_deaths) div 100 as banyak_kematian_perbulan
from deth
group by 1;

-- banyak korban meninggal pertahunnya
select
	date_format(date, "%Y") as tahun,
    sum(new_deaths) div 100 as banyak_kasus_pertahun
from deth
group by 1;

-- total kasus covid di indonesia 
select sum(new_cases) div 100 as total_kasus_covid
from deth;

-- total korban meninggal akibat covid
select sum(new_deaths) div 100 as total_meninggal
from deth;

-- seberapa banyak masyarakat indonesia yang masuk rumah sakit dikarenakan covid
select 
	date_format(date, "%M-%Y") as bulan_tahun,
    sum(hosp_patients) div 100 as pasien_icu_covid
from deth
group by 1; -- output kosong mungkin dikarenakan tidak terhitung sebagai pasien


-- seberapa banyak masyarakat yang masuk icu dikarenakan covid
select 
	date_format(date, "%M-%Y") as bulan_tahun,
    sum(icu_patients) div 100 as pasien_icu_covid
from deth
group by 1;

-- 5 Bulan dengan jumlah terinfeksi paling tinggi
select
	date_format(date, "%M-%Y") as bulan_tahun,
    sum(new_cases div 100) as banyak_kasus_perbulan
from deth
group by 1
order by 2 desc
limit 5; 

-- Bulan dimana Jumlah kematian sangat tinggi
select
	date_format(date, "%M-%Y") as bulan_tahun,
    sum(new_deaths) div 100 as banyak_kematian_perbulan
from deth
group by 1
order by 2 desc
limit 5;

-- new cases vs new deaths per bulannya
select
	date_format(date, "%M-%Y") as bulan_tahun,
    sum(new_cases) div 100 as banyak_kasus_perbulan,
    sum(new_deaths) div 100 as banyak_kematian_perbulan
from deth
group by 1;

-- seberapa mematikannya covid ini 
select 
	bulan_tahun,
    banyak_kasus_perbulan,
    banyak_kematian_perbulan,
    (banyak_kematian_perbulan / banyak_kasus_perbulan)* 100 as persen_kematian
from (
select
	date_format(date, "%M-%Y") as bulan_tahun,
    sum(new_cases) div 100 as banyak_kasus_perbulan,
    sum(new_deaths) div 100 as banyak_kematian_perbulan
from deth 
group by 1) as summary
order by persen_kematian desc; 
/* awal-awal covid menyebabkan banyaknya korban jiwa dengan persen kematian yang tinggi dikarenakan
belum terdapat vaksin */

-- berapa persen orang yang terinfeksi
select
	date_format(date, "%M-%Y") as bulan_tahun,
    (sum(new_cases div 100) / population)*100 as persen_orang_terinfeksi
from deth 
group by 1;

-- DATA VAKSIN

-- new_tests vs new cases
select 
	date_format(date, "%M-%Y") as bulan_tahun,
    sum(new_cases div 100) as jumlah_kasus,
    sum(new_tests div 100) as jumlah_tes,
    sum(new_deaths div 100) as jumlah_meninggal
from vac
join deth using(date)
group by 1;
/* perbandingan antara tes dan jumlah kasus yang tercatat*/

-- positive rate berdasarkan bulan
select 
	date_format(date, "%M-%Y") as bulan_tahun,
    (sum(cast(new_tests as double))/100 / sum(cast(new_cases as double)))*100 as persen_infeksi
from vac
join deth using(date)
group by 1;

-- pengaruh vaksin dengan penurunan kasus
select 
	date_format(date, "%M-%Y") as bulan_tahun,
    sum(people_vaccinated div 100) as vaksin_1,
    sum(people_fully_vaccinated div 100) as full_vaksin,
    sum(new_cases div 100) as kasus_baru,
    sum(new_deaths div 100) as kematian
from vac
join deth using(date)
group by 1;

