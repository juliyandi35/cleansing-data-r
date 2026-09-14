library(readxl)
library(dplyr)
library(haven)

# Algoritma untuk menghilangkan nama desa yang hanya ada di salah satu data
feature_selection <- function(A,B){
  # Menghitung jumlah kemunculan nama desa di A dan B
  jumlah_desa_A <- table(A$Nama.Desa)
  jumlah_desa_B <- table(B$Nama.Desa)
  
  # Mencari nama desa yang jumlahnya berbeda di A dan B
  desa_beda_A <- names(jumlah_desa_A)[!(names(jumlah_desa_A) %in% names(jumlah_desa_B))]
  
  # Menghapus baris di A yang memiliki nama desa yang jumlahnya berbeda
  for (desa in desa_beda_A) {
    A <- A[!(A$Nama.Desa == desa), ]
  }
  
  # Menghitung jumlah kemunculan nama desa di A dan B
  jumlah_desa_A <- table(A$Nama.Desa)
  jumlah_desa_B <- table(B$Nama.Desa)
  
  desa_beda_B <- names(jumlah_desa_B)[!(names(jumlah_desa_B) %in% names(jumlah_desa_A))]
  
  # Menghapus baris di A yang memiliki nama desa yang jumlahnya berbeda
  for (desa in desa_beda_B) {
    B <- B[!(B$Nama.Desa == desa), ]
  }
  
  A
  B
  
  # Menghitung jumlah kemunculan nama desa di A dan B
  jumlah_desa_A <- table(A$Nama.Desa)
  jumlah_desa_B <- table(B$Nama.Desa)
  
  # Mencari nama desa yang jumlahnya berbeda di A dan B
  desa_beda <- names(jumlah_desa_A[jumlah_desa_A != jumlah_desa_B])
  
  # Menghapus baris di A yang memiliki nama desa yang jumlahnya berbeda
  for (desa in desa_beda) {
    if (length(which(A$Nama.Desa == desa)) > length(which(B$Nama.Desa == desa))){
      # Mencari indeks baris yang memuat nama desa yang berulang
      indeks_desa <- which(A$Nama.Desa == desa)
      
      # Menghitung jumlah baris yang perlu dihapus
      jumlah_hapus <- length(indeks_desa) - jumlah_desa_B[desa]
      
      # Menghapus baris yang berulang
      A <- A[-indeks_desa[(length(indeks_desa)-jumlah_hapus+1):length(indeks_desa)], ]
    } else {
      # Mencari indeks baris yang memuat nama desa yang berulang
      indeks_desa <- which(B$Nama.Desa == desa)
      
      # Menghitung jumlah baris yang perlu dihapus
      jumlah_hapus <- length(indeks_desa) - jumlah_desa_A[desa]
      
      # Menghapus baris yang berulang
      B <- B[-indeks_desa[(length(indeks_desa)-jumlah_hapus+1):length(indeks_desa)], ]
    }
  }
  
  A <- A[order(A$Nama.Desa), ]
  B <- B[order(B$Nama.Desa), ]
  
  data_gabungan <- cbind(A, B)
  return(data_gabungan)
}


## Import data BUMDes
Data.BUMDes <- read_excel("0. Data BUMDES 2014 2021.xlsx",sheet = "Data")
names(Data.BUMDes)
Data.BUMDes <- Data.BUMDes[,c(9,1,10:19)]
colnames(Data.BUMDes) <- c("Nama.Desa","Tahun","Eksistensi.Bumdes","Nama.Bumdes",
                           "UU.Bisnis.Sosial","UU.Sewa",
                           "UU.Perdagangan","UU.Keuangan",
                           "UU.Perantara","UU.Bidang.Lingkungan",
                           "UU.Pariwisata","Total.UU")
# Import data Dana Desa
Dana.Desa <- read_excel("PPID_Dana_Desa_gg.xlsx")
names(Dana.Desa)
colnames(Dana.Desa) <- c("Kode Desa","Desa","Pemda","Provinsi","T15",
                         "T16","T17","T18","T19","T20","T21")
Data.Awal <- data.frame(Nama.Desa = Dana.Desa$Desa,
                        Tahun.2014 = rep(0,length(Dana.Desa$Desa)),
                        Tahun.2018 = log(Dana.Desa$T15+Dana.Desa$T16+Dana.Desa$T17+Dana.Desa$T18),
                        Tahun.2021 = log(Dana.Desa$T19+Dana.Desa$T20+Dana.Desa$T21))
Data.Awal$Nama.Desa <- toupper(Data.Awal$Nama.Desa)

library(tidyr)
library(dplyr)
Data.Dana <- Data.Awal %>%
  pivot_longer(cols = starts_with("Tahun."),
               names_to = "Tahun",
               values_to = "Dana.Desa") %>%
  mutate(Tahun = as.numeric(gsub("Tahun.", "", Tahun)))
Data.Dana


# Data Podes
Data.2014 = read_excel("podes14_gg.xlsx")
Data.2014$KODE_BPS <- apply(Data.2014[,c(1,3,5,7)], 1, function(x) paste(x, collapse = "."))
Data.2014$TAHUN <- rep(2014,nrow(Data.2014))

