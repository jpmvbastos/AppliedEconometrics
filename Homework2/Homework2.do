use "/Users/joamacha/Library/CloudStorage/OneDrive-TexasTechUniversity/Personal/Projects/Code/GitHub/AppliedEconometrics/Homework2/lasvegas.xlsx", clear

gen id =_n
* 1 (a)

reg DELINQUENT LVR REF INSUR RATE AMOUNT CREDIT TERM ARM, vce(robust)
predict LP_DELINQ

* 1 (b)

probit DELINQUENT LVR REF INSUR RATE AMOUNT CREDIT TERM ARM
predict PROBIT_DELINQ


* 1(c)
list LP_DELINQ PROBIT_DELINQ if id==500 | id==1000


* 1(d)
histogram CREDIT

set obs `=_N+1'
replace X = 1 if _n == _N

reg DELINQUENT LVR REF INSUR RATE AMOUNT CREDIT TERM ARM, vce(robust)
margins, at (CREDIT =(500(100)700)) at AMOUNT=2.5 at LVR=80 at RATE=8 at TERM=30 at REF=1 at ARM=1


probit DELINQUENT LVR REF INSUR RATE AMOUNT CREDIT TERM ARM




*1(e)
probit DELINQUENT LVR REF INSUR RATE AMOUNT CREDIT TERM ARM

margins, dydx 


*1(f)

histogram LVR

* 1(g)

gen byte LP_CORRECT_PRED = 1 if (DELINQUENT==1 & LP_DELINQ>= 0.5) |  (DELINQUENT==0 & LP_DELINQ< 0.5)
tab LP_CORRECT_PRED

gen byte PROB_CORRECT_PRED = 1 if (DELINQUENT==1 & PROB_DELINQ>= 0.5) |  (DELINQUENT==0 & PROB_DELINQ< 0.5)
tab PROB_CORRECT_PRED


* 1(h)


*** QUESTION 2 ***
use "/Users/joamacha/Library/CloudStorage/OneDrive-TexasTechUniversity/Personal/Projects/Code/GitHub/AppliedEconometrics/Homework2/nels_small.xlsx", clear


* 2 (a)



*** QUESTION 5 *** 
use "/Users/joamacha/Library/CloudStorage/OneDrive-TexasTechUniversity/Personal/Projects/Code/GitHub/AppliedEconometrics/Homework2/Cardholder.xlsx", clear

gen log_spend = ln(spending)
gen log_income = ln(income)


* 1(a)
reg log_spend log_income age adepcnt ownrent


* 2(a)
reg log_spend log_income age adepcnt ownrent if cardholder==1

* 3(a)
poisson minordrg log_income age adepcnt ownrent exp_inc if cardholder==1
margins, dydx atmeans

* 3(b)
nbreg inordrg log_income age adepcnt ownrent exp_inc if cardholder==1
margins, dydx atmeans





