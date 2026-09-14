clear all

*Simulasikan dataset 1
input str1 ID
1
1
1
2
2
3
4
4
5
5
end
forvalues i = 1/5 {
    gen var`i' = runiform()
}
tempfile data1
save `data1', replace

*Simulasikan dataset 2
clear all
input str1 ID
1
1
1
2
2
3
4
4
5
5
end
forvalues i = 6/10 {
    gen var`i' = runiform()
}
tempfile data2
save `data2', replace

*Gabungkan dataset 1 dan dataset 2
merge m:m ID using `data1'

*Tampilkan hasil penggabungan
list