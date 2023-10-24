**** Homework 1 - Causal Inference ****

* Data
use "/Users/jpmvbastos/Library/CloudStorage/OneDrive-TexasTechUniversity/Fall 2023/Causal Inference/Homework/CardKrueger1994.dta", clear

* New Variables
gen byte treat = 1 if treated==1
replace treat = 0 if treated==0

gen byte did = t*treat

gen rest = ""
foreach i in bk kfc roys wendys {
	replace rest = "`i'" if `i'==1
}
encode rest, gen(chain)

* Regressions

* 1 
reg fte t treat did

/* 2 (requires ssc install boottest)
*/
set seed 777

reg fte t treat did, cluster(chain) 
boottest t, weight(webb)
boottest treat, weight(webb)
boottest did, weight(webb)

* 3
* Means for PA and NJ before treatment 
bysort treated: sum fte if t==0
* Means for PA and NJ after treatment
bysort treated: sum fte if t==1

* 4 

eststo clear

eststo: reg fte t treat did if bk==1
eststo: reg fte t treat did if kfc==1
eststo: reg fte t treat did if roys==1
eststo: reg fte t treat did if wendys==1

esttab using "/Users/jpmvbastos/Library/CloudStorage/OneDrive-TexasTechUniversity/Fall 2023/Causal Inference/Homework/ResultsbyChain.tex", replace star(* 0.10 ** 0.05 *** 0.01) se r2 

* Get percentage of BK relative to the whole sample
tab chain 


