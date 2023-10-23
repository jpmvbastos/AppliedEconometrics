* Import

import delimited "/Users/jpmvbastos/Documents/GitHub/AppliedEconometrics/Causal Inference/TermProject/Data/MainData.csv", clear 

gen treat = 0
replace treat = 2014 if host==1

egen avg_pop = mean(population), by(ibge_code)
gen main=0
replace main=1 if pop>100000

encode sigla, gen(uf)

gen gdppc = pibmunicipal/population
gen icms_pc = icms_transfers / population

drop aeroportodedestinonome ano aeroportodedestinouf private avg_pop

label var treat "Host cities == 2014"
label var bankbranches "Number of bank branches"
label var bankdeposits "Total bank deposits in local bank branches"
label var homiciderate "Homicide rate per 100,000"
label var icms_transfers "State sales tax transfers"
label var pibmunicipal "Municipal GDP"
label var savings "Total savings in local bank branches"
label var taxrevenue "Local tax revenue, excludes state & federal transfers"
label var population "Population"
label var ncountry_from "# of countries the city airport receive flight from (2008)"
label var nairports_from "# of airports the city receives flight from (2008)"
label var npassengers "# of passengers arriving at airport (2008)"
label var host "Host city indicator"
label var cand "Host city candidates"	
label var total "Total number of firms"
label var small "Total number of medium firms: < 20 employees"
label var medium "Total number of medium firms: 20-99 employees"
label var large "Total number of large firms: > 100 employees"
label var individual "Total number of self-employed people"
label var total_emp "Total number of employed people"
label var main "Indicator for cities with pop > 100,000"
label var icms_pc "State sales tax transfers per capita"
label var gdppc "Municipal GDP per capita"


foreach k in transportation accommodation retail construction { 
	label var `k' "Total number of firms in `k' sector"
	label var `k'_s "Total number of small firms in `k' sector"
	label var `k'_m "Total number of medium firms in `k' sector"
	label var `k'_l "Total number of large firms in `k' sector"
	label var `k'_indiv "Total number of self-employed people in sector `k'"
	label var `k'_emp "Total number of employees in sector `k'"
	
}


save "/Users/jpmvbastos/Documents/GitHub/AppliedEconometrics/Causal Inference/TermProject/Data/WorldCupYearly.dta", replace




* Clean Start Here

use "/Users/jpmvbastos/Documents/GitHub/AppliedEconometrics/Causal Inference/TermProject/Data/WorldCupYearly.dta", clear

local controls "icms_pc gdppc total_emp transportation accommodation retail construction cand npassengers nairports_from ncountry_from"

csdid total_emp gdppc total_emp homiciderate uf transportation accommodation retail  /// 
	construction pop cand if main==1, ivar(ibge_code) time(year) gvar(treat) ///
		wboot reps(250) cluster(uf)
csdid_plot, group(2014)


csdid retail_emp gdppc total_emp homiciderate uf transportation accommodation retail  /// 
	construction pop cand if main==1, ivar(ibge_code) time(year) gvar(treat) ///
		wboot reps(250) cluster(uf)
csdid_plot, group(2014)



* Monthly Data

import delimited "/Users/jpmvbastos/Documents/GitHub/AppliedEconometrics/Causal Inference/TermProject/Data/CagedData.csv", clear 

drop small medium large


label var period "Period: YYYYMM"
label var host "Host city indicator"
label var cand "Host city candidates"		
label var hired "Total number of opened jobs"
label var fired "Total number of closed jobs "
label var temp_hired "Number of temporary jobs opened"
label var temp_fired "Number of temporary jobs closed"
label var th_wages "Sum of wages for jobs opened"
label var tf_wages "Sum of wages for jobs closed"
label var th_hours "Sum of hired hours, jobs opened"
label var tf_hours "Sum of hired hours, jobs opened"
label var netjobs "Net change in jobs"
label var net_wages "Net change in total wages"
label var net_hours "Net change in total hired hours"
label var th_share "Share of temporary jobs in total jobs opened"
label var tf_share "Share of temporary jobs in total jobs closed"
label var net_tempjobs "Net change in temporary jobs"
label var net_tempwages "Net change in total wages from temporary jobs"
label var net_temphours "Net change in total hours from temporary jobs"
label var avg_hourly_wage_h "Avg. hourly wage in opened jobs"
label var avg_hourly_wage_f "Avg. hourly wage in closed jobs"


foreach k in small large { 
		gen `k'_netjobs = `k'_hired - `k'_fired
		gen `k'_net_wages = `k'_th_wages - `k'_tf_wages
		gen `k'_net_hours = `k'_th_hours - `k'_tf_hours
		label var `k'_hired "Total number of opened jobs, `k' firms"
		label var `k'_fired "Total number of closed jobs, `k' firms "
		label var `k'_temp_hired "Number of temporary jobs opened, `k' firms"
		label var `k'_temp_fired "Number of temporary jobs closed, `k' firms"
		label var `k'_th_wages "Sum of wages, jobs opened, `k' firms"
		label var `k'_tf_wages "Sum of wages, jobs closed, `k' firms"
		label var `k'_th_hours "Sum of hired hours, jobs opened, `k' firms"
		label var `k'_tf_hours "Sum of hired hours, jobs opened, `k' firms"
		label var `k'_netjobs "Net change in jobs, `k' firms"
		label var `k'_net_wages "Net change in total wages, `k' firms"
		label var `k'_net_hours "Net change in total hired hours, `k' firms"
	
}


foreach k in transportation accommodation retail construction {
		label var hired_`k' "Total number of opened jobs in `k'"
		label var fired_`k' "Total number of closed jobs in `k'"
		label var temp_hired_`k' "Number of temporary jobs opened in `k'"
		label var temp_fired_`k' "Number of temporary jobs closed in `k'"
		label var th_wages_`k' "Sum of wages, jobs opened in `k'"
		label var tf_wages_`k' "Sum of wages, jobs closed in `k'"
		label var th_hours_`k' "Sum of hired hours, jobs opened in `k'"
		label var tf_hours_`k' "Sum of hired hours, jobs opened in `k'"
		label var netjobs_`k' "Net change in jobs, sector `k'"
		label var net_wages_`k' "Net change in total wages, sector `k'"
		label var net_hours_`k' "Net change in total hired hours, sector `k'"
}


save "/Users/jpmvbastos/Documents/GitHub/AppliedEconometrics/Causal Inference/TermProject/Data/WorldCupMonthly.dta", replace
