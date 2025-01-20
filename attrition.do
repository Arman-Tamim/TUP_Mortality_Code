cls
clear
*set maxvar 25000

do "$base_dir\Directory_TUP_health"


use "$base_dir\stup_3wave_panel_for_analysis_withAttriters.dta" , clear

gen chronic_illness = 1 if H_chronic_type1_1 !=.
replace chronic_illness = 0 if chronic_illness ==.

foreach x in H_chronic_illnessD H_chronic_type1_1 H_chronic_type2_1 H_chronic_type3_1{
	replace `x' = . if chronic_illness ==0
}





keep if survey_wave  == 1

bys branchid spotno hhno: gen family_size = _N




bys branchid spotno hhno: gen total_male = sum(C_sex)

bys branchid spotno hhno: gen total_female = sum(female)

gen male_female_ratio = total_male/total_female




sort branchid spotno  hhno survey_wave 
keep branchid spotno hhno lino chronic_illness C_sex H_chronic_illnessD H_chronic_type1_1 H_chronic_type2_1 H_chronic_type3_1 head_gender headD kartik H_kartik food_kartik educ_years_head resp_age resp_NGO_none resp_educ_years potential_migrate_no selfemp_hr_tot M_selfemp_hr_tot selfemp_inc_tot M_selfemp_inc_tot wage_inc_per_hr M_wage_inc_per_hr head_main_femaleD head_age head_married head_muslim head_out_home Lland_own_cult_value land_own_pond_value land_own_rent_value land_own_other_value wealth savings_total loan_total_value unable_to_work unemployed hstead_owned hstead_value crisisD_1 food_affordD H_child_birthD family_size male_female_ratio total_male total_female

keep if headD==1





save "$data_clean\baseline_head_demo_from_panel", replace

use "$data_clean\hhdata_w1", clear

drop if reason_uns !=.
rename head_lino lino

egen hh_basset = rowtotal(pass_value1 pass_value2 pass_value3 pass_value4 pass_value5 pass_value6 pass_value7 pass_value8 pass_value9 pass_value10 pass_value11 pass_value12 pass_value13 pass_value14 pass_value15 pass_value16 pass_value17 pass_value18)


*land

egen hh_land = rowtotal (land_own_pond_value land_own_mort_value land_own_rent_value land_own_other_value land_own_share_value land_own_cult_value)

* Non business asset

egen hh_nbasset = rowtotal (nba_value1 nba_value2 nba_value3 nba_value4 nba_value5 nba_value6 nba_value7 nba_value8 nba_value9 nba_value10 nba_value11 nba_value12 nba_value13 nba_value14 nba_value15)

* Asset

gen hh_asset = hh_basset + hh_land + hh_nbasset


* savings
egen hh_savings=rowtotal( save_home save_bank save_brac save_NGO save_guard)

*loan received

egen loan_received = rowtotal (loan_value1 loan_value2 loan_value3 loan_value4 loan_value5)
gen dummy_loan_received =.
replace dummy_loan_received=1 if loan_received >0
replace dummy_loan_received=0 if dummy_loan_received==.

*loan provided

egen loan_provided = rowtotal (loan_lend_value1 loan_lend_value2 loan_lend_value3 loan_lend_value4 loan_lend_value5)

gen dummy_loan_provided =.
replace dummy_loan_provided=1 if loan_provided >0
replace dummy_loan_provided=0 if dummy_loan_provided ==.

gen lvstk_hr=0
gen lvst_days =0
gen lvst_income =0
forvalues i = 1/7{
	    replace lvstk_hr = ba_days`i'*ba_hours_per_day`i' if ba_type`i'==  "Livestock Husbandry"
	}
	
forvalues i = 1/7{
	    replace lvst_days = ba_days`i' if ba_type`i'==  "Livestock Husbandry"
	}	
	
forvalues i = 1/7{
	    replace lvst_income = ba_income`i' if ba_type`i'==  "Livestock Husbandry"
	}	
/*forvalues i = 1/7{
	    encode ba_type`i', gen(ba_type`i'_n)
	}	
*/
gen casual_land_hr =0

gen casual_land_days =0
gen casual_land_income =0
forvalues i = 1/7{
	    replace  casual_land_hr= ba_days`i'*ba_hours_per_day`i' if ba_type`i'== "Laborer on Someone Else's Land (agri day labor)" | ba_type`i'== "Household Land cultivation"
	}
	
forvalues i = 1/7{
	    replace  casual_land_days= ba_days`i' if ba_type`i'== "Laborer on Someone Else's Land (agri day labor)" | ba_type`i'== "Household Land cultivation"
	}
forvalues i = 1/7{
	    replace casual_land_income = ba_income`i' if ba_type`i'==  "Livestock Husbandry"
	}	
