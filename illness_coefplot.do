
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
	


**************************Coefplot*******************************************************************

use "$data_clean\balanced_panel_selected_individual", clear
drop age_group
gen age_group = 0
replace age_group =1 if age_years==0
replace age_group= 2 if age_years >= 5 & age_years <= 15
replace age_group= 3 if age_years > 15 & age_years <= 25
replace age_group= 4 if age_years > 25 & age_years <= 35
replace age_group= 5 if age_years > 35 & age_years <= 45
replace age_group= 6 if age_years > 45 & age_years <= 55
replace age_group= 7 if age_years > 55 & age_years <= 65
replace age_group= 8 if age_years > 65

expand 2, generate(all)
replace C_sex = 3 if all == 1
la def C_sex 1 "Male" 2 "Female" 3 "Overall", modify
la val C_sex C_sex
drop all		

gen beta = .
gen ub = .
gen lb = .
gen pvalue = .
gen gender = ""
gen gender_num = .
gen group = .
gen wave = 2
gen observation = .
local gender pooled female male
local m = 3
local d = 1



    foreach x of local gender {
        forvalues k = 1/8 {
            areg illness2 treatment if age_group == `k' & C_sex == `m' , absorb(subdistrict) cluster(branchid) 
            replace beta = e(b)[1,1] in `d'
            replace lb = e(b)[1,1] - _se[treatment] * invttail(e(df_r), 0.025) in `d'
            replace ub = e(b)[1,1] + _se[treatment] * invttail(e(df_r), 0.025) in `d'
            replace pvalue = (2 * ttail(e(df_r), abs(_b[treatment]/_se[treatment]))) in `d'

            // Store values of group, gender, gender_num, and wave
            replace group = `k' in `d'
            replace gender = "`x'" in `d'
            replace gender_num = `m' in `d'
			replace observation = e(N) in `d'

            eststo age_group`k'_`i'_`x'
            local d = `d' + 1
        }
        local m = `m' - 1
    }
save "$data_clean\age_group_illness2", replace




 

use "$data_clean\age_group_illness2.dta", clear

recode gender_num (3=1) (2=2) (1=3)

keep beta ub lb pvalue group wave gender gender_num observation

keep if beta !=.

sort group gender_num
gen lab_pos=10
replace lab_pos=2 if beta>0


mkmat beta ub lb pvalue gender_num lab_pos observation , matrix(A)

mat list A

matrix A2=A`j''

mat list A2

forvalues i=1/`=colsof(A2)'{
    mat A2_`i' = A2[1..`=rowsof(A2)', `i']
} 


coefplot (matrix(A2_1[1]), ci((2 3)) msymbol(dot) mc(purple%50) ciopts(recast(rcap) color(purple%70)) msize(vsmall) ) ///
(matrix(A2_2[1]), ci((2 3)) mcolor(green%50) msymbol(dot) msize(vsmall) ciopts(recast(rcap) color(green%70)) ) ///
(matrix(A2_3[1]), ci((2 3)) mcolor(black%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(black%70)) ) ///
(matrix(A2_4[1]), ci((2 3)) msymbol(dot) mc(purple%50) ciopts(recast(rcap) color(purple%70)) msize(vsmall) ) ///
(matrix(A2_5[1]), ci((2 3)) mcolor(green%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(green%70)) ) ///
(matrix(A2_6[1]), ci((2 3)) mcolor(black%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(black%70)) ) ///
(matrix(A2_7[1]), ci((2 3)) msymbol(dot) mc(purple%50) ciopts(recast(rcap) color(purple%70)) msize(vsmall) ) ///
(matrix(A2_8[1]), ci((2 3)) mcolor(green%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(green%70)) ) ///
(matrix(A2_9[1]), ci((2 3)) mcolor(black%50) msymbol(dot) msize(small) ciopts(recast(rcap) color(black%70)) ) ///
(matrix(A2_10[1]), ci((2 3)) msymbol(dot) mc(purple%50) ciopts(recast(rcap) color(purple%70)) msize(vsmall) ) ///
(matrix(A2_11[1]), ci((2 3)) mcolor(green%50) msymbol(dot) msize(small) ciopts(recast(rcap) color(green%70)) ) ///
(matrix(A2_12[1]), ci((2 3)) mcolor(black%50) msymbol(dot) msize(small) ciopts(recast(rcap) color(black%70)) ) ///
(matrix(A2_13[1]), ci((2 3)) msymbol(dot) mc(purple%50) ciopts(recast(rcap) color(purple%70)) msize(vsmall) ) ///
(matrix(A2_14[1]), ci((2 3)) mcolor(green%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(green%70)) ) ///
(matrix(A2_15[1]), ci((2 3)) mcolor(black%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(black%70)) ) ///
(matrix(A2_16[1]), ci((2 3)) msymbol(dot) mc(purple%50) ciopts(recast(rcap) color(purple%70)) msize(vsmall) ) ///
(matrix(A2_17[1]), ci((2 3)) mcolor(green%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(green%70)) ) ///
(matrix(A2_18[1]), ci((2 3)) mcolor(black%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(black%70)) ) ///
(matrix(A2_19[1]), ci((2 3)) msymbol(dot) mc(purple%50) ciopts(recast(rcap) color(purple%70)) msize(vsmall) ) ///
(matrix(A2_20[1]), ci((2 3)) mcolor(green%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(green%70)) ) ///
(matrix(A2_21[1]), ci((2 3)) mcolor(black%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(black%70)) ) ///
(matrix(A2_22[1]), ci((2 3)) msymbol(dot) mc(purple%50) ciopts(recast(rcap) color(purple%70)) msize(vsmall) ) ///
(matrix(A2_23[1]), ci((2 3)) mcolor(green%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(green%70)) ) ///
(matrix(A2_24[1]), ci((2 3)) mcolor(black%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(black%70)) ) ///
, aseq legend(off) ///
xline(0, lwidth(medium) lcolor(red) lpattern(dash)) ///
mlabel(cond(pvalue<.01, string(@b, "%9.2fc") + "***", cond(pvalue<.05, string(@b, "%9.2fc") + "**", cond(pvalue<.1, string(@b, "%9.2fc") + "*", string(@b, "%9.2fc"))))) ///
xscale(range(-0.20 0.20)) ///
title("1st Follow-up") ///
ylabel(, labsize(vsmall) nogrid) ///
xlabel(-0.20(0.05)0.20, labsize(vsmall)) ///
plotregion(color(white) fcolor(white)) scheme(white_tableau) ///
graphregion(margin(r=15 l=15)) mlabgap(*0.55) mlabsize(vsmall) ///
mlabvposition(lab_pos) nokey ///
grid(none) ///
headings(r1= "{bf:0-5 Years}" r4= "{bf:6-15 Years}" r7= "{bf:16-25 Years}" r10= "{bf:26-35 Years}" r13= "{bf:36-45 Years}" r16= "{bf:46-55 Years}" r19= "{bf:56-65 Years}" r22= "{bf:65 Above}", labsize(vsmall) labcolor($lavendar) labgap(7) ) ///
groups(r1=" n =2518" ///
             r2=" n = 1235" ///
             r3=" n = 1283" ///
             r4=" n = 6003"  ///
             r5=" n = 2835" ///
			 r6=" n = 3168" ///
             r7=" n = 2712"  ///
             r8=" n = 1599" ///
			 r9=" n = 1113" ///
             r10=" n = 3219"  ///
             r11=" n = 1991" ///
			 r12=" n = 1228" ///
             r13=" n = 2527"  ///
             r14=" n = 1459" ///
             r15=" n = 1068" ///
             r16=" n = 1915"  ///
             r17=" n = 1295" ///
			 r18=" n = 620" ///
             r19=" n = 1320"  ///
             r20=" n = 821" ///
			 r21=" n = 499" ///
             r22=" n = 702"  ///
             r23=" n = 315"  ///
			 r24=" n = 387") ///
yscale(alt axis(2)) ///
coeflabels( r1="Pooled" ///
             r2="Female"  ///
             r3="Male" ///
             r4="Pooled" ///
             r5="Female"  ///
             r6="Male" ///
			 r7="Pooled" ///
             r8="Female"  ///
             r9="Male" ///
			 r10="Pooled" ///
             r11="Female"  ///
             r12="Male" ///
			 r13="Pooled" ///
             r14="Female"  ///
             r15="Male" ///
             r16="Pooled" ///
             r17="Female"  ///
             r18="Male" ///
			 r19="Pooled" ///
             r20="Female"  ///
             r21="Male" ///
			 r22="Pooled" ///
             r23="Female"  ///
             r24="Male" ) 




 graph export "$figure/selected/illness/selected_age_group_combined_illness2.png", replace


use "$data_clean\balanced_panel_selected_individual", clear
drop age_group
gen age_group = 0
replace age_group =1 if age_years==0
replace age_group= 2 if age_years >= 5 & age_years <= 15
replace age_group= 3 if age_years > 15 & age_years <= 25
replace age_group= 4 if age_years > 25 & age_years <= 35
replace age_group= 5 if age_years > 35 & age_years <= 45
replace age_group= 6 if age_years > 45 & age_years <= 55
replace age_group= 7 if age_years > 55 & age_years <= 65
replace age_group= 8 if age_years > 65

expand 2, generate(all)
replace C_sex = 3 if all == 1
la def C_sex 1 "Male" 2 "Female" 3 "Overall", modify
la val C_sex C_sex
drop all		

gen beta = .
gen ub = .
gen lb = .
gen pvalue = .
gen gender = ""
gen gender_num = .
gen group = .
gen wave = 3
gen observation = .
local gender pooled female male
local m = 3
local d = 1



    foreach x of local gender {
        forvalues k = 1/8 {
            areg illness3 treatment if age_group == `k' & C_sex == `m' , absorb(subdistrict) cluster(branchid) 
            replace beta = e(b)[1,1] in `d'
            replace lb = e(b)[1,1] - _se[treatment] * invttail(e(df_r), 0.025) in `d'
            replace ub = e(b)[1,1] + _se[treatment] * invttail(e(df_r), 0.025) in `d'
            replace pvalue = (2 * ttail(e(df_r), abs(_b[treatment]/_se[treatment]))) in `d'

            // Store values of group, gender, gender_num, and wave
            replace group = `k' in `d'
            replace gender = "`x'" in `d'
            replace gender_num = `m' in `d'
			replace observation = e(N) in `d'

            eststo age_group`k'_`i'_`x'
            local d = `d' + 1
        }
        local m = `m' - 1
    }
save "$data_clean\age_group_illness3", replace
 
 
 

use "$data_clean\age_group_illness3.dta", clear

recode gender_num (3=1) (2=2) (1=3)

keep beta ub lb pvalue group wave gender gender_num observation
keep if beta !=.

sort group gender_num
gen lab_pos=10
replace lab_pos=2 if beta>0


mkmat beta ub lb pvalue gender_num lab_pos , matrix(B)

mat list B

matrix B2=B`j''

