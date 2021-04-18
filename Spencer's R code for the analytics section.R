# Spencer Marlen-Starr's R code for his Project Objective

getwd()
setwd('C:/Users/spenc/OneDrive/Documents/George Mason University/Spring 2021/CS 504/Group Project/My contributions')

# load the libraries I will need
library(plm)
library(tidyverse)
library(rstatix)
library(coin)
library(binaryLogic)
library(lubridate)
library(RMariaDB)


mysqldb.connStrfile<-"C:\\Users\\spenc\\OneDrive\\Documents\\George Mason University\\Spring 2021\\CS 504\\Group Project\\AWS\\passwd.txt"
mysqldb.db<-"SMIL"
dbConn <- dbConnect(RMariaDB::MariaDB(),default.file=mysqldb.connStrfile,group=mysqldb.db)

dbListTables(dbConn)


# import the half hourly table 
hhblocks <- dbGetQuery(dbConn, 
                       "
select hh1.day, hh2.numbSmMtrs, hh_0, hh_1, hh_2, hh_3, hh_4, hh_5, hh_6, hh_7, hh_8, hh_9, hh_10, hh_11, hh_12, hh_13, hh_14, hh_15, hh_16, hh_17, hh_18, hh_19, hh_20, hh_21, hh_22, hh_23, hh_24, hh_25, hh_26, hh_27, hh_28, hh_29, hh_30, hh_31, hh_32, hh_33, hh_34, hh_35, hh_36, hh_37, hh_38, hh_39, hh_40, hh_41, hh_42, hh_43, hh_44, hh_45, hh_46, hh_47
from 
(
    select day, sum(hh_0) as hh_0, sum(hh_1) as hh_1,  sum(hh_2) as hh_2,  sum(hh_3) as hh_3,  sum(hh_4) as hh_4,  sum(hh_5) as hh_5,  sum(hh_6) as hh_6,  sum(hh_7) as hh_7,  sum(hh_8) as hh_8,  sum(hh_9) as hh_9,  sum(hh_10) as hh_10,  sum(hh_11) as hh_11,  sum(hh_12) as hh_12,  sum(hh_13) as hh_13,  sum(hh_14) as hh_14,  sum(hh_15) as hh_15,  sum(hh_16) as hh_16,  sum(hh_17) as hh_17,  sum(hh_18) as hh_18,  sum(hh_19) as hh_19,  sum(hh_20) as hh_20,  sum(hh_21) as hh_21,  sum(hh_22) as hh_22,  sum(hh_23) as hh_23,  sum(hh_24) as hh_24,  sum(hh_25) as hh_25,  sum(hh_26) as hh_26,  sum(hh_27) as hh_27,  sum(hh_28) as hh_28,  sum(hh_29) as hh_29,  sum(hh_30) as hh_30,  sum(hh_31) as hh_31,  sum(hh_32) as hh_32,  sum(hh_33) as hh_33,  sum(hh_34) as hh_34,  sum(hh_35) as hh_35,  sum(hh_36) as hh_36,  sum(hh_37) as hh_37,  sum(hh_38) as hh_38,  sum(hh_39) as hh_39,  sum(hh_40) as hh_40,  sum(hh_41) as hh_41,  sum(hh_42) as hh_42,  sum(hh_43) as hh_43,  sum(hh_44) as hh_44,  sum(hh_45) as hh_45,  sum(hh_46) as hh_46,  sum(hh_47) as hh_47
    from hhblock
    group by day
) as hh1
left outer join
(
    select day, count(distinct LCLid) as numbSmMtrs
    from hhblock
    group by day
) as hh2
on hh1.day = hh2.day
;
"
)

head(hhblocks)
class(hhblocks)


# import the tariffs table
tariffs <- read.csv('Tariffs_table.csv')
str(tariffs)

# import the daily dataset table
dd <- dbGetQuery(dbConn, "select * from daily_dataset; ")
class(dd)
typeof(dd)
str(dd)
dd$day <- ymd(dd$day)
str(dd$day)
#dd$energy_median <- as.numeric(dd$energy_median)
#dd$energy_mean <- as.numeric(dd$energy_mean)
#dd$energy_max <- as.numeric(dd$energy_max)
#dd$energy_min <- as.numeric(dd$energy_min)
#dd$energy_std <- as.numeric(dd$energy_std)
#dd$energy_sum <- as.numeric(dd$energy_sum)
str(dd)


# import the household information table
h <- read.csv('Household_information_table.csv')
str(h)



