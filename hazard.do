/*cls
clear
*set maxvar 25000

do "$base_dir\Directory_TUP_health"



use "$data_clean\ind_w4_mortality.dta", clear

replace age_yr = 1 if age_m> 0 & age_m < 24 
replace age_yr = 2 if age_m >= 24 & age_m < 36
replace age_yr = 3 if age_m >= 36 & age_m < 48
replace age_yr = 4 if age_m >= 48 & age_m < 60
replace age_yr = 5 if age_m == 60


gen age_hazard = age_yr
replace age_hazard = age_yr + 7 if mortality4==0

replace age_hazard = age_yr +  1 if mortality2==1 & died_in_2008 == 1

replace age_hazard = age_yr  if mortality2==1 & died_in_2008 == 0


replace age_hazard = age_yr + 3 if mortality3==1 & mortality2==. & died_in_2010 == 1

replace age_hazard = age_yr + 2 if mortality3==1 & mortality2==. & died_in_2010 == 0


replace age_hazard = age_yr + 6 if mortality4==1 & mortality2==. & mortality3==. & died_in_2013 == 1
replace age_hazard = age_yr + 5 if mortality4==1 & mortality2==. & mortality3==. & died_in_2013 == 0


*rename mortality4 mortality

bys age_hazard treatment: egen hazard = sum(mortality4)


rename age_hazard age

expand age, gen(exp)

bysort hhid lino: gen survival_time = _n

gen mortality = 0
replace mortality=1 if mortality4==1 & age==survival_time

egen id_new = concat(hhid lino)


set scheme white_tableau 

stset survival_time, id(id_new)   failure(mortality4==1) 

sts list, by(treatment)

sts test treatment, logrank

sts graph, xlabel(0 (10) 110) by(treatment) risktable name(g1,replace) 

graph export "$figure/graph.png", replace

stset survival_time if C_sex==1, id(id_new) failure(mortality==1) 

sts test treatment, logrank

sts graph, xlabel(0 (10) 110) by(treatment) risktable name(g2,replace)


stset survival_time if C_sex==2, id(id_new) failure(mortality==1) 

sts test treatment, logrank
sts graph, xlabel(0 (10) 110) by(treatment) risktable name(g3,replace)


***************************************************************
***********Age>40***************

*******************Did not work************

stphplot if C_sex ==2, by(treatment)

stcoxkm if C_sex==2, by(treatment)

stset age if C_sex==1, fail(mortality==1)
sts list if C_sex==1, by(treatment) cumhaz

sts graph, by(treatment)

stphplot if C_sex ==1, by(treatment)

stcoxkm if C_sex==2, by(treatment)
*bys age_yr: egen haz = total(mortality4)


*******************Simulation********
/*clear

set obs 100
gen ft = 0

replace ft = runiform(20,50) in 1/25

replace ft = runiform(80,150) in 26/100

sort ft


gen failtime = round(ft)

drop ft

gen f2 = 0

replace f2 = runiform(1,5) in 1/25

replace f2 = runiform(3,7) in 26/100

gen fail = round(f2)

stset failtime, fail(fail)

gen t2 = runiform(1,2)

gen treatment = round(t2)

drop t2
***********************
snapspan id wave poverty, replace gen(entry_year)

stset wave, id(id) exit(time .) origin(entry_year) failure(poverty = 1)
sts graph

*************
by ID (year), sort: assert _n == _N if failure == 1 // VERIFY AT MOST ONE FAILURE PER ID, AND IT OCCURS IN FINAL YEAR
by ID (year): gen observation_time = year[_N] - year[1] + 1
by ID (year): keep if _n == _N
stset observation_time, failure(failure == 1)

*/
***************Hazard Curve*****************

**graph query, schemes

set scheme white_tableau

stset age, fail(mortality==1)
sts list, by(treatment) cumhaz

sts graph, xlabel(0 (5) 110, alternate) by(treatment) 

graph export "$figure/selected/hazard/chazard.png", replace
sts list if C_sex==1, by(treatment) cumhaz
sts graph , xlabel(40 (5) 100, alternate) by(treatment) haz
graph export "$figure/selected/hazard/hazard.png", replace

stphplot if C_sex==1, by(treatment)

stcoxkm , by(treatment)


*/


**********************Analysis time survival analysis***********
cls
clear
*set maxvar 25000

do "$base_dir\Directory_TUP_health"

set scheme white_tableau


use "$data_clean\ind_w1_mortality.dta", clear

merge 1:1 branchid hhid lino using "$data_clean\ind_w2"

drop if _merge == 2

gen censor2 = 0
replace censor2 = 1 if _merge==1
drop _merge

merge 1:1 branchid hhid lino using "$data_clean\ind_w3"

drop if _merge == 2

gen censor4 = 0
replace censor4 = 1 if _merge==1 & censor2 == 0

drop _merge

merge 1:1 branchid hhid lino using "$data_clean\ind_w4"

drop if _merge == 2


gen censor6 = 0
replace censor6 = 1 if _merge==1 & censor2 == 0 & censor4 ==0

drop _merge




keep branchid hhid lino censor*

save "$data_clean\censor.dta", replace


use "$data_clean\ind_w4_mortality.dta", clear

merge 1:1 branchid hhid lino using "$data_clean\censor"



