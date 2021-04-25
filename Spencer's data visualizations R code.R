# Spencer's R code for the data visualization part of the group project


getwd()
setwd('C:/Users/spenc/OneDrive/Documents/George Mason University/Spring 2021/CS 504/Group Project/My contributions')

# load the libraries I will need
library(tidyverse)
library(dplyr)
library(lubridate)
library(RMariaDB)
library(ggplot2)



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
on hh1.day = hh2.day;")

head(hhblocks)
class(hhblocks)

    
    
    
# create a Q-Q plot of the daily_dataset for the energy_sum versus
# whether a house is on time of use pricing or not
qqplot(dd_hi$energy_sum[dd_hi$ToU_dummy == 1],
       dd_hi$energy_sum[dd_hi$ToU_dummy == 0],
       xlab = 'Houses on Dynamic Time of Use Energy Rate',
       ylab = 'Houses on the Standard Flat Energy Rate',
       main = 'Q-Q Plot of Total Daily Energy Usage vs Time of Use Pricing') 

#create a Q-Q plot of the distribution of the energy_sum column in the 
# daily_dataset table for houses on time of use pricing 
# versus the Normal distribution
qqnorm(dd_hi$energy_sum[dd_hi$ToU_dummy == 1],
       xlab = 'Theoretical Standard Gaussian Quantiles',
       ylab = 'Sample Quantiles', 
main = 'Q-Q Plot of the Distribution of energy_sum for ToU Houses vs a Gaussian')
qqline(dd_hi$energy_sum[dd_hi$ToU_dummy == 1])

#create a Q-Q plot of the distribution of the energy_sum column in the 
# daily_dataset table for houses on flat rate pricing 
# versus the standard "Normal" distribution
qqnorm(dd_hi$energy_sum[dd_hi$ToU_dummy == 0],
       xlab = 'Theoretical Standard "Gaussian Quantiles',
       ylab = 'Sample Quantiles', 
       main = 'Q-Q Plot of the Distribution of energy_sum for Std Houses vs a Gaussian')
qqline(dd_hi$energy_sum[dd_hi$ToU_dummy == 0])
