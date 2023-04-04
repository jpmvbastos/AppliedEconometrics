#### WORK IN PROGRESS - INCOMPLETE ####
This code applies the Almost Ideal Demand System (AIDS) 
using R. 
########

install.packages("midEconAids")

library()
library(micEconAids)

data = read.csv("labdata_2023.csv")
view(data)

data$Exp = data$p1*data$q1 + data$p2*data$q2 + data$p3*data$q3 + data$p4*data$q4

data$w1 = data$p1*data$q1 / data$Exp
data$w2 = data$p2*data$q2 / data$Exp
data$w3 = data$p3*data$q3 / data$Exp
data$w4 = data$p4*data$q4 / data$Exp

price_m = colMeans(data[, c("p1","p2","p3","p4")])
shares_m = colMeans(data[, c("w1","w2","w3","w4")])
