*** Matching Homework

use "/Users/jpmvbastos/Documents/GitHub/AppliedEconometrics/Causal Inference/HW3_Matching/nsw_dw.dta", clear

* 1 Compute the treatment effect (difference in RE78 between randomized treated and controls). Explain what your result means.

bysort treat: sum re78

ttest re78, by(treat)

* Now DROP the experimental controls (260 obs where treated = 0) and add in the PSID controls in the dataset psid_controls.dta  
* (the variables should be exactly the same). You should have a dataset now with 185 treated and 2490 controls. 

drop if treat == 0

append using "/Users/jpmvbastos/Documents/GitHub/AppliedEconometrics/Causal Inference/HW3_Matching/psid_controls.dta"

tab treat // Check for 185 treated and 2490 controls


* 2 Run a regression of RE78 on treat and the other covariates in the dataset. What is your estimated treatment effect here?


reg re78 treat re75 re74 married nodegree hispanic education black age


* 3 Estimate a classic dif in dif. (before is RE75, after is RE78). What is your estimated treatment effect now?

reg re78 treat re75 treat
