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
	global lavendar "115 79 150"
	 
	**sequential color
	global blue1 "158 202 225"
	global blue2 "66 146 198"
	global blue3 "8 81 156"
	
	global purple1 "188 189 220"
	global purple2 "128 125 186"
	global purple3 "84 39 143"
	


**************************Coefplot*******************************************************************

forvalues i = 2/5 {
    use "$data_clean\ind_w`i'_mortality.dta", clear
    expand 2, generate(all)
    replace C_sex = 3 if all == 1
    la def C_sex 1 "Male" 2 "Female" 3 "Overall", modify
    la val C_sex C_sex
    drop all
    local gender pooled female male
    local m = 3
    gen beta = .
    gen ub = .
    gen lb = .
    gen pvalue = .
    gen gender_ = ""
    gen gender_num = .
    gen group = .
    gen wave = .
	gen observation = .
    local d = 1

    foreach x of local gender {
        forvalues k = 1/8 {
            areg mortality`i' treatment if age_group == `k' & C_sex == `m', absorb(subdistrict) cluster(branchid) 
            replace beta = e(b)[1,1] in `d'
            replace lb = e(b)[1,1] - _se[treatment] * invttail(e(df_r), 0.025) in `d'
            replace ub = e(b)[1,1] + _se[treatment] * invttail(e(df_r), 0.025) in `d'
            replace pvalue = (2 * ttail(e(df_r), abs(_b[treatment]/_se[treatment]))) in `d'

            // Store values of group, gender, gender_num, and wave
            replace group = `k' in `d'
            replace wave = `i' in `d'
            replace gender_ = "`x'" in `d'
            replace gender_num = `m' in `d'
			replace observation = e(N) in `d'

            eststo age_group`k'_`i'_`x'
            local d = `d' + 1
        }
        local m = `m' - 1
    }

    keep if beta != .
    save "$data_clean\age_group`i'_mortality", replace
}



 

use "$data_clean\age_group2_mortality.dta", clear

recode gender_num (3=1) (2=2) (1=3)

keep beta ub lb pvalue group wave gender_ gender_num observation

sort group gender_num
gen lab_pos=10
replace lab_pos=2 if beta>0


mkmat beta ub lb pvalue gender_num lab_pos  , matrix(A)

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
, aseq  ///
xline(0, lwidth(medium) lcolor(red) lpattern(dash)) ///
mlabel(cond(pvalue<.01, string(@b, "%9.2fc") + "***", cond(pvalue<.05, string(@b, "%9.2fc") + "**", cond(pvalue<.1, string(@b, "%9.2fc") + "*", string(@b, "%9.2fc"))))) ///
xscale(range(-0.20 0.20)) ///
ylabel(, labsize(vsmall) nogrid) ///
xlabel(-0.20(0.05)0.20, labsize(vsmall)) ///
plotregion(color(white) fcolor(white)) scheme(white_tableau) ///
graphregion(margin(r=15 l=15)) mlabgap(*0.55) mlabsize(vsmall) ///
mlabvposition(lab_pos) nokey ///
title("1st Follow-up") ///
grid(none) ///
headings(r1= "{bf:0-5 Years  }" r4= "{bf:6-15 Years}" r7= "{bf:16-25 Years}" r10= "{bf:26-35 Years}" r13= "{bf:36-45 Years}" r16= "{bf:46-55 Years}" r19= "{bf:56-65 Years}" r22= "{bf:65 Above}", labsize(vsmall) angle(90) labcolor($lavendar) labgap(7) ) ///
groups(r1=" n =2946" ///
             r2=" n = 1439" ///
             r3=" n = 1507" ///
             r4=" n = 6785"  ///
             r5=" n = 3214" ///
			 r6=" n = 3571" ///
             r7=" n = 3176"  ///
             r8=" n = 1921" ///
			 r9=" n = 1255" ///
             r10=" n = 3718"  ///
             r11=" n = 2285" ///
			 r12=" n = 1433" ///
             r13=" n = 2843"  ///
             r14=" n = 1638" ///
             r15=" n = 1205" ///
             r16=" n = 2149"  ///
             r17=" n = 1472" ///
			 r18=" n = 677" ///
             r19=" n = 1523"  ///
             r20=" n = 975" ///
			 r21=" n = 548" ///
             r22=" n = 829"  ///
             r23=" n = 379"  ///
			 r24=" n = 450") ///
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
             r24="Male" ) name(m2,replace)




 graph export "$figure/selected/mortality/selected_age_group_combined_mortality2.png", replace

