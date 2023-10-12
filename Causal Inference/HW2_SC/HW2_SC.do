* Synthetic Control Homework

cd "/Users/jpmvbastos/Documents/GitHub/AppliedEconometrics/Causal Inference/HW2_SC"

use smoking-3.dta, clear

tsset state year

* 1 - Estimate a synthetic control on the California smoking data. 
* Use the same model as in the Abadie et al JASA paper

synth cigsale lnincome age15to24 retprice beer(1984(1)1988) ///
		cigsale(1988) cigsale(1980) cigsale(1975), nested ///
        trunit(3) trperiod(1989) fig keep(model1)

* 2. Show your results. What is the composition of the syn. Control? 
* How do the indicator variables match up? What does the treatment effect look like?

graph export "/Users/jpmvbastos/Documents/GitHub/AppliedEconometrics/Causal Inference/HW2_SC/Graph1.png", /// 
		as(png) name("Graph")


/* 3. Now estimate the model using all the possible lagged outcome variables and no other covariates. 
What is the composition of the syn. Control? What does the treatment effect look like? 
How, if at all, do these results differ from the ones in question 2. */ 

synth cigsale cigsale(1970) cigsale(1971) cigsale(1972) cigsale(1973) cigsale(1974) ///
	  cigsale(1975) cigsale(1976) cigsale(1977) cigsale(1978) cigsale(1979) ///
	  cigsale(1980) cigsale(1981) cigsale(1982) cigsale(1983) cigsale(1984) ///
	  cigsale(1985) cigsale(1986) cigsale(1987) cigsale(1988), ///
	  trunit(3) trperiod(1989) fig keep(model2)
	  
graph export "/Users/jpmvbastos/Documents/GitHub/AppliedEconometrics/Causal Inference/HW2_SC/Graph2.png", /// 
		replace as(png) name("Graph")

/* 4. Do an in-time placebo. Assume that prop 9 passed in 1981 and use 82-88 for the treatment period. 
	Show your results. What is the composition of the syn. Control? 
	How do the indicator variables match up? What does the treatment effect look like? */

synth cigsale cigsale(1970) cigsale(1971) cigsale(1972) cigsale(1973) cigsale(1974) ///
	  cigsale(1975) cigsale(1976) cigsale(1977) cigsale(1978) cigsale(1979) ///
	  cigsale(1980) cigsale(1981), trunit(3) trperiod(1982) ///
	  resultsperiod(1970(1)1988) fig keep(model3)
		
		
graph export "/Users/jpmvbastos/Documents/GitHub/AppliedEconometrics/Causal Inference/HW2_SC/Graph3.png", /// 
		replace as(png) name("Graph")
		
		
/* 5.  Use the synthrunner module (from the resources page) and run placebos 
			to estimate p-values for the models in questions 2,3, and 4. */ 

*Using Synth-Runner
synth_runner cigsale lnincome age15to24 retprice beer(1984(1)1988) ///
		cigsale(1988) cigsale(1980) cigsale(1975), trunit(3) trperiod(1989)  gen_vars
effect_graphs, trlinediff(-1)
pval_graphs

drop pre_rmspe post_rmspe lead effect cigsale_synth

synth_runner cigsale cigsale(1970) cigsale(1971) cigsale(1972) cigsale(1973) cigsale(1974) ///
	  cigsale(1975) cigsale(1976) cigsale(1977) cigsale(1978) cigsale(1979) ///
	  cigsale(1980) cigsale(1981) cigsale(1982) cigsale(1983) cigsale(1984) ///
	  cigsale(1985) cigsale(1986) cigsale(1987) cigsale(1988), trunit(3) trperiod(1989)
effect_graphs, trlinediff(-1)
pval_graphs

drop pre_rmspe post_rmspe lead effect cigsale_synth

synth_runner cigsale cigsale(1970) cigsale(1971) cigsale(1972) cigsale(1973) cigsale(1974) ///
	  cigsale(1975) cigsale(1976) cigsale(1977) cigsale(1978) cigsale(1979) ///
	  cigsale(1980) cigsale(1981) cigsale(1982) cigsale(1983) cigsale(1984) ///
	  cigsale(1985) cigsale(1986) cigsale(1987) cigsale(1988), trunit(3) trperiod(1989)  
effect_graphs, trlinediff(-1)
pval_graphs

drop if year > 1988
synth_runner cigsale cigsale(1970) cigsale(1971) cigsale(1972) cigsale(1973) cigsale(1974) ///
	  cigsale(1975) cigsale(1976) cigsale(1977) cigsale(1978) cigsale(1979) ///
	  cigsale(1980) cigsale(1981), trunit(3) trperiod(1982) 
effect_graphs, trlinediff(-1)
pval_graphs