Data.2014 <- Data.2014[,-c(1,3,5,7)]
names(Data.2014)
head(Data.2014$r104n)
str(Data.2014)
Data.2014 <- Data.2014[,c(152,153,4,109,134,138,110,111,112)] 
head(Data.2014)
colnames(Data.2014) <- c("KODE_BPS","Tahun","Nama_Desa","KUD","Pendidikan_Kepala_Desa","Pendidikan_Sekretaris_Desa","KOPINKRA","KOSPIN","Koperasi_Lainnya")
haven::write_dta(Data.2014,"Data Podes 2014.dta")
colnames(Data.2014) <- c("KODE_BPS","Tahun","Nama.Desa","KUD","Pendidikan.Kepala.Desa","Pendidikan.Sekretaris.Desa","KOPINKRA","KOSPIN","Koperasi.Lainnya")
writexl::write_xlsx(Data.2014,"Data Podes 2014.xlsx")

Dagri.2014 <- read_excel("PENDUDUK_DAGRI.xlsx",sheet = "tahun 2014" ,skip = 1)
Desa_Dagri.2014 <- subset(Dagri.2014, nchar(KODE) == 13)
names(Desa_Dagri.2014)
colnames(Desa_Dagri.2014) <- c("KODE_DAGRI","Nama_Desa","LAKI_LAKI","PEREMPUAN","TOTAL","KK","LUAS_KM2")
Desa_Dagri.2014 <- Desa_Dagri.2014[complete.cases(Desa_Dagri.2014[ , "Nama.Desa"]), ]
haven::write_dta(Desa_Dagri.2014,"Data Dagri 2014.dta")
colnames(Desa_Dagri.2014) <- c("KODE_DAGRI","Nama.Desa","LAKI-LAKI","PEREMPUAN","TOTAL","KK","LUAS.KM2")
writexl::write_xlsx(Desa_Dagri.2014,"Desa Dagri 2014.xlsx")

Data.Podes.Dagri.2014 <- feature_selection(Data.2014,Desa_Dagri.2014)
names(Data.Podes.Dagri.2014)
Data.Podes.Dagri.2014 <- Data.Podes.Dagri.2014[,c(1,10,3,2,4:9,12:16)]
colnames(Data.Podes.Dagri.2014) <- c("KODE_BPS","KODE_DAGRI","Nama.Desa","Tahun","KUD",
                                  "Pendidikan.Kepala.Desa","Pendidikan.Sekretaris.Desa",
                                  "KOPINKRA","KOSPIN","Koperasi.Lainnya","LAKI-LAKI",
                                  "PEREMPUAN","Total.Penduduk","KK","LUAS.KM2")

Data.BUMDes.2014 <- subset(Data.BUMDes,Tahun %in% 2014)
Data.Podes.Dagri.BUMDes.2014 <- feature_selection(Data.Podes.Dagri.2014,Data.BUMDes.2014)

Data.Dana.2014 <- subset(Data.Dana,Tahun %in% 2014)
Data.Dana.2014 <- Data.Dana.2014[order(Data.Dana.2014$Nama.Desa),]
Data.Gabungan.2014 <- feature_selection(Data.Podes.Dagri.BUMDes.2014,Data.Dana.2014)
names(Data.Gabungan.2014)
Data.Gabungan.2014 <- Data.Gabungan.2014[,c(1:15,18:27,30)]
colnames(Data.Gabungan.2014) <- c("KODE_BPS","KODE_DAGRI","Nama_Desa","Tahun","KUD",
                                  "Pendidikan_Kepala_Desa","Pendidikan_Sekretaris_Desa",
                                  "KOPINKRA","KOSPIN","Koperasi_Lainnya","LAKI_LAKI",
                                  "PEREMPUAN","Total_Penduduk","KK","LUAS_KM2",
                                  "Ekstistensi_BUMDes","Nama_BUMDes","UU_Bisnis_Sosial",
                                  "UU_Sewa","UU_Perdagangan","UU_Keuangan","UU_Perantara",
                                  "UU_Bidang_Lingkungan","UU_Pariwisata","Total_UU","Dana_Desa")
haven::write_dta(Data.Gabungan.2014,"Dataset Gabungan 2014.dta")
colnames(Data.Gabungan.2014) <- c("KODE_BPS","KODE_DAGRI","Nama.Desa","Tahun","KUD",
                                  "Pendidikan.Kepala.Desa","Pendidikan.Sekretaris.Desa",
                                  "KOPINKRA","KOSPIN","Koperasi.Lainnya","LAKI-LAKI",
                                  "PEREMPUAN","Total.Penduduk","KK","LUAS.KM2",
                                  "Ekstistensi.BUMDes","Nama.BUMDes","UU.Bisnis.Sosial",
                                  "UU.Sewa","UU.Perdagangan","UU.Keuangan","UU.Perantara",
                                  "UU.Bidang.Lingkungan","UU.Pariwisata","Total.UU","Dana.Desa")