// ************* WRITTING LESS CODE
//
// use "$data_clean\age_group2_mortality.dta", clear
//
// recode gender_num (3=1) (2=2) (1=3)
//
// keep beta ub lb pvalue group wave gender gender_num observation
//
// sort gender_num group
// gen lab_pos=10
// replace lab_pos=2 if beta>0
//
//
//
// forval j=1/3{
//
//
// mkmat beta ub lb pvalue gender_num lab_pos if gender_num==`j', matrix(A`j')
//
// matrix A`j'2=A`j''
//
// mat list A`j'2
//
//  }
//
// coefplot matrix(A12[1,])   (matrix(A22[1,])) (matrix(A32[1,])), ci((2 3)) msymbol(dot) msize(vsmall) mlabvposition(lab_pos) nokey xline(0, lwidth(medium) lcolor(red) lpattern(dash)) ///
// xscale(range(-0.20 0.20)) ///
// ylabel(, labsize(vsmall) nogrid) ///
// xlabel(-0.20(0.05)0.20, labsize(vsmall)) /// xtitle("Effect size in standard deviations of the control group", size(vsmall)) ///
// title("1st Follow-up") ///
// coeflabels(r1= "{bf:0-5 Years  }" r2= "{bf:6-15 Years}" r3= "{bf:16-25 Years}" r4= "{bf:26-35 Years}" r5= "{bf:36-45 Years}" r6= "{bf:46-55 Years}" r7= "{bf:56-65 Years}" r8= "{bf:65 Above}" ) ///
// legend(order(3 "Pooled" 6 "Female" 9 "Male") ring(0) bmargin(small) position(2) size(vsmall) rows(3) ) 
//
// graph play pink_change.grec
// 
//
// 
// graph play "D:\Replication\TUP_health\do\play pink_change.grec"
// 
//  **Didn't work
// /*use "$data_clean\age_group3_mortality.dta", clear
//
// recode gender_num (3=1) (2=2) (1=3)
//
// keep beta ub lb pvalue group wave gender gender_num observation
//
// sort group gender_num
// gen lab_pos=10
// replace lab_pos=2 if beta>0
//
// */

use "$data_clean\age_group3_mortality.dta", clear

recode gender_num (3=1) (2=2) (1=3)

keep beta ub lb pvalue group wave gender_ gender_num observation

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
ylabel(, labsize(vsmall) nogrid) ///
xlabel(-0.20(0.05)0.20, labsize(vsmall)) ///
plotregion(color(white) fcolor(white)) scheme(white_tableau) ///
graphregion(margin(r=15 l=15)) mlabgap(*0.55) mlabsize(vsmall) ///
title("2nd Follow-up") ///
mlabvposition(lab_pos) nokey ///
headings(r1= "{bf:0-5 Years}" r4= "{bf:6-15 Years}" r7= "{bf:16-25 Years}" r10= "{bf:26-35 Years}" r13= "{bf:36-45 Years}" r16= "{bf:46-55 Years}" r19= "{bf:56-65 Years}" r22= "{bf:65 Above}", labsize(vsmall) labcolor($lavendar) labgap(7) ) ///
grid(none) ///
groups(r1=" n =2748" ///
             r2=" n = 1334" ///
             r3=" n = 1391" ///
             r4=" n = 6426"  ///
             r5=" n = 3018" ///
			 r6=" n = 3372" ///
             r7=" n = 2942"  ///
             r8=" n = 1746" ///
			 r9=" n = 1174" ///
             r10=" n = 3485"  ///
             r11=" n = 2154" ///
			 r12=" n = 1312" ///
             r13=" n = 2700"  ///
             r14=" n = 1554" ///
             r15=" n = 1132" ///
             r16=" n = 2060"  ///
             r17=" n = 1398" ///
			 r18=" n = 658" ///
             r19=" n = 1439"  ///
             r20=" n = 911" ///
			 r21=" n = 519" ///
             r22=" n = 791"  ///
             r23=" n = 360"  ///
			 r24=" n = 425") ///
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
             r24="Male" ) name(m3,replace)
			 
