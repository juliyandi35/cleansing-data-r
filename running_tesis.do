clear
set more off

cd "C:\BEASISWA S2\PPIE UI 2023\SEMINAR PROPOSAL HASIL\DATA\Dana Desa"
import excel "IN\PPID_Dana_Desa_gg.xlsx", sheet("Realisasi Dana Desa_2015-2023") firstrow

save "OUT\dana_desa", replace


*Data Tanpa Dana Desa
*Replace pendidikan kepala desa
use "C:\BEASISWA S2\PPIE UI 2023\SEMINAR PROPOSAL HASIL\DATA\GABUNGAN setelah CLEANSING\gabungan final\Dataset 2014sd2021.dta"
gen Dummy_Pendidikan_Kades =real(Pendidikan_Kepala_Desa)
replace Dummy_Pendidikan_Kades=1 if Pendidikan_Kepala_Desa=="6"
replace Dummy_Pendidikan_Kades=1 if Pendidikan_Kepala_Desa=="7"
replace Dummy_Pendidikan_Kades=1 if Pendidikan_Kepala_Desa=="8"
replace Dummy_Pendidikan_Kades=1 if Pendidikan_Kepala_Desa=="9"
replace Dummy_Pendidikan_Kades=0 if Pendidikan_Kepala_Desa=="1"
replace Dummy_Pendidikan_Kades=0 if Pendidikan_Kepala_Desa=="2"
replace Dummy_Pendidikan_Kades=0 if Pendidikan_Kepala_Desa=="3"
replace Dummy_Pendidikan_Kades=0 if Pendidikan_Kepala_Desa=="4"
replace Dummy_Pendidikan_Kades=0 if Pendidikan_Kepala_Desa=="5"

*Replace pendidikan sekretaris desa
gen Dummy_Pendidikan_Sekretaris= real(Pendidikan_Sekretaris_Desa)
replace Dummy_Pendidikan_Sekretaris=1 if Pendidikan_Sekretaris_Desa=="6"
replace Dummy_Pendidikan_Sekretaris=1 if Pendidikan_Sekretaris_Desa=="7"
replace Dummy_Pendidikan_Sekretaris=1 if Pendidikan_Sekretaris_Desa=="8"
replace Dummy_Pendidikan_Sekretaris=1 if Pendidikan_Sekretaris_Desa=="9"
replace Dummy_Pendidikan_Sekretaris=0 if Pendidikan_Sekretaris_Desa=="1"
replace Dummy_Pendidikan_Sekretaris=0 if Pendidikan_Sekretaris_Desa=="2"
replace Dummy_Pendidikan_Sekretaris=0 if Pendidikan_Sekretaris_Desa=="3"
replace Dummy_Pendidikan_Sekretaris=0 if Pendidikan_Sekretaris_Desa=="4"
replace Dummy_Pendidikan_Sekretaris=0 if Pendidikan_Sekretaris_Desa=="5"

*Generate Variabel Interaksi
gen interaksi_ekonomi = Ekstistensi_BUMDes*UU_Perdagangan*UU_Keuangan*UU_Sewa 
gen interaksi_sosial = Ekstistensi_BUMDes*UU_Perantara 
gen interaksi_lingkungan= Ekstistensi_BUMDes*UU_Bidang_Lingkungan*UU_Pariwisata

xtset Tahun 
*Regresi tanpa interaksi
xtreg KUD Ekstistensi_BUMDes UU_Bisnis_Sosial UU_Sewa UU_Perdagangan UU_Keuangan UU_Perantara UU_Bidang_Lingkungan UU_Pariwisata Dummy_Pendidikan_Kades Dummy_Pendidikan_Sekretaris Total_Penduduk KOSPIN KOPINKRA

*Random-effects GLS regression                   Number of obs     =    163,459
*\Group variable: Tahun                           Number of groups  =          3

R-squared:                                      Obs per group:
     Within  = 0.0124                                         min =     47,552
     Between = 0.9938                                         avg =   54,486.3
     Overall = 0.0129                                         max =     58,261

                                                Wald chi2(13)     =    2139.62
*corr(u_i, X) = 0 (assumed)                      Prob > chi2       =     0.0000*

---------------------------------------------------------------------------------------------
                        KUD | Coefficient  Std. err.      z    P>|z|     [95% conf. interval]
