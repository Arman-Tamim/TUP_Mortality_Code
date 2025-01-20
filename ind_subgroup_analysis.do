cls
clear
*set maxvar 25000

do "$base_dir\Directory_TUP_health"

use "$data_clean\balanced_panel_selected_individual", clear

local vars	illness com_illness	 non_com_illness
cap nois erase "$results\n_ind_ANCOVA_selected2.xls"
cap nois erase "$results\n_ind_ANCOVA_selected2.txt"
foreach x in `vars' {
    forvalues i=2/4 {
        areg `x'`i' treatment `x'1, absorb(subdistrict) cluster (branchid)
		sum `x'`i' if treatment == 0
		local control_mean=r(mean) 
        outreg2 using "$results\n_ind_ANCOVA_selected2.xls", keep(treatment) nocons nor2 addstat(Control Mean, `control_mean') append ctitle("`x'`i'") wide 
    }
}





***** Illness interfered
replace ill_income_days1 = 365 if ill_income_days1== 999

forvalues i=1/4{
    replace ill_income_days`i' = 0 if ill_income_days`i'==.
}

cap nois erase "$results\n_ind_ANCOVA_ill_income_days.xls"
cap nois erase "$results\n_ind_ANCOVA_ill_income_days.txt"

    forvalues i=2/4 {
        areg ill_income_days`i' treatment ill_income_days1 if C_sex==1 & age_years>35 & age_years <66, absorb(subdistrict) cluster (branchid)
		sum ill_income_days`i' if treatment == 0 & C_sex==1 & age_years>35 & age_years <66
		local control_mean=r(mean) 
        outreg2 using "$results\n_ind_ANCOVA_ill_income_days.xls", keep(treatment) nocons nor2 addstat(Control Mean, `control_mean') append ctitle("ill_income_days`i'") wide 
    }



cap nois erase "$results\n_ind_ANCOVA_ill_income_days_if_ill.xls"
cap nois erase "$results\n_ind_ANCOVA_ill_income_days_if_ill.txt"

    forvalues i=2/4 {
        areg ill_income_days`i' treatment ill_income_days1 if illness`i' ==1 & C_sex==1 & age_years>35 & age_years <66, absorb(subdistrict) cluster (branchid)
		sum ill_income_days`i' if treatment == 0 & illness`i' ==1 & C_sex==1 & age_years>35 & age_years <66
		local control_mean=r(mean) 
        outreg2 using "$results\n_ind_ANCOVA_ill_income_days_if_ill.xls", keep(treatment) nocons nor2 addstat(Control Mean, `control_mean') append ctitle("ill_income_days`i'") wide 
    }

	
	
	********Working Age Male treatment expense
	cap nois erase "$results\n_ind_ANCOVA_treat_expense_working_age.xls"
cap nois erase "$results\n_ind_ANCOVA_treat_expense_working_age.txt"
	
forvalues i=2/4{
    areg  treatment_expense`i' treatment  treatment_expense1 if illness`i' ==1 & C_sex==1 & age_years>35 & age_years <66, absorb(subdistrict) cluster (branchid)	
	sum treatment_expense`i' if treatment == 0 & illness`i' ==1 & C_sex==1 & age_years>35 & age_years <66
		local control_mean=r(mean) 
        outreg2 using "$results\n_ind_ANCOVA_treat_expense_working_age.xls", keep(treatment) nocons nor2 addstat(Control Mean, `control_mean') append ctitle("ill_income_days`i'") wide 
}	



	cap nois erase "$results\n_ind_ANCOVA_treat_expense_working_age_female.xls"
cap nois erase "$results\n_ind_ANCOVA_treat_expense_working_age_female.txt"
	
forvalues i=2/4{
    areg  treatment_expense`i' treatment  treatment_expense1 if illness`i' ==1 & C_sex==2 & age_years>35 & age_years <66, absorb(subdistrict) cluster (branchid)	
	sum treatment_expense`i' if treatment == 0 & illness`i' ==1 & C_sex==2 & age_years>35 & age_years <66
		local control_mean=r(mean) 
        outreg2 using "$results\n_ind_ANCOVA_treat_expense_working_age_female.xls", keep(treatment) nocons nor2 addstat(Control Mean, `control_mean') append ctitle("ill_income_days`i'") wide 
}	


****************Attrition adjusted 
merge m:1 hhid using "$data_clean\attrition"
keep if _merge ==3
drop _merge
local vars	illness com_illness	 non_com_illness
cap nois erase "$results\n_ind_ANCOVA_selected_att2.xls"
cap nois erase  "$results\n_ind_ANCOVA_selected_att2.txt"
foreach x in `vars' {
    forvalues i=2/4 {
        areg `x'`i' treatment `x'1 [pweight=att_weight], absorb(subdistrict) cluster (branchid)
		sum `x'`i' if treatment == 0
		local control_mean=r(mean) 
        outreg2 using  "$results\n_ind_ANCOVA_selected_att2.xls", keep(treatment) nocons nor2 addstat(Control Mean, `control_mean') append ctitle("`x'`i'") wide 
    }
}







*******************Sub-sample based on non-communicable illness

local vars	illness com_illness	
cap nois erase "$results\n_ind_ANCOVA_selected_hetero2.xls"
cap nois erase "$results\n_ind_ANCOVA_selected_hetero2.txt"

forvalues i=2/4 {
   foreach x in `vars' {
    forvalues j=0/1 {
			areg `x'`i' treatment  if non_com_illness1 ==`j' , absorb(subdistrict) cluster (branchid)
			sum `x'`i' if treatment == 0 & `x'1 ==`j'
			local control_mean=r(mean) 
			outreg2 using "$results\n_ind_ANCOVA_selected_hetero2.xls", keep(treatment) nocons nor2 addstat(Control Mean, `control_mean') 		append ctitle("`x'`i'_`j'") wide 
		}
    }
}


forvalues i=2/4 {
    forvalues j=0/1 {
			areg non_com_illness`i' treatment  if non_com_illness1 ==`j' , absorb(subdistrict) cluster (branchid)
			sum non_com_illness`i' if treatment == 0
			local control_mean=r(mean) 
			outreg2 using "$results\n_ind_ANCOVA_selected_hetero2.xls", keep(treatment) nocons nor2 addstat(Control Mean, `control_mean') 		append ctitle("non_com_illness`i'_`j'") wide 
		}
    }

	




cap nois erase "$results\n_ind_ANCOVA_selected_seeking.xls"
cap nois erase "$results\n_ind_ANCOVA_selected_seeking.txt"
    forvalues i=2/4 {
        areg treatment_seeking`i' treatment treatment_seeking1, absorb(subdistrict) cluster (branchid)
		sum treatment_seeking`i' if treatment == 0
		local control_mean=r(mean) 
        outreg2 using "$results\n_ind_ANCOVA_selected_seeking.xls", keep(treatment) nocons nor2 addstat(Control Mean, `control_mean') append ctitle("treatment_seeking`i'") wide 
}

cap nois erase "$results\n_ind_ANCOVA_selected_expense.xls"
cap nois erase "$results\n_ind_ANCOVA_selected_expense.txt"
    forvalues i=2/4 {
        areg treatment_expense`i' treatment treatment_expense1, absorb(subdistrict) cluster (branchid)
		sum treatment_expense`i' if treatment == 0
		local control_mean=r(mean) 
        outreg2 using "$results\n_ind_ANCOVA_selected_expense.xls", keep(treatment) nocons nor2 addstat(Control Mean, `control_mean') append ctitle("treatment_expense`i'") wide 
}


local subgroups age_group1 age_group2 age_group3 age_group4 age_group5  male female male_age_group2 male_age_group3 male_age_group4 male_age_group5 female_age_group1 female_age_group2 female_age_group3 female_age_group4 female_age_group5 male_age_group1 

local a = 1
foreach subgroup in `subgroups' {
    preserve
    keep if sub_sample_`a' == 1

    // Dynamic file naming
    local xls_file "$results\subsample\selected\selected_ind_`subgroup'.xls"
    local txt_file "$results\subsample\selected\selected_ind_`subgroup'.txt"

    // Erase existing files
    cap nois erase "`xls_file'"
    cap nois erase "`txt_file'"

    local vars illness com_illness non_com_illness

    foreach x in `vars' {
        forvalues i = 2/4 {
            areg `x'`i' treatment `x'1 , absorb(subdistrict) cluster(branchid)

            sum `x'`i' if treatment == 0
            local control_mean = r(mean)
            outreg2 using "`xls_file'", keep(treatment) nocons nor2 addstat(Control_Mean, `control_mean') append ctitle("`x'`i'") wide
        }
    }

    restore
    local a = `a' + 1
}





/*local subgroup $results\subsample\selected\selected_ind_age_group1 $results\subsample\selected\selected_ind_age_group2 $results\subsample\selected\selected_ind_age_group3 $results\subsample\selected\selected_ind_age_group4 $results\subsample\selected\selected_ind_age_group5 $results\subsample\selected\selected_ind_female $results\subsample\selected\selected_ind_male $results\subsample\selected\selected_ind_female_age_group1 $results\subsample\selected\selected_ind_female_age_group2 $results\subsample\selected\selected_ind_female_age_group3 $results\subsample\selected\selected_ind_female_age_group4 $results\subsample\selected\selected_ind_female_age_group5 $results\subsample\selected\selected_ind_male_age_group1 $results\subsample\selected\selected_ind_male_age_group2 $results\subsample\selected\selected_ind_male_age_group3 $results\subsample\selected\selected_ind_male_age_group4 $results\subsample\selected\selected_ind_male_age_group5


local a = 1 

foreach y in `subgroup'{
    preserve
    keep if sub_sample_`a' == 1
	/*if `j' == `a' local name "`xl_name'`j'"
	if `j' == `a' local txt "`txt_name'`j'" */
	local vars      illness com_illness      non_com_illness
 
 cap nois erase "`y'.xls"
 
 cap nois erase "`y'.txt"
 
 foreach x in `vars' {
           forvalues i=2/4 {
                 reg `x'`i' treatment `x'1 i.subdistrict, vce(cluster branchid)
                   
                 sum `x'`i' if treatment == 0
                 local control_mean=r(mean) 
                 outreg2 using "`y'.xls", keep(treatment) nocons nor2 addstat(Control Mean, `control_mean') append ctitle("`x'`i'") wide 
				 
				
       }
   }
	
	             restore
				 local a = `a'+1
} 
*/
