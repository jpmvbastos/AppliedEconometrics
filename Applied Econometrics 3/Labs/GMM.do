* Import data from Stata database
use http://www.stata-press.com/data/r13/auto
sysuse auto

* OLS
reg mpg weight length


* GMM (see: https://www.stata.com/manuals13/rgmm.pdf)
gmm (mpg-{b1}-{b2}*weight-{b3}*length), instruments(weight length) 

* Coefficients are the same, but Std. Errors are different.
* GMM uses Robust Standard Errors by default. We can specify for vce(unadjusted)

* Using OLS with robust given nearly identical Std. Errors.
reg mpg weight length, vce(robust)





* Import new data
use http://www.stata-press.com/data/r13/hsng2

* hsngval is endogenous, use faminc as instrument

* Instrumental Variable Regression || see: https://www.stata.com/manuals13/rgmm.pdf (p. 15)
gmm (rent - {xb:hsngval pcturban} - {b0}), instruments(faminc pcturban)

* Regional dummy variables as extra instruments
gmm (rent - {xb:hsngval pcturban} - {b0}), instruments(faminc pcturban reg2-reg4)




* Import new data
use http://www.stata-press.com/data/r13/klein

* Three-Stage Least Squares || see: https://www.stata.com/manuals13/rgmm.pdf (p.36)

gmm (eq1: consump - {b0} - {xb: wagepriv wagegovt}) (eq2: wagepriv - {c0} - {xc: consump govt capital1}), ///
instruments(eq1: wagegovt govt capital1) instruments(eq2: wagegovt govt capital1) ///
winitial(unadjusted, independent) twostep


* Rational expectations / Intertemporal consumption model 

* Import new data
use http://www.stata-press.com/data/r13/cr
gen cgrowth = c / L.c

* Euler Equations
gmm ({b=1}*(1+F.r)*(F.c/c)^(-1*{a=1})-1), instruments(L.r L2.r cgrowth L.cgrowth) wmat(hac nw 4) twostep

 
  
 