gen casual_maid_hr =0
gen casual_maid_days =0
gen casual_maid_income =0
forvalues i = 1/7{
	    replace  casual_maid_hr = ba_days`i'*ba_hours_per_day`i' if ba_type`i'== "Maid/Servant" | ba_type`i'=="Maid/Servant/Chef"
	}

	
forvalues i = 1/7{
	    replace  casual_maid_days = ba_days`i' if ba_type`i'== "Maid/Servant" | ba_type`i'=="Maid/Servant/Chef"
	}	
	
forvalues i = 1/7{
	    replace casual_maid_income = ba_income`i' if ba_type`i'==  "Livestock Husbandry"
	}	
summarize casual_maid_hr if survey_wave==1

egen total_income = rowtotal(ba_income1 ba_income2 ba_income3 ba_income4 ba_income5 ba_income6 ba_income7)


forvalues i = 1/7{
	    gen hours`i' =0
		replace hours`i' = ba_days`i'*ba_hours_per_day`i' if ba_type`i'!= "Unable to work / not looking for work / Retired" | ba_type`i'!= "Student"
	}	

egen total_hours = rowtotal (hours1 hours2 hours3 hours4 hours5 hours6 hours7)


egen hours = rowtotal (lvstk_hr casual_maid_hr casual_land_hr )


capture drop chronic_illness C_sex H_chronic_illnessD H_chronic_type1_1 H_chronic_type2_1 H_chronic_type3_1 head_gender headD kartik H_kartik food_kartik educ_years_head resp_age resp_NGO_none resp_educ_years potential_migrate_no selfemp_hr_tot M_selfemp_hr_tot selfemp_inc_tot M_selfemp_inc_tot wage_inc_per_hr M_wage_inc_per_hr head_main_femaleD head_age head_married head_muslim head_out_home Lland_own_cult_value land_own_pond_value land_own_rent_value land_own_other_value wealth savings_total loan_total_value unable_to_work unemployed hstead_owned hstead_value crisisD_1 food_affordD H_child_birthD



merge 1:1  branchid spotno hhno lino using "$data_clean\baseline_head_demo_from_panel"


drop if _merge == 2
rename _merge _merge1

save "$data_clean\baseline_head_demo", replace


use "$base_dir\HHdata_complete_finalselected_W1-5 (2)", clear
keep if survey_wave==4
foreach i in 9 11 14 18{
	keep if split`i' == 0
}

drop if reason_uns !=.

keep hhid

merge 1:1 hhid using "$data_clean\baseline_head_demo"


gen attrition = 0

replace attrition = 1 if _merge==2

gen treatment =(branchid<21)

gen subdistrict=0
forvalues i = 1/20{
	replace subdistrict= `i' if branchid== `i' | branchid== `i' + 20
         }
		 
reg attrition treatment, cluster(branchid)

replace M_wage_inc_per_hr = 0 if M_wage_inc_per_hr ==.

replace wage_inc_per_hr = 0 if wage_inc_per_hr ==.

******Control variables

global attrition_vars head_gender educ_years_head resp_educ_years  head_age head_muslim hstead_owned food_affordD  hh_asset hh_savings loan_received  family_size total_female total_male  head_married


*****generating interactioin terms
foreach x of global attrition_vars{
    gen interaction_`x' = treatment * `x'
}

global interaction_attrition_vars interaction_head_gender interaction_educ_years_head  interaction_resp_educ_years  interaction_head_age  interaction_head_muslim   interaction_hstead_owned  interaction_food_affordD  interaction_hh_asset interaction_hh_savings interaction_loan_received  interaction_family_size interaction_total_male interaction_total_female interaction_head_married  


******cap nois erase will find these files and erase them. It works like replace (save , replace. or "outreg2 using "$results\hh_attrition_1.xls" ,  keep(treatment) addtext(Control Variable, "No", Interaction, "No" ) nocons nor2 replace" ). It is more convenient while running multiple regression in a loop. 

cap nois erase "$results\hh_attrition_1.xls"

cap nois erase "$results\hh_attrition_1.txt"

areg attrition treatment ,absorb(subdistrict) cluster(branchid)

