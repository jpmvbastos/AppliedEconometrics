*** Matching Homework

cd "/Users/jpmvbastos/Documents/GitHub/AppliedEconometrics/Causal Inference/HW3_Matching/"

use nsw_dw.dta, clear

* 1 Compute the treatment effect (difference in RE78 between randomized treated and controls). 
* Explain what your result means.

bysort treat: sum re78

ttest re78, by(treat)

* Now DROP the experimental controls (260 obs where treated = 0) and add in the PSID controls in the dataset psid_controls.dta  
* (the variables should be exactly the same). You should have a dataset now with 185 treated and 2490 controls. 

drop if treat == 0

append using psid_controls.dta

tab treat // Check for 185 treated and 2490 controls


* 2 Run a regression of RE78 on treat and the other covariates in the dataset. What is your estimated treatment effect here?


reg re78 treat re75 re74 married nodegree hispanic education black age


* 3 Estimate a classic dif in dif. (before is RE75, after is RE78). What is your estimated treatment effect now?

* Before
bysort treat: sum re75

* After
bysort treat: sum re78


* 4. Using psmatch2, estimate propensity scores using the nearest neighbor and the treatment effect (restricted to the region of common support). 

*Explain what variables you chose and why. Use psgraph [bin(20) ] to show the distribution of the ps scores for the treated and controls. What is it telling you? 

*Use pstest to look for covariate balance. What do you find? If you do not achieve balance, go back to the functional form of your PS equation and modify until you do.  

* Once you have balance, compute the treatment effect on the treated (psmatch2 does this for you).

global controls "age age2 educ edu2 re74 re75 re74_2 re75_2 black hispanic married nodegree"

bootstrap r(att), r(250): psmatch2 treat $controls, out(re78) ai(1) common ate n(1) 
pstest $controls, both

psgraph, bin(20)

graph export psgraph.png, as(png) 


*5. Use ebalance to achieve covariate balance. Then run a weighted regression of RE78 on treat. 
* What is the estimated treatment effect now? Compare it to your answers from parts 1 and 2 above.

ebalance treat $controls 

svyset [pweight= _webal]
svy: reg re78 treat


* 6. Do a classic dif in dif using the weighted data and compare results to the discussion in question 5.

 bysort treat: tabstat re78 [aweight=_webal] 
 bysort treat: tabstat re78 [aweight=_webal] 
