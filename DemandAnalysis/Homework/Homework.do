*** HOMEWORK 3 ***

* QUESTION 1

import excel "/Users/joamacha/Library/CloudStorage/OneDrive-TexasTechUniversity/Personal/Projects/Code/GitHub/AppliedEconometrics/DemandAnalysis/Homework/data.xlsx", sheet("Sheet1") firstrow

* (a)
summarize p1 p2 p3 p4 p5
summarize q1 q2 q3 q4 q5

* (b)

forvalues i = 1/5 {
gen lnp`i' = log(p`i')
gen lnq`i' = log(q`i')
}

forvalues i = 1/5 {
	eststo: reg lnq`i' lnp1 lnp2 lnp3 lnp4 lnp5	
	test lnp`i' = -1
	}
esttab using "/Users/joamacha/Library/CloudStorage/OneDrive-TexasTechUniversity/Personal/Projects/Code/GitHub/AppliedEconometrics/DemandAnalysis/Homework/Table2.tex", se r2

*(c)

forvalues i = 1/5 {
gen exp`i' = p`i'*q`i'
}
gen exp = exp1 + exp2 + exp3 + exp4 + exp5


* Generate budget shares as well as data to estimate Rotterdam model
tsset week
forvalues i = 1/5 {
gen w`i' = exp`i'/exp
gen what`i' = 0.5*(w`i' + l.w`i')
gen dlnq`i' = log(q`i'/l.q`i')
gen dlnp`i' = log(p`i'/l.p`i')
gen y`i' = what`i'*dlnq`i'
}

* Linear expenditure model
nlsur (exp1 = {gamma1}*p1 + {beta1}*(exp - {gamma1}*p1 - {gamma2}*p2 - {gamma3}*p3 - {gamma4}*p4)) ///
	  (exp2 = {gamma2}*p2 + {beta2}*(exp - {gamma1}*p1 - {gamma2}*p2 - {gamma3}*p3 - {gamma4}*p4)) ///
	  (exp3 = {gamma3}*p3 + {beta3}*(exp - {gamma1}*p1 - {gamma2}*p2 - {gamma3}*p3 - {gamma4}*p4)) ///
	  (exp4 = {gamma4}*p4 + {beta4}*(exp - {gamma1}*p1 - {gamma2}*p2 - {gamma3}*p3 - {gamma4}*p4)) ///
	  (exp5 = {gamma5}*p5 + (1- {beta1} - {beta2} - {beta3} - {beta4})*(exp - {gamma1}*p1 - {gamma2}*p2 - {gamma3}*p3 - {gamma4}*p4 - {gamma5}*p5)), ifgnls

	  
matrix b = e(b)
matrix v_b = e(V)
scalar beta1 = b[1,2]
scalar se_beta1 = sqrt(v_b[2,2])
scalar beta2 = b[1,6]
scalar se_beta2 = sqrt(v_b[6,6])
scalar beta3 = b[1,7]
scalar se_beta3 = sqrt(v_b[7,7])
scalar beta4 = b[1,8] 
scalar se_beta4 = sqrt(v_b[8,8])
scalar gamma1 = b[1,1]
scalar se_gamma1 = v_b[1,1]
scalar gamma2 = b[1,3]
scalar se_gamma2 = v_b[3,3]
scalar gamma3 = b[1,4]
scalar se_gamma3 = v_b[4,4]
scalar gamma4 = b[1,5]
scalar se_gamma4 = v_b[5,5]
scalar gamma5 = b[1,9]
scalar se_gamma5 = v_b[]
scalar beta5 = 1 - b[1,2] - b[1,6] - b[1,7] -b[1,8]
scalar se_beta5 = sqrt(v_b[2,2] + v_b[6,6] + v_b[7,7] + v_b[8,8]- 2*v_b[2,6] - ///
				2*v_b[2,7] - 2*v_b[2,8] - 2*v_b[6,7] - 2*v_b[6,8] - 2*v_b[7,8])
				
* Expenditure elasticities
forvalues i = 1/5 {
sum w`i', meanonly
scalar wha`i' = r(mean)
sum p`i', meanonly
scalar phat`i' = r(mean)
sum exp, meanonly
scalar exphat = r(mean)
scalar eta`i' = beta`i'/wha`i'
scalar se_eta`i' = se_beta`i'/wha`i'
scalar t_stat_eta`i' = eta`i'/se_eta`i'
}

* Price elasticities
scalar phat_gamma = phat1*gamma1 + phat2*gamma2 + phat3*gamma3 + phat4*gamma4 + phat5*gamma5
forvalues i = 1/5 {
forvalues j = 1/5 {
if `i' == `j' {
scalar e`i'`j' = -eta`i'*(1-((phat_gamma - phat`i'*gamma`i')/exphat))
} 
else {
scalar e`i'`j' = -eta`i'*phat`j'*gamma`j'/exphat
}
}
}

matrix elastLES = ( e11, e12, e13, e14, e15 \ e21, e22, e23, e24, e25 \ e31, e32, e33, e34, e35 \ e41, e42, e43, e44, e45 \ e51, e52, e53, e54, e55 )

esttab matrix(elastLES) "/Users/joamacha/Library/CloudStorage/OneDrive-TexasTechUniversity/Personal/Projects/Code/GitHub/AppliedEconometrics/DemandAnalysis/Homework/Table3PriceElas.tex"