mat list B2

forvalues i=1/`=colsof(B2)'{
    mat B2_`i' = B2[1..`=rowsof(B2)', `i']
} 


coefplot (matrix(B2_1[1]), ci((2 3)) msymbol(dot) mc(purple%50) ciopts(recast(rcap) color(purple%70)) msize(vsmall) ) ///
(matrix(B2_2[1]), ci((2 3)) mcolor(green%50) msymbol(dot) msize(vsmall) ciopts(recast(rcap) color(green%70)) ) ///
(matrix(B2_3[1]), ci((2 3)) mcolor(black%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(black%70)) ) ///
(matrix(B2_4[1]), ci((2 3)) msymbol(dot) mc(purple%50) ciopts(recast(rcap) color(purple%70)) msize(vsmall) ) ///
(matrix(B2_5[1]), ci((2 3)) mcolor(green%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(green%70)) ) ///
(matrix(B2_6[1]), ci((2 3)) mcolor(black%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(black%70)) ) ///
(matrix(B2_7[1]), ci((2 3)) msymbol(dot) mc(purple%50) ciopts(recast(rcap) color(purple%70)) msize(vsmall) ) ///
(matrix(B2_8[1]), ci((2 3)) mcolor(green%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(green%70)) ) ///
(matrix(B2_9[1]), ci((2 3)) mcolor(black%50) msymbol(dot) msize(small) ciopts(recast(rcap) color(black%70)) ) ///
(matrix(B2_10[1]), ci((2 3)) msymbol(dot) mc(purple%50) ciopts(recast(rcap) color(purple%70)) msize(vsmall) ) ///
(matrix(B2_11[1]), ci((2 3)) mcolor(green%50) msymbol(dot) msize(small) ciopts(recast(rcap) color(green%70)) ) ///
(matrix(B2_12[1]), ci((2 3)) mcolor(black%50) msymbol(dot) msize(small) ciopts(recast(rcap) color(black%70)) ) ///
(matrix(B2_13[1]), ci((2 3)) msymbol(dot) mc(purple%50) ciopts(recast(rcap) color(purple%70)) msize(vsmall) ) ///
(matrix(B2_14[1]), ci((2 3)) mcolor(green%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(green%70)) ) ///
(matrix(B2_15[1]), ci((2 3)) mcolor(black%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(black%70)) ) ///
(matrix(B2_16[1]), ci((2 3)) msymbol(dot) mc(purple%50) ciopts(recast(rcap) color(purple%70)) msize(vsmall) ) ///
(matrix(B2_17[1]), ci((2 3)) mcolor(green%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(green%70)) ) ///
(matrix(B2_18[1]), ci((2 3)) mcolor(black%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(black%70)) ) ///
(matrix(B2_19[1]), ci((2 3)) msymbol(dot) mc(purple%50) ciopts(recast(rcap) color(purple%70)) msize(vsmall) ) ///
(matrix(B2_20[1]), ci((2 3)) mcolor(green%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(green%70)) ) ///
(matrix(B2_21[1]), ci((2 3)) mcolor(black%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(black%70)) ) ///
(matrix(B2_22[1]), ci((2 3)) msymbol(dot) mc(purple%50) ciopts(recast(rcap) color(purple%70)) msize(vsmall) ) ///
(matrix(B2_23[1]), ci((2 3)) mcolor(green%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(green%70)) ) ///
(matrix(B2_24[1]), ci((2 3)) mcolor(black%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(black%70)) ) ///
, aseq legend(off) ///
xline(0, lwidth(medium) lcolor(red) lpattern(dash)) ///
mlabel(cond(pvalue<.01, string(@b, "%9.2fc") + "***", cond(pvalue<.05, string(@b, "%9.2fc") + "**", cond(pvalue<.1, string(@b, "%9.2fc") + "*", string(@b, "%9.2fc"))))) ///
xscale(range(-0.20 0.20)) ///
title("2nd Follow-up") ///
ylabel(, labsize(vsmall) nogrid) ///
xlabel(-0.20(0.05)0.20, labsize(vsmall)) ///
plotregion(color(white) fcolor(white)) scheme(white_tableau) ///
graphregion(margin(r=15 l=15)) mlabgap(*0.55) mlabsize(vsmall) ///
mlabvposition(lab_pos) nokey ///
grid(none) ///
headings(r1= "{bf:0-5 Years}" r4= "{bf:6-15 Years}" r7= "{bf:16-25 Years}" r10= "{bf:26-35 Years}" r13= "{bf:36-45 Years}" r16= "{bf:46-55 Years}" r19= "{bf:56-65 Years}" r22= "{bf:65 Above}", labsize(vsmall) labcolor($lavendar) labgap(7) ) ///
groups(r1=" n =2518" ///
             r2=" n = 1235" ///
             r3=" n = 1283" ///
             r4=" n = 6003"  ///
             r5=" n = 2835" ///
			 r6=" n = 3168" ///
             r7=" n = 2712"  ///
             r8=" n = 1599" ///
			 r9=" n = 1113" ///
             r10=" n = 3219"  ///
             r11=" n = 1991" ///
			 r12=" n = 1228" ///
             r13=" n = 2527"  ///
             r14=" n = 1459" ///
             r15=" n = 1068" ///
             r16=" n = 1915"  ///
             r17=" n = 1295" ///
			 r18=" n = 620" ///
             r19=" n = 1320"  ///
             r20=" n = 821" ///
			 r21=" n = 499" ///
             r22=" n = 702"  ///
             r23=" n = 315"  ///
			 r24=" n = 387") ///
yscale(alt axis(2)) ///
coeflabels( r1="Pooled" ///
             r2="Female"  ///
             r3="Male" ///
             r4="Pooled" ///
             r5="Female"  ///
             r6="Male" ///
			 r7="Pooled" ///
             r8="Female"  ///
             r9="Male" ///
			 r10="Pooled" ///
             r11="Female"  ///
             r12="Male" ///
			 r13="Pooled" ///
             r14="Female"  ///
             r15="Male" ///
             r16="Pooled" ///
             r17="Female"  ///
             r18="Male" ///
			 r19="Pooled" ///
             r20="Female"  ///
             r21="Male" ///
			 r22="Pooled" ///
             r23="Female"  ///
             r24="Male" ) 
			 
graph export "$figure/selected/illness/selected_age_group_combined_illness3.png", replace		 

			 
			 
use "$data_clean\balanced_panel_selected_individual", clear
drop age_group
gen age_group = 0
replace age_group =1 if age_years==0
replace age_group= 2 if age_years >= 5 & age_years <= 15
replace age_group= 3 if age_years > 15 & age_years <= 25
replace age_group= 4 if age_years > 25 & age_years <= 35
replace age_group= 5 if age_years > 35 & age_years <= 45
replace age_group= 6 if age_years > 45 & age_years <= 55
replace age_group= 7 if age_years > 55 & age_years <= 65
replace age_group= 8 if age_years > 65

expand 2, generate(all)
replace C_sex = 3 if all == 1
la def C_sex 1 "Male" 2 "Female" 3 "Overall", modify
la val C_sex C_sex
drop all		

gen beta = .
gen ub = .
gen lb = .
gen pvalue = .
gen gender = ""
gen gender_num = .
gen group = .
gen wave = 4
gen observation = .
local gender pooled female male
local m = 3
local d = 1



    foreach x of local gender {
        forvalues k = 1/8 {
            areg illness4 treatment if age_group == `k' & C_sex == `m' , absorb(subdistrict) cluster(branchid) 
            replace beta = e(b)[1,1] in `d'
            replace lb = e(b)[1,1] - _se[treatment] * invttail(e(df_r), 0.025) in `d'
            replace ub = e(b)[1,1] + _se[treatment] * invttail(e(df_r), 0.025) in `d'
            replace pvalue = (2 * ttail(e(df_r), abs(_b[treatment]/_se[treatment]))) in `d'

            // Store values of group, gender, gender_num, and wave
            replace group = `k' in `d'
            replace gender = "`x'" in `d'
            replace gender_num = `m' in `d'
			replace observation = e(N) in `d'

            eststo age_group`k'_`i'_`x'
            local d = `d' + 1
        }
        local m = `m' - 1
    }
save "$data_clean\age_group_illness4", replace
 
 
 

use "$data_clean\age_group_illness4.dta", clear

recode gender_num (3=1) (2=2) (1=3)

keep beta ub lb pvalue group wave gender gender_num observation
keep if beta !=.

sort group gender_num
gen lab_pos=10
replace lab_pos=2 if beta>0


mkmat beta ub lb pvalue gender_num lab_pos , matrix(B)

mat list B

matrix B2=B`j''

