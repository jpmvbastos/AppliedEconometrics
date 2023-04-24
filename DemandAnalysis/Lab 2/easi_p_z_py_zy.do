* Tricks with Hicks: The EASI demand system
* Arthur Lewbel and Krishna Pendakur
* 2008, American Economic Review

* Herein, find Stata code to estimate a demand system with neq equations, nprice prices, 
*	ndem demographic characteristics and npowers powers of implicit utility
* This Stata code estimates Lewbel and Pendakur's EASI demand system using approximate 
*    OLS estimation and iterated linear 3SLS estimation. Note that iterated linear 3SLS is 
*    not formally equivalent to fully nonlinear 3SLS (which does not exist in Stata).  
*    However, in some contexts they are asymptotically equivalent (see, e.g., Blundell and
*    Robin 1999 and Dominitz and Sherman 2005), and we have verified in our data that 
*    coefficients estimated using iterated linear 3SLS are within 0.001 of those 
*    estimated using fully nonlinear 3SLS. 
*    Code to estimate the fully nonlinear 3SLS/GMM version in TSP is available on request
*    from the authors.
* This model includes pz,py,zy interactions.  See 'iterated 3sls without pz,py,zy.do' for 
*    shorter code to estimate the model without interactions.

set more off
macro drop _all
use "C:\projects\hixtrix\revision\hixdata.dta", clear

* set number of equations and prices and demographic characteristics and convergence criterion
global neqminus1 "7"
global neq "8"
global nprice "9"
global ndem 5
global npowers "5"
* set a convergence criterion and choose whether or not to base it on parameters
global conv_crit "0.00000000000001"
scalar conv_param=1
scalar conv_y=0
*note set the matrix size big enough to do constant,y,z,p,zp,yp,yz
global matsize_value=100+$neq*(1+$npowers+$ndem+$neq*(1+$ndem+1)+$ndem)
set matsize $matsize_value

*data labeling conventions:
* data weights: wgt (replace with 1 if unweighted estimation is desired)
* budget shares: s1 to sneq
* prices: p1 to nprice
* log total expenditures: x
* implicit utility: y, or related names
* demographic characteristics: z1 to zndem
g obs_weight=wgt
g s1=sfoodh
g s2=sfoodr
g s3=srent
g s4=soper
g s5=sfurn
g s6=scloth
g s7=stranop
g s8=srecr
g s9=spers

g p1=pfoodh
g p2=pfoodr
g p3=prent
g p4=poper
g p5=pfurn
g p6=pcloth
g p7=ptranop
g p8=precr
g p9=ppers

* polynomial systems are easier to estimate if you normalise the variable in the polynomial
g x=log_y
*egen mean_log_y=mean(log_y)
*replace x=log_y-mean_log_y

* normalised prices are what enter the demand system
* generate normalised prices, backup prices (they get deleted), and pAp, pBp
global nplist ""
forvalues j=1(1)$neq {
	g np`j'=p`j'-p$nprice	
	global nplist "$nplist np`j'"
}
forvalues j=1(1)$neq {
	g np`j'_backup=np`j'
	g Ap`j'=0
	g Bp`j'=0
}
g pAp=0
g pBp=0

*list demographic characteristics: fill them in, and add them to zlist below
g z1=age
g z2=hsex
g z3=carown
g z4=tran
g z5=time
global zlist "z1 z2 z3 z4 z5"

*make pz interactions
global npzlist ""
forvalues j=1(1)$neq {
	forvalues k=1(1)$ndem {
		g np`j'z`k'=np`j'*z`k'	
		global npzlist "$npzlist np`j'z`k'"
	}
}

*make y_stone=x-p'w, and gross instrument, y_tilda=x-p'w^bar
g y_stone=x
g y_tilda=x
forvalues num=1(1)$nprice {
	egen mean_s`num'=mean(s`num')
	replace y_tilda=y_tilda-mean_s`num'*p`num'
	replace y_stone=y_stone-s`num'*p`num'
}

