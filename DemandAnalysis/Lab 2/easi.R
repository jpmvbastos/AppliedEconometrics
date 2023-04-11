# WORK IN PROGRESS, NOT COMPLETE

# Install required packages
# install.packages("midEconAids")
# install.packages("easi")
# install.packages("devtools")
# devtools::install_github("https://github.com.jpmam1/easi", dependencies=TRUE)

library(dplyr)
library(systemfit)
library(devtools)
library(micEconAids)
library(easi)

hixdata <- data("hixdata")

shares <- hixdata[,2:10]
log.prices <- hixdata[,11:19]
demog <- hixdata[,21:25]
log.exp <- hixdata[,20]
labels.demog <- c("age","gender","own a car","time","gov transfers")
labels.shares<- c("food in", "food out","rent","operations","furnishings","clothes","transport","recreation")

easi_model <- easi(shares = shares, log.price = log.prices, var.soc = demog,
                    y.power = 5, log.exp = log.exp, labels.share - labels.shares,
                     labels.soc = labels.demog, py.inter=TRUE, zy.inter = TRUE)
                     
                     
# py.inter includes interactions between prices and expenditure shares 
# zy.inter includes interactions between demographics and the expenditure shares (e.g. expenditures depends on Age)
# pz.inter includes interactions between price and demographics
