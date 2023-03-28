# Applied Econometrics 
 
This repository contains codes for projects and homeworks for courses Applied Econometrics 3 (AAEC6317) and Demand and Price Analysis (AAEC63) at Texas Tech University. 

### General Files

[MonteCarlo_Simulations.ipynb](https://github.com/jpmvbastos/AppliedEconometrics/blob/main/MonteCarlo_Simulations.ipynb) applies common econometrics techniques to data generating processes under the standard assumptions for Gauss-Markov theorem, as well as when those are violated: endogeneity, heteroskedasticity, auto-correlation.

## Applied Econometrics III

### Labs

[Maximum_Likelihood.do](https://github.com/jpmvbastos/AppliedEconometrics/blob/main/Labs/Maximum_Likelihood.do) implements maximum likelihood estimators (multinomial logit ```mlogit```, conditional logit ```asclogit```, and nested logit ```nlogit```) using Stata and the [Fishing.xls](https://github.com/jpmvbastos/AppliedEconometrics/blob/main/Labs/Fishing.xls) dataset.

[GMM.do](https://github.com/jpmvbastos/AppliedEconometrics/blob/main/Labs/GMM.do) includes examples for application of Generalized Method of Moments estimator, using Stata's ```gmm```. 


### [Homework 1](https://github.com/jpmvbastos/AppliedEconometrics3/tree/main/Homework1)
[Homework1.ipynb](https://github.com/jpmvbastos/AppliedEconometrics3/blob/main/Homework1/Homework1.ipynb) applies Maximum Likelihood techniques to different data generating processes, also relying on Stata for some estimations. The file [Homework1.do](https://github.com/jpmvbastos/AppliedEconometrics3/blob/main/Homework1/Homework1.ipynb) has the replication code for Stata, which includes:
- Estimation of Box-Cox demand using ```boxcox```, and using the user-inputed expression method for Maximum Likelihood Estimation (```mlexp```). 
- Finite Mixture Models: ```fmm```.

Replication data: 

Question 1: [data_1.xlsx](https://github.com/jpmvbastos/AppliedEconometrics3/blob/main/Homework1/data_1.xlsx).

Question 2: [data_2.xlsx](https://github.com/jpmvbastos/AppliedEconometrics3/blob/main/Homework1/data_2.xlsx).

### [Homework 2](https://github.com/jpmvbastos/AppliedEconometrics3/tree/main/Homework2)

Maximum Likelihood estimations with marginal effects in Stata for discrete choice models and censored regressions, including: 
- Multinomial Logit using ```mlogit```
- Alternative-specific conditional logit using ```asclogit```
- Nested logit using ```nlogit```
- Truncated and censored regressions under a variety of functional forms using ```tobit```,```truncreg```, ```nbreg```, and ```poisson```.
- Heckman's selection model using ```heckman```

The assignment and related datasets are described in [Homework.pdf](https://github.com/jpmvbastos/AppliedEconometrics/blob/main/Homework2/Homework2.pdf)

### [Homework 3](https://github.com/jpmvbastos/AppliedEconometrics3/tree/main/Homework3)

Includes exercises in Time Series using Python and Matlab. 

Using Matlab:
- A simple attempt to replicate the CKLS model from [Chan et al. (1992)](https://onlinelibrary.wiley.com/doi/10.1111/j.1540-6261.1992.tb04011.x).

Using Python: 
- Basic autocorrelation and stationariety analysis (Dickey-Fuller, Ljung-Box, etc.)
- Autoressive (AR) models 
- Conditional Heteroskedasticity models (ARCH, GARCH)

### [Term Project](https://github.com/jpmvbastos/AppliedEconometrics3/tree/main/TermProject)

A rought draft where I use Fixed Effects and Maximum Likelihood Estimators to investigate whether corruption is more harmful to female-led businesses.

Using firm-level data from the World Bank Enterprise Surveys with around 130,000 observations in 133 countries, I ask whether female businesses are more likely to pay bribes and whether they report corruption as a bigger obstacle than their male counterparts. 


## Demand and Price Analysis

### [Lab1]()

Estimates demand models using Stata's ```nlsur``` (Non-Linear Seemingly Unrelated Regression) function.
- [Code]()
- [Data]()