* make list of functions of (implicit) utility, y: fill them in, and add them to ylist below
* alternatively, fill ylist and yinstlist with the appropriate variables and instruments
g y=y_stone
g y_inst=y_tilda
global ylist ""
global yinstlist ""
global yzlist ""
global yzinstlist ""
global ynplist ""
global ynpinstlist ""
forvalues j=1(1)$npowers {
	g y`j'=y^`j'
	g y`j'_inst=y_inst^`j'
	global ylist "$ylist y`j'"
	global yinstlist "$yinstlist y`j'_inst"
}
forvalues k=1(1)$ndem {
	g yz`k'=y*z`k'
	g yz`k'_inst=y_inst*z`k'
	global yzlist "$yzlist yz`k'"
	global yzinstlist "$yzinstlist yz`k'_inst"
}
forvalues k=1(1)$neq {
	g ynp`k'=y*np`k'
	g ynp`k'_inst=y_inst*np`k'
	global ynplist "$ynplist ynp`k'"
	global ynpinstlist "$ynpinstlist ynp`k'_inst"
}

*set up the equations and put them in a list
global eqlist ""
forvalues num=1(1)$neq {
	global eq`num' "(s`num' $ylist $zlist $yzlist $nplist $ynplist $npzlist)"
	macro list eq`num'
	global eqlist "$eqlist \$eq`num'"
}

*create linear constraints and put them in a list, called conlist
global conlist ""
forvalues j=1(1)$neq {
	local jplus1=`j'+1
	forvalues k=`jplus1'(1)$neq {
		constraint `j'`k' [s`j']np`k'=[s`k']np`j'	
		global conlist "$conlist `j'`k'"
	}
}
*add constraints for yp interactions
forvalues j=1(1)$neq {
	local jplus1=`j'+1
	forvalues k=`jplus1'(1)$neq {
		constraint `j'`k'0 [s`j']ynp`k'=[s`k']ynp`j'	
		global conlist "$conlist `j'`k'0"
	}
}

