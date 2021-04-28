# Spencer Marlen-Starr's R code for his Project Objective

getwd()
setwd('C:/Users/spenc/OneDrive/Documents/George Mason University/Spring 2021/CS 504/Group Project/My contributions')

# load the libraries I will need
library(plm)
library(tidyverse)
library(rstatix)
library(fBasics)
library(coin)
library(lubridate)
library(RMariaDB)


mysqldb.connStrfile<-"C:\\Users\\spenc\\OneDrive\\Documents\\George Mason University\\Spring 2021\\CS 504\\Group Project\\AWS\\passwd.txt"
mysqldb.db<-"SMIL"
dbConn <- dbConnect(RMariaDB::MariaDB(),default.file=mysqldb.connStrfile,group=mysqldb.db)

dbListTables(dbConn)






# import the daily dataset table
dd <- dbGetQuery(dbConn, "select * from daily_dataset; ")
class(dd)
typeof(dd)
str(dd)
dd$day <- ymd(dd$day)
str(dd$day)
str(dd)


# import the household information table
hi <- dbGetQuery(dbConn, "SELECT * FROM informations_households; ")
str(hi)



# import a left join of the daily dataset and household
# information tables into RStudio as a data frame
dd_hi <- dbGetQuery(dbConn, "SELECT * FROM daily_dataset
LEFT JOIN informations_households 
ON daily_dataset.LCLid = informations_households.LCLid; ")

str(dd_hi)

# change the datetime column to a date column
dd_hi$day <- ymd(dd_hi$day)

# add a numerical ID column
dd_hi$id <- substr(dd_hi$LCLid, 4, 9)
dd_hi$id

# add a dummy variable column for time of use houses
dd_hi$ToU_dummy <- ifelse(dd_hi$stdorToU == "ToU", 1, 0)

# add a dummy variable for affluent households
dd_hi$Affluent_dummy <- ifelse(dd_hi$Acorn_grouped == "Affluent", 1, 0)
# add a dummy variable for comfortable households
dd_hi$Comfortable_dummy <- ifelse(dd_hi$Acorn_grouped == "Comfortable", 1, 0)
# add a dummy variable for households facing financial adversity
dd_hi$Adversity_dummy <- ifelse(dd_hi$Acorn_grouped == "Adversity", 1, 0)
# add a dummy variable for households in the Acorn group "Acorn-U"
dd_hi$AcornU_dummy <- ifelse(dd_hi$Acorn_grouped == "ACORN-U", 1, 0)

# add a dummy variable for households in the Acorn-E
dd_hi$AcornE_dummy <- ifelse(dd_hi$Acorn == "ACORN-E", 1, 0)
# add a dummy variable for households in the Acorn-N
dd_hi$AcornN_dummy <- ifelse(dd_hi$Acorn == "ACORN-N", 1, 0)
# add a dummy variable for households in the Acorn-H
dd_hi$AcornH_dummy <- ifelse(dd_hi$Acorn == "ACORN-H", 1, 0)
# add a dummy variable for households in the Acorn-P
dd_hi$AcornP_dummy <- ifelse(dd_hi$Acorn == "ACORN-P", 1, 0)
# add a dummy variable for households in the Acorn-F
dd_hi$AcornF_dummy <- ifelse(dd_hi$Acorn == "ACORN-F", 1, 0)
# add a dummy variable for households in the Acorn-K
dd_hi$AcornK_dummy <- ifelse(dd_hi$Acorn == "ACORN-K", 1, 0)
# add a dummy variable for households in the Acorn-Q
dd_hi$AcornQ_dummy <- ifelse(dd_hi$Acorn == "ACORN-Q", 1, 0)
# add a dummy variable for households in the Acorn-I
dd_hi$AcornI_dummy <- ifelse(dd_hi$Acorn == "ACORN-I", 1, 0)
# add a dummy variable for households in the Acorn-L
dd_hi$AcornL_dummy <- ifelse(dd_hi$Acorn == "ACORN-L", 1, 0)
# add a dummy variable for households in the Acorn-D
dd_hi$AcornD_dummy <- ifelse(dd_hi$Acorn == "ACORN-D", 1, 0)
# add a dummy variable for households in the Acorn-J
dd_hi$AcornJ_dummy <- ifelse(dd_hi$Acorn == "ACORN-J", 1, 0)
# add a dummy variable for households in the Acorn-O
dd_hi$AcornO_dummy <- ifelse(dd_hi$Acorn == "ACORN-O", 1, 0)
# add a dummy variable for households in the Acorn-A
dd_hi$AcornA_dummy <- ifelse(dd_hi$Acorn == "ACORN-A", 1, 0)
# add a dummy variable for households in the Acorn-B
dd_hi$AcornB_dummy <- ifelse(dd_hi$Acorn == "ACORN-B", 1, 0)
# add a dummy variable for households in the Acorn-C
dd_hi$AcornC_dummy <- ifelse(dd_hi$Acorn == "ACORN-C", 1, 0)
# add a dummy variable for households in the Acorn-M
dd_hi$AcornM_dummy <- ifelse(dd_hi$Acorn == "ACORN-M", 1, 0)
# add a dummy variable for households in the Acorn-G
dd_hi$AcornG_dummy <- ifelse(dd_hi$Acorn == "ACORN-G", 1, 0)

str(dd_hi)
categories <- unique(dd_hi$Acorn_grouped) 
categories
categories2 <- unique(dd_hi$Acorn)
categories2
categories3 <- unique(dd_hi$file)
categories3





dd_hi_ToU <- dbGetQuery(dbConn, "SELECT * FROM daily_dataset
LEFT JOIN informations_households ON daily_dataset.LCLid = informations_households.LCLid
WHERE informations_households.stdorToU = 'ToU' AND energy_sum IS NOT NULL; ")
class(dd_hi_ToU)

median(dd_hi_ToU$energy_sum)
median(dd_hi_ToU$energy_max)
kurtosis(dd_hi_ToU$energy_sum, na.rm = FALSE, method = c("excess", "moment", "fisher"))
kurtosis(dd_hi_ToU$energy_sum)
kurtosis(dd_hi_ToU$energy_max)


dd_hi_Std <- dbGetQuery(dbConn, "SELECT * FROM daily_dataset
LEFT JOIN informations_households ON daily_dataset.LCLid = informations_households.LCLid
WHERE informations_households.stdorToU = 'Std' AND energy_sum IS NOT NULL; ")
class(dd_hi_Std)

median(dd_hi_Std$energy_sum)
median(dd_hi_Std$energy_max)
kurtosis(dd_hi_Std$energy_sum)
kurtosis(dd_hi_Std$energy_max)







 


# also run a Wilcoxon Rank Sum Test on the sum of daily energy 
# use because the daily usage data appears to have 
# much more variation than a Gaussian distribution
attach(dd_hi)
wilcox.test(energy_sum ~ stdorToU, mu = 0, alternative = "greater", 
            conf.int = T, paired = FALSE)

wilcox.test(energy_sum ~ stdorToU, mu = 0, alternative = "less", 
            conf.int = TRUE, paired = F)

# calculate the Wilcoxon effect size of the difference
dd_hi %>% wilcox_effsize(energy_sum ~ stdorToU, paired = FALSE,
                         alternative = "greater", mu = 0, ci = FALSE,
                         conf.level = 0.95, ci.type = "perc", nboot = 1000)


# also run a Wilcoxon Rank Sum Test on the max amount of daily energy usage
wilcox.test(energy_max ~ stdorToU, data = dd_hi, alternative = "greater")

wilcox.test(energy_max ~ stdorToU, mu = 0, alternative = "greater",
            conf.int = TRUE, paired = FALSE)

# calculate the Wilcoxon effect size of the difference
dd_hi %>% wilcox_effsize(energy_max ~ stdorToU, paired = FALSE,
               alternative = "greater", mu = 0, ci = FALSE,
               conf.level = 0.95, ci.type = "perc", nboot = 1000)






# estimate a fixed effects regression of the impacts of time of use
# energy pricing on total daily energy use with plm()
# Status <- cbind(Affluent_dummy, Comfortable_dummy, Adversity_dummy, AcornU_dummy)
# Acorn <- cbind(AcornA_dummy, AcornB_dummy, AcornC_dummy, AcornD_dummy, AcornE_dummy,
# AcornF_dummy, AcornG_dummy, AcornH_dummy, AcornI_dummy, AcornJ_dummy, AcornK_dummy,
# AcornL_dummy, AcornM_dummy, AcornN_dummy, AcornO_dummy, AcornP_dummy, AcornQ_dummy)
# file <- dd_hi$file
# entity_FEs <- cbind(Status, Acorn)
# str(entity_FEs)
# head(entity_FEs)

dd_hi2 <- dd_hi[, c(2:9, 12:37)]
head(dd_hi2)
str(dd_hi2)
attach(dd_hi2)
Total_Energy_FE <- plm(formula = energy_sum ~ ToU_dummy + Affluent_dummy + Comfortable_dummy + 
                  Adversity_dummy + AcornA_dummy + AcornB_dummy 
                  + AcornC_dummy + AcornD_dummy + AcornE_dummy + AcornF_dummy 
                  + AcornG_dummy + AcornH_dummy + AcornI_dummy + AcornJ_dummy 
                  + AcornK_dummy + AcornL_dummy + AcornM_dummy + AcornN_dummy 
                  + AcornO_dummy + AcornP_dummy + AcornQ_dummy, 
                   data = dd_hi2, model = "within", index = "day")
summary(Total_Energy_FE)


Total_Energy_FE2 <- plm(formula = energy_sum ~ ToU_dummy + Affluent_dummy + Comfortable_dummy + 
                            Adversity_dummy + AcornA_dummy + AcornB_dummy + AcornC_dummy + AcornD_dummy + AcornE_dummy + AcornF_dummy + AcornG_dummy + AcornH_dummy + AcornI_dummy + AcornJ_dummy 
                        + AcornK_dummy + AcornL_dummy + AcornM_dummy + AcornN_dummy 
                        + AcornO_dummy + AcornP_dummy + AcornQ_dummy, 
                        data = dd_hi2, model = "within", index = c("id", "day"))
summary(TTotal_Energy_FE2)




Total_Energy_RE <- plm(formula = energy_sum ~ ToU_dummy + Affluent_dummy + Comfortable_dummy + 
                           Adversity_dummy + AcornA_dummy + AcornB_dummy 
                       + AcornC_dummy + AcornD_dummy + AcornE_dummy + AcornF_dummy 
                       + AcornG_dummy + AcornH_dummy + AcornI_dummy + AcornJ_dummy 
                       + AcornK_dummy + AcornL_dummy + AcornM_dummy + AcornN_dummy 
                       + AcornO_dummy + AcornP_dummy + AcornQ_dummy, 
                       data = dd_hi2, model = "random", index = "day")
summary(Total_Energy_RE)




Total_Energy_RE2 <- plm(formula = energy_sum ~ ToU_dummy + Affluent_dummy + Comfortable_dummy + 
                           Adversity_dummy + AcornA_dummy + AcornB_dummy + AcornC_dummy + AcornD_dummy + AcornE_dummy + AcornF_dummy + AcornG_dummy + AcornH_dummy + AcornI_dummy + AcornJ_dummy 
                       + AcornK_dummy + AcornL_dummy + AcornM_dummy + AcornN_dummy 
                       + AcornO_dummy + AcornP_dummy + AcornQ_dummy, 
                       data = dd_hi2, model = "random", index = c("id", "day"))
summary(Total_Energy_RE2)


# run a Hausman test to see whether I should use fixed effects or random effects
phtest(Total_Energy_FE, Total_Energy_RE)






# fun an FE and a RE on the data but with energy_max as the dependent variable 
EnergyMax_FE <- plm(formula = energy_max ~ ToU_dummy + Affluent_dummy + Comfortable_dummy + 
                        Adversity_dummy + AcornA_dummy + AcornB_dummy 
                    + AcornC_dummy + AcornD_dummy + AcornE_dummy + AcornF_dummy 
                    + AcornG_dummy + AcornH_dummy + AcornI_dummy + AcornJ_dummy 
                    + AcornK_dummy + AcornL_dummy + AcornM_dummy + AcornN_dummy 
                    + AcornO_dummy + AcornP_dummy + AcornQ_dummy, 
                    data = dd_hi2, model = "within", index = "day")
summary(EnergyMax_FE)

rm(Total_Energy_FE)


# estimate a random effects regression model
attach(dd_hi2)

EnergyMax_RE <- plm(formula = energy_max ~ ToU_dummy + Affluent_dummy + 
                  Comfortable_dummy + Adversity_dummy + 
                  AcornA_dummy + AcornB_dummy + AcornC_dummy + AcornD_dummy +
                  AcornE_dummy + AcornF_dummy + AcornG_dummy + AcornH_dummy +
                  AcornI_dummy + AcornJ_dummy + AcornK_dummy + AcornL_dummy +
                  AcornM_dummy + AcornN_dummy + AcornO_dummy + AcornP_dummy +
                  AcornQ_dummy, data = dd_hi2, index = "day", model = "random")
summary(EnergyMax_RE)



EnergyMax_RE2 <- plm(formula = energy_max ~ ToU_dummy + Affluent_dummy + Comfortable_dummy + 
                        Adversity_dummy + AcornA_dummy + AcornB_dummy 
                    + AcornC_dummy + AcornD_dummy + AcornE_dummy + AcornF_dummy 
                    + AcornG_dummy + AcornH_dummy + AcornI_dummy + AcornJ_dummy 
                    + AcornK_dummy + AcornL_dummy + AcornM_dummy + AcornN_dummy 
                    + AcornO_dummy + AcornP_dummy + AcornQ_dummy, 
                    data = dd_hi2, model = "random", index = c("id", "day"))
summary(EnergyMax_RE2)


# run a Hausman test to see whether I should use fixed effects or random effects
phtest(EnergyMax_FE, EnergyMax_RE)





