*** HOMEWORK 3 ***

* QUESTION 1

import excel "/Users/joamacha/Library/CloudStorage/OneDrive-TexasTechUniversity/Personal/Projects/Code/GitHub/AppliedEconometrics/DemandAnalysis/Homework/data.xlsx", sheet("Sheet1") firstrow

* (a)
summarize p1 p2 p3 p4 p5
summarize q1 q2 q3 q4 q5

* (b)

forvalues i = 1/5 {
*gen exp`i' = p`i'*q`i'
*gen lnp`i' = log(p`i')
*gen lnq`i' = log(q`i')
gen lnexp`i' = log(p`i'*q`i')
}
forvalues i = 1/5 {

}
gen exp = exp1 + exp2 + exp3 + exp4 + exp5
gen lnexp = log(exp)


forvalues i = 1/5 {
	eststo: reg lnq`i' lnp1 lnp2 lnp3 lnp4 lnp5	lnexp
	test lnp`i' = -1
	}
esttab using "/Users/joamacha/Library/CloudStorage/OneDrive-TexasTechUniversity/Personal/Projects/Code/GitHub/AppliedEconometrics/DemandAnalysis/Homework/Table2.tex", replace se r2

eststo clear

forvalues i = 1/5 {
	eststo: reg lnq`i' lnp1 lnp2 lnp3 lnp4 lnp5	lnexp	
	}
esttab using "/Users/joamacha/Library/CloudStorage/OneDrive-TexasTechUniversity/Personal/Projects/Code/GitHub/AppliedEconometrics/DemandAnalysis/Homework/Table22.tex", replace se r2

*(c)
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
nlsur (exp1 = {gamma1}*p1 + {beta1}*(exp - {gamma1}*p1 - {gamma2}*p2 - {gamma3}*p3 - {gamma4}*p4 - (1-{gamma1}-{gamma2}-{gamma3}-{gamma4})*p5)) ///
	  (exp2 = {gamma2}*p2 + {beta2}*(exp - {gamma1}*p1 - {gamma2}*p2 - {gamma3}*p3 - {gamma4}*p4 - (1-{gamma1}-{gamma2}-{gamma3}-{gamma4})*p5)) ///
	  (exp3 = {gamma3}*p3 + {beta3}*(exp - {gamma1}*p1 - {gamma2}*p2 - {gamma3}*p3 - {gamma4}*p4 - (1-{gamma1}-{gamma2}-{gamma3}-{gamma4})*p5)) ///
	  (exp4 = {gamma4}*p4 + {beta4}*(exp - {gamma1}*p1 - {gamma2}*p2 - {gamma3}*p3 - {gamma4}*p4 - (1-{gamma1}-{gamma2}-{gamma3}-{gamma4})*p5)) ///
	  (exp5 = (1-{gamma1}-{gamma2}-{gamma3}-{gamma4})*p5 + (1- {beta1} - {beta2} - {beta3} - {beta4})*(exp ///
	  - {gamma1}*p1 - {gamma2}*p2 - {gamma3}*p3 - {gamma4}*p4 - (1-{gamma1}-{gamma2}-{gamma3}-{gamma4})*p5)),ifgnls
	  
matrix b = e(b)
matrix v_b = e(V)

nlcom (b5: 1 - [beta1]_cons - [beta2]_cons - [beta3]_cons - [beta4]_cons) (gamma5: 1 - [gamma1]_cons - [gamma2]_cons - [gamma3]_cons - [gamma4]_cons)
matrix bLES = r(b)
matrix VLES = r(V)

scalar beta1 = b[1,2]
scalar se_beta1 = sqrt(v_b[2,2])
scalar beta2 = b[1,6]
scalar se_beta2 = sqrt(v_b[6,6])
scalar beta3 = b[1,7]
scalar se_beta3 = sqrt(v_b[7,7])
scalar beta4 = b[1,8] 
scalar se_beta4 = sqrt(v_b[8,8])
scalar beta5 = bLES[1,1]
scalar se_beta5 = sqrt(VLES[1,1])
scalar gamma1 = b[1,1]
scalar se_gamma1 = v_b[1,1]
scalar gamma2 = b[1,3]
scalar se_gamma2 = v_b[3,3]
scalar gamma3 = b[1,4]
scalar se_gamma3 = v_b[4,4]
scalar gamma4 = b[1,5]
scalar se_gamma4 = v_b[5,5]
scalar gamma5 = bLES[1,2]
scalar se_gamma5 = sqrt(VLES[2,2])
				
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
matrix expLES = (eta1, eta2, eta3, eta4, eta5 \ se_eta1, se_eta2, se_eta3, se_eta4, se_eta5)

gen dlnexp = log(exp/l.exp)
gen dlogX = dlnexp - what1*dlnp1 - what2*dlnp2 - what3*dlnp3 - what4*dlnp4 - what5*dlnp5

* Rotterdam model
nlsur (y1 = {a1}*dlogX + {g11}*dlnp1 + {g12}*dlnp2 + {g13}*dlnp3 + {g14}*dlnp4 + (1-{g11}-{g12}-{g13}-{g14})*dlnp5) ///
	  (y2 = {a2}*dlogX + {g21}*dlnp1 + {g22}*dlnp2 + {g23}*dlnp3 + {g24}*dlnp4 + (1-{g21}-{g22}-{g23}-{g24})*dlnp5) ///
	  (y3 = {a3}*dlogX + {g31}*dlnp1 + {g32}*dlnp2 + {g33}*dlnp3 + {g34}*dlnp4 + (1-{g31}-{g32}-{g33}-{g34})*dlnp5) ///
	  (y4 = {a4}*dlogX + {g41}*dlnp1 + {g42}*dlnp2 + {g43}*dlnp3 + {g44}*dlnp4 + (1-{g41}-{g42}-{g43}-{g44})*dlnp5) ///
	  (y5 = (1-{a1}-{a2}-{a3}-{a4})*dlogX + (1-{g11}-{g21}-{g31}-{g41})*dlnp1 + (1-{g12}-{g22}-{g32}-{g42})*dlnp2 ///
	  + (1-{g13}-{g23}-{g33}-{g43})*dlnp3 + (1-{g14}-{g24}-{g34}-{g44})*dlnp4 + ///
	  (1-(1-{g11}-{g12}-{g13}-{g14})-(1-{g21}-{g22}-{g23}-{g24})-(1-{g31}-{g32}-{g33}-{g34})-(1-{g41}-{g42}-{g43}-{g44}))*dlnp5), ifgnls
	  
matrix bR = e(b)
matrix v_bR = e(V)

* Recover coefficients
	  
nlcom (g15: 1-[g11]_cons-[g12]_cons-[g13]_cons-[g14]_cons) ///
	  (g25: 1-[g21]_cons-[g22]_cons-[g23]_cons-[g24]_cons) ///
	  (g35: 1-[g31]_cons-[g32]_cons-[g33]_cons-[g34]_cons) ///
	  (g45: 1-[g41]_cons-[g42]_cons-[g43]_cons-[g44]_cons)

matrix gi5R = r(b)
matrix Vgi5R = r(V)
matrix list gi5R 

nlcom (g51: 1-[g11]_cons-[g21]_cons-[g31]_cons-[g41]_cons) (g52: 1-[g12]_cons-[g22]_cons-[g32]_cons-[g42]_cons) (g53: 1-[g13]_cons-[g23]_cons-[g33]_cons-[g43]_cons) (g54: 1-[g14]_cons-[g24]_cons-[g34]_cons-[g44]_cons) (g55: 1-(1-[g11]_cons-[g12]_cons-[g13]_cons-[g14]_cons)-(1-[g21]_cons-[g22]_cons-[g23]_cons-[g24]_cons) -(1-[g31]_cons-[g32]_cons-[g33]_cons-[g34]_cons)-(1-[g41]_cons-[g42]_cons-[g43]_cons-[g44]_cons))
	  
matrix g5iR = r(b)
matrix se5i5R = r(V)
matrix list g5iR 

*Alphas 
scalar a1 = bR[1,1]
scalar se_a1 = v_bR[1,1]
scalar a2 = bR[1,6]
scalar se_a2 = v_bR[6,6]
scalar a3 = bR[1,11]
scalar se_a3 = v_bR[11,11]
scalar a4 = bR[1,16]
scalar se_a4 = v_bR[16,16]
nlcom a5: 1 - [a1]_cons - [a2]_cons - [a3]_cons - [a4]_cons
matrix a5 = r(b)
matrix se_a5 = r(V)
scalar a5 = a5[1,1]
scalar se_a5 = sqrt(se_a5[1,1])

* Gammas
forvalues i = 1/4 {
scalar ga1`i' = bR[1,`i'+1]
scalar se_g1`i' = sqrt(v_bR[`i'+1,`i'+1])
scalar ga2`i' = bR[1,`i'+6]
scalar se_g2`i' = sqrt(v_bR[`i'+6,`i'+6])
scalar ga3`i' = bR[1,`i'+11]
scalar se_g3`i' = sqrt(v_bR[`i'+11,`i'+11])
scalar ga4`i' = bR[1,`i'+16]
scalar se_g4`i' = sqrt(v_bR[`i'+16,`i'+16])
scalar ga5`i' = g5iR[1,`i']
scalar se_g5`i' = sqrt(se5i5R[`i',`i'])
scalar ga`i'5 = gi5R[1,`i']
scalar se_g`i'5 = sqrt(Vgi5R[`i',`i']) 
}
scalar ga55 = g5iR[1,5]
scalar se_g55 =se5i5R[5,5]

