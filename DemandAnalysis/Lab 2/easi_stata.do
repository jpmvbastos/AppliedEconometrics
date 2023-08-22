
clear all
import delimited P:\Demand\hixdata.csv

* set number of equations, prices, demographic characteristics, and convergence criterion
global neqminus1 "7"
global neq "8"
global nprice "9"
global ndem 5
global npowers "5"
global conv_crit "0.000001"

*data labeling conventions:
* budget shares: s1 to sneq
* prices: p1 to nprice
* implicit utility: y, or related names
* demographic characteristics: z1 to zTdem13

g s1 = sfoodh
g s2 = sfoodr
g s3 = srent
g s4 = soper
g s5 = sfurn
g s6 = scloth
g s7 = stranop
g s8 = srecr
g s9 = spers
g p1 = pfoodh
g p2 = pfoodr
g p3 = prent
g p4 = poper
g p5 = pfurn
g p6 = pcloth
g p7 = ptranop
g p8 = precr
g p9 = ppers

* normalised prices are what enter the demand system
* generate normalised prices, backup prices (they get deleted), and Ap
forvalues j = 1(1)$neq {
g np`j' = p`j' - p$nprice
}
forvalues j=1(1)$neq {
g np`j'_backup = np`j'
g Ap`j' = 0
}
g pAp = 0


*list demographic characteristics: fill them in, and add them to zlist below
g z1=age
g z2=hsex
g z3=carown
g z4=time
g z5=tran
global zlist "z1 z2 z3 z4 z5"

*make y_stone = x-p'w, and gross instrument, y_tilda = x-p'w^bar
g x = log_y
g y_stone = x
g y_tilda = x

forvalues num=1(1)$nprice {
egen mean_s`num' = mean(s`num')
replace y_tilda = y_tilda - mean_s`num'*p`num'
replace y_stone = y_stone - s`num'*p`num'
}

*list of functions of (implicit) utility, y: fill them in, and add them to ylist below
*alternatively, fill ylist and yinstlist with the appropriate variables and instruments
g y = y_stone
g y_inst = y_tilda
global ylist ""
global yinstlist ""

forvalues j = 1(1)$npowers {
g y`j' = y^`j'
g y`j'_inst = y_inst^`j'
global ylist "$ylist y`j'"
global yinstlist "$yinstlist y`j'_inst"
}

*set up the equations and put them in a list
global eqlist ""

forvalues num = 1(1)$neq {
global eq`num'"(s`num'$ylist $zlist np1-np$neq)"
macro list eq`num'
global eqlist "$eqlist \$eq`num'"
}

*create linear constraints and put them in a list, called conlist
global conlist ""

forvalues j = 1(1)$neq {
local jplus1 = `j'+1
forvalues k = `jplus1'(1)$neq {
constraint `j'`k'[s`j']np`k' = [s`k']np`j'
global conlist "$conlist `j'`k'"
}
}

* First get a pre-estimate to create the instrument:
* run three stage least squares on the model with no py, pz or yz interactions, and then iterate to convergence
* note that the difference in predicted values between p and p=0 is Ap

replace y = y_stone
g y_old = y_stone
g y_change = 0
scalar crit_test=1

while crit_test > $conv_crit {
quietly reg3 $eqlist, constr($conlist) endog($ylist) exog($yinstlist)
quietly replace pAp = 0
replace y_old = y
forvalues j = 1(1)$neq {
quietly predict s`j'hat, equation(s`j')
}
forvalues j = 1(1)$neq {
quietly replace np`j' = 0
}
forvalues j = 1(1)$neq {
quietly predict s`j'hat_p0, equation(s`j')
}
forvalues j=1(1)$neq {
quietly replace np`j' = np`j'_backup
quietly replace Ap`j' = s`j'hat - s`j'hat_p0
quietly replace pAp = pAp + np`j'*Ap`j'
quietly drop s`j'hat s`j'hat_p0
}
replace pAp = int(1000000*pAp +0.5)/1000000
summ pAp
quietly replace y = y_stone+0.5*pAp
forvalues j = 1(1)$npowers {
quietly replace y`j' = y^`j'
}
quietly replace y_change = abs(y-y_old)
summ y_change
scalar crit_test=r(max)
display `k'
scalar list crit_test
summ y_stone y y_old
}

*now, create the instruments
quietly replace y_inst = y_tilda + 0.5*pAp
forvalues j = 1(1)$npowers {
quietly replace y`j'_inst=y_inst^`j'
}

*run three stage least squares on the model with no py, pz or yz interactions, and then iterate to convergence
* note that the di§erence in predicted values between p and p=0 is Ap
*reset the functions of y
replace y = y_stone
forvalues j = 1(1)$npowers {
quietly replace y`j' = y^`j'
}
replace y_old = y_stone
replace y_change = 0
scalar crit_test = 1

while crit_test> $conv_crit {
quietly reg3 $eqlist, constr($conlist) endog($ylist) exog($yinstlist)
quietly replace pAp = 0
replace y_old =y 
forvalues j = 1(1)$neq {
quietly predict s`j'hat, equation(s`j')
}
forvalues j = 1(1)$neq {
quietly replace np`j' = 0
}
forvalues j = 1(1)$neq {
quietly predict s`j'hat_p0, equation(s`j')
}
forvalues j = 1(1)$neq {
quietly replace np`j' = np`j'_backup
quietly replace Ap`j' = s`j'hat - s`j'hat_p0
quietly replace pAp = pAp + np`j'*Ap`j'
quietly drop s`j'hat s`j'hat_p0
}
replace pAp = int(1000000*pAp+0.5)/1000000
summ pAp
quietly replace y = y_stone + 0.5*pAp 
forvalues j = 1(1)$npowers {
quietly replace y`j' = y^`j'
}
quietly replace y_change = abs(y-y_old)
summ y_change
scalar crit_test = r(max)
display `k'
scalar list crit_test
summ y_stone y y_old
}

*note that reported standard errors are wrong for iterated estimates
reg3 $eqlist, constr($conlist) endog($ylist) exog($yinstlist)