* add constraints for pz interactions
forvalues h=1(1)$ndem {
	forvalues j=1(1)$neq {
		local jplus1=`j'+1
		forvalues k=`jplus1'(1)$neq {
			constraint `j'`k'`h' [s`j']np`k'z`h'=[s`k']np`j'z`h'	
			global conlist "$conlist `j'`k'`h'"
		}
	}
}

*an approximate model would use one of:
*reg3 $eqlist [aweight=obs_weight], constr($conlist) endog($ylist $ynplist $yzlist) exog($yinstlist $ynpinstlist $yzinstlist)
*sureg $eqlist, constr($conlist) 
*sureg $eqlist


*the exact model requires two steps:  step 1) get a pre-estimate to construct the intrument, step 2) use the instrument to estimate the model
*first get a pre-estimate to create the instrument:
*run three stage least squares on the model with py, pz or yz interactions, and then iterate to convergence,
* constructing y=(y_stone+0.5*p'A(z)p)/(1-0.5*p'Bp) at each iteration
* note that the difference in predicted values for y=1 between p and p=0 is A(z)p, and
* that the difference in difference in predicted values for y=1 vs y=0 between p and p=0 is Bp
replace y=y_stone
g y_backup=y_stone
g y_old=y_stone
g y_change=0
scalar crit_test=1
scalar iter=0
while crit_test>$conv_crit {
	scalar iter=iter+1
	quietly reg3 $eqlist [aweight=obs_weight],  constr($conlist) endog($ylist $ynplist $yzlist) exog($yinstlist $ynpinstlist $yzinstlist)
	if (iter>1) {		
		matrix params_old=params
	}
	matrix params=e(b)
	quietly replace pAp=0
	quietly replace pBp=0
	quietly replace y_old=y
	quietly replace y_backup=y

	*predict with y=1
	*generate rhs vars,interactions with y=1
	forvalues j=1(1)$npowers {
		quietly replace y`j'=1
	} 
	forvalues j=1(1)$neq {
		quietly replace ynp`j'=np`j'
	} 
	forvalues j=1(1)$ndem {
		quietly replace yz`j'=z`j'
	} 
	*generate predicted values
	forvalues j=1(1)$neq {
		quietly predict s`j'hat_y1, equation(s`j')		
	}
	*set all p, pz, py to zero
	foreach yvar in $nplist $ynplist $npzlist {
		quietly replace `yvar'=0
	} 
	forvalues j=1(1)$neq {
		quietly predict s`j'hat_y1_p0, equation(s`j')		
	}
	
	*refresh p,pz
	forvalues j=1(1)$neq {
		quietly replace np`j'=np`j'_backup
		forvalues k=1(1)$ndem {
			quietly replace np`j'z`k'=np`j'_backup*z`k'		 
		}
	}
	
	*generate rhs vars,interactions with y=0
	foreach yvar in $ylist $ynplist $yzlist {
		quietly replace `yvar'=0
	} 
	*generate predicted values
	forvalues j=1(1)$neq {
		quietly predict s`j'hat_y0, equation(s`j')		
	}
	*set all p, pz, py to zero
	foreach yvar in $nplist $ynplist $npzlist {
		quietly replace `yvar'=0
	} 
	forvalues j=1(1)$neq {
		quietly predict s`j'hat_y0_p0, equation(s`j')		
	}

	*refresh p only
	forvalues j=1(1)$neq {
		quietly replace np`j'=np`j'_backup
	}
	
	*fill in pAp and pBp
	forvalues j=1(1)$neq {
		quietly replace Ap`j'=s`j'hat_y0-s`j'hat_y0_p0
		quietly replace pAp=pAp+np`j'*Ap`j'	
		quietly replace Bp`j'=(s`j'hat_y1-s`j'hat_y1_p0)-(s`j'hat_y0-s`j'hat_y0_p0)
		quietly replace pBp=pBp+np`j'*Bp`j'	
		quietly drop s`j'hat_y0 s`j'hat_y0_p0 s`j'hat_y1 s`j'hat_y1_p0
	}

	*round pAp and pBp to the nearest millionth, for easier checking
	quietly replace pAp=int(1000000*pAp+0.5)/1000000
	quietly replace pBp=int(1000000*pBp+0.5)/1000000

	*recalculate y,yz,py,pz
	quietly replace y=(y_stone+0.5*pAp)/(1-0.5*pBp)
	forvalues j=1(1)$npowers {
		quietly replace y`j'=y^`j'
	}
	forvalues j=1(1)$ndem {
		quietly replace yz`j'=y*z`j'
	} 
	*refresh py,pz
	forvalues j=1(1)$neq {
		quietly replace ynp`j'=y*np`j'_backup
		forvalues k=1(1)$ndem {
			quietly replace np`j'z`k'=np`j'_backup*z`k'		 
		}
	}

	if (iter>1 & conv_param==1) {		
		matrix params_change=(params-params_old)
		matrix crit_test_mat=(params_change*(params_change'))
		svmat crit_test_mat, names(temp)
		scalar crit_test=temp
		drop temp
	}
	quietly replace y_change=abs(y-y_old)
	quietly summ y_change
	if(conv_y==1) {
		scalar crit_test=r(max)
	}
	display "iteration " iter 
	scalar list crit_test 
	summ y_change y_stone y y_old pAp pBp
}

*now, create the instrument, and its interactions yp and yz
quietly replace y_inst=(y_tilda+0.5*pAp)/(1-0.5*pBp)
forvalues j=1(1)$npowers {
	quietly replace y`j'_inst=y_inst^`j'
}
forvalues j=1(1)$neq {
	replace ynp`j'_inst=y_inst*np`j'
} 
forvalues j=1(1)$ndem {
	replace yz`j'_inst=y_inst*z`j'
} 


*with nice instrument in hand, run three stage least squares on the model, and then iterate to convergence
replace y_old=y
replace y_change=0
scalar iter=0
scalar crit_test=1
while crit_test>$conv_crit {
	scalar iter=iter+1
	quietly reg3 $eqlist [aweight=obs_weight],  constr($conlist) endog($ylist $ynplist $yzlist) exog($yinstlist $ynpinstlist $yzinstlist)
	if (iter>1) {		
		matrix params_old=params
	}
	matrix params=e(b)
	quietly replace pAp=0
	quietly replace pBp=0
	quietly replace y_old=y
	quietly replace y_backup=y

	*predict with y=1
	*generate rhs vars,interactions with y=1
	forvalues j=1(1)$npowers {
		quietly replace y`j'=1
	} 
	forvalues j=1(1)$neq {
		quietly replace ynp`j'=np`j'
	} 
	forvalues j=1(1)$ndem {
		quietly replace yz`j'=z`j'
	} 
	*generate predicted values
	forvalues j=1(1)$neq {
		quietly predict s`j'hat_y1, equation(s`j')		
	}
	*set all p, pz, py to zero
	foreach yvar in $nplist $ynplist $npzlist {
		quietly replace `yvar'=0
	} 
	forvalues j=1(1)$neq {
		quietly predict s`j'hat_y1_p0, equation(s`j')		
	}
	
	*refresh p,pz
	forvalues j=1(1)$neq {
		quietly replace np`j'=np`j'_backup
		forvalues k=1(1)$ndem {
			quietly replace np`j'z`k'=np`j'_backup*z`k'		 
		}
	}
	
	*generate rhs vars,interactions with y=0
	foreach yvar in $ylist $ynplist $yzlist {
		quietly replace `yvar'=0
	} 
	*generate predicted values
	forvalues j=1(1)$neq {
		quietly predict s`j'hat_y0, equation(s`j')		
	}
	*set all p, pz, py to zero
	foreach yvar in $nplist $ynplist $npzlist {
		quietly replace `yvar'=0
	} 
	forvalues j=1(1)$neq {
		quietly predict s`j'hat_y0_p0, equation(s`j')		
	}

	*refresh p only
	forvalues j=1(1)$neq {
		quietly replace np`j'=np`j'_backup
	}
	
	*fill in pAp and pBp
	forvalues j=1(1)$neq {
		quietly replace Ap`j'=s`j'hat_y0-s`j'hat_y0_p0
		quietly replace pAp=pAp+np`j'*Ap`j'	
		quietly replace Bp`j'=(s`j'hat_y1-s`j'hat_y1_p0)-(s`j'hat_y0-s`j'hat_y0_p0)
		quietly replace pBp=pBp+np`j'*Bp`j'	
		quietly drop s`j'hat_y0 s`j'hat_y0_p0 s`j'hat_y1 s`j'hat_y1_p0
	}

	*round pAp and pBp to the nearest millionth, for easier checking
	quietly replace pAp=int(1000000*pAp+0.5)/1000000
	quietly replace pBp=int(1000000*pBp+0.5)/1000000

	*recalculate y,yz,py,pz
	quietly replace y=(y_stone+0.5*pAp)/(1-0.5*pBp)
	forvalues j=1(1)$npowers {
		quietly replace y`j'=y^`j'
	}
	forvalues j=1(1)$ndem {
		quietly replace yz`j'=y*z`j'
	} 
	*refresh py,pz
	forvalues j=1(1)$neq {
		quietly replace ynp`j'=y*np`j'_backup
		forvalues k=1(1)$ndem {
			quietly replace np`j'z`k'=np`j'_backup*z`k'		 
		}
	}

	if (iter>1 & conv_param==1) {		
		matrix params_change=(params-params_old)
		matrix crit_test_mat=(params_change*(params_change'))
		svmat crit_test_mat, names(temp)
		scalar crit_test=temp
		drop temp
	}
	quietly replace y_change=abs(y-y_old)
	quietly summ y_change
	if(conv_y==1) {
		scalar crit_test=r(max)
	}
	display "iteration " iter 
	scalar list crit_test 
	summ y_change y_stone y y_old pAp pBp
}

*note that reported standard errors are wrong for iterated estimates
reg3 $eqlist [aweight=obs_weight],  constr($conlist) endog($ylist $ynplist $yzlist) exog($yinstlist $ynpinstlist $yzinstlist)

