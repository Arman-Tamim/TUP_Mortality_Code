cls
clear
*set maxvar 25000
use "$data_clean\ind_w2_mortality.dta", clear	
areg mortality2 treatment , absorb(subdistrict) cluster (branchid)
reg mortality2 treatment , cluster (branchid)
reg mortality2 treatment


merge 1:1 hhid lino using "$data_clean\ind_w1_unbalanced"
keep if _merge==3
drop _merge

cap nois erase "$results\mortality_selected_hetero2.xls"
cap nois erase "$results\mortality_selected_hetero2.txt"


forvalues j=0/1{
	    areg mortality2 treatment if  non_com_illness1==`j'  , absorb(subdistrict) cluster (branchid)
		sum mortality2 if treatment == 0 & non_com_illness1==`j' 
		local control_mean = r(mean) 
		outreg2 using "$results\mortality_selected_hetero2.xls", keep(treatment) nocons nor2 addstat(Control Mean, `control_mean') append ctitle("mortality2_`j'") wide 
		}

forvalues i=1/2{
    forvalues j=0/1{
	    areg mortality2 treatment if  non_com_illness1==`j' & C_sex==`i' , absorb(subdistrict) cluster (branchid)
		sum mortality2 if treatment == 0 & non_com_illness1==`j' & C_sex==`i'
		local control_mean = r(mean) 
		outreg2 using "$results\mortality_selected_hetero2.xls", keep(treatment) nocons nor2 addstat(Control Mean, `control_mean') append ctitle("mortality2_`i'`j'") wide 
		}
}


***Power
sum mortality2 if treatment == 0
local control_mean = r(mean)
local m1 = r(N)/20

sum mortality2 if treatment == 1

local m2 = r(N)/20

loneway mortality2 branchid

local rho = r(rho)

power twoproportions `control_mean' , k1(20) k2(20) m1(`m1') m2(`m2') rho(`rho') power(0.80) direction(lower)



use "$data_clean\ind_w3_mortality.dta", clear	
areg mortality3 treatment , absorb(subdistrict) cluster (branchid)
reg mortality3 treatment , cluster (branchid)
reg mortality3 treatment

merge 1:1 hhid lino using "$data_clean\ind_w1_unbalanced"
keep if _merge==3
drop _merge

forvalues j=0/1{
	    areg mortality3 treatment if  non_com_illness1==`j'  , absorb(subdistrict) cluster (branchid)
		sum mortality3 if treatment == 0 & non_com_illness1==`j' 
		local control_mean = r(mean) 
		outreg2 using "$results\mortality_selected_hetero2.xls", keep(treatment) nocons nor2 addstat(Control Mean, `control_mean') append ctitle("mortality3_`j'") wide 
		}

forvalues i=1/2{
    forvalues j=0/1{
	    areg mortality3 treatment if  non_com_illness1==`j' & C_sex==`i' , absorb(subdistrict) cluster (branchid)
		sum mortality3 if treatment == 0 & non_com_illness1==`j' & C_sex==`i'
		local control_mean = r(mean) 
		outreg2 using "$results\mortality_selected_hetero2.xls", keep(treatment) nocons nor2 addstat(Control Mean, `control_mean') append ctitle("mortality3_`i'`j'") wide 
		}
}

use "$data_clean\ind_w4_mortality.dta", clear
replace mortality2 = 0 if mortality2 ==.
replace mortality3 = 0 if mortality3 ==.
areg mortality4 treatment , absorb(subdistrict) cluster (branchid)
reg mortality4 treatment , cluster (branchid)
reg mortality4 treatment

merge 1:1 hhid lino using "$data_clean\ind_w1_unbalanced"
keep if _merge==3
drop _merge

forvalues j=0/1{
	    areg mortality4 treatment if  non_com_illness1==`j'  , absorb(subdistrict) cluster (branchid)
		sum mortality4 if treatment == 0 & non_com_illness1==`j' 
		local control_mean = r(mean) 
		outreg2 using "$results\mortality_selected_hetero2.xls", keep(treatment) nocons nor2 addstat(Control Mean, `control_mean') append ctitle("mortality4_`j'") wide 
		}

forvalues i=1/2{
    forvalues j=0/1{
	    areg mortality4 treatment if  non_com_illness1==`j' & C_sex==`i' , absorb(subdistrict) cluster (branchid)
		sum mortality4 if treatment == 0 & non_com_illness1==`j' & C_sex==`i'
		local control_mean = r(mean) 
		outreg2 using "$results\mortality_selected_hetero2.xls", keep(treatment) nocons nor2 addstat(Control Mean, `control_mean') append ctitle("mortality4_`i'`j'") wide 
		}
}


**For 2024

use "$data_clean\ind_w5_mortality.dta", clear
replace mortality2 = 0 if mortality2 ==.
replace mortality3 = 0 if mortality3 ==.
areg mortality5 treatment , absorb(subdistrict) cluster (branchid)
reg mortality4 treatment , cluster (branchid)
reg mortality4 treatment

merge 1:1 branchid spotno hhno lino using "$data_clean\ind_w1_unbalanced"
keep if _merge==3
drop _merge

forvalues j=0/1{
	    areg mortality5 treatment if  non_com_illness1==`j'  , absorb(subdistrict) cluster (branchid)
		sum mortality5 if treatment == 0 & non_com_illness1==`j' 
		local control_mean = r(mean) 
		outreg2 using "$results\mortality_selected_hetero2.xls", keep(treatment) nocons nor2 addstat(Control Mean, `control_mean') append ctitle("mortality5_`j'") wide 
		}

forvalues i=1/2{
    forvalues j=0/1{
	    areg mortality5 treatment if  non_com_illness1==`j' & Gender==`i' , absorb(subdistrict) cluster (branchid)
		sum mortality5 if treatment == 0 & non_com_illness1==`j' & Gender==`i'
		local control_mean = r(mean) 
		outreg2 using "$results\mortality_selected_hetero2.xls", keep(treatment) nocons nor2 addstat(Control Mean, `control_mean') append ctitle("mortality5_`i'`j'") wide 
		}
}



*****
local waves 2 3 4 5

cap nois erase "$results\mortality_selected2.xls"
cap nois erase "$results\mortality_selected2.txt"


foreach wv in `waves' {
	use "$data_clean\ind_w`wv'_mortality.dta", clear
	areg mortality`wv' treatment  , absorb(subdistrict) cluster (branchid)
    sum mortality`wv' if treatment == 0
    local control_mean = r(mean) 
    outreg2 using "$results\mortality_selected2.xls", keep(treatment) nocons nor2 addstat(Control Mean, `control_mean') append ctitle("mortality`wv'") wide 
}


gen age_group_work = (age_yr>35 & age_yr <66)

areg mortality4 treatment if C_sex==1 & age_group_w==1, absorb(subdistrict) cluster (branchid)
*****************Gender********************************

local gender Male Female
local waves 2 3 4

local i =1 
foreach g in `gender' {
    // Initialize variables to store results
    local xls_file "$results\subsample\selected\selected_ind_mortality_`g'.xls"
    local txt_file "$results\subsample\selected\selected_ind_mortality_`g'.txt"

    // Erase existing files
    cap nois erase "`xls_file'"
    cap nois erase "`txt_file'"

    foreach wv in `waves' {
        // Clear data for each iteration
        use "$data_clean\ind_w`wv'_mortality.dta", clear
		
        keep if C_sex == `i'

        // Run regression and calculate control mean
        areg mortality`wv' treatment, absorb(subdistrict) cluster (branchid)
        sum mortality`wv' if treatment == 0
        local control_mean = r(mean)

        // Output regression results to the same Excel file
        outreg2 using "`xls_file'", keep(treatment) addstat(Control_Mean, `control_mean') nocons nor2 append ctitle("mortality`wv'") wide
    }
	
	local i = `i' + 1
}

use "$data_clean\ind_w5_mortality.dta", clear


cap nois erase "$results\selected_ind_mortality_5.xls"
cap nois erase "$results\selected_ind_mortality_5.txt"

// Run regression and calculate control mean

forvalues i=1/2{
        areg mortality5 treatment if Gender ==`i', absorb(subdistrict) cluster (branchid)
        sum mortality5 if treatment == 0 & Gender ==`i'
        local control_mean = r(mean)

        // Output regression results to the same Excel file
        outreg2 using "$results\selected_ind_mortality_5.xls", keep(treatment) addstat(Control_Mean, `control_mean') nocons nor2 append ctitle("mortality5`i'") wide
}
********age****************************


// Specify age groups and waves
local age_groups 1 2 3 4 5 6 7 8
local waves 2 3 4

foreach ag in `age_groups' {
    // Initialize variables to store results
    local xls_file "$results\subsample\selected\selected_ind_mortality_age_group`ag'.xls"
    local txt_file "$results\subsample\selected\selected_ind_mortality_age_group`ag'.txt"

    // Erase existing files
    cap nois erase "`xls_file'"
    cap nois erase "`txt_file'"

    foreach wv in `waves' {
        // Clear data for each iteration
        use "$data_clean\ind_w`wv'_mortality.dta", clear
        keep if age_group == `ag'

        // Run regression and calculate control mean
        areg mortality`wv' treatment , absorb(subdistrict) cluster (branchid)
        sum mortality`wv' if treatment == 0
        local control_mean = r(mean)

        // Output regression results to the same Excel file
        outreg2 using "`xls_file'", keep(treatment) addstat(Control_Mean, `control_mean') nocons nor2 append ctitle("mortality`wv'") wide
    }
}
*/
**************************Coeffplot*******************************************************************
forvalues i=2/4{
	use "$data_clean\ind_w`i'_mortality.dta", clear
    forvalues k=1/8{
	    preserve
		keep if age_group == `k'
	    areg mortality`i' treatment , absorb(subdistrict) cluster (branchid)
		eststo age_group`k'
		restore
	}
	coefplot ///
	(age_group1, keep(treatment) aseq("0-5 years") mcolor(purple%50) msymbol(dot) msize(small) ciopts(recast(rcap) color(purple%70)) mlabposition(1)) ///
	(age_group2, keep(treatment) aseq("6-15 years") mcolor(purple%50) msymbol(dot) msize(small) ciopts(recast(rcap) color(purple%70)) mlabposition(1)) ///
	(age_group3, keep(treatment) aseq("16-25 years") mcolor(purple%50) msymbol(dot) msize(small) ciopts(recast(rcap) color(purple%70)) mlabposition(1)) ///
	(age_group4, keep(treatment) aseq("26-35 years") mcolor(purple%50) msymbol(dot) msize(small) ciopts(recast(rcap) color(purple%70)) mlabposition(1)) ///
	(age_group5, keep(treatment) aseq("36-45 years") mcolor(purple%50) msymbol(dot) msize(small) ciopts(recast(rcap) color(purple%70)) mlabposition(6)) ///
	(age_group6, keep(treatment) aseq("46-55 years") mcolor(purple%50) msymbol(dot) msize(small) ciopts(recast(rcap) color(purple%70)) mlabposition(1)) ///
	(age_group7, keep(treatment) aseq("56-65 years") mcolor(purple%50) msymbol(dot) msize(small) ciopts(recast(rcap) color(purple%70)) mlabposition(6)) ///
	(age_group8, keep(treatment) aseq("65 above") mcolor(purple%50) msymbol(dot) msize(small) ciopts(recast(rcap) color(purple%70)) mlabposition(1)) ///
, aseq swapnames legend(off) coeflabels(, wrap(40)) drop(_cons)  ylabel(, angle(horizontal) labsize(vsmall)) mlabgap(*0.5) mlabsize(vsmall) mlabel(cond(@pval<.01, string(@b, "%9.2fc") + "***", cond(@pval<.05, string(@b, "%9.2fc") + "**", cond(@pval<.1, string(@b, "%9.2fc") + "*", string(@b, "%9.2fc"))))) plotregion(color(white) fcolor(white)) scheme(white_tableau) xtitle("Treatment effect on mortality`i'", size(vsmall)) headings("0-5 years"="{bf:Age group}" "Female"="{bf:Gender}" "Female 0-5 years"="{bf:Female age group}" "Male 0-5 years"="{bf:Male age group}", labsize(vsmall)) graphregion(margin(r=15 l=15))
*groups("5-11 years" "12-18 years" "Males" "Females" ="{bf:Children Demographics}") ///testing out grouping, not needed for this graph

  graph export "$figure/selected/selected_age_group_mortality`i'.png", replace
}

********************************male coeffplot************************
forvalues i=2/4{
	use "$data_clean\ind_w`i'_mortality.dta", clear
	keep if C_sex==1
    forvalues k=1/8{
	    preserve
		keep if age_group == `k'
	    areg mortality`i' treatment , absorb(subdistrict) cluster (branchid)
		eststo age_group`k'
		restore
	}
	coefplot ///
	(age_group1, keep(treatment) aseq("0-5 years") mcolor(purple%50) msymbol(dot) msize(small) ciopts(recast(rcap) color(purple%70)) mlabposition(1)) ///
	(age_group2, keep(treatment) aseq("6-15 years") mcolor(purple%50) msymbol(dot) msize(small) ciopts(recast(rcap) color(purple%70)) mlabposition(1)) ///
	(age_group3, keep(treatment) aseq("16-25 years") mcolor(purple%50) msymbol(dot) msize(small) ciopts(recast(rcap) color(purple%70)) mlabposition(1)) ///
	(age_group4, keep(treatment) aseq("26-35 years") mcolor(purple%50) msymbol(dot) msize(small) ciopts(recast(rcap) color(purple%70)) mlabposition(1)) ///
	(age_group5, keep(treatment) aseq("36-45 years") mcolor(purple%50) msymbol(dot) msize(small) ciopts(recast(rcap) color(purple%70)) mlabposition(6)) ///
	(age_group6, keep(treatment) aseq("46-55 years") mcolor(purple%50) msymbol(dot) msize(small) ciopts(recast(rcap) color(purple%70)) mlabposition(1)) ///
	(age_group7, keep(treatment) aseq("56-65 years") mcolor(purple%50) msymbol(dot) msize(small) ciopts(recast(rcap) color(purple%70)) mlabposition(6)) ///
	(age_group8, keep(treatment) aseq("65 above") mcolor(purple%50) msymbol(dot) msize(small) ciopts(recast(rcap) color(purple%70)) mlabposition(1)) ///
, aseq swapnames legend(off) coeflabels(, wrap(40)) drop(_cons)  ylabel(, angle(horizontal) labsize(vsmall)) mlabgap(*0.5) mlabsize(vsmall) mlabel(cond(@pval<.01, string(@b, "%9.2fc") + "***", cond(@pval<.05, string(@b, "%9.2fc") + "**", cond(@pval<.1, string(@b, "%9.2fc") + "*", string(@b, "%9.2fc"))))) plotregion(color(white) fcolor(white)) scheme(white_tableau) xtitle("Treatment effect on male mortality`i'", size(vsmall)) headings("0-5 years"="{bf:Age group}" "Female"="{bf:Gender}" "Female 0-5 years"="{bf:Female age group}" "Male 0-5 years"="{bf:Male age group}", labsize(vsmall)) graphregion(margin(r=15 l=15)) name(g`i', replace)
*groups("5-11 years" "12-18 years" "Males" "Females" ="{bf:Children Demographics}") ///testing out grouping, not needed for this graph

  graph export "$figure/selected/selected_age_group_male_mortality`i'.png", replace
}

esttab g1 g2 g3, graph combine(name(combined)) ///
    title("Combined Graph") ///
    name(combined)
    
graph export "$figure/selected/selected_age_group_male_mortality_combined.png", replace


forvalues i=2/4 {
    use "$data_clean\ind_w`i'_mortality.dta", clear
    keep if C_sex==1
    forvalues k=1/8 {
        preserve
        keep if age_group == `k'
        areg mortality`i' treatment, absorb(subdistrict) cluster (branchid)
        eststo age_group`k'
        restore
    }
    coefplot (age_group1, keep(treatment) aseq("0-5 years") mcolor(purple%50) msymbol(dot) msize(small) ciopts(recast(rcap) color(purple%70)) mlabposition(1)) ///
             (age_group2, keep(treatment) aseq("6-15 years") mcolor(purple%50) msymbol(dot) msize(small) ciopts(recast(rcap) color(purple%70)) mlabposition(1)) ///
             (age_group3, keep(treatment) aseq("16-25 years") mcolor(purple%50) msymbol(dot) msize(small) ciopts(recast(rcap) color(purple%70)) mlabposition(1)) ///
             (age_group4, keep(treatment) aseq("26-35 years") mcolor(purple%50) msymbol(dot) msize(small) ciopts(recast(rcap) color(purple%70)) mlabposition(1)) ///
             (age_group5, keep(treatment) aseq("36-45 years") mcolor(purple%50) msymbol(dot) msize(small) ciopts(recast(rcap) color(purple%70)) mlabposition(6)) ///
             (age_group6, keep(treatment) aseq("46-55 years") mcolor(purple%50) msymbol(dot) msize(small) ciopts(recast(rcap) color(purple%70)) mlabposition(1)) ///
             (age_group7, keep(treatment) aseq("56-65 years") mcolor(purple%50) msymbol(dot) msize(small) ciopts(recast(rcap) color(purple%70)) mlabposition(6)) ///
             (age_group8, keep(treatment) aseq("65 above") mcolor(purple%50) msymbol(dot) msize(small) ciopts(recast(rcap) color(purple%70)) mlabposition(1)) ///
             , aseq swapnames legend(off) coeflabels(, wrap(40)) drop(_cons)  ylabel(, angle(horizontal) labsize(vsmall)) mlabgap(*0.5) mlabsize(vsmall) ///
             mlabel(cond(@pval<.01, string(@b, "%9.2fc") + "***", cond(@pval<.05, string(@b, "%9.2fc") + "**", cond(@pval<.1, string(@b, "%9.2fc") + "*", string(@b, "%9.2fc"))))) plotregion(color(white) fcolor(white)) scheme(white_tableau) xtitle("Treatment effect on male mortality`i'", size(vsmall)) ///
             headings("0-5 years"="{bf:Age group}" "Female"="{bf:Gender}" "Female 0-5 years"="{bf:Female age group}" "Male 0-5 years"="{bf:Male age group}", labsize(vsmall)) graphregion(margin(r=15 l=15)) ///
             name(g`i', replace)
}

/*graph combine g2 g3 g4, xcommon ycommon name(combined, replace)

graph export "$figure/selected/selected_age_group_male_mortality_combined.png", replace
*/



***************************************female mortality*********************

forvalues i=2/4{
	use "$data_clean\ind_w`i'_mortality.dta", clear
	keep if C_sex==2
    forvalues k=1/8{
	    preserve
		keep if age_group == `k'
	    areg mortality`i' treatment , absorb(subdistrict) cluster (branchid)
		eststo age_group`k'
		restore
	}
	coefplot ///
	(age_group1, keep(treatment) aseq("0-5 years") mcolor(purple%50) msymbol(dot) msize(small) ciopts(recast(rcap) color(purple%70)) mlabposition(1)) ///
	(age_group2, keep(treatment) aseq("6-15 years") mcolor(purple%50) msymbol(dot) msize(small) ciopts(recast(rcap) color(purple%70)) mlabposition(1)) ///
	(age_group3, keep(treatment) aseq("16-25 years") mcolor(purple%50) msymbol(dot) msize(small) ciopts(recast(rcap) color(purple%70)) mlabposition(1)) ///
	(age_group4, keep(treatment) aseq("26-35 years") mcolor(purple%50) msymbol(dot) msize(small) ciopts(recast(rcap) color(purple%70)) mlabposition(1)) ///
	(age_group5, keep(treatment) aseq("36-45 years") mcolor(purple%50) msymbol(dot) msize(small) ciopts(recast(rcap) color(purple%70)) mlabposition(6)) ///
	(age_group6, keep(treatment) aseq("46-55 years") mcolor(purple%50) msymbol(dot) msize(small) ciopts(recast(rcap) color(purple%70)) mlabposition(1)) ///
	(age_group7, keep(treatment) aseq("56-65 years") mcolor(purple%50) msymbol(dot) msize(small) ciopts(recast(rcap) color(purple%70)) mlabposition(6)) ///
	(age_group8, keep(treatment) aseq("65 above") mcolor(purple%50) msymbol(dot) msize(small) ciopts(recast(rcap) color(purple%70)) mlabposition(1)) ///
, aseq swapnames legend(off) coeflabels(, wrap(40)) drop(_cons)  ylabel(, angle(horizontal) labsize(vsmall)) mlabgap(*0.5) mlabsize(vsmall) mlabel(cond(@pval<.01, string(@b, "%9.2fc") + "***", cond(@pval<.05, string(@b, "%9.2fc") + "**", cond(@pval<.1, string(@b, "%9.2fc") + "*", string(@b, "%9.2fc"))))) plotregion(color(white) fcolor(white)) scheme(white_tableau) xtitle("Treatment effect on female mortality`i'", size(vsmall)) headings("0-5 years"="{bf:Age group}" "Female"="{bf:Gender}" "Female 0-5 years"="{bf:Female age group}" "Male 0-5 years"="{bf:Male age group}", labsize(vsmall)) graphregion(margin(r=15 l=15))
*groups("5-11 years" "12-18 years" "Males" "Females" ="{bf:Children Demographics}") ///testing out grouping, not needed for this graph

  graph export "$figure/selected/selected_age_group_female_mortality`i'.png", replace
}


