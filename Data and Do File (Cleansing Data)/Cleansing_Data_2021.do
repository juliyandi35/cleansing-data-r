clear all
** Podes x Dana **
* Cleansing Data Podes
use Data_Dana_2021.dta, clear

*Hitung jumlah kemunculan setiap desa di dataset pertama
bysort Nama_Desa: gen count_1 = _N
duplicates drop Nama_Desa, force
tempfile data1_temp
save `data1_temp', replace

use Data_Podes_2021.dta, clear
bysort Nama_Desa: gen count_2 = _N
merge m:1 Nama_Desa using `data1_temp'

gen min_count = min(count_1, count_2)
bysort Nama_Desa: gen obs_no = _n

drop if obs_no > min_count
drop count_1 count_2 _merge min_count obs_no
drop Dana_Desa Tahun
save Data_Podes_2021_clean.dta, replace

* Cleansing Data Dana
use Data_Podes_2021.dta, clear
bysort Nama_Desa: gen count_1 = _N
duplicates drop Nama_Desa, force
tempfile data1_temp
save `data1_temp', replace

use Data_Dana_2021.dta, clear
bysort Nama_Desa: gen count_2 = _N
merge m:1 Nama_Desa using `data1_temp'
gen min_count = min(count_1, count_2)
bysort Nama_Desa: gen obs_no = _n

drop if obs_no > min_count
drop count_1 count_2 _merge min_count obs_no 
keep Nama_Desa Dana_Desa
replace Dana_Desa = 0 if missing(Dana_Desa)
save Data_Dana_2021_clean.dta, replace

* Gabungkan kedua data
use Data_Podes_2021_clean.dta, clear
tempfile Data_Podes_2021_clean
save `Data_Podes_2021_clean', replace

use Data_Dana_2021_clean.dta
merge m:m Nama_Desa using `Data_Podes_2021_clean'
drop _merge
save Data_Podes_Dana_2021.dta, replace

** Podes_Dana x Dagri **
clear all
* Cleansing Data Podes_Dana
use Data_Dagri_2021.dta, clear

*Hitung jumlah kemunculan setiap desa di dataset pertama
bysort Nama_Desa: gen count_1 = _N
duplicates drop Nama_Desa, force
tempfile data1_temp
save `data1_temp', replace

use Data_Podes_Dana_2021.dta, clear
bysort Nama_Desa: gen count_2 = _N
merge m:1 Nama_Desa using `data1_temp'

gen min_count = min(count_1, count_2)
bysort Nama_Desa: gen obs_no = _n

drop if obs_no > min_count
drop count_1 count_2 _merge min_count obs_no
drop Laki_Laki Perempuan Total_Penduduk KK Luas_km KODE_DAGRI
save Data_Podes_Dana_2021_clean.dta, replace

* Cleansing Data Dagri
use Data_Podes_Dana_2021.dta, clear
bysort Nama_Desa: gen count_1 = _N
duplicates drop Nama_Desa, force
tempfile data1_temp
save `data1_temp', replace

use Data_Dagri_2021.dta, clear
bysort Nama_Desa: gen count_2 = _N
merge m:1 Nama_Desa using `data1_temp'
gen min_count = min(count_1, count_2)
bysort Nama_Desa: gen obs_no = _n

drop if obs_no > min_count
drop count_1 count_2 _merge min_count obs_no 
keep Nama_Desa Laki_Laki Perempuan Total_Penduduk KK Luas_km KODE_DAGRI
save Data_Dagri_2021_clean.dta, replace

* Gabungkan kedua data
use Data_Podes_Dana_2021_clean.dta, clear
tempfile Data_Podes_Dana_2021_clean
save `Data_Podes_Dana_2021_clean', replace

use Data_Dagri_2021_clean.dta
merge m:m Nama_Desa using `Data_Podes_Dana_2021_clean'
drop _merge
save Data_Podes_Dana_Dagri_2021.dta, replace

** Podes_Dana_Dagri x BUMDes **
clear all
* Cleansing Data Podes_Dana_Dagri
use Data_BUMDes_2021.dta, clear

*Hitung jumlah kemunculan setiap desa di dataset pertama
bysort Nama_Desa: gen count_1 = _N
duplicates drop Nama_Desa, force
tempfile data1_temp
save `data1_temp', replace

use Data_Podes_Dana_Dagri_2021.dta, clear
bysort Nama_Desa: gen count_2 = _N
merge m:1 Nama_Desa using `data1_temp'

gen min_count = min(count_1, count_2)
bysort Nama_Desa: gen obs_no = _n

drop if obs_no > min_count
drop count_1 count_2 _merge min_count obs_no 
drop TAHUN Eksistensi_BUMDes NamaBumdes UU_Bisnis_Sosial UU_Sewa UU_Perdagangan UU_Keuangan UU_Perantara UU_Bidang_Lingkungan UU_Pariwisata Total_UU
save Data_Podes_Dana_Dagri_2021_clean.dta, replace

* Cleansing Data BUMDes
use Data_Podes_Dana_Dagri_2021.dta, clear
bysort Nama_Desa: gen count_1 = _N
duplicates drop Nama_Desa, force
tempfile data1_temp
save `data1_temp', replace

use Data_BUMDes_2021.dta, clear
bysort Nama_Desa: gen count_2 = _N
merge m:1 Nama_Desa using `data1_temp'
gen min_count = min(count_1, count_2)
bysort Nama_Desa: gen obs_no = _n

drop if obs_no > min_count
drop count_1 count_2 _merge min_count obs_no 
keep Nama_Desa Eksistensi_BUMDes UU_Bisnis_Sosial UU_Sewa UU_Perdagangan UU_Keuangan UU_Perantara UU_Bidang_Lingkungan UU_Pariwisata Total_UU
save Data_BUMDes_2021_clean.dta, replace

* Gabungkan kedua data
use Data_Podes_Dana_Dagri_2021.dta, clear
tempfile Data_Podes_Dana_Dagri_2021
save `Data_Podes_Dana_Dagri_2021', replace

use Data_BUMDes_2021_clean.dta
merge m:m Nama_Desa using `Data_Podes_Dana_Dagri_2021'
save Data_Gabungan_2021.dta, replace
