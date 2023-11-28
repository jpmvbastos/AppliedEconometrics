* Using Entropy Balancing

cd "/Users/jpmvbastos/Documents/GitHub/AppliedEconometrics/Causal Inference/TermProject/"

use "Data/WorldCupMonthly.dta", clear

drop if period==.

drop if period<201306

keep avg_wage avg_wage_t netjobs net_wages net_hours net_tempjobs ///
net_tempwages net_temphours avg_wage avg_wage_t /// 
netjobs netjobs_transportation netjobs_accommodation ///
netjobs_retail netjobs_construction gdppc taxrevenue population ///
ibge_code município host cand period


reshape wide avg_wage avg_wage_t ///
netjobs net_wages net_hours net_tempjobs net_tempwages net_temphours /// 
netjobs_transportation netjobs_accommodation ///
netjobs_retail netjobs_construction ///
gdppc taxrevenue population, i(ibge_code município host cand)  j(period) 

gen pop_13 = population201306 
gen pop_14 = population201401

gen pop_100k = 0
replace pop_100k = 1 if pop_14 > 100000

gen pop_200k = 0 
replace pop_200k = 1 if pop_14 > 200000

bysort host: sum pop_14 if pop_200k ==1

gen gdppc_13 = gdppc201312 
gen gdppc_14 = gdppc201401

drop gdppc2* population*


foreach v in netjobs201306 netjobs201307 netjobs201308 netjobs201309 netjobs201310 netjobs201311 netjobs201312 {
	replace `v' = `v' / (pop_13  / 10000)
}

foreach v in netjobs201401 netjobs201402 netjobs201403 netjobs201404 netjobs201405 netjobs201406 netjobs201407 netjobs201408 netjobs201409 netjobs201410 netjobs201411 netjobs201412 {
	
	replace `v' = `v' / (pop_14 /10000)
}



ebalance host gdppc_13 netjobs2013* netjobs201401 netjobs201402 /// 
netjobs201403 netjobs201404 if pop_100k==1, ///
generate(ebal100k) maxiter(50) target(1) 

ebalance host gdppc_14 netjobs2013* netjobs201401 netjobs201402 ///
netjobs201403 netjobs201404 netjobs201405 if pop_200k==1, ///
generate(ebal200k) maxiter(50) target(1)


svyset [pweight= ebal100k]
svy: reg netjobs201406 host
svy: reg netjobs201407 host

svyset [pweight= ebal200k]
svy: reg netjobs201406 host
svy: reg netjobs201407 host


**** USING PANEL STRUCTURE

use "Data/WorldCupMonthly.dta", clear

drop if period==.

gen p100k = 0 
gen p200k = 0

replace p100k=1 if avg_pop > 100000
replace p200k=1 if avg_pop > 200000

foreach v in netjobs netjobs_transportation netjobs_accommodation netjobs_retail netjobs_construction {
	
	replace `v' = `v' / (population/10000)
	
}

gen post = 0
replace post = 1 if period > 201405


global outcomes "netjobs netjobs_transportation netjobs_accommodation netjobs_retail netjobs_construction"


ebalance host gdppc $outcomes if p100k==1 & period==201405, ///
generate(ebal100k) maxiter(50) target(2) 

ebalance host gdppc $outcomes if p200k==1 & period==201405, ///
generate(ebal200k) maxiter(50) target(2) 

* extend ebalance weight constant for the whole 

egen ebal100kc = total(ebal100k), by(ibge_code)
egen ebal200kc = total(ebal200k), by(ibge_code)

replace ebal100kc = . if ebal100kc == 0
replace ebal200kc = . if ebal200kc == 0

gen rel_time = time - 18




foreach v in vars{ 

csdid netjobs if ebal200kc!=. [iweight=ebal200kc], ivar(ibge_code) time(time) gvar(treat) ///
		wboot reps(250) cluster(uf) rseed(1) reg

csdid_plot, group(18) xtitle("Periods from World Cup") ///
	ytitle("ATT: Net Change in Jobs per 10,000 people")
	
}




eventdd netjobs i.uf [aw=ebal100k], ols timevar(rel_time) ci(rcap) cluster(uf) ///
	ci_op(color(black)) coef_op(msymbol(S) color(black)) noline ///
	graph_op(xtitle("Periods since the World Cup") ///
	ytitle("Average Treatment Effect") ///
	title("Figure 1: The effect of World Cup on Jobs") ///
	xlabel(-18(1)6, nogrid) ///
	xline(-1, lcolor(gs8) lpattern(dash)) ///
	legend(off) name(netjobs, replace)) 





