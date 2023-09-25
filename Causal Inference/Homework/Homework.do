**** Homework 1 - Causal Inference ****

* Data
use "/Users/jpmvbastos/Library/CloudStorage/OneDrive-TexasTechUniversity/Fall 2023/Causal Inference/Homework/cardkrueger1994.dta"

* New Variables
gen byte treat = 1 if treated==1
replace treat = 0 if treated==0

gen byte did = t*treat

* Regressions

* 1 
reg fte t treat did

/* 2 (requires ssc install boottest)
*/
set seed 1

reg fte t treat did, cluster(treat) /* what level of cluster should I use?*/
boottest t, weight(webb)
boottest treat, weight(webb)
boottest did, weight(webb)

* 3
bysort treated: sum fte if t==0
bysort treated: sum fte if t==1

* 4 

eststo clear

eststo: reg fte t treat did if bk==1
eststo: reg fte t treat did if kfc==1
eststo: reg fte t treat did if roys==1
eststo: reg fte t treat did if wendys==1

esttab using "/Users/jpmvbastos/Library/CloudStorage/OneDrive-TexasTechUniversity/Fall 2023/Causal Inference/Homework/ResultsbyChain.tex", replace star(* 0.10 ** 0.05 *** 0.01) se r2 