writexl::write_xlsx(Data.Gabungan.2014,"Data Gabungan 2014.xlsx")

# Data 2018
Data.2018 = read_excel("podes18_gg.xlsx")
Data.2018$KODE_BPS <- apply(Data.2018[,c(1,3,5,7)], 1, function(x) paste(x, collapse = "."))
Data.2018$TAHUN <- rep(2018,nrow(Data.2018))

Data.2018 <- Data.2018[,-c(1,3,5,7)]
names(Data.2018)
head(Data.2018$r104n)
str(Data.2018)
Data.2018 <- Data.2018[,c(139,140,4,103,134,138,107,108,109)] 
colnames(Data.2018) <- c("KODE_BPS","Tahun","Nama.Desa","KUD","Pendidikan.Kepala.Desa","Pendidikan.Sekretaris.Desa","KOPINKRA","KOSPIN","Koperasi.Lainnya")
head(Data.2018)
writexl::write_xlsx(Data.2018,"Data Podes 2018.xlsx")
colnames(Data.2018) <- c("KODE_BPS","Tahun","Nama_Desa","KUD","Pendidikan_Kepala_Desa","Pendidikan_Sekretaris_Desa","KOPINKRA","KOSPIN","Koperasi_Lainnya")
haven::write_dta(Data.2018,"Data Podes 2018.dta")
colnames(Data.2018) <- c("KODE_BPS","Tahun","Nama.Desa","KUD","Pendidikan.Kepala.Desa","Pendidikan.Sekretaris.Desa","KOPINKRA","KOSPIN","Koperasi.Lainnya")

Dagri.2018 <- read_excel("PENDUDUK_DAGRI.xlsx",sheet = "tahun 2018" ,skip = 1)
Desa_Dagri.2018 <- subset(Dagri.2018, nchar(KODE) == 13)
names(Desa_Dagri.2018)
colnames(Desa_Dagri.2018) <- c("KODE_DAGRI","Nama.Desa","LAKI-LAKI","PEREMPUAN","TOTAL","KK","LUAS.KM2")
Desa_Dagri.2018 <- Desa_Dagri.2018[complete.cases(Desa_Dagri.2018[ , "Nama.Desa"]), ]
writexl::write_xlsx(Desa_Dagri.2018,"Desa Dagri 2018.xlsx")
colnames(Desa_Dagri.2018) <- c("KODE_DAGRI","Nama_Desa","LAKI_LAKI","PEREMPUAN","TOTAL","KK","LUAS_KM2")
haven::write_dta(Desa_Dagri.2018,"Data Dagri 2018.dta")
colnames(Desa_Dagri.2018) <- c("KODE_DAGRI","Nama.Desa","LAKI-LAKI","PEREMPUAN","TOTAL","KK","LUAS.KM2")

Data.Podes.Dagri.2018 <- feature_selection(Data.2018,Desa_Dagri.2018)
names(Data.Podes.Dagri.2018)
Data.Podes.Dagri.2018 <- Data.Podes.Dagri.2018[,c(1,10,3,2,4:9,12:16)]
colnames(Data.Podes.Dagri.2018) <- c("KODE_BPS","KODE_DAGRI","Nama.Desa","Tahun","KUD",
                                     "Pendidikan.Kepala.Desa","Pendidikan.Sekretaris.Desa",
                                     "KOPINKRA","KOSPIN","Koperasi.Lainnya","LAKI-LAKI",
                                     "PEREMPUAN","Total.Penduduk","KK","LUAS.KM2")

Data.BUMDes.2018 <- subset(Data.BUMDes,Tahun %in% 2018)
Data.Podes.Dagri.BUMDes.2018 <- feature_selection(Data.Podes.Dagri.2018,Data.BUMDes.2018)

Data.Dana.2018 <- subset(Data.Dana,Tahun %in% 2018)
Data.Dana.2018 <- Data.Dana.2018[order(Data.Dana.2018$Nama.Desa),]
Data.Gabungan.2018 <- feature_selection(Data.Podes.Dagri.BUMDes.2018,Data.Dana.2018)
names(Data.Gabungan.2018)
Data.Gabungan.2018 <- Data.Gabungan.2018[,c(1:15,18:27,30)]
colnames(Data.Gabungan.2018) <- c("KODE_BPS","KODE_DAGRI","Nama_Desa","Tahun","KUD",
                                  "Pendidikan_Kepala_Desa","Pendidikan_Sekretaris_Desa",
                                  "KOPINKRA","KOSPIN","Koperasi_Lainnya","LAKI_LAKI",
                                  "PEREMPUAN","Total_Penduduk","KK","LUAS_KM2",
                                  "Ekstistensi_BUMDes","Nama_BUMDes","UU_Bisnis_Sosial",
                                  "UU_Sewa","UU_Perdagangan","UU_Keuangan","UU_Perantara",
                                  "UU_Bidang_Lingkungan","UU_Pariwisata","Total_UU","Dana_Desa")
