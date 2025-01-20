****************************pop pyramid
cls
clear
*set maxvar 25000

do "$base_dir\Directory_TUP_health"

set scheme plotplainblind
	**color
	global skyblue "86 180 233"
	global blue "0 114 178"
	global teal "17 222 245"
	global orange "213 94 0"
	global green "0 158 115"
	global yellow "230 159 0"
	global purple "204 121 167"
	global lavendar "154 121 250"
	 
	**sequential color
	global blue1 "158 202 225"
	global blue2 "66 146 198"
	global blue3 "8 81 156"
	
	global purple1 "188 189 220"
	global purple2 "128 125 186"
	global purple3 "84 39 143"

use "$data_clean\ind_w4_mortality.dta", clear

bys age_group_pp C_sex treatment: gen total_pop = _N

keep treatment age_group age_group_pp total_pop C_sex

collapse (max) total_pop , by(age_group_pp C_sex treatment)

replace total_pop = - total_pop if C_sex==1



twoway bar  total_pop age_group_pp if treatment==1 & C_sex==1, horizontal xvarlab(Males) ls(foreground) barwidth(1) lw(vthin) fcolor("8 81 156") || bar  total_pop age_group if treatment==1 & C_sex==2, horizontal xvarlab(Females) fc("158 202 225") ls(foreground) barwidth(1) lw(thin) || , ylabel(1 "Under 5" 2 "5-10 Years" 3 "11-15 Years" 4 "16-20 Years" 5 "21-25 Years" 6 "26-30 Years" 7 "31-35 Years" 8 "36-40 Years" 9 "41-45 Years" 10 "46-50 Years"  11 "51-55 Years" 12 "56-60 Years" 13 "61-65 Years" 14 "Above 65 Years" , angle(horizontal) valuelabel labsize(*.8))  xlabel( -1500 "1500" -1000 "1000" -500 "500" 0  500 1000 1500  , angle(horizontal) valuelabel labsize(*.8) ) xtitle("Total Population") ytitle("Age Group")  legend(size(vsmall) order(1 "Male" 2 "Female" ) cols(1)) title("Treatment Group Male and Female Population by Age", size(small)) plotregion(color(white) fcolor(white)) scheme(white_tableau)  name(treat_pop, replace) legend(position(6) row(1))

graph export "$figure/selected/des_stat/pyramid_treatment.png", replace


twoway bar  total_pop age_group_pp if treatment==0 & C_sex==1, horizontal xvarlab(Males) ls(foreground) barwidth(1) lw(thin) fcolor("8 81 156") || bar  total_pop age_group if treatment==0 & C_sex==2, horizontal xvarlab(Females) fc("158 202 225") ls(foreground) barwidth(1) lw(thin) || , ylabel(1 "Under 5" 2 "5-10 Years" 3 "11-15 Years" 4 "16-20 Years" 5 "21-25 Years" 6 "26-30 Years" 7 "31-35 Years" 8 "36-40 Years" 9 "41-45 Years" 10 "46-50 Years"  11 "51-55 Years" 12 "56-60 Years" 13 "61-65 Years" 14 "Above 65 Years" , angle(horizontal) valuelabel labsize(*.8)) xlabel( -1000 "1000" -500 "500" 0  500 1000  , angle(horizontal) valuelabel labsize(*.8) ) xtitle("Total Population") ytitle("Age Group")  legend(size(vsmall) order(1 "Male" 2 "Female" ) cols(1)) title("Control Group Male and Female Population by Age", size(small)) plotregion(color(white) fcolor(white)) scheme(white_tableau)  name(control_pop, replace) legend(position(6) row(1))

graph export "$figure/selected/des_stat/pyramid_control.png", replace


grc1leg treat_pop control_pop, colfirst iscale(*1.02) ycommon rows(1) ysize(11) imargin(0 0 0 0) graphregion(margin(t=15 r=5 l=5))
*graph combine treat_pop control_pop, iscale(1) ycom  cols(2) saving(gcombined)

graph export "$figure/selected/des_stat/pyramid_combined.png", replace


