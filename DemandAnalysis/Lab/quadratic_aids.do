clear all
cd "P:/Demand"

import excel "labdata.xls", firstrow 

* Generate log prices, log quantities, expenditure
forvalues i = 1/10 {
gen lnp`i' = log(p`i')
gen lnq`i' = log(q`i')
gen exp`i' = p`i' * q`i'
}
global price p1 p2 p3 p4 p5 p6 p7 p8 p9 p10
global lprice lnp1 lnp2 lnp3 lnp4 lnp5 lnp6 lnp7 lnp8 lnp9 lnp10 
global quantity q1 q2 q3 q4 q5 q6 q7 q8 q9 q10  

gen  X = exp1 + exp2 + exp3 + exp4 + exp5 + exp6 + exp7 + exp8 + exp9 + exp10
gen lnX = log(X)
forvalues i = 1/10{
gen w`i' = exp`i'/X
}

quaids w1-w10, anot(0) prices(p1 p2 p3 p4 p5 p6 p7 p8 p9 p10) expenditure(X
estat expenditure, atmeans
estat uncompensated, atmeans
