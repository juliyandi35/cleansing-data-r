clear
set more off

import excel "D:\Kerjaan\Project Cleansing Data\Data Gabungan Seluruhnya.xlsx", sheet("Sheet1") firstrow

*Generate Variabel Interaksi
gen interaksi_ekonomi = EkstistensiBUMDes*UUPerdagangan*UUKeuangan*UUSewa 
gen interaksi_sosial = EkstistensiBUMDes*UUPerantara*UUBisnisSosial
gen interaksi_lingkungan= EkstistensiBUMDes*UUBidangLingkungan*UUPariwisata

xtset Tahun 
*Regresi tanpa interaksi
xtreg KUD EkstistensiBUMDes UUBisnisSosial UUSewa UUPerdagangan UUKeuangan UUPerantara UUBidangLingkungan UUPariwisata PendidikanKepalaDesa PendidikanSekretarisDesa TotalPenduduk KOSPIN KOPINKRA KoperasiLainnya DanaDesa