* Expenditure elasticities
forvalues i = 1/5 {
sum what`i', meanonly
scalar whatR`i' = r(mean)
sum lnexp`i' , meanonly
scalar lnexphat`i' = r(mean)
scalar Reta`i' = a`i'/whatR`i'
scalar se_Reta`i' = se_a`i'/whatR`i'
scalar t_stat_Reta`i' = Reta`i'/se_Reta`i'
}

matrix expR = (Reta1, Reta2, Reta3, Reta4, Reta5 \ se_Reta1, se_Reta2, se_Reta3, se_Reta4, se_Reta5)
matrix list expR

* Price elasticities
forvalues i = 1/5 {
forvalues j = 1/5 {
if `i' == `j' {
scalar eR`i'`i' = ga`i'`i' - Reta`i'*whatR`i'
} 
else {
scalar eR`i'`j' = ga`i'`j'-Reta`i'*whatR`j'
}
}
}

matrix elastR = ( eR11, eR12, eR13, eR14, eR15 \ eR21, eR22, eR23, eR24, eR25 \ eR31, eR32, eR33, eR34, eR35 \ eR41, eR42, eR43, eR44, eR45 \ eR51, eR52, eR53, eR54, eR55 )
matrix list elastR


* AIDS MODELS

global price p1 p2 p3 p4 p5 
global lprice lnp1 lnp2 lnp3 lnp4 lnp5 
global quantity q1 q2 q3 q4 q5 
gen lnexp = log(exp)

