cls
clear
*set maxvar 25000

do "$base_dir\Directory_TUP_health"


***********More precise death time
* For hh level ANCOVA

use "$base_dir\HHdata_complete_finalselected_W1-5 (2)", clear

drop if survey_wave == 5

foreach i in 9 11 14 18{
	keep if split`i' == 0
}

gen household_mortality = H_mort_D

forvalues i= 2/4{
    gen household_mortality_`i' = .
	replace household_mortality_`i' = 1 if household_mortality ==1 &  survey_wave == `i'
}

forvalues i=2/4{
    preserve
	keep if survey_wave == `i'
	drop if household_mortality_`i' ==.
	forvalues j=1/2{
	    gen age_low_range`j' = H_mort_age_year`j' - 3 if H_mort_age_year`j' != .
		gen age_high_range`j' = H_mort_age_year`j' + 3 if H_mort_age_year`j' != .
	}
	
	
	keep hhid  H_mort_sex1 H_mort_relation1 age_low_range1 age_high_range1 H_mort_age_year1 H_mort_age_month1 H_mort_cause1 H_mort_treatment1 H_mort_sex2 H_mort_relation2 age_low_range2 age_high_range2 H_mort_age_year2 H_mort_age_month2 H_mort_cause2 H_mort_treatment2 household_mortality_`i'
	
	local vars  H_mort_sex1 H_mort_relation1 age_low_range1 age_high_range1 H_mort_age_year1 H_mort_age_month1 H_mort_cause1 H_mort_treatment1 H_mort_sex2 H_mort_relation2 age_low_range2 age_high_range2 H_mort_age_year2 H_mort_age_month2 H_mort_cause2 H_mort_treatment2
	
	foreach x in `vars'{
	    rename `x' `x'_`i'
	}
	
	sort hhid
	save "$data_clean\hh_w`i'_mortality.dta",replace
	restore
}


* For Individual level ANCOVA

use "$base_dir\W1_Indiv_finalselected.dta", clear
	rename lino_w1 lino
    sort branchid hhid lino
gen treatment = 0
    forvalues j = 1/20 {
        replace treatment = 1 if branchid == `j'
    }
gen subdistrict = 0
    forvalues k = 1/20 {
        replace subdistrict = `k' if branchid == `k' | branchid == `k' + 20
    }
	

gen age_group = 0
replace age_group =1 if age_years==0
replace age_group= 2 if age_years >= 5 & age_years <= 15
replace age_group= 3 if age_years > 15 & age_years <= 25
replace age_group= 4 if age_years > 25 & age_years <= 35
replace age_group= 5 if age_years > 35 & age_years <= 45
replace age_group= 6 if age_years > 45 & age_years <= 55
replace age_group= 7 if age_years > 55 & age_years <= 65
replace age_group= 8 if age_years > 65

gen age_group_pp = 0
replace age_group_pp =1 if age_years==0
replace age_group_pp= 2 if age_years >= 5 & age_years <= 10
replace age_group_pp= 3 if age_years > 10 & age_years <= 15
replace age_group_pp= 4 if age_years > 15 & age_years <= 20
replace age_group_pp= 5 if age_years > 20 & age_years <= 25
replace age_group_pp= 6 if age_years > 25 & age_years <= 30
replace age_group_pp= 7 if age_years > 30 & age_years <= 35
replace age_group_pp= 8 if age_years > 35 & age_years <= 40
replace age_group_pp= 9 if age_years > 40 & age_years <= 45
replace age_group_pp= 10 if age_years > 45 & age_years <= 50
replace age_group_pp= 11 if age_years > 50 & age_years <= 55
replace age_group_pp= 12 if age_years > 55 & age_years <= 60
replace age_group_pp= 13 if age_years > 60 & age_years <= 65

replace age_group_pp= 14 if age_years > 65



gen age_yr=age_years

gen age_m=age_months

gen relation_head = relation	
label value  relation_head relation
preserve
keep hhid lino relation_head
save "$data_clean\ind_w1_relation.dta",replace
restore
save "$data_clean\ind_w1_mortality.dta",replace


use "$data_clean\ind_w2", clear

recode C_sex (0 = 2) (1=1) 
gen mortality2=0
replace mortality2 =1 if followup_status == 4                                   

preserve
keep if mortality2 == 1

merge m:1 hhid using "$data_clean\hh_w2_mortality.dta"
gen  treat =(branchid < 21)
drop if _merge==2
drop _merge
duplicates tag hhid, gen(duple)


br hhid lino  household_mortality_2 age_years H_mort_age_year1 H_mort_age_year2 C_sex H_mort_sex1 H_mort_sex2 H_mort_relation1 H_mort_relation2  if duple> 0 & household_mortality_2==1

gen died_in_2008 =0
replace died_in_2008 = 1 if duple == 0 & household_mortality_2 == 1
replace died_in_2008 = 1 if duple == 1 & household_mortality_2 == 1 & age_years >= age_low_range1_2 & age_years <= age_high_range1_2

save "$data_clean\ind_append_w2_mortality.dta", replace
restore


merge 1:1 branchid hhid lino using "$data_clean\ind_w1_mortality.dta"
tab mortality2
tab _merge mortality2
keep if _merge==3
drop _merge


save "$data_clean\ind_w2_mortality.dta", replace



use "$data_clean\ind_w3", clear
recode C_sex (0 = 2) (1=1) 
gen mortality3=0
replace mortality3 =1 if followup_status == 4
sort hhid lino
merge 1:1 hhid lino using "$data_clean\ind_append_w2_mortality.dta"
drop _merge
*duplicates tag hhid lino, gen(duple)
replace mortality3 = 1 if mortality2 ==1

preserve
keep if mortality3 ==1
merge m:1 hhid using "$data_clean\hh_w3_mortality.dta"
gen  treat2 =(branchid < 21)
drop if _merge==2
drop _merge
duplicates tag hhid, gen(duple2)

br hhid lino  household_mortality_3 age_years H_mort_age_year1_3 H_mort_age_year2_3 C_sex H_mort_sex1_3 H_mort_sex2_3 H_mort_relation1_3 H_mort_relation2_3 if duple2>0 & household_mortality_3==1

gen died_in_2010 =0
replace died_in_2010 = 1 if duple2 == 0 & household_mortality_3 == 1
replace died_in_2010 = 1 if duple2 == 1 & household_mortality_3 == 1 & age_years >= age_low_range1_3 & age_years <= age_high_range1_3


save "$data_clean\ind_append_w3_mortality.dta", replace
restore

merge 1:1 branchid hhid lino using "$data_clean\ind_w1_mortality.dta"
	tab mortality3
	
    forvalues i=2/3{
		tab _merge mortality`i'
	}
	keep if _merge==3
	drop _merge


