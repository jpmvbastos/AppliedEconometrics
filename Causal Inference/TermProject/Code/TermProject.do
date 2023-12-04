* Packages

net from http://personalpages.manchester.ac.uk/staff/mark.lunt
pbalchk

ssc install ebalance




* Import

cd "/Users/jpmvbastos/Documents/GitHub/AppliedEconometrics/Causal Inference/TermProject/"

import delimited "Data/MainData.csv", clear 

gen treat = 0
replace treat = 2014 if host==1

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
	gen share_`k' = `k' / total
	gen share_`k'_emp = `k'_emp / total_emp
	label var share_`k' "Share of firms in sector `k'"
	label var share_`k'_emp "Share of employees in sector `k'"
	label var `k' "Total number of firms in `k' sector"
	label var `k'_s "Total number of small firms in `k' sector"
	label var `k'_m "Total number of medium firms in `k' sector"
	label var `k'_l "Total number of large firms in `k' sector"
	label var `k'_indiv "Total number of self-employed people in sector `k'"
	label var `k'_emp "Total number of employees in sector `k'"
	
}


save "Data/WorldCupYearly.dta", replace


* Clean Start Here

use "Data/WorldCupYearly.dta", clear


gen p100k = 0 
gen p200k = 0

egen avg_pop = mean(population), by(ibge_code)

replace p100k=1 if avg_pop > 100000
replace p200k=1 if avg_pop > 200000

foreach v in netjobs netjobs_transportation netjobs_accommodation netjobs_retail netjobs_construction {
	
	replace `v' = `v' / (population/10000)
	
}

global outcomes "share_transportation_emp share_accommodation_emp share_retail_emp share_construction_emp"
global outcomes "share_transportation share_transportation_emp share_accommodation share_accommodation_emp share_retail share_retail_emp share_construction share_construction_emp"
global controls "gdppc"


ebalance host gdppc $outcomes if p100k==1 & year==2013, ///
generate(ebal100k) maxiter(50) target(1 2 2 2 2 2 1 2 2) tolerance(0.681)

ebalance host gdppc $outcomes if p200k==1 & year==2014, ///
generate(ebal200k) maxiter(50) target(2) 

* extend ebalance weight constant for the whole 

egen ebal100kc = total(ebal100k), by(ibge_code)
egen ebal200kc = total(ebal200k), by(ibge_code)

replace ebal100kc = . if ebal100kc == 0
replace ebal200kc = . if ebal200kc == 0


* Main results 
foreach v in  $outcomes {

csdid `v' $controls if main==1, ivar(ibge_code) time(year) gvar(treat) ///
		wboot reps(250) cluster(uf) rseed(1)
csdid_plot, group(2014)

graph export "Plots/`v'.png", as(png) name("Graph")

}

global controls "gdppc homiciderate pop cand total total_emp"


* Main results (alternative controls)
foreach v in  $outcomes {

csdid `v' `v' $controls if main==1, ivar(ibge_code) time(year) gvar(treat) ///
		wboot reps(250) cluster(uf) rseed(1)
csdid_plot, group(2014)

graph export "Plots/`v'_lags.png", as(png) name("Graph")

}



* Results in Shares

global outcomes "transportation accommodation retail construction"

foreach v in $outcomes{ 
	
csdid share_`v' if ebal100kc!=. [iweight=ebal100kc], ivar(ibge_code) time(year) gvar(treat) ///
		wboot reps(250) cluster(uf) rseed(1) reg

csdid_plot, group(2014) xtitle("Years from World Cup") ///
	ytitle("ATT: Share of firms in the `v' sector")
	graph export "Plots/Entropy/share_`v'_100k.png", as(png) name("Graph") replace

csdid share_`v'_emp if ebal100kc!=. [iweight=ebal100kc], ivar(ibge_code) time(year) gvar(treat) ///
		wboot reps(250) cluster(uf) rseed(1) reg

csdid_plot, group(2014) xtitle("Years from World Cup") ///
	ytitle("ATT: Share of employees in `v' sector")
	graph export "Plots/Entropy/share_`v'_emp_100k.png", as(png) name("Graph") replace
}

global shares "share_transportation share_transportation_emp share_accommodation share_accommodation_emp share_retail share_retail_emp share_construction share_construction_emp"
global controls "gdppc homiciderate uf pop cand"

foreach v in  $shares {

csdid `v' `v' $controls if main==1, ivar(ibge_code) time(year) gvar(treat) ///
		wboot reps(250) cluster(uf) rseed(1)
csdid_plot, group(2014)

graph export "Plots/Shares/`v'.png", as(png) name("Graph")

}


csdid total total $controls if main==1, ivar(ibge_code) time(year) gvar(treat) ///
		wboot reps(250) cluster(uf) rseed(1) saverif(est_details)
csdid_plot, group(2014)



foreach v in  $outcomes {

csdid `v' $controls if main==1, ivar(ibge_code) time(year) gvar(treat) ///
		wboot reps(250) cluster(uf) rseed(1)
csdid_plot, group(2014)

graph export "Plots/`v'.png", as(png) name("Graph")

}


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
	
		label var netjobs_`k' "Net change in jobs in sector `k', per 10,000 population"
		label var net_hours_`k' "Net change in hired hours in sector `k', per 10,000 population"
		}
		


foreach k in transportation accommodation retail construction {
	
		gen wage_`k' = th_wages_`k' / th_hours_`k'
		label var wage_`k' "Average hourly rate in sector `k'"
			
		}
		
gen avg_wage = net_wages / net_hours
gen avg_wage_t = net_tempwages / net_temphours