----------------------------+----------------------------------------------------------------
         Ekstistensi_BUMDes |  -.0125533   .0018248    -6.88   0.000    -.0161299   -.0089768
           UU_Bisnis_Sosial |   .0032074   .0014036     2.29   0.022     .0004563    .0059586
                    UU_Sewa |   .0004303   .0011074     0.39   0.698    -.0017402    .0026008
             UU_Perdagangan |   .0044729   .0012893     3.47   0.001     .0019458    .0069999
                UU_Keuangan |   .0057574   .0011136     5.17   0.000     .0035747      .00794
               UU_Perantara |   .0045155   .0014888     3.03   0.002     .0015974    .0074336
       UU_Bidang_Lingkungan |   -.003003    .003088    -0.97   0.331    -.0090553    .0030493
              UU_Pariwisata |  -.0040699   .0019061    -2.14   0.033    -.0078057    -.000334
     Dummy_Pendidikan_Kades |   .0058754    .002072     2.84   0.005     .0018143    .0099365
Dummy_Pendidikan_Sekretaris |   .0052863   .0018878     2.80   0.005     .0015863    .0089863
             Total_Penduduk |   5.95e-06   2.38e-07    25.04   0.000     5.48e-06    6.42e-06
                     KOSPIN |   .0088501   .0005009    17.67   0.000     .0078684    .0098317
                   KOPINKRA |   .0440483   .0018328    24.03   0.000     .0404561    .0476405
                      _cons |   .0514855    .001461    35.24   0.000      .048622    .0543489
----------------------------+----------------------------------------------------------------
                    sigma_u |          0
                    sigma_e |  .34496791
                        rho |          0   (fraction of variance due to u_i)
---------------------------------------------------------------------------------------------



*Regresi dengan interaksi
xtreg KUD Ekstistensi_BUMDes UU_Bisnis_Sosial UU_Sewa UU_Perdagangan UU_Keuangan UU_Perantara UU_Bidang_Lingkungan UU_Pariwisata Dummy_Pendidikan_Kades Dummy_Pendidikan_Sekretaris Total_Penduduk KOSPIN KOPINKRA interaksi_ekonomi interaksi_lingkungan interaksi_sosial

Random-effects GLS regression                   Number of obs     =    163,459
Group variable: Tahun                           Number of groups  =          3

*R-squared:                                      Obs per group:
    * Within  = 0.0125                                         min =     47,552*
     *Between = 0.9754                                         avg =   54,486.3*
     *Overall = 0.0131                                         max =     58,261*

                                                Wald chi2(16)     =    2165.97
*\corr(u_i, X) = 0 (assumed)                      Prob > chi2       =     0.0000

---------------------------------------------------------------------------------------------
                        KUD | Coefficient  Std. err.      z    P>|z|     [95% conf. interval]
----------------------------+----------------------------------------------------------------
         Ekstistensi_BUMDes |   -.012402   .0019205    -6.46   0.000    -.0161662   -.0086379
           UU_Bisnis_Sosial |   .0032381   .0014038     2.31   0.021     .0004867    .0059895
                    UU_Sewa |   .0013312   .0011266     1.18   0.237    -.0008769    .0035393
             UU_Perdagangan |   .0052936   .0013041     4.06   0.000     .0027376    .0078496
                UU_Keuangan |   .0071132   .0011486     6.19   0.000     .0048621    .0093643
               UU_Perantara |   .0081603   .0027826     2.93   0.003     .0027066     .013614
       UU_Bidang_Lingkungan |    -.00206   .0033377    -0.62   0.537    -.0086019    .0044819
              UU_Pariwisata |   -.003672   .0021188    -1.73   0.083    -.0078248    .0004808
     Dummy_Pendidikan_Kades |   .0058287    .002072     2.81   0.005     .0017677    .0098896
