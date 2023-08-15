#devtools::install_github("https://github.com/jpmam1/easi", dependencies = TRUE)
setwd("P:/Demand")
rm(list = ls())
library(dplyr)
library(systemfit)
library(micEconAids)
library(easi)
easi_data <- data("hixdata")

shares <- hixdata[,2:10]
log.prices <- hixdata[,11:19]
demogr <- hixdata[,21:25]
log.exp <- hixdata[,20]
labels.demogr <- c("age", "gender", "own a car", "time", "gov transferts")
labels.shares <- c("food in", "food out", "rent", "operations", "furnishing", "clothes", "transport", "recreation")

easi_model <- easi(shares = shares, log.price = log.prices, var.soc = demogr,
                   y.power = 5, log.exp = log.exp, labels.share = labels.shares, 
                   labels.soc = labels.demogr, py.inter = TRUE, zy.inter = TRUE,
                   pz.inter = TRUE, interpz = c(1:ncol(demogr)))


easi_elast_price <- elastic(easi_model, type = "price", sd = TRUE)
easi_elast_income <- elastic(easi_model, type = "income", sd = TRUE)


easi_elast_table <- data.frame("Estimates" = easi_elast_price$ELASTPRICE,
                              "Std error" = easi_elast_price$ELASTPRICE_SE,
                              "t-value"   = easi_elast_price$ELASTPRICE/easi_elast_price$ELASTPRICE_SE)

engel_curves <- engel(easi_model, file = 'graph_engels_curves', sd = TRUE)
