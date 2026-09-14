clear all
use Data_Gabungan_2014.dta
gen Tahun = 2014
gen Pendidikan_Kepala_Desa_num= real(Pendidikan_Kepala_Desa)
recode Pendidikan_Kepala_Desa_num (1/4=0) (5/9=1)
gen Pendidikan_Sekretaris_Desa_num= real(Pendidikan_Sekretaris_Desa)
recode Pendidikan_Sekretaris_Desa_num (1/4=0) (5/9=1)
drop Pendidikan_Kepala_Desa Pendidikan_Sekretaris_Desa
tempfile Data_Gabungan_2014
save `Data_Gabungan_2014', replace

* Gabungkan dataset pertama dan kedua
use Data_Gabungan_2018.dta
gen Tahun = 2018
gen Pendidikan_Kepala_Desa_num =Pendidikan_Kepala_Desa
recode Pendidikan_Kepala_Desa_num (1/4=0) (5/9=1)
gen Pendidikan_Sekretaris_Desa_num =Pendidikan_Sekretaris_Desa
recode Pendidikan_Sekretaris_Desa_num (1/4=0) (5/9=1)
drop Pendidikan_Kepala_Desa Pendidikan_Sekretaris_Desa
append using `Data_Gabungan_2014'

tempfile Data_Gabungan_2014_2018
save `Data_Gabungan_2014_2018', replace

* Gabungkan gabungan dataset pertama dan kedua dengan dataset ketiga
use Data_Gabungan_2021.dta
gen Tahun = 2021
gen Pendidikan_Kepala_Desa_num =Pendidikan_Kepala_Desa
recode Pendidikan_Kepala_Desa_num (1/4=0) (5/9=1)
gen Pendidikan_Sekretaris_Desa_num =Pendidikan_Sekretaris_Desa
recode Pendidikan_Sekretaris_Desa_num (1/4=0) (5/9=1)
drop Pendidikan_Kepala_Desa Pendidikan_Sekretaris_Desa
append using `Data_Gabungan_2014_2018'