Dummy_Pendidikan_Sekretaris |   .0051591   .0018879     2.73   0.006      .001459    .0088593
             Total_Penduduk |   5.90e-06   2.38e-07    24.79   0.000     5.43e-06    6.36e-06
                     KOSPIN |   .0087997   .0005009    17.57   0.000     .0078179    .0097815
                   KOPINKRA |   .0440756   .0018327    24.05   0.000     .0404836    .0476677
          interaksi_ekonomi |  -.0013355   .0002948    -4.53   0.000    -.0019134   -.0007576
       interaksi_lingkungan |   .0018926   .0029308     0.65   0.518    -.0038517     .007637
           interaksi_sosial |  -.0036919    .003147    -1.17   0.241      -.00986    .0024762
                      _cons |   .0503483   .0014971    33.63   0.000      .047414    .0532825
----------------------------+----------------------------------------------------------------
                    sigma_u |          0
                    sigma_e |   .3449566
                        rho |          0   (fraction of variance due to u_i)
---------------------------------------------------------------------------------------------


*Uji Haussman (Test FE/RE)
xtreg KUD Ekstistensi_BUMDes UU_Bisnis_Sosial UU_Sewa UU_Perdagangan UU_Keuangan UU_Perantara UU_Bidang_Lingkungan UU_Pariwisata Dummy_Pendidikan_Kades Dummy_Pendidikan_Sekretaris Total_Penduduk KOSPIN KOPINKRA, fe
est store fe
xtreg KUD Ekstistensi_BUMDes UU_Bisnis_Sosial UU_Sewa UU_Perdagangan UU_Keuangan UU_Perantara UU_Bidang_Lingkungan UU_Pariwisata Dummy_Pendidikan_Kades Dummy_Pendidikan_Sekretaris Total_Penduduk KOSPIN KOPINKRA, re
est store re
hausman fe re

Fixed-effects (within) regression               Number of obs     =    163,459
Group variable: Tahun                           Number of groups  =          3

R-squared:                                      Obs per group:
     Within  = 0.0130                                         min =     47,552
     Between = 0.9757                                         avg =   54,486.3
     Overall = 0.0117                                         max =     58,261

                                                F(13,163443)      =     166.13
corr(u_i, Xb) = -0.1420                         Prob > F          =     0.0000

---------------------------------------------------------------------------------------------
                        KUD | Coefficient  Std. err.      t    P>|t|     [95% conf. interval]
----------------------------+----------------------------------------------------------------
         Ekstistensi_BUMDes |    .013116    .002571     5.10   0.000     .0080768    .0181552
           UU_Bisnis_Sosial |    .002097   .0014049     1.49   0.136    -.0006567    .0048506
                    UU_Sewa |  -.0010377   .0011149    -0.93   0.352    -.0032229    .0011475
             UU_Perdagangan |   .0024711   .0012976     1.90   0.057    -.0000722    .0050145
                UU_Keuangan |   .0047706   .0011155     4.28   0.000     .0025844    .0069569
               UU_Perantara |   .0044505   .0014881     2.99   0.003      .001534    .0073671
       UU_Bidang_Lingkungan |  -.0025628   .0030869    -0.83   0.406    -.0086131    .0034875
              UU_Pariwisata |  -.0042197    .001905    -2.22   0.027    -.0079533    -.000486
     Dummy_Pendidikan_Kades |   .0064595   .0020714     3.12   0.002     .0023996    .0105194
Dummy_Pendidikan_Sekretaris |   .0067196   .0018894     3.56   0.000     .0030164    .0104228
             Total_Penduduk |   5.59e-06   2.39e-07    23.39   0.000     5.12e-06    6.06e-06
                     KOSPIN |   .0086763   .0005007    17.33   0.000     .0076949    .0096577
                   KOPINKRA |   .0441001    .001833    24.06   0.000     .0405074    .0476927
                      _cons |   .0406402    .001646    24.69   0.000     .0374141    .0438662
----------------------------+----------------------------------------------------------------
                    sigma_u |  .02188468
                    sigma_e |  .34496791
                        rho |  .00400847   (fraction of variance due to u_i)
---------------------------------------------------------------------------------------------
F test that all u_i=0: F(2, 163443) = 102.00                 Prob > F = 0.0000

. est store fe

. xtreg KUD Ekstistensi_BUMDes UU_Bisnis_Sosial UU_Sewa UU_Perdagangan UU_Keuangan UU_Perantara UU_Bidang_Lingkungan UU_Pariwisata Du
> mmy_Pendidikan_Kades Dummy_Pendidikan_Sekretaris Total_Penduduk KOSPIN KOPINKRA, re