haven::write_dta(Data.Gabungan.2018,"Dataset Gabungan 2018.dta")
colnames(Data.Gabungan.2018) <- c("KODE_BPS","KODE_DAGRI","Nama.Desa","Tahun","KUD",
                                  "Pendidikan.Kepala.Desa","Pendidikan.Sekretaris.Desa",
                                  "KOPINKRA","KOSPIN","Koperasi.Lainnya","LAKI-LAKI",
                                  "PEREMPUAN","Total.Penduduk","KK","LUAS.KM2",
                                  "Ekstistensi.BUMDes","Nama.BUMDes","UU.Bisnis.Sosial",
                                  "UU.Sewa","UU.Perdagangan","UU.Keuangan","UU.Perantara",
                                  "UU.Bidang.Lingkungan","UU.Pariwisata","Total.UU","Dana.Desa")
writexl::write_xlsx(Data.Gabungan.2018,"Data Gabungan 2018.xlsx")

# Data 2021
Data.2021 = read_excel("podes21_gg.xlsx")
Data.2021$KODE_BPS <- apply(Data.2021[,c(1,3,5,7)], 1, function(x) paste(x, collapse = "."))
Data.2021$TAHUN <- rep(2021,nrow(Data.2021))

Data.2021 <- Data.2021[,-c(1,3,5,7)]
names(Data.2021)
head(Data.2021$r104n)
str(Data.2021)
Data.2021 <- Data.2021[,c(181,182,4,143,176,180,144,145,146)] 
colnames(Data.2021) <- c("KODE_BPS","Tahun","Nama.Desa","KUD","Pendidikan.Kepala.Desa","Pendidikan.Sekretaris.Desa","KOPINKRA","KOSPIN","Koperasi.Lainnya")
head(Data.2021)
Data.2021$Nama.Desa <- toupper(Data.2021$Nama.Desa)
writexl::write_xlsx(Data.2021,"Data Podes 2021.xlsx")
colnames(Data.2021) <- c("KODE_BPS","Tahun","Nama_Desa","KUD","Pendidikan_Kepala_Desa","Pendidikan_Sekretaris_Desa","KOPINKRA","KOSPIN","Koperasi_Lainnya")
haven::write_dta(Data.2021,"Data Podes 2021.dta")
colnames(Data.2021) <- c("KODE_BPS","Tahun","Nama.Desa","KUD","Pendidikan.Kepala.Desa","Pendidikan.Sekretaris.Desa","KOPINKRA","KOSPIN","Koperasi.Lainnya")

Dagri.2021 <- read_excel("PENDUDUK_DAGRI.xlsx",sheet = "tahun 2021" ,skip = 1)
Desa_Dagri.2021 <- subset(Dagri.2021, nchar(KODE) == 13)
names(Desa_Dagri.2021)
colnames(Desa_Dagri.2021) <- c("KODE_DAGRI","Nama.Desa","LAKI-LAKI","PEREMPUAN","TOTAL","KK","LUAS.KM2")
Desa_Dagri.2021 <- Desa_Dagri.2021[complete.cases(Desa_Dagri.2021[ , "Nama.Desa"]), ]
Desa_Dagri.2021$Nama.Desa <- toupper(Desa_Dagri.2021$Nama.Desa) 
writexl::write_xlsx(Desa_Dagri.2021,"Desa Dagri 2021.xlsx")
colnames(Desa_Dagri.2021) <- c("KODE_DAGRI","Nama_Desa","LAKI_LAKI","PEREMPUAN","TOTAL","KK","LUAS_KM2")
haven::write_dta(Desa_Dagri.2021,"Data Dagri 2021.dta")
colnames(Desa_Dagri.2021) <- c("KODE_DAGRI","Nama.Desa","LAKI-LAKI","PEREMPUAN","TOTAL","KK","LUAS.KM2")

Data.Podes.Dagri.2021 <- feature_selection(Data.2021,Desa_Dagri.2021)
names(Data.Podes.Dagri.2021)
Data.Podes.Dagri.2021 <- Data.Podes.Dagri.2021[,c(1,10,3,2,4:9,12:16)]
colnames(Data.Podes.Dagri.2021) <- c("KODE_BPS","KODE_DAGRI","Nama.Desa","Tahun","KUD",
                                     "Pendidikan.Kepala.Desa","Pendidikan.Sekretaris.Desa",
                                     "KOPINKRA","KOSPIN","Koperasi.Lainnya","LAKI-LAKI",
                                     "PEREMPUAN","Total.Penduduk","KK","LUAS.KM2")

Data.BUMDes.2021 <- subset(Data.BUMDes,Tahun %in% 2021)
Data.BUMDes.2021$Nama.Desa <- toupper(Data.BUMDes.2021$Nama.Desa)
Data.BUMDes.2021 <- Data.BUMDes.2021[complete.cases(Data.BUMDes.2021[,"Nama.Desa"]),]
Data.Podes.Dagri.BUMDes.2021 <- feature_selection(Data.Podes.Dagri.2021,Data.BUMDes.2021)

