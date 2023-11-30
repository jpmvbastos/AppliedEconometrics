* Using Entropy Balancing

cd "/Users/jpmvbastos/Documents/GitHub/AppliedEconometrics/Causal Inference/TermProject/"

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