graph export "$figure/selected/mortality/selected_age_group_combined_mortality3.png", replace		 

			 
			 
/*use "$data_clean\age_group4_mortality.dta", clear

recode gender_num (3=1) (2=2) (1=3)

keep beta ub lb pvalue group wave gender gender_num observation

sort group gender_num
sort group gender_num
gen lab_pos=10
replace lab_pos=2 if beta>0
*/

use "$data_clean\age_group4_mortality.dta", clear

recode gender_num (3=1) (2=2) (1=3)

keep beta ub lb pvalue group wave gender_ gender_num observation

sort group gender_num
gen lab_pos=10
replace lab_pos=2 if beta>0



mkmat beta ub lb pvalue gender_num lab_pos observation , matrix(C)

mkmat observation, matrix (C_obs)

mat list C

matrix C2=C`j''

matrix C_obs2=C_obs`j''

mat list C2

forvalues i=1/`=colsof(C2)'{
    mat C2_`i' = C2[1..`=rowsof(C2)', `i']
}

forvalues i=1/`=colsof(C_obs2)'{
    mat C_obs2_`i' = C_obs2[1, `i']
} 


			 
coefplot (matrix(C2_1[1]), ci((2 3)) msymbol(dot) mc(purple%50) ciopts(recast(rcap) color(purple%70)) msize(vsmall)  ) ///
(matrix(C2_2[1]), ci((2 3)) mcolor(green%50) msymbol(dot) msize(vsmall) ciopts(recast(rcap) color(green%70)) ) ///
(matrix(C2_3[1]), ci((2 3)) mcolor(black%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(black%70)) ) ///
(matrix(C2_4[1]), ci((2 3)) msymbol(dot) mc(purple%50) ciopts(recast(rcap) color(purple%70)) msize(vsmall) ) ///
(matrix(C2_5[1]), ci((2 3)) mcolor(green%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(green%70)) ) ///
(matrix(C2_6[1]), ci((2 3)) mcolor(black%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(black%70)) ) ///
(matrix(C2_7[1]), ci((2 3)) msymbol(dot) mc(purple%50) ciopts(recast(rcap) color(purple%70)) msize(vsmall) ) ///
(matrix(C2_8[1]), ci((2 3)) mcolor(green%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(green%70)) ) ///
(matrix(C2_9[1]), ci((2 3)) mcolor(black%50) msymbol(dot) msize(small) ciopts(recast(rcap) color(black%70)) ) ///
(matrix(C2_10[1]), ci((2 3)) msymbol(dot) mc(purple%50) ciopts(recast(rcap) color(purple%70)) msize(vsmall) ) ///
(matrix(C2_11[1]), ci((2 3)) mcolor(green%50) msymbol(dot) msize(small) ciopts(recast(rcap) color(green%70)) ) ///
(matrix(C2_12[1]), ci((2 3)) mcolor(black%50) msymbol(dot) msize(small) ciopts(recast(rcap) color(black%70)) ) ///
(matrix(C2_13[1]), ci((2 3)) msymbol(dot) mc(purple%50) ciopts(recast(rcap) color(purple%70)) msize(vsmall) ) ///
(matrix(C2_14[1]), ci((2 3)) mcolor(green%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(green%70)) ) ///
(matrix(C2_15[1]), ci((2 3)) mcolor(black%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(black%70)) ) ///
(matrix(C2_16[1]), ci((2 3)) msymbol(dot) mc(purple%50) ciopts(recast(rcap) color(purple%70)) msize(vsmall) ) ///
(matrix(C2_17[1]), ci((2 3)) mcolor(green%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(green%70)) ) ///
(matrix(C2_18[1]), ci((2 3)) mcolor(black%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(black%70)) ) ///
(matrix(C2_19[1]), ci((2 3)) msymbol(dot) mc(purple%50) ciopts(recast(rcap) color(purple%70)) msize(vsmall) ) ///
(matrix(C2_20[1]), ci((2 3)) mcolor(green%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(green%70)) ) ///
(matrix(C2_21[1]), ci((2 3)) mcolor(black%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(black%70)) ) ///
(matrix(C2_22[1]), ci((2 3)) msymbol(dot) mc(purple%50) ciopts(recast(rcap) color(purple%70)) msize(vsmall) ) ///
(matrix(C2_23[1]), ci((2 3)) mcolor(green%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(green%70)) ) ///
(matrix(C2_24[1]), ci((2 3)) mcolor(black%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(black%70)) ) ///
, aseq  ///
groups(r1=" n =2536" ///
             r2=" n = 1278" ///
             r3=" n = 1258" ///
             r4=" n = 6027"  ///
             r5=" n = 2919" ///
			 r6=" n = 3108" ///
             r7=" n = 2727"  ///
             r8=" n = 1642" ///
			 r9=" n = 1085" ///
             r10=" n = 3234"  ///
             r11=" n = 2013" ///
			 r12=" n = 1221" ///
             r13=" n = 2540"  ///
             r14=" n = 1474" ///
             r15=" n = 1066" ///
             r16=" n = 1935"  ///
             r17=" n = 1309" ///
			 r18=" n = 626" ///
             r19=" n = 1346"  ///
             r20=" n = 842" ///
			 r21=" n = 504" ///
             r22=" n = 737"  ///
             r23=" n = 331"  ///
			 r24=" n = 406") ///