Data.Dana.2021 <- subset(Data.Dana,Tahun %in% 2021)
Data.Dana.2021 <- Data.Dana.2021[order(Data.Dana.2021$Nama.Desa),]
Data.Gabungan.2021 <- feature_selection(Data.Podes.Dagri.BUMDes.2021,Data.Dana.2021)
names(Data.Gabungan.2021)
Data.Gabungan.2021 <- Data.Gabungan.2021[,c(1:15,18:27,30)]
colnames(Data.Gabungan.2021) <- c("KODE_BPS","KODE_DAGRI","Nama_Desa","Tahun","KUD",
                                  "Pendidikan_Kepala_Desa","Pendidikan_Sekretaris_Desa",
                                  "KOPINKRA","KOSPIN","Koperasi_Lainnya","LAKI_LAKI",
                                  "PEREMPUAN","Total_Penduduk","KK","LUAS_KM2",
                                  "Ekstistensi_BUMDes","Nama_BUMDes","UU_Bisnis_Sosial",
                                  "UU_Sewa","UU_Perdagangan","UU_Keuangan","UU_Perantara",
                                  "UU_Bidang_Lingkungan","UU_Pariwisata","Total_UU","Dana_Desa")
haven::write_dta(Data.Gabungan.2021,"Dataset Gabungan 2021.dta")
colnames(Data.Gabungan.2021) <- c("KODE_BPS","KODE_DAGRI","Nama.Desa","Tahun","KUD",
                                  "Pendidikan.Kepala.Desa","Pendidikan.Sekretaris.Desa",
                                  "KOPINKRA","KOSPIN","Koperasi.Lainnya","LAKI-LAKI",
                                  "PEREMPUAN","Total.Penduduk","KK","LUAS.KM2",
                                  "Ekstistensi.BUMDes","Nama.BUMDes","UU.Bisnis.Sosial",
                                  "UU.Sewa","UU.Perdagangan","UU.Keuangan","UU.Perantara",
                                  "UU.Bidang.Lingkungan","UU.Pariwisata","Total.UU","Dana.Desa")
writexl::write_xlsx(Data.Gabungan.2021,"Data Gabungan 2021.xlsx")

# Gabungan seluruh data
Data.Gabungan <- rbind(Data.Gabungan.2014,Data.Gabungan.2018,Data.Gabungan.2021)
Data.Gabungan <- Data.Gabungan[order(Data.Gabungan$Nama.Desa), ]
head(Data.Gabungan)
colnames(Data.Gabungan) <- c("KODE_BPS","KODE_DAGRI","Nama_Desa","Tahun","KUD",
                                  "Pendidikan_Kepala_Desa","Pendidikan_Sekretaris_Desa",
                                  "KOPINKRA","KOSPIN","Koperasi_Lainnya","LAKI_LAKI",
                                  "PEREMPUAN","Total_Penduduk","KK","LUAS_KM2",
                                  "Ekstistensi_BUMDes","Nama_BUMDes","UU_Bisnis_Sosial",
                                  "UU_Sewa","UU_Perdagangan","UU_Keuangan","UU_Perantara",
                                  "UU_Bidang_Lingkungan","UU_Pariwisata","Total_UU","Dana_Desa")
haven::write_dta(Data.Gabungan,"Dataset Gabungan Seluruhnya.dta")
colnames(Data.Gabungan) <- c("KODE_BPS","KODE_DAGRI","Nama.Desa","Tahun","KUD",
                                  "Pendidikan.Kepala.Desa","Pendidikan.Sekretaris.Desa",
                                  "KOPINKRA","KOSPIN","Koperasi.Lainnya","LAKI-LAKI",
                                  "PEREMPUAN","Total.Penduduk","KK","LUAS.KM2",
                                  "Ekstistensi.BUMDes","Nama.BUMDes","UU.Bisnis.Sosial",
                                  "UU.Sewa","UU.Perdagangan","UU.Keuangan","UU.Perantara",
                                  "UU.Bidang.Lingkungan","UU.Pariwisata","Total.UU","Dana.Desa")
writexl::write_xlsx(Data.Gabungan,"Data Gabungan Seluruhnya.xlsx")