/*
preserve
keep if treatment == 0

rename total_pop pop_c


reshape wide pop , i(age_group ) j(C_sex)



save "$data_clean\ind_pyramid_control.dta", replace

restore
keep if treatment == 1

rename total_pop pop_t

reshape wide pop_t , i(age_group ) j(C_sex)

save "$data_clean\ind_pyramid_treatment.dta", replace

merge 1:1 age_group using "$data_clean\ind_pyramid_control.dta"

drop _merge

replace pop_t1 = - pop_t1


replace pop_c1 = - pop_c1

twoway bar  pop_t1 age_group, horizontal xvarlab(Males) ls(foreground) barwidth(0.5) lw(thin) fcolor(gs10) || bar  pop_t2 age_group, horizontal xvarlab(Females) fc(emerald) ls(foreground) barwidth(0.5) lw(thin) || , ylabel(1 "Under 5"2 "6-15 Years" 3 "16-25 Years" 4 "26-35 Years" 5 "36-45 Years" 6 "46-55 Years" 7 "56-65 Years" 8 "Above 65 Years" , angle(horizontal) valuelabel labsize(*.8))  xlabel(-2000 "2000" -1500 "1500" -1000 "1000" -500 "500" 0  500 1000 1500 2000 , angle(horizontal) valuelabel labsize(*.8) ) xtitle("Total Population") ytitle("Age Group")  legend(size(vsmall) order(1 "Male" 2 "Female" ) cols(1)) title("Treatment Group Male and Female Population by Age", size(small)) plotregion(color(white) fcolor(white)) scheme(white_tableau) graphregion(margin(r=20 l=20 t = 20 b=20)) 

twoway bar  pop_c1 age_group, horizontal xvarlab(Males) ls(foreground) barwidth(1) lw(thin) fcolor(gs10) || bar  pop_c2 age_group, horizontal xvarlab(Females) fc(emerald) ls(foreground) barwidth(1) lw(thin) || , ylabel(1 "Under 5"2 "6-15 Years" 3 "16-25 Years" 4 "26-35 Years" 5 "36-45 Years" 6 "46-55 Years" 7 "56-65 Years" 8 "Above 65 Years" , angle(horizontal) valuelabel labsize(*.8)) xlabel(-1500 "1500" -1000 "1000" -500 "500" 0  500 1000 1500 , angle(horizontal) valuelabel labsize(*.8) ) xtitle("Total Population") ytitle("Age Group")  legend(size(vsmall) order(1 "Male" 2 "Female" ) cols(1)) title("Control Group Male and Female Population by Age", size(small)) plotregion(color(white) fcolor(white)) scheme(white_tableau) graphregion(margin(r=20 l=20 t = 28 b=28)) 


*/








***********************line graphregion
use "$data_clean\ind_w4_mortality.dta", clear

collapse (mean) mortality4, by(treatment C_sex age_group)

tw (sc mortality4  age_group if treatment==1 & C_sex ==1, mc("0 114 178") msize(small) msymbol(dot))  (sc mortality4  age_group if treatment==1 & C_sex ==2, mc(teal) msize(small) msymbol(dot)) (sc mortality4  age_group if treatment==0 & C_sex ==1, mc("154 121 250") msize(small) msymbol(Oh))	(sc mortality4  age_group if treatment==0 & C_sex ==2, mc("$orange") msize(small) msymbol(Oh)) (line mortality4  age_group if treatment==1 & C_sex ==1, lc("0 114 178") lp(solid)) (line mortality4  age_group if treatment==1 & C_sex ==2, lc(teal) lp(solid)) (line mortality4  age_group if treatment==0 & C_sex ==1, lc("154 121 250") lp(solid)) (line mortality4  age_group if treatment==0 & C_sex ==2, lc("$orange") lp(solid)) ,  xlabel(1 (1) 8 , angle(horizontal) valuelabel labsize(*.8) ) xtitle("Age Group") ytitle("Mortality Rate")  legend(size(vsmall) order(1 "Treamnet male" 2 "Treatment Female" 3 "Control Male" 4 "Control Female") cols(1)) title("", size(small)) plotregion(color(white) fcolor(white)) scheme(white_tableau) graphregion(margin(r=20 l=20 t = 20 b=20)) 

graph export "$figure/selected/des_stat/mortality_rate.png", replace

/*
preserve
keep if treatment == 0

rename mortality4 c_mortality 

reshape wide c_mortality , i(age_group ) j(C_sex)



save "$data_clean\ind_hazard_ratio_control.dta", replace
restore

keep if treatment == 1

rename mortality4 t_mortality 

reshape wide t_mortality , i(age_group ) j(C_sex)

save "$data_clean\ind_hazard_ratio_treatment.dta", replace


merge 1:1 age_group using "$data_clean\ind_hazard_ratio_control.dta"

drop _merge treatment
 



tw (sc t_mortality1  age_group, mc("0 114 178") msize(small) msymbol(dot))  (sc t_mortality2  age_group, mc(teal) msize(small) msymbol(dot)) (sc c_mortality1  age_group, mc("154 121 250") msize(small) msymbol(Oh))	(sc c_mortality2  age_group, mc("$orange") msize(small) msymbol(Oh)) (line t_mortality1  age_group, lc("0 114 178") lp(solid)) (line t_mortality2  age_group, lc(teal) lp(solid)) (line c_mortality1  age_group, lc("154 121 250") lp(solid)) (line c_mortality2  age_group, lc("$orange") lp(solid)) ,  xlabel(1 (1) 8 , angle(horizontal) valuelabel labsize(*.8) ) xtitle("Age Group") ytitle("Mortality Rate")  legend(size(vsmall) order(1 "Treamnet male" 2 "Treatment Female" 3 "Control Male" 4 "Control Female") cols(1)) title("", size(small)) plotregion(color(white) fcolor(white)) scheme(white_tableau) graphregion(margin(r=20 l=20 t = 20 b=20)) 