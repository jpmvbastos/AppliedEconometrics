* Import

import delimited "/Users/jpmvbastos/Documents/GitHub/AppliedEconometrics/Causal Inference/TermProject/Data/MainData.csv", clear 

gen treat = 0
replace treat = 2014 if host==1

encode sigla, gen(uf)

gen gdppc = pibmunicipal/population
gen icms_pc = icms_transfers / population

local controls "icms_pc gdppc total_emp transportation accommodation retail construction cand npassengers nairports_from ncountry_from"

csdid total_emp `controls', ivar(ibge_code) time(year) gvar(treat) wboot reps(250) cluster(uf)
