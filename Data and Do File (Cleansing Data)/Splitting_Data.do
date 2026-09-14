* Load dataset BUMDes
import excel "D:/Kerjaan/Project Cleansing Data/0. Data BUMDES 2014 2021.xlsx", sheet("Data") firstrow clear
rename DESA Nama_Desa
rename AdaTidakBumdes Eksistensi_BUMDes
rename JumlahUnitUsahaBisnisSosial UU_Bisnis_Sosial
rename JumlahUnitUsahaSewa UU_Sewa
rename JumlahUnitUsahaPerdagangan UU_Perdagangan
rename JumlahUnitUsahaKeuangan UU_Keuangan
rename JumlahUnitUsahaPerantara UU_Perantara
rename JumlahUnitUsahaBidangLingkun UU_Bidang_Lingkungan
rename JumlahUnitUsahaPariwisata UU_Pariwisata
rename TOTAL Total_UU
keep Nama_Desa TAHUN Eksistensi_BUMDes NamaBumdes UU_Bisnis_Sosial UU_Sewa UU_Perdagangan UU_Keuangan UU_Perantara UU_Bidang_Lingkungan UU_Pariwisata Total_UU
save Data_BUMDes.dta, replace

* Bagi berdasarkan tahun
use Data_BUMDes.dta, clear
keep if TAHUN == 2014
save Data_BUMDes_2014.dta, replace

use Data_BUMDes.dta, clear
keep if TAHUN == 2018
save Data_BUMDes_2018.dta, replace

use Data_BUMDes.dta, clear
keep if TAHUN == 2021
save Data_BUMDes_2021.dta, replace

* Load Dana Desa data
import excel "D:/Kerjaan/Project Cleansing Data/PPID_Dana_Desa_gg.xlsx", firstrow clear
gen Nama_Desa = upper(Desa)
drop Desa
rename E T15
rename F T16
rename G T17
rename H T18
rename I T19
rename J T20
rename K T21

replace T15 = 0 if missing(T15)
replace T16 = 0 if missing(T16)
replace T17 = 0 if missing(T17)
replace T18 = 0 if missing(T18)
replace T19 = 0 if missing(T19)
replace T20 = 0 if missing(T20)
replace T21 = 0 if missing(T21)
gen Tahun_2014 = 0
gen Tahun_2018 = log(T15 + T16 + T17 + T18)
replace Tahun_2018 = 0 if missing(Tahun_2018)
gen Tahun_2021 = log(T19 + T20 + T21)
replace Tahun_2021 = 0 if missing(Tahun_2021)

* Reshape Dana Desa to long format
gen rowid = _n
reshape long Tahun_, i(rowid Nama_Desa) j(Tahun)

drop rowid KodeDesa Pemda Provinsi T15 T16 T17 T18 T19 T20 T21

rename Tahun_ Dana_Desa
save Dana_Desa.dta, replace

* Bagi berdasarkan tahun
use Dana_Desa.dta, clear
keep if Tahun == 2014
save Data_Dana_2014.dta, replace

use Dana_Desa.dta, clear
keep if Tahun == 2018
save Data_Dana_2018.dta, replace

use Dana_Desa.dta, clear
keep if Tahun == 2021
save Data_Dana_2021.dta, replace

* Load Podes data
import excel "D:/Kerjaan/Project Cleansing Data/podes14_gg.xlsx", firstrow clear
gen KODE_BPS = r101 + "." + r102 + "." + r103 + "." + r104

gen Tahun = 2014
rename r104n Nama_Desa
rename r1212a KUD
rename r1601a_2 Pendidikan_Kepala_Desa
rename r1601b_2 Pendidikan_Sekretaris_Desa
rename r1212b KOPINKRA
rename r1212c KOSPIN
rename r1212d Koperasi_Lainnya
keep KODE_BPS Tahun Nama_Desa KUD Pendidikan_Kepala_Desa Pendidikan_Sekretaris_Desa KOPINKRA KOSPIN Koperasi_Lainnya
save Data_Podes_2014.dta, replace

import excel "D:/Kerjaan/Project Cleansing Data/podes18_gg.xlsx", firstrow clear
gen KODE_BPS = r101 + "." + r102 + "." + r103 + "." + r104

gen Tahun = 2018
rename r104n Nama_Desa
rename r1204a KUD
rename r1701ak5 Pendidikan_Kepala_Desa
rename r1701bk5 Pendidikan_Sekretaris_Desa
rename r1205a1 KOPINKRA
rename r1205a2 KOSPIN
rename r1205a3 Koperasi_Lainnya
keep KODE_BPS Tahun Nama_Desa KUD Pendidikan_Kepala_Desa Pendidikan_Sekretaris_Desa KOPINKRA KOSPIN Koperasi_Lainnya
save Data_Podes_2018.dta, replace

import excel "D:/Kerjaan/Project Cleansing Data/podes21_gg.xlsx", firstrow clear
gen KODE_BPS = r101 + "." + r102 + "." + r103 + "." + r104

gen Nama_Desa = upper(r104n)
gen Tahun = 2021
rename r1206a1 KUD
rename r1601ak5 Pendidikan_Kepala_Desa
rename r1601bk5 Pendidikan_Sekretaris_Desa
rename r1206a2 KOPINKRA
rename r1206a3 KOSPIN
rename r1206a4 Koperasi_Lainnya
keep KODE_BPS Tahun Nama_Desa KUD Pendidikan_Kepala_Desa Pendidikan_Sekretaris_Desa KOPINKRA KOSPIN Koperasi_Lainnya
save Data_Podes_2021.dta, replace

* Load Data Dagri
import excel "D:/Kerjaan/Project Cleansing Data/PENDUDUK_DAGRI.xlsx", sheet("tahun 2014") firstrow clear
gen KODE_DAGRI = REKAPITULASIDATAKEPENDUDUKAN
drop if strlen(KODE_DAGRI) != 13
rename B Nama_Desa
rename C Laki_Laki
rename D Perempuan
rename E Total_Penduduk
rename F KK
rename G Luas_km
drop REKAPITULASIDATAKEPENDUDUKAN
save Data_Dagri_2014.dta, replace

import excel "D:/Kerjaan/Project Cleansing Data/PENDUDUK_DAGRI.xlsx", sheet("tahun 2018") firstrow clear
gen KODE_DAGRI = REKAPITULASIDATAKEPENDUDUKAN
drop if strlen(KODE_DAGRI) != 13
rename B Nama_Desa
rename C Laki_Laki
rename D Perempuan
rename E Total_Penduduk
rename F KK
rename G Luas_km
drop REKAPITULASIDATAKEPENDUDUKAN
save Data_Dagri_2018.dta, replace

import excel "D:/Kerjaan/Project Cleansing Data/PENDUDUK_DAGRI.xlsx", sheet("tahun 2021") firstrow clear
gen KODE_DAGRI = REKAPITULASIDATAKEPENDUDUKAN
drop if strlen(KODE_DAGRI) != 13
rename B Nama_Desa
rename C Laki_Laki
rename D Perempuan
rename E Total_Penduduk
rename F KK
rename G Luas_km
drop REKAPITULASIDATAKEPENDUDUKAN
save Data_Dagri_2021.dta, replace