yscale(alt axis(2)) /// 
xline(0, lwidth(medium) lcolor(red) lpattern(dash)) ///
mlabel(cond(pvalue<.01, string(@b, "%9.2fc") + "***", cond(pvalue<.05, string(@b, "%9.2fc") + "**", cond(pvalue<.1, string(@b, "%9.2fc") + "*", string(@b, "%9.2fc"))))) ///
xscale(range(-0.20 0.20)) ///
ylabel(, labsize(vsmall) nogrid) ///
xlabel(-0.20(0.05)0.20, labsize(vsmall) ) ///
plotregion(color(white) fcolor(white)) scheme(white_tableau) ///
graphregion(margin(r=15 l=15)) mlabgap(*1) mlabsize(vsmall) ///
mlabvposition(lab_pos) nokey ///
grid(none) ///
title("3rd Follow-up") ///
headings(r1= "{bf:0-5 Years}" r4= "{bf:6-15 Years}" r7= "{bf:16-25 Years}" r10= "{bf:26-35 Years}" r13= "{bf:36-45 Years}" r16= "{bf:46-55 Years}" r19= "{bf:56-65 Years}" r22= "{bf:65 Above}", labsize(vsmall) labcolor($lavendar) labgap(7) ) ///
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
             r24="Male" )  name(m4,replace)
			 
graph export "$figure/selected/mortality/selected_age_group_combined_mortality4.png", replace






******2024
use "$data_clean\age_group5_mortality.dta", clear

recode gender_num (3=1) (2=2) (1=3)

