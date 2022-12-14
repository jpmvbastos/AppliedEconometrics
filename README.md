# Applied Econometrics 3
 
This repository contains codes for projects and homeworks for Applied Econometrics 3 (AAEC6317) course at Texas Tech University. 

## Labs

[MonteCarlo_Simulations.ipynb](https://github.com/jpmvbastos/AppliedEconometrics3/blob/main/MonteCarlo_Simulations.ipynb) applies common econometrics techniques to data generating processes under the standard assumptions for Gauss-Markov theorem, as well as when those are violated: endogeneity, heteroskedasticity, auto-correlation.

[Maximum_Likelihood.do](https://github.com/jpmvbastos/AppliedEconometrics/blob/main/Labs/Maximum_Likelihood.do) implements maximum likelihood estimators (multinomial logit ```mlogit```, conditional logit ```asclogit```, and nested logit ```nlogit```) using Stata and the [Fishing.xls](https://github.com/jpmvbastos/AppliedEconometrics/blob/main/Labs/Fishing.xls) dataset.

[GMM.do](https://github.com/jpmvbastos/AppliedEconometrics/blob/main/Labs/GMM.do) includes examples for application of Generalized Method of Moments estimator, using Stata's ```gmm```. 


## [Homework 1](https://github.com/jpmvbastos/AppliedEconometrics3/tree/main/Homework1)
[Homework1.ipynb](https://github.com/jpmvbastos/AppliedEconometrics3/blob/main/Homework1/Homework1.ipynb) applies Maximum Likelihood techniques to different data generating processes, also relying on Stata for some estimations. The file [Homework1.do](https://github.com/jpmvbastos/AppliedEconometrics3/blob/main/Homework1/Homework1.ipynb) has the replication code for Stata, which includes:
- Estimation of Box-Cox demand using ```boxcox```, and using the user-inputed expression method for Maximum Likelihood Estimation (```mlexp```). 
- Finite Mixture Models: ```fmm```.

Replication data: 

Question 1: [data_1.xlsx](https://github.com/jpmvbastos/AppliedEconometrics3/blob/main/Homework1/data_1.xlsx).

Question 2: [data_2.xlsx](https://github.com/jpmvbastos/AppliedEconometrics3/blob/main/Homework1/data_2.xlsx).

## [Homework 2](https://github.com/jpmvbastos/AppliedEconometrics3/tree/main/Homework2)

Maximum Likelihood estimations with marginal effects in Stata for discrete choice models and censored regressions, including: 
- Multinomial Logit using ```mlogit```
- Alternative-specific conditional logit using ```asclogit```
- Nested logit using ```nlogit```
- Truncated and censored regressions under a variety of functional forms using ```tobit```,```truncreg```, ```nbreg```, and ```poisson```.
- Heckman's selection model using ```heckman```

The assignment and related datasets are described in [Homework.pdf](https://github.com/jpmvbastos/AppliedEconometrics/blob/main/Homework2/Homework2.pdf)