* (e) Full Aids
quaids w1 w2 w3 w4 w5, anot(0) prices(p1 p2 p3 p4 p5) expenditure(exp) noquadratic nolog
estat expenditure, atmeans
matrix aidsexp = r(expelas)
estat uncompensated, atmeans
matrix aidsun = r(uncompelas)
estat compensated, atmeans
matrix aidscomp = r(compelas)

* (f) Quadratic aids

quaids w1 w2 w3 w4 w5, anot(0) prices(p1 p2 p3 p4 p5) expenditure(exp) nolog
estat expenditure, atmeans
matrix quaidsexp = r(expelas)
estat uncompensated, atmeans
matrix quaidsun = r(uncompelas)


* QUESTION 3

foreach v of varlist Qcereals Qmeat Qfish Qmilk Qvegetables Qoils Expcereals Texpmeat Texpfish Texpmilk Texpvegetables Texpoils{
gen censored = 1 if `v'==.
replace `v'= 0 if `v'==.
}

gen Texp = Expcereals + Texpmeat +Texpfish +Texpmilk +Texpvegetables +Texpoils 

gen wcereal = Expcereals/Texp
gen wmeats = Texpmeat / Texp
gen wfish = Texpfish/Texp
gen wmilk = Texpmilk/Texp 
gen wveg = Texpvegetables / Texp
gen woils = Texpoils / Texp

* (a)
quaids wcereal wmeats wfish wmilk wveg woils , anot(0) prices(pricecereals pricemeat pricef pricemilk pvegetables priceoils) expenditure(Texp) nolog noquadratic
estat expenditure, atmeans
matrix ceaidsexp = r(expelas)
estat uncompensated, atmeans
matrix ceaidsun = r(uncompelas)

* (b)

foreach v of varlist Qcereals Qmeat Qfish Qmilk Qvegetables Qoils pricecereals pricemeat pricef pricemilk pvegetables priceoils Texp {
gen ln`v'= log(`v')	
}


eststo clear
foreach v of varlist lnQcereals lnQmeat lnQfish lnQmilk lnQvegetables lnQoils {
eststo: tobit `v' lnpricecereals lnpricemeat lnpricef lnpricemilk lnpvegetables lnpriceoils lnTexp, ll(0.001)
}
esttab using "/Users/joamacha/Library/CloudStorage/OneDrive-TexasTechUniversity/Personal/Projects/Code/GitHub/AppliedEconometrics/DemandAnalysis/Homework/Tobit.tex", se r2