replace age_yr = 1 if age_m> 0 & age_m < 24 
replace age_yr = 2 if age_m >= 24 & age_m < 36
replace age_yr = 3 if age_m >= 36 & age_m < 48
replace age_yr = 4 if age_m >= 48 & age_m < 60
replace age_yr = 5 if age_m == 60


gen age_hazard = age_yr
replace age_hazard = age_yr + 7 if mortality4==0

replace age_hazard = age_yr +  1 if mortality2==1 & died_in_2008 == 1

replace age_hazard = age_yr  if mortality2==1 & died_in_2008 == 0


replace age_hazard = age_yr + 3 if mortality3==1 & mortality2==. & died_in_2010 == 1

replace age_hazard = age_yr + 2 if mortality3==1 & mortality2==. & died_in_2010 == 0


replace age_hazard = age_yr + 6 if mortality4==1 & mortality2==. & mortality3==. & died_in_2013 == 1
replace age_hazard = age_yr + 5 if mortality4==1 & mortality2==. & mortality3==. & died_in_2013 == 0


*rename mortality4 mortality


bys age_hazard treatment: egen hazard = sum(mortality4)


rename age_hazard age

/*expand 7, gen(all)

bysort hhid lino: gen survival_time = _n
replace survival_time = survival_time - 1

gen mortality = mortality4

egen id_new = concat(hhid lino)
*/
gen survival_time = 6
gen mortality = mortality4

replace survival_time = 5 if mortality4==1 & mortality2==. & mortality3==. & died_in_2013 == 0 

replace survival_time = 4 if mortality4==1 & mortality2==. & mortality3==1 & died_in_2010 == 1 

replace survival_time = 3 if mortality4==1 & mortality2==. & mortality3==1 & died_in_2010 == 0 


replace survival_time = 2 if mortality4==1 & mortality2==1 & mortality3==1 & died_in_2008 ==1  

replace survival_time = 1 if mortality4==1 & mortality2==1 & mortality3==1 & died_in_2008 ==0  


*bysort hhid lino: gen sum_mortality= sum(mortality)





*drop if sum_mortality > 1


replace survival_time=1 if censor2==1 & mortality != 1

replace survival_time=3 if censor4==1 & mortality !=1

replace survival_time=5 if censor6==1 & mortality != 1




stset survival_time,  failure(mortality==1)

stcox treatment 

global z95 =  -invnorm(0.025)
global b= _b[treatment]
global se= _se[treatment]
global hazard_ratio : di exp($b)
global lb : di exp( $b - ${z95} * $se)
global ub : di exp($b + ${z95} * $se)
global p : di 2*normal(-abs($b/$se))

**# Bookmark #4
sts graph, xlabel(0 (1) 6) ylabel(.80 (.025) 1)  by(treatment) xtitle("Years after the intervention")  risktable text( 0.80 0 "HR $hazard_ratio (95% CI $lb-$ub) ; p< $p" , place(ne) size(.4cm) box bcolor(gs15) just(left) margin(l+2 t+1 b+1) width(100) ) name(g4,replace)

sts test treatment, logrank

 

stset survival_time if C_sex==1,  failure(mortality==1)


stcox treatment 

global z95 =  -invnorm(0.025)
global b= _b[treatment]
global se= _se[treatment]
global hazard_ratio : di exp($b)
global lb : di exp( $b - ${z95} * $se)
global ub : di exp($b + ${z95} * $se)
global p : di 2*normal(-abs($b/$se))

sts graph, xlabel(0 (1) 6) ylabel(.80 (.025) 1)  by(treatment) xtitle("Years after the intervention") text( 0.80 -0.22 "HR $hazard_ratio (95% CI $lb-$ub) ; p< $p" , place(ne) size(.25cm) ) title("Male") plotregion(color(white) fcolor(white)) name(g5,replace) risktable(, order(1 "Control" 2 "Treatment") size(small)) legend(order(1 "Control  " 2 "Treatment  ") row(1) pos(6) size(small))


sts test treatment, logrank

stset survival_time if C_sex==2,  failure(mortality==1) 


stcox treatment 

global z95 =  -invnorm(0.025)
global b= _b[treatment]
global se= _se[treatment]
global hazard_ratio : di exp($b)
global lb : di exp( $b - ${z95} * $se)
global ub : di exp($b + ${z95} * $se)
global p : di 2*normal(-abs($b/$se))

sts graph, xlabel(0 (1) 6) ylabel(.80 (.025) 1)  by(treatment) xtitle("Years after the intervention") risktable text( 0.80 -0.22 "HR $hazard_ratio (95% CI $lb-$ub) ; p< $p" , place(ne) size(.25cm)  ) title("Female")  plotregion(color(white) fcolor(white)) name(g6,replace) risktable(, order(1 "Control" 2 "Treatment") size(small)) legend(order(1 "Control" 2 "Treatment") row(1) pos(6) size(small))

**# Bookmark #1
grc1leg g5 g6, colfirst iscale(*1.02) ycommon rows(1) ysize(11) imargin(0 0 0 0) graphregion(margin(t=10 b=10))

graph export "D:\Replication\TUP_health\figure\selected\hazard\combined.png", replace

sts test treatment, logrank

sts list, by(treatment)