cls
clear
*set maxvar 25000

do "$base_dir\Directory_TUP_health"


* For Individual level ANCOVA

use "$base_dir\W4_Indiv_finalselected.dta", clear

rename lino_w4 lino

foreach i in 9 11 14 18{
	keep if split`i' == 0
}
*label list ill_type

clonevar followup_status_4 = followup_status


gen illness4 = 0

forvalues i=1/3{
    replace illness4 = 1 if  ill_type`i' != .
}





gen com_illness4 =  0



*drop com_illness4
forvalues i= 1/3{
    replace com_illness4 = 1 if inlist(ill_type`i', 1, 4, 5, 16, 17, 19, 20, 25, 33, 34, 39, 48, 68, 70, 73, 79, 98, 6, 15, 67, 26)
	
}



gen non_com_illness4 = 0
replace non_com_illness4 = 1 if illness4 ==1 & com_illness4 ==0

gen treatment_seeking4 = 0
replace treatment_seeking4 =1 if inlist(ill_treatment, 2,3,4,5,6,10)
replace treatment_seeking4=. if ill_treatment==.


egen treatment_expense4 = rowtotal(treat_expense_visit treat_expense_medic treat_expense_trans)

replace treatment_expense4=. if treat_expense_visit==. & treat_expense_medic==. & treat_expense_trans==.

sort branchid hhid lino

gen treatment = 1 if branchid <21
replace treatment = 0 if branchid >20


rename  ill_income_days ill_income_days4
save "$data_clean\ind_w4", replace

use "$base_dir\W3_Indiv_finalselected.dta", clear

clonevar followup_status_3 = followup_status

rename lino_w3 lino

foreach i in 9 11 14 18{
	keep if split`i' == 0
}
*label list ill_type

recode C_sex (0 = 2) (1=1) 


gen illness3 = 0

forvalues i=1/2{
    replace illness3 = 1 if  ill_type`i' != .
}


gen com_illness3 =  0





*drop com_illness4
forvalues i= 1/2{
    replace com_illness3 = 1 if inlist(ill_type`i', 1, 4, 5, 16, 17, 19, 20, 25, 33, 34, 39, 48, 68, 70, 73, 79, 98, 6, 15, 67, 26)
	
}



gen non_com_illness3 = 0
replace non_com_illness3 = 1 if illness3 ==1 & com_illness3 ==0


gen treatment_seeking3 = 0
replace treatment_seeking3 =1 if inlist(ill_treatment, 2,3,4,5,6,10)
replace treatment_seeking3=. if ill_treatment==.

egen treatment_expense3 = rowtotal(treat_expense_visit treat_expense_medic treat_expense_trans)

replace treatment_expense3=. if treat_expense_visit==. & treat_expense_medic==. & treat_expense_trans==.


sort branchid hhid lino

gen treatment = 1 if branchid <21
replace treatment = 0 if branchid >20


rename  ill_income_days ill_income_days3

save "$data_clean\ind_w3", replace



use "$base_dir\W2_Indiv_finalselected.dta", clear


clonevar followup_status_2 = followup_status


rename lino_w2 lino

bys  hhid: gen total_male = sum(C_sex)

gen female=(C_sex==0)

bys  hhid: gen total_female = sum(female)



foreach i in 9 11 14 18{
	keep if split`i' == 0
}
*label list ill_type

recode C_sex (0 = 2) (1=1) 

gen illness2 = 0

forvalues i=1/2{
    replace illness2 = 1 if  ill_type`i' != .
}





gen com_illness2 =  0




*drop com_illness4
forvalues i= 1/2{
    replace com_illness2 = 1 if inlist(ill_type`i', 1, 4, 5, 16, 17, 19, 20, 25, 33, 34, 39, 48, 68, 70, 73, 79, 98, 6, 15, 67, 26)
	
}



gen non_com_illness2 = 0
replace non_com_illness2 = 1 if illness2 ==1 & com_illness2 ==0


gen treatment_seeking2 = 0
replace treatment_seeking2 =1 if inlist(ill_treatment, 2,3,4,5,6,10)
replace treatment_seeking2=. if ill_treatment==.

egen treatment_expense2 = rowtotal(treat_expense_visit treat_expense_medic treat_expense_trans)

replace treatment_expense2=. if treat_expense_visit==. & treat_expense_medic==. & treat_expense_trans==.



sort branchid hhid lino
gen treatment = 1 if branchid <21
replace treatment = 0 if branchid >20

rename  ill_income_days ill_income_days2

save "$data_clean\ind_w2", replace

use "$base_dir\W1_Indiv_finalselected.dta", clear

rename lino_w1 lino

foreach i in 9 11 14 18{
	keep if split`i' == 0
}
*label list ill_type
gen treatment = 1 if branchid <21
replace treatment = 0 if branchid >20

gen illness1 = 0

forvalues i=1/2{
    replace illness1 = 1 if  ill_type`i' != .
}





gen com_illness1 =  0



*drop com_illness4
forvalues i= 1/2{
    replace com_illness1 = 1 if inlist(ill_type`i', 1, 4, 5, 16, 17, 19, 20, 25, 33, 34, 39, 48, 68, 70, 73, 79, 98, 6, 15, 67, 26)
}



gen non_com_illness1 = 0
replace non_com_illness1 = 1 if illness1 ==1 & com_illness1 ==0

gen treatment_seeking1 = 0
replace treatment_seeking1 =1 if inlist(ill_treatment, 2,3,4,5,6,10)
*replace treatment_seeking1=. if ill_treatment==.

egen treatment_expense1 = rowtotal(treat_expense_visit treat_expense_medic treat_expense_trans)

*replace treatment_expense1=. if treat_expense_visit==. & treat_expense_medic==. & treat_expense_trans==.

rename  ill_income_days ill_income_days1


gen age = age_years
save "$data_clean\ind_w1_unbalanced",replace

sort branchid hhid lino

merge 1:1 branchid hhid lino using "$data_clean\ind_w2"

keep if _merge ==3
drop _merge

merge 1:1 branchid hhid lino using "$data_clean\ind_w3"
keep if _merge ==3
drop _merge

merge 1:1 branchid hhid lino using "$data_clean\ind_w4"
keep if _merge ==3
drop _merge





gen subdistrict=0
forvalues i = 1/20{
	replace subdistrict= `i' if branchid== `i' | branchid== `i' + 20
         }




**********************sub sample***************************
*******Variable for sub group**********
 
********age

gen age_group = 0
replace age_group =1 if age_months !=0 & age_months !=.
replace age_group= 2 if age_years >= 5 & age_years <= 15
replace age_group= 3 if age_years > 15 & age_years <= 35 
replace age_group= 4 if age_years > 35 & age_years <= 55
replace age_group= 5 if age_years > 55

***********gender

gen male= C_sex 


************For running all the regression in a loop *******
forvalues i=1/5{
	gen sub_sample_`i' = 1 if age_group ==`i'
	replace sub_sample_`i' = 0 if sub_sample_`i' ==.
}

local j = 6
forvalues i = 1/2 {
	gen sub_sample_`j' = 1 if  male == `i'
	replace sub_sample_`j' = 0 if sub_sample_`j'==.
	local j = `j' + 1
}	


gen sub_sample_8 = 1 if age_group == 1 & male == 1
gen sub_sample_9 = 1 if age_group == 2 & male == 1
gen sub_sample_10 = 1 if age_group == 3 & male == 1
gen sub_sample_11 = 1 if age_group == 4 & male == 1
gen sub_sample_12 = 1 if age_group == 5 & male == 1
gen sub_sample_13 = 1 if age_group == 1 & male == 2
gen sub_sample_14 = 1 if age_group == 2 & male == 2
gen sub_sample_15 = 1 if age_group == 3 & male == 2
gen sub_sample_16 = 1 if age_group == 4 & male == 2
gen sub_sample_17 = 1 if age_group == 5 & male == 2

save "$data_clean\balanced_panel_selected_individual", replace




* After adjusting illness remain same (it should be), effect on communicable increases, non_com decreases
save "$data_clean\ind_w1", replace

/*use "$base_dir\stup_3wave_panel_for_analysis_withAttriters", clear

use "$base_dir\Indiv_panel_N", clear


foreach i in 9 11 14 18{
	keep if split`i' == 0
}


keep  branchid id_spot id_hhno hhid lino survey_wave
reshape wide branchid id_spot id_hhno , i(hhid lino) j(survey_wave)



/*use "$base_dir\W3_Indiv_finalselected.dta", clear

global w1  "$base_dir\W1_Indiv_finalselected.dta"
global w2  "$base_dir\W2_Indiv_finalselected.dta"
global w3  "$base_dir\W3_Indiv_finalselected.dta"
global w4  "$base_dir\W4_Indiv_finalselected.dta"



forvalues i=1/3{
    foreach y of global w`i' {
    use `y', clear
	gen ill_type3 =0
}

local h = 1
foreach y of global w`h' {
    use `y', clear
	
	


forvalues i=1/3{
    replace illness`h' = 1 if  ill_type`i' != .
}


gen com_illness`h' =  0

foreach i= 1/3{
    replace com_illness`h' = 1 if inlist (ill_type`i', 1, 4, 5, 16, 17, 19, 20, 25, 33, 34, 39, 48,68, 70, 73, 79, 98 )
}

gen non_com_illness`h' = 0
replace non_com_illness`h' = 1 if illness`h' = 1 & com_illness`h' = 0


sort branchid hhid lino

save , replace 

local `h' = `h' + 1
}
	

