import excel "/Users/joamacha/Library/CloudStorage/OneDrive-TexasTechUniversity/Personal/Projects/Code/GitHub/AppliedEconometrics/Homework2/lasvegas.xlsx", firstrow clear

* 1 (a)

reg DELINQUENT LVR REF INSUR RATE AMOUNT CREDIT TERM ARM, vce(robust)
predict LP_DELINQ

* 1 (b)

probit DELINQUENT LVR REF INSUR RATE AMOUNT CREDIT TERM ARM
predict PROBIT_DELINQ


* 1(c)
gen id =_n

list DELINQUENT LVR REF INSUR RATE AMOUNT CREDIT TERM ARM LP_DELINQ PROBIT_DELINQ if id==500 | id==1000


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
tab phat500_correct

*** QUESTION 2 ***
import excel "/Users/joamacha/Library/CloudStorage/OneDrive-TexasTechUniversity/Personal/Projects/Code/GitHub/AppliedEconometrics/Homework2/nels_small.xlsx", firstrow clear

* 1 = highschool
* 2 = 2-year college
* 3 = 4-year college 

* 2 (a)
mlogit PSECHOICE GRADES FAMINC FEMALE BLACK, baseoutcome(1)

*2 (b)
margins, predict(outcome(3)) at((medians) GRADES FAMINC FEMALE=0 BLACK=0)

* 2(c)
margins, predict(outcome(1)) at((medians) GRADES FAMINC FEMALE=0 BLACK=0)
gen q2c= (.5239466/.1920783)
disp q2c


* 2(d)
margins, at((medians) FAMINC GRADES=6.53039 FEMALE=0 BLACK=0)
margins, at((medians) FAMINC GRADES=4.905 FEMALE=0 BLACK=0)
gen q2d = (.7320075-.5239466)
disp q2d

*2(e)
mlogit PSECHOICE GRADES FAMINC FEMALE BLACK if PSECHOICE!=2, baseoutcome(1)
margins, predict(outcome(3)) at((medians) GRADES FAMINC FEMALE=0 BLACK=0)
gen q2e = (.7640356/(1-.7640356))
disp q2e

*** QUESTION 3 ***
import excel "/Users/joamacha/Library/CloudStorage/OneDrive-TexasTechUniversity/Personal/Projects/Code/GitHub/AppliedEconometrics/Homework2/cola.xlsx", firstrow clear

* 3(a)
sort ID, stable
by ID: gen ALT = _n
label define BRAND 1 "Pepsi" 2 "7Up" 3 "Coke"
label values ALT BRAND
asclogit CHOICE PRICE FEATURE DISPLAY, case(ID) alternatives(ALT) noconstant

* 3(b)
estat mfx, at (PRICE=1.25 DISPLAY=0 FEATURE=0)


*3(c)
estat mfx, at (PRICE=1.25 Coke:DISPLAY=1 Pepsi:DISPLAY=0 7Up:DISPLAY=0 FEATURE=0)

*3(d)
estat mfx, at (Coke:PRICE=1.30 Pepsi:PRICE=1.25 7Up:PRICE=1.25  Coke:DISPLAY=1 Pepsi:DISPLAY=0 7Up:DISPLAY=0 FEATURE=0)

*3(e)
asclogit CHOICE PRICE FEATURE DISPLAY, case(ID) alternatives(ALT) basealternative(Coke)
estat mfx, at (PRICE=1.25 Coke:DISPLAY=1 Pepsi:DISPLAY=0 7Up:DISPLAY=0 FEATURE=0)

*3(f)
estat mfx, at (Coke:PRICE=1.30 Pepsi:PRICE=1.25 7Up:PRICE=1.25  Coke:DISPLAY=1 Pepsi:DISPLAY=0 7Up:DISPLAY=0 FEATURE=0)

* 3(g)

nlogitgen type = ALT(Cola: Coke|Pepsi, Other: 7Up)
nlogittree ALT type, choice(CHOICE)
nlogit CHOICE FEATURE ||type:,base(Other)||ALT:PRICE DISPLAY, case(ID) 

predict pr*, pr

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
margins, at (BLACK=1 FAMINC=52 FAMSIZ=4 PARCOLL=1 GRADES=(6.64,4.95))


* 4(e)
margins, at (BLACK=0 FAMINC=52 FAMSIZ=4 PARCOLL=1 GRADES=(6.64,4.95))



*** QUESTION 5 *** 
import excel  "/Users/joamacha/Library/CloudStorage/OneDrive-TexasTechUniversity/Personal/Projects/Code/GitHub/AppliedEconometrics/Homework2/Cardholder.xlsx",  firstrow case(lower) clear


destring spending, replace
destring logspend, replace

gen logincome = ln(income)


* 1(a)
reg logspend logincome age adepcnt ownrent

* 1(b)
tobit logspend logincome age adepcnt ownrent, ll(1)
margins, dydx(logincome)

* 1(c)
heckman logspend logincome age adepcnt ownrent, select(cardhldr=logincome age adepcnt ownrent)
margins, dydx(logincome)


* 2(a)
drop if cardhldr==0
reg logspend logincome age adepcnt ownrent


*2(b)
truncreg logspend logincome age adepcnt ownrent, ll(1)


import excel  "/Users/joamacha/Library/CloudStorage/OneDrive-TexasTechUniversity/Personal/Projects/Code/GitHub/AppliedEconometrics/Homework2/Cardholder.xlsx",  firstrow case(lower) clear

* 3(a)
poisson minordrg logincome age adepcnt ownrent exp_inc if cardhldr==1
mfx

summarize minordrg, detail

* 3(b)
nbreg minordrg logincome age adepcnt ownrent exp_inc if cardhldr==1
mfx

* 3(c) 

poisson minordrg logincome age adepcnt ownrent exp_inc, offset(cardhldr)
mfx

nbreg minordrg logincome age adepcnt ownrent exp_inc, offset(cardhldr)
mfx
    