# Analisis Deskriptif Data-data Numerik
Tabel_Deskriptif_Numerik <- data.frame(Variabel =  c("KUD","KOPINKRA","KOSPIN","Koperasi Lainnya",
                                                     "Laki-laki","Perempuan","Total","KK","Luas Km2",
                                                     "UU.Bisnis.Sosial","UU.Sewa","UU.Perdagangan","UU.Keuangan",
                                                     "UU.Perantara","UU.Bidang.Lingkungan","UU.Pariwisata",
                                                     "Total.UU","Dana.Desa"),
                                       Obs = c(length(Data.Gabungan$KUD),
                                               length(Data.Gabungan$KOPINKRA),
                                               length(Data.Gabungan$KOSPIN),
                                               length(Data.Gabungan$Koperasi.Lainnya),
                                               length(Data.Gabungan$`LAKI-LAKI`),
                                               length(Data.Gabungan$PEREMPUAN),
                                               length(Data.Gabungan$Total.Penduduk),
                                               length(Data.Gabungan$KK),
                                               length(Data.Gabungan$LUAS.KM2),
                                               length(Data.Gabungan$UU.Bisnis.Sosial),
                                               length(Data.Gabungan$UU.Sewa),
                                               length(Data.Gabungan$UU.Perdagangan),
                                               length(Data.Gabungan$UU.Keuangan),
                                               length(Data.Gabungan$UU.Perantara),
                                               length(Data.Gabungan$UU.Bidang.Lingkungan),
                                               length(Data.Gabungan$UU.Pariwisata),
                                               length(Data.Gabungan$Total.UU),
                                               length(Data.Gabungan$Dana.Desa)),
                                       Mean=c(mean(Data.Gabungan$KUD),
                                              mean(Data.Gabungan$KOPINKRA),
                                              mean(Data.Gabungan$KOSPIN),
                                              mean(Data.Gabungan$Koperasi.Lainnya),
                                              mean(Data.Gabungan$`LAKI-LAKI`),
                                              mean(Data.Gabungan$PEREMPUAN),
                                              mean(Data.Gabungan$Total.Penduduk,na.rm = TRUE),
                                              mean(Data.Gabungan$KK),
                                              mean(Data.Gabungan$LUAS.KM2,na.rm = TRUE),
                                              mean(Data.Gabungan$UU.Bisnis.Sosial),
                                              mean(Data.Gabungan$UU.Sewa),
                                              mean(Data.Gabungan$UU.Perdagangan),
                                              mean(Data.Gabungan$UU.Keuangan),
                                              mean(Data.Gabungan$UU.Perantara),
                                              mean(Data.Gabungan$UU.Bidang.Lingkungan),
                                              mean(Data.Gabungan$UU.Pariwisata),
                                              mean(Data.Gabungan$Total.UU),
                                              mean(Data.Gabungan$Dana.Desa,na.rm = TRUE)),
                                       St.Dev=c(sd(Data.Gabungan$KUD),
                                                sd(Data.Gabungan$KOPINKRA),
                                                sd(Data.Gabungan$KOSPIN),
                                                sd(Data.Gabungan$Koperasi.Lainnya),
                                                sd(Data.Gabungan$`LAKI-LAKI`),
                                                sd(Data.Gabungan$PEREMPUAN),
                                                sd(Data.Gabungan$Total.Penduduk,na.rm = TRUE),
                                                sd(Data.Gabungan$KK),
                                                sd(Data.Gabungan$LUAS.KM2,na.rm = TRUE),
                                                sd(Data.Gabungan$UU.Bisnis.Sosial),
                                                sd(Data.Gabungan$UU.Sewa),
                                                sd(Data.Gabungan$UU.Perdagangan),
                                                sd(Data.Gabungan$UU.Keuangan),
                                                sd(Data.Gabungan$UU.Perantara),
                                                sd(Data.Gabungan$UU.Bidang.Lingkungan),
                                                sd(Data.Gabungan$UU.Pariwisata),
                                                sd(Data.Gabungan$Total.UU),
                                                sd(Data.Gabungan$Dana.Desa,na.rm = TRUE)),
                                       Min=c(min(Data.Gabungan$KUD),
                                             min(Data.Gabungan$KOPINKRA),
                                             min(Data.Gabungan$KOSPIN),
                                             min(Data.Gabungan$Koperasi.Lainnya),
                                             min(Data.Gabungan$`LAKI-LAKI`),
                                             min(Data.Gabungan$PEREMPUAN),
                                             min(Data.Gabungan$Total.Penduduk,na.rm = TRUE),
                                             min(Data.Gabungan$KK),
                                             min(Data.Gabungan$LUAS.KM2,na.rm = TRUE),
                                             min(Data.Gabungan$UU.Bisnis.Sosial),
                                             min(Data.Gabungan$UU.Sewa),
                                             min(Data.Gabungan$UU.Perdagangan),
                                             min(Data.Gabungan$UU.Keuangan),
                                             min(Data.Gabungan$UU.Perantara),
                                             min(Data.Gabungan$UU.Bidang.Lingkungan),
                                             min(Data.Gabungan$UU.Pariwisata),
                                             min(Data.Gabungan$Total.UU),
                                             min(Data.Gabungan$Dana.Desa,na.rm = TRUE)),
                                       Max=c(max(Data.Gabungan$KUD),
                                             max(Data.Gabungan$KOPINKRA),
                                             max(Data.Gabungan$KOSPIN),
                                             max(Data.Gabungan$Koperasi.Lainnya),
                                             max(Data.Gabungan$`LAKI-LAKI`),
                                             max(Data.Gabungan$PEREMPUAN),
                                             max(Data.Gabungan$Total.Penduduk,na.rm = TRUE),
                                             max(Data.Gabungan$KK),
                                             max(Data.Gabungan$LUAS.KM2,na.rm = TRUE),
                                             max(Data.Gabungan$UU.Bisnis.Sosial),
                                             max(Data.Gabungan$UU.Sewa),
                                             max(Data.Gabungan$UU.Perdagangan),
                                             max(Data.Gabungan$UU.Keuangan),
                                             max(Data.Gabungan$UU.Perantara),
                                             max(Data.Gabungan$UU.Bidang.Lingkungan),
                                             max(Data.Gabungan$UU.Pariwisata),
                                             max(Data.Gabungan$Total.UU),
                                             max(Data.Gabungan$Dana.Desa,na.rm = TRUE)))

