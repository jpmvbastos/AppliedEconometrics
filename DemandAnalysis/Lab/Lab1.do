clear all
import excel "E:\Demand\labdata_2023.xls", sheet("Sheet1") firstrow

* To be able to use lags
gen t = _n
tsset t

* Generate product expenditures
forvalues i = 1/4 {
gen exp`i' = p`i'*q`i'
}
* Generate total expenditure
gen exp = exp1 + exp2 + exp3 + exp4
gen lnexp = log(exp)
gen dlnexp = log(exp/l.exp)

* Generate budget shares as well as data to estimate Rotterdam model
forvalues i = 1/4 {
gen w`i' = exp`i'/exp
gen what`i' = 0.5*(w`i' + l.w`i')
gen lnp`i' = log(p`i')
gen lnq`i' = log(q`i')
gen dlnq`i' = log(q`i'/l.q`i')
gen dlnp`i' = log(p`i'/l.p`i')
gen y`i' = what`i'*dlnq`i'
}
gen dlogX = dlnexp - what1*dlnp1 - what2*dlnp2 - what3*dlnp3 - what4*dlnp4

* Linear expenditure model
nlsur (exp1 = {gamma1}*p1 + {beta1}*(exp - {gamma1}*p1 - {gamma2}*p2 - {gamma3}*p3 - {gamma4}*p4)) ///
	  (exp2 = {gamma2}*p2 + {beta2}*(exp - {gamma1}*p1 - {gamma2}*p2 - {gamma3}*p3 - {gamma4}*p4)) ///
	  (exp3 = {gamma3}*p3 + {beta3}*(exp - {gamma1}*p1 - {gamma2}*p2 - {gamma3}*p3 - {gamma4}*p4)) ///
	  (exp4 = {gamma4}*p4 + {beta4}*(exp - {gamma1}*p1 - {gamma2}*p2 - {gamma3}*p3 - {gamma4}*p4))
	  (exp5 = {gamma5}*p5 + (1- {beta1} - {beta2} - {beta3} - {beta4})*(exp - {gamma1}*p1 - {gamma2}*p2 - {gamma3}*p3 - {gamma4}*p4 - {gamma5}*p5)), ifgnls

matrix b = e(b)
matrix v_b = e(V)
scalar beta1 = b[1,2]
scalar se_beta1 = sqrt(v_b[2,2])
scalar beta2 = b[1,6]
scalar se_beta2 = sqrt(v_b[6,6])
scalar beta3 = b[1,7]
scalar se_beta3 = sqrt(v_b[7,7])
scalar beta4 = 1 - b[1,2] - b[1,6] - b[1,7]
scalar se_beta4 = sqrt(v_b[2,2] + v_b[6,6] + v_b[7,7] - 2*v_b[2,6] - 2*v_b[2,7] - 2*v_b[6,7])
scalar gamma1 = b[1,1]
scalar se_gamma1 = v_b[1,1]
scalar gamma2 = b[1,3]
scalar se_gamma2 = v_b[3,3]
scalar gamma3 = b[1,4]
scalar se_gamma3 = v_b[4,4]
scalar gamma4 = b[1,5]
scalar se_gamma4 = v_b[5,5]


* Expenditure elasticities
forvalues i = 1/4 {
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
scalar phat_gamma = phat1*gamma1 + phat2*gamma2 + phat3*gamma3 + phat4*gamma4
forvalues i = 1/4 {
forvalues j = 1/4 {
if `i' == `j' {
scalar e`i'`j' = -eta`i'*(1-((phat_gamma - phat`i'*gamma`i')/exphat))
} 
else {
scalar e`i'`j' = -eta`i'*phat`j'*gamma`j'/exphat
}
}
}

* Rotterdam model
nlsur (y1 = {a1}*dlogX + {g11}*dlnp1 + {g12}*dlnp2 + {g13}*dlnp3 + {g14}*dlnp4) ///
	  (y2 = {a2}*dlogX + {g12}*dlnp1 + {g22}*dlnp2 + {g23}*dlnp3 + {g24}*dlnp4) ///
	  (y3 = {a3}*dlogX + {g31}*dlnp1 + {g32}*dlnp2 + {g33}*dlnp3 + {g34}*dlnp4) ///
	  (y4 = {a4}*dlogX + {g41}*dlnp1 + {g42}*dlnp2 + {g43}*dlnp3 + {g44}*dlnp4), ifgnls

	  
program nlsurAIDS
	version 14
	syntax varlist(min=8 max=8) if, at(name)
	tokenize `varlist'
	args w1 w2 w3 lnp1 lnp2 lnp3 lnp4 lnexp 
	tempname a1 a2 a3 a4
	scalar `a1' = `at'[1,1]
	scalar `a2' = `at'[1,2]
	scalar `a3' = `at'[1,3]
	scalar `a4' = 1 - `a1' - `a2' - `a3' 
	tempname b1 b2 b3
	scalar `b1' = `at'[1,4]
	scalar `b2' = `at'[1,5]
	scalar `b3' = `at'[1,6]
	tempname g11 g12 g13 g14
	tempname g21 g22 g23 g24
	tempname g31 g32 g33 g34
	tempname g41 g42 g43 g44
	scalar `g11' = `at'[1,7]
	scalar `g12' = `at'[1,8]
	scalar `g13' = `at'[1,9]
	scalar `g14' = -`g11'-`g12'-`g13'
	scalar `g21' = `g12'
	scalar `g22' = `at'[1,10]
	scalar `g23' = `at'[1,11]
	scalar `g24' = -`g21'-`g22'-`g23'
	scalar `g31' = `g13'
	scalar `g32' = `g23'
	scalar `g33' = `at'[1,12]
	scalar `g34' = -`g31'-`g32'-`g33'
	scalar `g41' = `g14'
	scalar `g42' = `g24'
	scalar `g43' = `g34'
	scalar `g44' = -`g41'-`g42'-`g43'
	quietly {
		tempvar lnpindex
		gen double `lnpindex' = 5 + `a1'*`lnp1' + `a2'*`lnp2' + ///
		`a3'*`lnp3' + `a4'*`lnp4'
	forvalues i = 1/4 {
		forvalues j = 1/4 {
			replace `lnpindex' = `lnpindex' + ///
				0.5*`g`i'`j''*`lnp`i''*`lnp`j''
		}
	}
	replace `w1' = `a1' + `g11'*`lnp1' + `g12'*`lnp2' + ///
			`g13'*`lnp3' + `g14'*`lnp4' + ///
			`b1'*(`lnexp' - `lnpindex')
	replace `w2' = `a2' + `g21'*`lnp1' + `g22'*`lnp2' + ///
			`g23'*`lnp3' + `g24'*`lnp4' + ///
			`b2'*(`lnexp' - `lnpindex')
	replace `w3' = `a3' + `g31'*`lnp1' + `g32'*`lnp2' + ///
			`g33'*`lnp3' + `g34'*`lnp4' + ///
			`b3'*(`lnexp' - `lnpindex')
}
end

nlsur AIDS @ w1 w2 w3 lnp1 lnp2 lnp3 lnp4 exp, parameters(a1 a2 a3 b1 b2 b3 ///
g11 g12 g13 g22 g32 g33) neq(3) ifgnls