# import a left join of the daily dataset and household
# information tables into RStudio as a data frame
dd_hi <- dbGetQuery(dbConn, "SELECT * FROM daily_dataset
LEFT JOIN informations_households 
ON daily_dataset.LCLid = informations_households.LCLid; ")
str(dd_hi)

# change the datetime column to a date column
dd_hi$day <- ymd(dd_hi$day)

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



# import the left join of the half hourly and household
# information tables

str(hh_hi)



# I got the value of the mean of the daily energy sum
# for the treatment group from an SQL query
avgdes_t <- 9.5
# Likewise for its standard deviation
stddes_t <- 8.08
# Sample size for all of the daily readings of the treatment group
n1 <- 706031
# I got the value of the mean of the daily energy sum
# for the control group from another SQL query
avgdes_c <- 10.28
# Same for its standard deviation
stddes_c <- 9.37
# Sample size for all of the daily readings of the control group
n2 <- 2804402

# manually perform a difference in means t-test on the daily energy sum
# for the treatment and control groups
dmdes = avgdes_t - avgdes_c
dmdes
# calculate the standard error 
se = sqrt(((stddes_t**2)/n1) + ((stddes_c**2)/n2))
se
t = dmdes/se
t
# -70.1 is statistically significant at any conceivable threshold. 


# Repeat the above process for the daily maximum energy
# usage to see if time of use pricing reduced the acuteness
# of peak daily energy consumption among Londoners.
avgmax_t <- 0.79    # mean max daily energy use in the treatment group 
stdmax_t <- 0.60    # the standard deviation of max energy use in a half hour period

# mean max daily energy use in the control group
avgmax_c <- 0.85
stdmax_c <- 0.68

# calculate the standard error
se2 = sqrt(((stdmax_t**2)/n1) + ((stdmax_c**2)/n2))
se2
# manually perform a difference in means t-test on the max daily energy
# use between the treatment and control groups
dm2 = avgmax_t - avgmax_c
dm2
t_max = dm2/se2
t_max
# -73.0 is statistically significant at any conceivable threshold. 


# also run a Wilcoxon Rank Sum Test on the sum of daily energy 
# use because the daily usage data appears to have 
# much more variation than a Gaussian distribution
attach(dd_hi)
wilcox.test(energy_sum ~ stdorToU, data = dd_hi, alternative = "greater")


# also run a Wilcoxon Rank Sum Test on the max amount of daily energy usage
wilcox.test(energy_max ~ stdorToU, data = dd_hi, alternative = "greater")


# calculate the Wilcoxon effect size of the difference
dd_hi %>% wilcox_effsize(energy_sum ~ stdorToU, paired = FALSE,
               alternative = "greater", mu = 0, ci = FALSE,
               conf.level = 0.95, ci.type = "perc", nboot = 1000)






# estimate a fixed effects regression of time of use with plm()
Acorn <- dd_hi$Acorn
Status <- dd_hi$Acorn_grouped
file <- dd_hi$file
entity_FEs <- c(Acorn, Status, file)
str(entity_FEs)

ToU_FE <- plm(formula = energy_sum ~ ToU_dummy + Affluent_dummy + Comfortable_dummy + 
                  Adversity_dummy + AcornU_dummy + AcornA_dummy + AcornB_dummy 
                  + AcornC_dummy + AcornD_dummy + AcornE_dummy + AcornF_dummy 
                  + AcornG_dummy + AcornH_dummy + AcornI_dummy + AcornJ_dummy 
                  + AcornK_dummy + AcornL_dummy + AcornM_dummy + AcornN_dummy 
                  + AcornO_dummy + AcornP_dummy + AcornQ_dummy, 
              data = dd_hi, index = "day", model = "within")
summary(ToU_FE)


# estimate a random effects regression model
attach(dd_hi)
ToU_RE <- plm(formula = energy_sum ~ ToU_dummy + Affluent_dummy + 
                  Comfortable_dummy + Adversity_dummy + AcornU_dummy + 
                  AcornA_dummy + AcornB_dummy + AcornC_dummy + AcornD_dummy +
                  AcornE_dummy + AcornF_dummy + AcornG_dummy + AcornH_dummy +
                  AcornI_dummy + AcornJ_dummy + AcornK_dummy + AcornL_dummy +
                  AcornM_dummy + AcornN_dummy + AcornO_dummy + AcornP_dummy +
                  AcornQ_dummy, data = dd_hi, index = "day", model = "random")
summary(ToU_RE)


# run a Hausman test to see whether I should use fixed effects or random effects
phtest(ToU_FE, ToU_RE)





