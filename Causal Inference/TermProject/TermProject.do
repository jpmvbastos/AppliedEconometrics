* Import

import delimited "/Users/jpmvbastos/Documents/GitHub/AppliedEconometrics/Causal Inference/TermProject/Data/MainData.csv", clear 

bysort ibge_code: gen obs = _N
drop if obs<10

gen treat = 0
replace treat = 2014 if host==1

egen avg_pop = mean(population), by(ibge_code)
gen main=0
replace main=1 if pop>100000

encode sigla, gen(uf)

gen gdppc = pibmunicipal/population
gen icms_pc = icms_transfers / population

local controls "icms_pc gdppc total_emp transportation accommodation retail construction cand npassengers nairports_from ncountry_from"

csdid total_emp gdppc total_emp homiciderate uf transportation accommodation retail  /// 
	construction pop cand if main==1, ivar(ibge_code) time(year) gvar(treat) ///
		wboot reps(250) cluster(uf)
csdid_plot, group(2014)


csdid retail_emp gdppc total_emp homiciderate uf transportation accommodation retail  /// 
	construction pop cand if main==1, ivar(ibge_code) time(year) gvar(treat) ///
		wboot reps(250) cluster(uf)
csdid_plot, group(2014)