Random-effects GLS regression                   Number of obs     =    163,459
Group variable: Tahun                           Number of groups  =          3

R-squared:                                      Obs per group:
     Within  = 0.0124                                         min =     47,552
     Between = 0.9938                                         avg =   54,486.3
     Overall = 0.0129                                         max =     58,261

                                                Wald chi2(13)     =    2139.62
corr(u_i, X) = 0 (assumed)                      Prob > chi2       =     0.0000

---------------------------------------------------------------------------------------------
                        KUD | Coefficient  Std. err.      z    P>|z|     [95% conf. interval]
----------------------------+----------------------------------------------------------------
         Ekstistensi_BUMDes |  -.0125533   .0018248    -6.88   0.000    -.0161299   -.0089768
           UU_Bisnis_Sosial |   .0032074   .0014036     2.29   0.022     .0004563    .0059586
                    UU_Sewa |   .0004303   .0011074     0.39   0.698    -.0017402    .0026008
             UU_Perdagangan |   .0044729   .0012893     3.47   0.001     .0019458    .0069999
                UU_Keuangan |   .0057574   .0011136     5.17   0.000     .0035747      .00794
               UU_Perantara |   .0045155   .0014888     3.03   0.002     .0015974    .0074336
       UU_Bidang_Lingkungan |   -.003003    .003088    -0.97   0.331    -.0090553    .0030493
              UU_Pariwisata |  -.0040699   .0019061    -2.14   0.033    -.0078057    -.000334
     Dummy_Pendidikan_Kades |   .0058754    .002072     2.84   0.005     .0018143    .0099365
Dummy_Pendidikan_Sekretaris |   .0052863   .0018878     2.80   0.005     .0015863    .0089863
             Total_Penduduk |   5.95e-06   2.38e-07    25.04   0.000     5.48e-06    6.42e-06
                     KOSPIN |   .0088501   .0005009    17.67   0.000     .0078684    .0098317
                   KOPINKRA |   .0440483   .0018328    24.03   0.000     .0404561    .0476405
                      _cons |   .0514855    .001461    35.24   0.000      .048622    .0543489
----------------------------+----------------------------------------------------------------
                    sigma_u |          0
                    sigma_e |  .34496791
                        rho |          0   (fraction of variance due to u_i)
---------------------------------------------------------------------------------------------

. est store re

. hausman fe re

Note: the rank of the differenced variance matrix (12) does not equal the number of coefficients being tested (13); be sure this is
        what you expect, or there may be problems computing the test.  Examine the output of your estimators for anything unexpected
        and possibly consider scaling your variables so that the coefficients are on a similar scale.

                 ---- Coefficients ----
             |      (b)          (B)            (b-B)     sqrt(diag(V_b-V_B))
             |       fe           re         Difference       Std. err.
-------------+----------------------------------------------------------------
Ekstistens~s |     .013116    -.0125533        .0256693        .0018112
UU_Bisnis_~l |     .002097     .0032074       -.0011105        .0000602
     UU_Sewa |   -.0010377     .0004303        -.001468        .0001292
UU_Perdaga~n |    .0024711     .0044729       -.0020018        .0001466
 UU_Keuangan |    .0047706     .0057574       -.0009867        .0000638
UU_Perantara |    .0044505     .0045155        -.000065               .
UU_Bidang_~n |   -.0025628     -.003003        .0004402               .
UU_Pariwis~a |   -.0042197    -.0040699       -.0001498               .
Dummy_Pen~es |    .0064595     .0058754        .0005841               .
Dummy_Pen~is |    .0067196     .0052863        .0014333        .0000783
Total_Pend~k |    5.59e-06     5.95e-06       -3.64e-07        2.43e-08
      KOSPIN |    .0086763     .0088501       -.0001738               .
    KOPINKRA |    .0441001     .0440483        .0000518        .0000271
------------------------------------------------------------------------------
                          b = Consistent under H0 and Ha; obtained from xtreg.
           B = Inconsistent under Ha, efficient under H0; obtained from xtreg.

Test of H0: Difference in coefficients not systematic

   chi2(12) = (b-B)'[(V_b-V_B)^(-1)](b-B)
            = 204.57
Prob > chi2 = 0.0000
(V_b-V_B is not positive definite)

. 
end of do-file

. 
