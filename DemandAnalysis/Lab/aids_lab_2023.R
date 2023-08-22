setwd("E:/Demand")
rm(list = ls())
library(dplyr)
library(systemfit)
library(micEconAids)

# Read data
data = read.csv("labdata_2023.csv")
data$Exp = data$p1*data$q1 + data$p2*data$q2 + data$p3*data$q3 + data$p4*data$q4

data$w1 = data$p1*data$q1/data$Exp
data$w2 = data$p2*data$q2/data$Exp
data$w3 = data$p3*data$q3/data$Exp
data$w4 = data$p4*data$q4/data$Exp

prices_means <- colMeans(data[, c("p1" , "p2", "p3", 'p4')])
shares_means <- colMeans(data[, c("w1" , "w2", "w3", "w4")])
exp_mean <- mean(data[,"Exp"])

# LA-AIDS- Stone Index
la_aids_S = aidsEst(c("p1", "p2", "p3", "p4"), c("w1", "w2", "w3", "w4"), "Exp", data = data, priceIndex = "S")
summary(la_aids_S)

la_elast_S <- elas(la_aids_S, method = "B1")

# # LA-AIDS- Stone Index- Lagged shares
la_aids_SL = aidsEst(c("p1", "p2", "p3", "p4"), c("w1", "w2", "w3", "w4"), "Exp", data = data, priceIndex = "SL")
summary(la_aids_SL)

la_elast_SL <- elas(la_aids_SL, method = "B1")

# LA-AIDS 3SLS. Use logged prices and logged expenditure as IV
data$lnp1 = log(data$p1)
data$lnp2 = log(data$p2)
data$lnp3 = log(data$p3)
data$lnp4 = log(data$p4)
data$lnexp = log(data$Exp)
IV <- c("lnp1", "lnp2", "lnp3", "lnp4", "lnexp")

la_aids_3SLS = aidsEst(c("p1", "p2", "p3", "p4"), c("w1", "w2", "w3", "w4"), "Exp", 
                       data = data,instNames = IV,  priceIndex = "S")
summary(la_aids_3SLS)

la_elast_3SLS <- elas(la_aids_3SLS, method = "B1")

aid_elast_3sls <- aidsElas(coef(la_aids_3SLS), prices = prices_means, 
                           shares = shares_means, coefCov = vcov(la_aids_3SLS), df = df.residual(la_aids_3SLS))

# LA-AIDS- Paasche Price index
la_aids_P = aidsEst(c("p1", "p2", "p3", "p4"), c("w1", "w2", "w3", "w4"), "Exp", data = data, priceIndex = "P")
summary(la_aids_P)

la_elast_P <- elas(la_aids_P, method = "B1")

# LA-AIDS- Laspeyres Price index
la_aids_L = aidsEst(c("p1", "p2", "p3", "p4"), c("w1", "w2", "w3","w4"), "Exp", data = data, priceIndex = "L")
summary(la_aids_L)

la_elast_L <- elas(la_aids_L, method = "B1")

# LA-AIDS- Tornqvist Price index
la_aids_T = aidsEst(c("p1", "p2", "p3", "p4"), c("w1", "w2", "w3", "w4"), "Exp", data = data, priceIndex = "T")
summary(la_aids_T)

la_elast_T <- elas(la_aids_T, method = "B1")

# Full AIDS model

aids <- aidsEst(c("p1", "p2", "p3", "p4"), c("w1", "w2", "w3", "w4"), "Exp", data = data, method = "IL")
summary(aids)

aids_elast <- elas(aids)
aid_elast_v <- aidsElas(coef(aids), prices = prices_means, shares = shares_means, coefCov = vcov(aids), df = df.residual(aids))
summary(aid_elast_v)