keep beta ub lb pvalue group wave gender_ gender_num observation

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
ylabel(, labsize(vsmall) nogrid) ///
xlabel(-0.20(0.05)0.20, labsize(vsmall)) ///
plotregion(color(white) fcolor(white)) scheme(white_tableau) ///
graphregion(margin(r=15 l=15)) mlabgap(*0.55) mlabsize(vsmall) ///
mlabvposition(lab_pos) nokey ///
headings(r1= "{bf:0-5 Years}" r4= "{bf:6-15 Years}" r7= "{bf:16-25 Years}" r10= "{bf:26-35 Years}" r13= "{bf:36-45 Years}" r16= "{bf:46-55 Years}" r19= "{bf:56-65 Years}" r22= "{bf:65 Above}", labsize(vsmall) labcolor($lavendar) labgap(7) ) ///
grid(none) ///
groups(r1=" n =2748" ///
             r2=" n = 1334" ///
             r3=" n = 1391" ///
             r4=" n = 6426"  ///
             r5=" n = 3018" ///
			 r6=" n = 3372" ///
             r7=" n = 2942"  ///
             r8=" n = 1746" ///
			 r9=" n = 1174" ///
             r10=" n = 3485"  ///
             r11=" n = 2154" ///
			 r12=" n = 1312" ///
             r13=" n = 2700"  ///
             r14=" n = 1554" ///
             r15=" n = 1132" ///
             r16=" n = 2060"  ///
             r17=" n = 1398" ///
			 r18=" n = 658" ///
             r19=" n = 1439"  ///
             r20=" n = 911" ///
			 r21=" n = 519" ///
             r22=" n = 791"  ///
             r23=" n = 360"  ///
			 r24=" n = 425") ///
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
             r24="Male" ) name(m4,replace)
			 
graph export "$figure/selected/mortality/selected_age_group_combined_mortality5.png", replace		 




*graph export "$figure/selected/mortality/selected_age_group_combined_mortality4.pdf", replace


*grc1leg m2 m3 m4, colfirst iscale(*1.02) ycommon xcommon rows(2) ysize(11) imargin(0 0 0 0)

*graph combine m2 m3 m4, iscale(1) ycommon xcommon rows(2) saving(g)