Tabel_Deskriptif_Numerik
writexl::write_xlsx(Tabel_Deskriptif_Numerik,"Tabel Deskriptif Numerik.xlsx")

# Analisis Deskriptif Data-data Kategorik
Data.Gabungan$Pendidikan.Kepala.Desa <- as.factor(Data.Gabungan$Pendidikan.Kepala.Desa)
Data.Gabungan$Pendidikan.Sekretaris.Desa <- as.factor(Data.Gabungan$Pendidikan.Sekretaris.Desa)

Data.Gabungan$Pendidikan.Kepala.Desa <- ifelse(Data.Gabungan$Pendidikan.Kepala.Desa == 1, "Tidak Pernah Sekolah",
                                                            ifelse(Data.Gabungan$Pendidikan.Kepala.Desa == 2, "Tidak Tamat SD",
                                                                   ifelse(Data.Gabungan$Pendidikan.Kepala.Desa == 3 , "SD",
                                                                          ifelse(Data.Gabungan$Pendidikan.Kepala.Desa == 4, "SMP",
                                                                                 ifelse(Data.Gabungan$Pendidikan.Kepala.Desa == 5, "SMU", 
                                                                                        ifelse(Data.Gabungan$Pendidikan.Kepala.Desa == 6, "D-III", 
                                                                                               ifelse(Data.Gabungan$Pendidikan.Kepala.Desa == 7, "S1", 
                                                                                                      ifelse(Data.Gabungan$Pendidikan.Kepala.Desa == 8, "S2", 
                                                                                                             ifelse(Data.Gabungan$Pendidikan.Kepala.Desa == 9, "S3", Data.Gabungan$Pendidikan.Kepala.Desa)))))))))
Data.Gabungan$Pendidikan.Sekretaris.Desa <- ifelse(Data.Gabungan$Pendidikan.Sekretaris.Desa == 1, "Tidak Pernah Sekolah",
                                               ifelse(Data.Gabungan$Pendidikan.Sekretaris.Desa == 2, "Tidak Tamat SD",
                                                      ifelse(Data.Gabungan$Pendidikan.Sekretaris.Desa == 3 , "SD",
                                                             ifelse(Data.Gabungan$Pendidikan.Sekretaris.Desa == 4, "SMP",
                                                                    ifelse(Data.Gabungan$Pendidikan.Sekretaris.Desa == 5, "SMU", 
                                                                           ifelse(Data.Gabungan$Pendidikan.Sekretaris.Desa == 6, "D-III", 
                                                                                  ifelse(Data.Gabungan$Pendidikan.Sekretaris.Desa == 7, "S1", 
                                                                                         ifelse(Data.Gabungan$Pendidikan.Sekretaris.Desa == 8, "S2", 
                                                                                                ifelse(Data.Gabungan$Pendidikan.Sekretaris.Desa == 9, "S3", Data.Gabungan$Pendidikan.Sekretaris.Desa)))))))))
Data.Gabungan$Ekstistensi.BUMDes <- ifelse(Data.Gabungan$Ekstistensi.BUMDes == 0, "Tidak Ada",
                                                   ifelse(Data.Gabungan$Ekstistensi.BUMDes == 1, "Ada", Data.Gabungan$Ekstistensi.BUMDes))


pie(table(Data.Gabungan$Pendidikan.Kepala.Desa), labels =  paste(names(table(Data.Gabungan$Pendidikan.Kepala.Desa)), " (", round(table(Data.Gabungan$Pendidikan.Kepala.Desa) / sum(table(Data.Gabungan$Pendidikan.Kepala.Desa)) * 100, 1), "%)", sep = ""), main = "Pendidikan Tertinggi Kepala Desa")
pie(table(Data.Gabungan$Pendidikan.Sekretaris.Desa), labels =  paste(names(table(Data.Gabungan$Pendidikan.Sekretaris.Desa)), " (", round(table(Data.Gabungan$Pendidikan.Sekretaris.Desa) / sum(table(Data.Gabungan$Pendidikan.Sekretaris.Desa)) * 100, 1), "%)", sep = ""), main = "Pendidikan Tertinggi Sekretaris Desa")
pie(table(Data.Gabungan$Ekstistensi.BUMDes), labels =  paste(names(table(Data.Gabungan$Ekstistensi.BUMDes)), " (", round(table(Data.Gabungan$Ekstistensi.BUMDes) / sum(table(Data.Gabungan$Ekstistensi.BUMDes)) * 100, 1), "%)", sep = ""), main = "Eksistensi BUMDes")

table(Data.Gabungan$Pendidikan.Kepala.Desa)
table(Data.Gabungan$Pendidikan.Sekretaris.Desa)
table(Data.Gabungan$Ekstistensi.BUMDes)

