import excel "/Users/joamacha/Library/CloudStorage/OneDrive-TexasTechUniversity/Personal/Projects/Code/GitHub/AppliedEconometrics/Homework2/lasvegas.xlsx", firstrow clear

* 1 (a)

reg DELINQUENT LVR REF INSUR RATE AMOUNT CREDIT TERM ARM, vce(robust)
predict LP_DELINQ

* 1 (b)

probit DELINQUENT LVR REF INSUR RATE AMOUNT CREDIT TERM ARM
predict PROBIT_DELINQ


* 1(c)
gen id =_n
list LP_DELINQ PROBIT_DELINQ if id==500 | id==1000


* 1(d)
histogram CREDIT

reg DELINQUENT LVR REF INSUR RATE AMOUNT CREDIT TERM ARM, vce(robust)
margins, at (CREDIT =(500(100)700) AMOUNT=2.5 LVR=80 RATE=8 TERM=30 REF=1 ARM=1)


probit DELINQUENT LVR REF INSUR RATE AMOUNT CREDIT TERM ARM
margins, at (CREDIT =(500(100)700) AMOUNT=2.5 LVR=80 RATE=8 TERM=30 REF=1 ARM=1)



*1(e)
probit DELINQUENT LVR REF INSUR RATE AMOUNT CREDIT TERM ARM

margins, dydx(CREDIT) at (CREDIT =(500(100)700) AMOUNT=2.5 LVR=80 RATE=8 TERM=30 REF=1 ARM=1)


*1(f)

histogram LVR

reg DELINQUENT LVR REF INSUR RATE AMOUNT CREDIT TERM ARM, vce(robust)
margins, at (LVR=(20,80) CREDIT=600 AMOUNT=2.5 LVR=80 RATE=8 TERM=30 REF=1 ARM=1)


probit DELINQUENT LVR REF INSUR RATE AMOUNT CREDIT TERM ARM 
margins, at (LVR=(20,80) CREDIT=600 AMOUNT=2.5 LVR=80 RATE=8 TERM=30 REF=1 ARM=1)

* 1(g)

gen byte LP_CORRECT_PRED = 1 if (DELINQUENT==1 & LP_DELINQ>= 0.5) |  (DELINQUENT==0 & LP_DELINQ< 0.5)
replace LP_CORRECT_PRED = 0 if LP_CORRECT_PRED==.
tab LP_CORRECT_PRED

gen byte PROB_CORRECT_PRED = 1 if (DELINQUENT==1 & PROBIT_DELINQ>= 0.5) |  (DELINQUENT==0 & PROBIT_DELINQ< 0.5)
replace PROB_CORRECT_PRED = 0 if PROB_CORRECT_PRED==.
tab PROB_CORRECT_PRED


* 1(h)
reg DELINQUENT LVR REF INSUR RATE AMOUNT CREDIT TERM ARM if id<501, vce(robust)
predict lphat500 if id>500
gen lphat500_correct =0 
replace lphat500_correct=1 if (DELINQUENT==1 & lphat500>= 0.5) |  (DELINQUENT==0 & lphat500< 0.5)
tab lphat500_correct


probit DELINQUENT LVR REF INSUR RATE AMOUNT CREDIT TERM ARM 
predict phat500 if id>500
gen phat500_correct =0
replace phat500_correct=1 if (DELINQUENT==1 & phat500>= 0.5) |  (DELINQUENT==0 & phat500< 0.5)
tab lphat500_correct

*** QUESTION 2 ***
import excel "/Users/joamacha/Library/CloudStorage/OneDrive-TexasTechUniversity/Personal/Projects/Code/GitHub/AppliedEconometrics/Homework2/nels_small.xlsx", firstrow clear


* 2 (a)
mlogit PSECHOICE GRADES FAMINC FEMALE BLACK, baseoutcome(1)

*2 (b)
margins, at(GRADES=6.53039 FAMINC=51.3935 FEMALE=0 BLACK=0)

* 2(c)


* 2(d)
margins, at(GRADES=6.53039 FAMINC=51.3935 FEMALE=0 BLACK=0)
margins, at(GRADES=4.905 FAMINC=51.3935 FEMALE=0 BLACK=0)


*** QUESTION 3 ***
import excel "/Users/joamacha/Library/CloudStorage/OneDrive-TexasTechUniversity/Personal/Projects/Code/GitHub/AppliedEconometrics/Homework2/cola.xlsx", firstrow clear

* 3(a)
clogit CHOICE PRICE FEATURE DISPLAY, group(ID) 

* 3(b)
clogit CHOICE PRICE FEATURE DISPLAY, group(ID) or 


* 3(g)

gen COKE = 0
replace COKE=1 if 

nlogitgen type = CHOICE (coke: , noncoke: sevenup|pepsi)

nlogittree COKE type, choice(CHOICE)

nlogit d p q || type:, base(COKE) || fishmode: income, case(id)

*** QUESTION 4 ***
import excel "/Users/joamacha/Library/CloudStorage/OneDrive-TexasTechUniversity/Personal/Projects/Code/GitHub/AppliedEconometrics/Homework2/nels_small.xlsx", firstrow clear

* 4 (a)
oprobit PSECHOICE GRADES
estimates store rest

margins, at(GRADES=6.64)
margins, at(GRADES=4.95)

* 4(b)
oprobit PSECHOICE GRADES FAMINC FAMSIZ BLACK PARCOLL
estimates store unrest

* 4(c)
lrtest rest unrest

* 4(d)
margins, at (BLACK=1 FAMSIZ=4 PARCOLL=1 GRADES=(6.64,4.95))


* 4(e)
margins, at (BLACK=0 FAMSIZ=4 PARCOLL=1 GRADES=(6.64,4.95))



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