gen avg_wage_f = tf_wages / tf_hours
gen avg_wage_h = th_wages / th_hours

save "Data/WorldCupMonthly.dta", replace

import excel "Data/munic_data_monthly.xlsx", firstrow clear
save "Data/munic_data_monthly.dta", replace

use "Data/WorldCupMonthly.dta", clear
merge m:1 ibge_code using "Data/munic_data_monthly.dta"
drop _merge

encode sigla, gen(uf)

egen time = group(period)

gen year = 2013 if time <=12
replace year = 2014 if time > 12

egen avg_pop = mean(population), by(ibge_code)
gen main=0
replace main=1 if pop>100000

gen treat = 0 
replace treat = 18 if host==1

gen gdppc = pibmunicipal/population

save "Data/WorldCupMonthly.dta", replace


use "Data/WorldCupMonthly.dta", clear

/* Main results 
global outcomes "netjobs net_wages net_hours net_tempjobs net_tempwages net_temphours avg_wage avg_wage_t"
global outcomes2 "avg_wage_h avg_wage_f temp_hired temp_fired th_wages tf_wages th_hours tf_hours"
global controls "gdppc pop uf"
 

foreach v in  $outcomes2 {

csdid `v' `v' $controls if main==1, ivar(ibge_code) time(time) gvar(treat) ///
		wboot reps(250) cluster(uf) rseed(1)
csdid_plot, group(18)

graph export "Plots/CAGED/`v'.png", as(png) name("Graph") replace

}*/

* Using Entropy Balancing

cd "/Users/jpmvbastos/Documents/GitHub/AppliedEconometrics/Causal Inference/TermProject/"

use "Data/WorldCupMonthly.dta", clear

drop if period==.

gen p100k = 0 
gen p200k = 0
gen p250k = 0
gen p500k = 0

replace p100k=1 if avg_pop > 100000
replace p200k=1 if avg_pop > 200000
replace p250k=1 if avg_pop > 250000
replace p500k=1 if avg_pop > 500000

global outcomes "netjobs netjobs_transportation netjobs_accommodation netjobs_retail netjobs_construction"
global hours = "net_hours net_hours_transportation net_hours_accommodation net_hours_retail net_hours_construction"


foreach v in $outcomes $outcomes {
	
	replace `v' = `v' / (population/10000)
	
}

ebalance host $outcomes $hours gdppc if p100k==1 & period==201405, ///
generate(ebal100k) maxiter(50) target(1 2 2 2 2 1 2 2 2 2 2) 

foreach v in gdppc $outcomes $hours {
	label var `v' ""
}

pbalchk host gdppc $outcomes $hours if period==201405 & p100k==1, wt(ebal100k) p graph

graph export "Plots/CAGED/Entropy/Balance_100k.png"

* Table for Sum Stats

bysort host: sum gdppc $outcomes $hours if period==201405 & p100k==1 [aweight=ebal100k]


ebalance host $outcomes $hours gdppc if p100k==1 & period==201405, ///
generate(ebal200k) maxiter(50) target(2) 

ebalance host gdppc $outcomes if p500k==1 & period==201405, ///
generate(ebal500k) maxiter(50) target(1) 

* extend ebalance weight constant for the whole 

egen ebal100kc = total(ebal100k), by(ibge_code)
egen ebal200kc = total(ebal200k), by(ibge_code)
egen ebal500kc = total(ebal500k), by(ibge_code)

replace ebal100kc = . if ebal100kc == 0
replace ebal200kc = . if ebal200kc == 0
replace ebal500kc = . if ebal500kc == 0

log using "Logs/EntropyMonth_NetJobsHours_100k.smcl", replace

* Main Results

foreach v in $outcomes{ 

csdid `v' if ebal100kc!=. [iweight=ebal100kc], ivar(ibge_code) time(time) gvar(treat) ///
		wboot reps(250) cluster(uf) rseed(1) reg

csdid_plot, group(18) xtitle("Periods from World Cup") ///
	ytitle("ATT: Net Change in Jobs per 10,000 people")
	
graph export "Plots/CAGED/Entropy/`v'_100k.png", as(png) name("Graph") replace
	

/*csdid `v' if ebal200kc!=. [iweight=ebal200kc], ivar(ibge_code) time(time) gvar(treat) ///
		wboot reps(250) cluster(uf) rseed(1) reg

csdid_plot, group(18) xtitle("Periods from World Cup") ///
	ytitle("ATT: Net Change in Jobs per 10,000 people")
	
graph export "Plots/CAGED/Entropy/`v'_200k.png", as(png) name("Graph") replace
*/	
}

foreach v in $hours{ 

csdid `v' if ebal100kc!=. [iweight=ebal100kc], ivar(ibge_code) time(time) gvar(treat) ///
		wboot reps(250) cluster(uf) rseed(1) reg

csdid_plot, group(18) xtitle("Periods from World Cup") ///
	ytitle("ATT: Net Change in Hired Hours per 10,000 people")
	
graph export "Plots/CAGED/Entropy/`v'_100k.png", as(png) name("Graph") replace
	
}

log close
/*
foreach v in $outcomes{ 

csdid `v' if ebal500kc!=. [iweight=ebal500kc], ivar(ibge_code) time(time) gvar(treat) ///
		wboot reps(250) cluster(uf) rseed(1) reg

csdid_plot, group(18) xtitle("Periods from World Cup") ///
	ytitle("ATT: Net Change in Jobs per 10,000 people")
	
graph export "Plots/CAGED/Entropy/`v'_500k.png", as(png) name("Graph") replace
	
}
*/

