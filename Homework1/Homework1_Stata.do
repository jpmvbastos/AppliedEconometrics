* Use the data_1.xlsx file

reg q p ps

* Box Cox Model / see: https://www.stata.com/manuals/rboxcox.pdf
boxcox q p ps, model(rhsonly) lrtest nolog

test p = -ps
testnl [Trans]p = -[Trans]ps


mlexp ((-1/2)*ln(2*_pi)-(1/2)*(q-{b1}-({b2}*(p^({lambda})-1))/({lambda})-({b3}*(ps^({lambda})-1))/({lambda}))^2), difficult

test /b2 + /b3 = 0
testnl /b2 + /b3 = 0


* Box Cox with different Lambdas

gen intercept=1

* See: https://www.stata.com/manuals/rmlexp.pdf

mlexp ((-1/2)*ln(2*_pi)-(1/2)*(q-{b1}-({b2}*(p^({lambda1})-1))/({lambda1})-({b3}*(ps^({lambda2})-1))/({lambda2}))^2), difficult

test /lambda1 = /lambda2


* Question 2 

* Data was generating using Python - see: https://github.com/jpmvbastos/AppliedEconometrics3/blob/da017b0fe15642fa97a956b381f795af5ecad320/Homework1.ipynb

* Use data_2.xlsx for replication

fmm 2: regress y x1 x2 