*xi: reg attrition treatment interaction_hh_asset i.subdistrict, cluster(branchid)

outreg2 using "$results\hh_attrition_1.xls" ,  keep(treatment) addtext(Control Variable, "No", Interaction, "No" ) nocons nor2

areg attrition treatment $interaction_attrition_vars $attrition_vars  , absorb(subdistrict) cluster(branchid)


test treatment $interaction_attrition_vars

scalar f_stat = r(F)

local f_test_result: di %6.3fc (r(F))
local star = cond(r(p)< 0.01 , "***" , cond(r(p)< 0.05 , "**", cond(r(p)< 0.10 , "*", "")))
di "`star'"
local fteststars  "`f_test_result'`star'"
di "`fteststars'"
outreg2 using "$results\hh_attrition_1.xls" ,  keep(treatment) addtext(F statistic, `fteststars', Control Variable, "Yes", Interaction, "Yes" ) nocons nor2 append


 /******* Now if we only want to know the f-stat or any other stat and not the significance level we could have write below the 
 "scalar f_stat = r(F)"  line


 outreg2 using "$results\hh_attrition_1.xls" ,  keep(treatment) addstat(F statistic, f_stat) addtext(Control Variable, "Yes", Interaction, "Yes" ) nocons nor2 append
 
 nocons - will not report constant
 nor2 - will not report R-squared
 keep(variable of interest)
 
 FYI you can add any stat usning the addstat command, for example
 
 sum treatment if treatment == 0
 local control_mean = r(mean)

 and then the in the outreg command use addstat( Control mean, `control_mean')

*/

outreg2 using "$results\hh_attrition_all variable.xls" ,  nocons nor2 append



predict attrition_hat
gen att_weight = 1/(1-attrition_hat)
keep hhid att_weight attrition_hat
save "$data_clean\attrition", replace

*capture ssc install texdoc

global model "reg areg"

local cntrol1 ""
local control2 "${interaction_attrition_vars} ${attrition_vars}"

local cluster1 ", cluster(branchid)"
local cluster2 ",absorb(subdistrict) cluster(branchid)"

local i = 1
foreach x in $model{
		`x' attrition treatment `control`i'' `cluster`i''
		global beta_`i' : di %6.3fc _b[treatment]
		global se_`i' : di %6.3fc _se[treatment]
		global se_`i' : di  ustrtrim("$se_`i'")
		qui test treatment = 0
		global treatment_p_`i' : di %12.2fc (r(p))
		global star`i' = cond(r(p)< 0.01 , "***" , cond(r(p)< 0.05 , "**", cond(r(p)< 0.10 , "*", "")))
		local N = e(N)
		global N_`i' : di %12.0fc `N'
		scalar r2 = e(r2)
		global r2_`i' : di %6.3fc r2
		local i = `i' + 1
}

test treatment $interaction_attrition_vars

scalar f_stat = r(F)

global f_test_result_2 : di %6.3fc f_stat 

global f_stat_star_2 = cond(r(p)< 0.01 , "***" , cond(r(p)< 0.05 , "**", cond(r(p)< 0.10 , "*", "")))


texdoc init "C:\Users\user\Dropbox\Apps\Overleaf\Test case\attrition.tex", replace force
tex Treatment & ${beta_1}${star1} & 
tex ${beta_2}${star2} \\ 
tex  & (${se_1}) & 
tex (${se_2}) \\  \addlinespace
tex Control Variable & No & Yes \\
tex Interaction & No & Yes \\
tex Joint F statistic & ~ & ${f_test_result_2}${f_stat_star_2} \\
tex Observations & $N_1 & $N_2
texdoc close



/*local f_test1 ""
local f_test2 "test treatment $interaction_attrition_vars"

local F_stat1 ""
local F_stat2 "scalar f_sta = r(F)"

local f_test_result1 ""
local f_test_result2 " global f_test_result_`i' : di %6.3fc f_sta "

local f_test_pval1 ""
local f_test_pval2 " scalar treatment_f_`i' = r(p) "

local f_stat_star1 ""
local f_stat_star2 "global f_stat_star_`i' = cond(r(p)< 0.01 , "***" , cond(r(p)< 0.05 , "**", cond(r(p)< 0.10 , "*", "")))"


*global star2 = cond(< 0.01 , "***" , cond(${treatment_p_`i'}< 0.05 , "**", cond(${treatment_p_`i'}< 0.10 , "*", "")))
*/