Tabel_Frekuensi_Pendidikan <- rbind(table(Data.Gabungan$Pendidikan.Kepala.Desa),table(Data.Gabungan$Pendidikan.Sekretaris.Desa))
rownames(Tabel_Frekuensi_Pendidikan) <- c("Kepala Desa","Sekretaris Desa")
Tabel_Frekuensi_Pendidikan
writexl::write_xlsx(data.frame(Tabel_Frekuensi_Pendidikan),"Tabel Frekuensi Pendidikan Tertinggi Kepala dan Sekretaris Desa.xlsx")
writexl::write_xlsx(data.frame(table(Data.Gabungan$Ekstistensi.BUMDes)),"Tabel Frekuensi Eksistensi BUMDes.xlsx")


### Pemodelan dengan Model Regresi Linear ###
library(car)
library(lmtest)
library(sandwich)

str(Data.Gabungan)
Data.Gabungan$Pendidikan.Kepala.Desa <- factor(Data.Gabungan$Pendidikan.Kepala.Desa,
                                               levels = c("Tidak Pernah Sekolah","Tidak Tamat SD",
                                                          "SD","SMP","SMU","D-III","S1",
                                                          "S2","S3",NA))
Data.Gabungan$Pendidikan.Kepala.Desa <- as.numeric(Data.Gabungan$Pendidikan.Kepala.Desa)
Data.Gabungan$Pendidikan.Kepala.Desa <- ifelse(Data.Gabungan$Pendidikan.Kepala.Desa <= 4, 0,
                                               ifelse(Data.Gabungan$Pendidikan.Kepala.Desa > 4, 1, Data.Gabungan$Pendidikan.Kepala.Desa))
Data.Gabungan$Pendidikan.Kepala.Desa <- factor(Data.Gabungan$Pendidikan.Kepala.Desa,
                                               levels = c(0,1,NA))
Data.Gabungan$Pendidikan.Sekretaris.Desa <- factor(Data.Gabungan$Pendidikan.Sekretaris.Desa,
                                                   levels = c("Tidak Pernah Sekolah","Tidak Tamat SD",
                                                              "SD","SMP","SMU","D-III","S1",
                                                              "S2","S3",NA))
Data.Gabungan$Pendidikan.Sekretaris.Desa <- as.numeric(Data.Gabungan$Pendidikan.Sekretaris.Desa)
Data.Gabungan$Pendidikan.Sekretaris.Desa <- ifelse(Data.Gabungan$Pendidikan.Sekretaris.Desa <= 4, 0,
                                               ifelse(Data.Gabungan$Pendidikan.Sekretaris.Desa > 4, 1, Data.Gabungan$Pendidikan.Sekretaris.Desa))
Data.Gabungan$Pendidikan.Sekretaris.Desa <- factor(Data.Gabungan$Pendidikan.Sekretaris.Desa,
                                               levels = c(0,1,NA))

Data.Gabungan$Ekstistensi.BUMDes <- factor(Data.Gabungan$Ekstistensi.BUMDes,levels = c("Tidak Ada","Ada"))
str(Data.Gabungan)
model <- lm(KUD ~ Total.UU + Ekstistensi.BUMDes + Pendidikan.Kepala.Desa + Pendidikan.Sekretaris.Desa +
              Total.Penduduk + KOPINKRA + KOSPIN + Koperasi.Lainnya + UU.Bisnis.Sosial +
              UU.Sewa + UU.Perdagangan + UU.Keuangan + UU.Perantara + UU.Bidang.Lingkungan + Dana.Desa, data = Data.Gabungan)
summary(model)

## Uji Asumsi Klasik
# Uji Normalitas
# Uji ini tidak perlu dilakukan karena jumlah observasi lebih besar dari 30

bptest(model) # Uji Heteroskedastisitas (Breusch-Pagan test)
vif(model) # Uji Multikolinieritas
dwtest(model) # Uji Autodata:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABIAAAASCAYAAABWzo5XAAAAbElEQVR4Xs2RQQrAMAgEfZgf7W9LAguybljJpR3wEse5JOL3ZObDb4x1loDhHbBOFU6i2Ddnw2KNiXcdAXygJlwE8OFVBHDgKrLgSInN4WMe9iXiqIVsTMjH7z/GhNTEibOxQswcYIWYOR/zAjBJfiXh3jZ6AAAAAElFTkSuQmCCkorelasi

# Model Setelah Penghapusan Multikolinieritas
new.model <- lm(KUD ~ Pendidikan.Kepala.Desa + Pendidikan.Sekretaris.Desa +
              Total.Penduduk + KOPINKRA + KOSPIN + Koperasi.Lainnya + UU.Bisnis.Sosial +
              UU.Sewa + UU.Perdagangan + UU.Keuangan + UU.Perantara + UU.Bidang.Lingkungan + Dana.Desa, data = Data.Gabungan)
summary(new.model)

bptest(new.model) # Uji Heteroskedastisitas (Breusch-Pagan test)
vif(new.model) # Uji Multikolinieritas
dwtest(new.model) # Uji Autokorelasi