mat list B2

forvalues i=1/`=colsof(B2)'{
    mat B2_`i' = B2[1..`=rowsof(B2)', `i']
} 


coefplot (matrix(B2_1[1]), ci((2 3)) msymbol(dot) mc(purple%50) ciopts(recast(rcap) color(purple%70)) msize(vsmall) ) ///
(matrix(B2_2[1]), ci((2 3)) mcolor(green%50) msymbol(dot) msize(vsmall) ciopts(recast(rcap) color(green%70)) ) ///
(matrix(B2_3[1]), ci((2 3)) mcolor(black%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(black%70)) ) ///
(matrix(B2_4[1]), ci((2 3)) msymbol(dot) mc(purple%50) ciopts(recast(rcap) color(purple%70)) msize(vsmall) ) ///
(matrix(B2_5[1]), ci((2 3)) mcolor(green%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(green%70)) ) ///
(matrix(B2_6[1]), ci((2 3)) mcolor(black%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(black%70)) ) ///
(matrix(B2_7[1]), ci((2 3)) msymbol(dot) mc(purple%50) ciopts(recast(rcap) color(purple%70)) msize(vsmall) ) ///
(matrix(B2_8[1]), ci((2 3)) mcolor(green%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(green%70)) ) ///
(matrix(B2_9[1]), ci((2 3)) mcolor(black%50) msymbol(dot) msize(small) ciopts(recast(rcap) color(black%70)) ) ///
(matrix(B2_10[1]), ci((2 3)) msymbol(dot) mc(purple%50) ciopts(recast(rcap) color(purple%70)) msize(vsmall) ) ///
(matrix(B2_11[1]), ci((2 3)) mcolor(green%50) msymbol(dot) msize(small) ciopts(recast(rcap) color(green%70)) ) ///
(matrix(B2_12[1]), ci((2 3)) mcolor(black%50) msymbol(dot) msize(small) ciopts(recast(rcap) color(black%70)) ) ///
(matrix(B2_13[1]), ci((2 3)) msymbol(dot) mc(purple%50) ciopts(recast(rcap) color(purple%70)) msize(vsmall) ) ///
(matrix(B2_14[1]), ci((2 3)) mcolor(green%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(green%70)) ) ///
(matrix(B2_15[1]), ci((2 3)) mcolor(black%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(black%70)) ) ///
(matrix(B2_16[1]), ci((2 3)) msymbol(dot) mc(purple%50) ciopts(recast(rcap) color(purple%70)) msize(vsmall) ) ///
(matrix(B2_17[1]), ci((2 3)) mcolor(green%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(green%70)) ) ///
(matrix(B2_18[1]), ci((2 3)) mcolor(black%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(black%70)) ) ///
(matrix(B2_19[1]), ci((2 3)) msymbol(dot) mc(purple%50) ciopts(recast(rcap) color(purple%70)) msize(vsmall) ) ///
(matrix(B2_20[1]), ci((2 3)) mcolor(green%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(green%70)) ) ///
(matrix(B2_21[1]), ci((2 3)) mcolor(black%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(black%70)) ) ///
(matrix(B2_22[1]), ci((2 3)) msymbol(dot) mc(purple%50) ciopts(recast(rcap) color(purple%70)) msize(vsmall) ) ///
(matrix(B2_23[1]), ci((2 3)) mcolor(green%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(green%70)) ) ///
(matrix(B2_24[1]), ci((2 3)) mcolor(black%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(black%70)) ) ///
, aseq legend(off) ///
xline(0, lwidth(medium) lcolor(red) lpattern(dash)) ///
mlabel(cond(pvalue<.01, string(@b, "%9.2fc") + "***", cond(pvalue<.05, string(@b, "%9.2fc") + "**", cond(pvalue<.1, string(@b, "%9.2fc") + "*", string(@b, "%9.2fc"))))) ///
xscale(range(-0.20 0.20)) ///
title("3rd Follow-up") ///
ylabel(, labsize(vsmall) nogrid) ///
xlabel(-0.20(0.05)0.20, labsize(vsmall)) ///
plotregion(color(white) fcolor(white)) scheme(white_tableau) ///
graphregion(margin(r=15 l=15)) mlabgap(*0.55) mlabsize(vsmall) ///
mlabvposition(lab_pos) nokey ///
grid(none) ///
headings(r1= "{bf:0-5 Years}" r4= "{bf:6-15 Years}" r7= "{bf:16-25 Years}" r10= "{bf:26-35 Years}" r13= "{bf:36-45 Years}" r16= "{bf:46-55 Years}" r19= "{bf:56-65 Years}" r22= "{bf:65 Above}", labsize(vsmall) labcolor($lavendar) labgap(7) ) ///
groups(r1=" n =2518" ///
             r2=" n = 1235" ///
             r3=" n = 1283" ///
             r4=" n = 6003"  ///
             r5=" n = 2835" ///
			 r6=" n = 3168" ///
             r7=" n = 2712"  ///
             r8=" n = 1599" ///
			 r9=" n = 1113" ///
             r10=" n = 3219"  ///
             r11=" n = 1991" ///
			 r12=" n = 1228" ///
             r13=" n = 2527"  ///
             r14=" n = 1459" ///
             r15=" n = 1068" ///
             r16=" n = 1915"  ///
             r17=" n = 1295" ///
			 r18=" n = 620" ///
             r19=" n = 1320"  ///
             r20=" n = 821" ///
			 r21=" n = 499" ///
             r22=" n = 702"  ///
             r23=" n = 315"  ///
			 r24=" n = 387") ///
yscale(alt axis(2)) ///
coeflabels( r1="Pooled" ///
             r2="Female"  ///
             r3="Male" ///
             r4="Pooled" ///
             r5="Female"  ///
             r6="Male" ///
			 r7="Pooled" ///
             r8="Female"  ///
             r9="Male" ///
			 r10="Pooled" ///
             r11="Female"  ///
             r12="Male" ///
			 r13="Pooled" ///
             r14="Female"  ///
             r15="Male" ///
             r16="Pooled" ///
             r17="Female"  ///
             r18="Male" ///
			 r19="Pooled" ///
             r20="Female"  ///
             r21="Male" ///
			 r22="Pooled" ///
             r23="Female"  ///
             r24="Male" ) 
			 
graph export "$figure/selected/illness/selected_age_group_combined_illness4.png", replace		 











            