save "$data_clean\ind_w3_mortality.dta", replace




use "$data_clean\ind_w4", clear

gen mortality4=0
replace mortality4 =1 if followup_status == 4

sort hhid lino
merge 1:1 hhid lino using "$data_clean\ind_append_w3_mortality.dta"
drop _merge

replace mortality4 = 1 if mortality3 ==1

merge m:1 hhid using "$data_clean\hh_w4_mortality.dta"
gen  treat3 =(branchid < 21)
drop if _merge==2
drop _merge
duplicates tag hhid, gen(duple3)

br hhid lino duple3 household_mortality_4 age_years_14 H_mort_age_year1_4 H_mort_age_year2_4 C_sex H_mort_sex1_4 H_mort_sex2_4  H_mort_relation1_4 H_mort_relation2_4 if mortality4 == 1 & duple3>0 & household_mortality_4==1  

gen died_in_2013 =0
replace died_in_2013 = 1 if duple3 == 0 & household_mortality_4 == 1 & mortality4 == 1
replace died_in_2013 = 1 if duple3 >0 & household_mortality_4 == 1 & age_years_14 >= age_low_range1_4 & age_years_14 <= age_high_range1_4 & mortality4 == 1

replace died_in_2013 = 1 if duple3 >0 & household_mortality_4 == 1 & age_years_14 >= age_low_range2_4 & age_years_14 <= age_high_range2_4 & mortality4 == 1


merge 1:1 branchid hhid lino using "$data_clean\ind_w1_mortality.dta"
	tab mortality3
	
    forvalues i=2/3{
		tab _merge mortality`i'
	}
	keep if _merge==3
	drop _merge




save "$data_clean\ind_w4_mortality.dta" , replace

use "$base_dir\s1_Roster", clear

rename pull_bocd branchid

rename pull_spcd spotno

rename pull_hhno hhno 

gen treatment = (branchid<21)
gen subdistrict = 0
    forvalues k = 1/20 {
        replace subdistrict = `k' if branchid == `k' | branchid == `k' + 20
    }

	
gen died_before_w4 = (hhmc2_1y <2015)

gen died_after_w4 = (hhmc2_1y >2014 & hhmc2_1y !=. )


gen mortality = (hhmc1_p3==8)

areg died_after_w4 treatment, absorb(subdistrict) cluster(branchid)
areg died_after_w4  if memgen == "female", absorb(subdistrict) cluster(branchid)
areg died_after_w4 treatment  if memgen == "female", absorb(subdistrict) cluster(branchid)


areg died_before_w4 treatment, absorb(subdistrict) cluster(branchid)
areg died_before_w4 treatment  if memgen == "female", absorb(subdistrict) cluster(branchid)
areg died_before_w4 treatment  if memgen == "female", absorb(subdistrict) cluster(branchid)




areg mortality treatment, absorb(subdistrict) cluster(branchid)
areg mortality treatment  if memgen == "female", absorb(subdistrict) cluster(branchid)
areg mortality treatment  if memgen == "male", absorb(subdistrict) cluster(branchid)

merge 1:m branchid spotno hhno lino using "$base_dir\HHdata_complete_notselected_W1-4.dta" 

merge 1:m branchid spotno hhno using "$base_dir\HHdata_complete_notselected_W1-4.dta" 