/*
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
 || (matrix(B2_1[1]), ci((2 3)) msymbol(dot) mc(purple%50) ciopts(recast(rcap) color(purple%70)) msize(vsmall) ) ///
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
|| (matrix(C2_1[1]), ci((2 3)) msymbol(dot) mc(purple%50) ciopts(recast(rcap) color(purple%70)) msize(vsmall)  ) ///
(matrix(C2_2[1]), ci((2 3)) mcolor(green%50) msymbol(dot) msize(vsmall) ciopts(recast(rcap) color(green%70)) ) ///
(matrix(C2_3[1]), ci((2 3)) mcolor(black%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(black%70)) ) ///
(matrix(C2_4[1]), ci((2 3)) msymbol(dot) mc(purple%50) ciopts(recast(rcap) color(purple%70)) msize(vsmall) ) ///
(matrix(C2_5[1]), ci((2 3)) mcolor(green%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(green%70)) ) ///
(matrix(C2_6[1]), ci((2 3)) mcolor(black%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(black%70)) ) ///
(matrix(C2_7[1]), ci((2 3)) msymbol(dot) mc(purple%50) ciopts(recast(rcap) color(purple%70)) msize(vsmall) ) ///
(matrix(C2_8[1]), ci((2 3)) mcolor(green%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(green%70)) ) ///
(matrix(C2_9[1]), ci((2 3)) mcolor(black%50) msymbol(dot) msize(small) ciopts(recast(rcap) color(black%70)) ) ///
(matrix(C2_10[1]), ci((2 3)) msymbol(dot) mc(purple%50) ciopts(recast(rcap) color(purple%70)) msize(vsmall) ) ///
(matrix(C2_11[1]), ci((2 3)) mcolor(green%50) msymbol(dot) msize(small) ciopts(recast(rcap) color(green%70)) ) ///
(matrix(C2_12[1]), ci((2 3)) mcolor(black%50) msymbol(dot) msize(small) ciopts(recast(rcap) color(black%70)) ) ///
(matrix(C2_13[1]), ci((2 3)) msymbol(dot) mc(purple%50) ciopts(recast(rcap) color(purple%70)) msize(vsmall) ) ///
(matrix(C2_14[1]), ci((2 3)) mcolor(green%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(green%70)) ) ///
(matrix(C2_15[1]), ci((2 3)) mcolor(black%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(black%70)) ) ///
(matrix(C2_16[1]), ci((2 3)) msymbol(dot) mc(purple%50) ciopts(recast(rcap) color(purple%70)) msize(vsmall) ) ///
(matrix(C2_17[1]), ci((2 3)) mcolor(green%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(green%70)) ) ///
(matrix(C2_18[1]), ci((2 3)) mcolor(black%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(black%70)) ) ///
(matrix(C2_19[1]), ci((2 3)) msymbol(dot) mc(purple%50) ciopts(recast(rcap) color(purple%70)) msize(vsmall) ) ///
(matrix(C2_20[1]), ci((2 3)) mcolor(green%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(green%70)) ) ///
(matrix(C2_21[1]), ci((2 3)) mcolor(black%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(black%70)) ) ///
(matrix(C2_22[1]), ci((2 3)) msymbol(dot) mc(purple%50) ciopts(recast(rcap) color(purple%70)) msize(vsmall) ) ///
(matrix(C2_23[1]), ci((2 3)) mcolor(green%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(green%70)) ) ///
(matrix(C2_24[1]), ci((2 3)) mcolor(black%50) msymbol(dot)  msize(vsmall) ciopts(recast(rcap) color(black%70)) ) ///
, aseq  ///
groups(r1=" n =2536" ///
             r2=" n = 1278" ///
             r3=" n = 1258" ///
             r4=" n = 6027"  ///
             r5=" n = 2919" ///
			 r6=" n = 3108" ///
             r7=" n = 2727"  ///
             r8=" n = 1642" ///
			 r9=" n = 1085" ///
             r10=" n = 3234"  ///
             r11=" n = 2013" ///
			 r12=" n = 1221" ///
             r13=" n = 2540"  ///
             r14=" n = 1474" ///
             r15=" n = 1066" ///
             r16=" n = 1935"  ///
             r17=" n = 1309" ///
			 r18=" n = 626" ///
             r19=" n = 1346"  ///
             r20=" n = 842" ///
			 r21=" n = 504" ///
             r22=" n = 737"  ///
             r23=" n = 331"  ///
			 r24=" n = 406") ///
yscale(alt axis(2)) /// 
xline(0, lwidth(medium) lcolor(red) lpattern(dash)) ///
mlabel(cond(pvalue<.01, string(@b, "%9.2fc") + "***", cond(pvalue<.05, string(@b, "%9.2fc") + "**", cond(pvalue<.1, string(@b, "%9.2fc") + "*", string(@b, "%9.2fc"))))) ///
xscale(range(-0.20 0.20)) ///
ylabel(, labsize(vsmall) nogrid) ///
xlabel(-0.20(0.05)0.20, labsize(vsmall) ) ///
plotregion(color(white) fcolor(white)) scheme(white_tableau) ///
graphregion(margin(r=15 l=15)) mlabgap(*1) mlabsize(vsmall) ///
mlabvposition(lab_pos) nokey ///
grid(none) ///
title("3rd Follow-up") ///
headings(r1= "{bf:0-5 Years}" r4= "{bf:6-15 Years}" r7= "{bf:16-25 Years}" r10= "{bf:26-35 Years}" r13= "{bf:36-45 Years}" r16= "{bf:46-55 Years}" r19= "{bf:56-65 Years}" r22= "{bf:65 Above}", labsize(vsmall) labcolor($lavendar) labgap(7) ) ///
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









            