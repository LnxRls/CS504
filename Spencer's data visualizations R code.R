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



# import a left join of the daily dataset and household
# information tables into RStudio as a data frame
dd_hi <- dbGetQuery(dbConn, "SELECT * FROM daily_dataset
LEFT JOIN informations_households ON daily_dataset.LCLid = informations_households.LCLid
WHERE day BETWEEN '2013-01-01' AND '2013-12-31'; ")

# change the datetime column to a date column
dd_hi$day <- ymd(dd_hi$day)

# add a numerical ID column
dd_hi$id <- substr(dd_hi$LCLid, 4, 9)
dd_hi$id

# add a dummy variable column for time of use houses
dd_hi$ToU_dummy <- ifelse(dd_hi$stdorToU == "ToU", 1, 0)

str(dd_hi)




# import the half hourly table 
hhblocks_avg <- dbGetQuery(dbConn, 
" select hh1.day, hh2.numbSmMtrs, hh_0/numbSmMtrs as mean_hh0, hh_1/numbSmMtrs as mean_hh1, hh_2/numbSmMtrs as mean_hh2, hh_3/numbSmMtrs as mean_hh3, hh_4/numbSmMtrs as mean_hh4, hh_5/numbSmMtrs as mean_hh5, hh_6/numbSmMtrs as mean_hh6, hh_7/numbSmMtrs as mean_hh7, hh_8/numbSmMtrs as mean_hh8, hh_9/numbSmMtrs as mean_hh9, hh_10/numbSmMtrs as mean_hh10, hh_11/numbSmMtrs as mean_hh11, hh_12/numbSmMtrs as mean_hh12, hh_13/numbSmMtrs as mean_hh13, hh_14/numbSmMtrs as mean_hh14, hh_15/numbSmMtrs as mean_hh15, hh_16/numbSmMtrs as mean_hh16, hh_17/numbSmMtrs as mean_hh17, hh_18/numbSmMtrs as mean_hh18, hh_19/numbSmMtrs as mean_hh19, hh_20/numbSmMtrs as mean_hh20, hh_21/numbSmMtrs as mean_hh21, hh_22/numbSmMtrs as mean_hh22, hh_23/numbSmMtrs as mean_hh23, hh_24/numbSmMtrs as mean_hh24, hh_25/numbSmMtrs as mean_hh25, hh_26/numbSmMtrs as mean_hh26, hh_27/numbSmMtrs as mean_hh27, hh_28/numbSmMtrs as mean_hh28, hh_29/numbSmMtrs as mean_hh29, hh_30/numbSmMtrs as mean_hh30, hh_31/numbSmMtrs as mean_hh31, hh_32/numbSmMtrs as mean_hh32, hh_33/numbSmMtrs as mean_hh33, hh_34/numbSmMtrs as mean_hh34, hh_35/numbSmMtrs as mean_hh35, hh_36/numbSmMtrs as mean_hh36, hh_37/numbSmMtrs as mean_hh37, hh_38/numbSmMtrs as mean_hh38, hh_39/numbSmMtrs as mean_hh39, hh_40/numbSmMtrs as mean_hh40, hh_41/numbSmMtrs as mean_hh41, hh_42/numbSmMtrs as mean_hh42, hh_43/numbSmMtrs as mean_hh43, hh_44/numbSmMtrs as mean_hh44, hh_45/numbSmMtrs as mean_hh45, hh_46/numbSmMtrs as mean_hh46, hh_47/numbSmMtrs as mean_hh47
from (select day, round(sum(hh_0),1) as hh_0, round(sum(hh_1),1) as hh_1,  round(sum(hh_2),1) as hh_2,  round(sum(hh_3),1) as hh_3,  round(sum(hh_4),1) as hh_4,  round(sum(hh_5),1) as hh_5,  round(sum(hh_6),1) as hh_6,  round(sum(hh_7),1) as hh_7,  round(sum(hh_8),1) as hh_8,  round(sum(hh_9),1) as hh_9,  round(sum(hh_10),1) as hh_10,  round(sum(hh_11),1) as hh_11,  round(sum(hh_12),1) as hh_12,  round(sum(hh_13),1) as hh_13, round(sum(hh_14),1) as hh_14,  round(sum(hh_15),1) as hh_15,  round(sum(hh_16),1) as hh_16,  round(sum(hh_17),1) as hh_17,  round(sum(hh_18),1) as hh_18,  round(sum(hh_19),1) as hh_19,  round(sum(hh_20),1) as hh_20,  round(sum(hh_21),1) as hh_21,  round(sum(hh_22),1) as hh_22,  round(sum(hh_23),1) as hh_23,  round(sum(hh_24),1) as hh_24,  round(sum(hh_25),1) as hh_25,  round(sum(hh_26),1) as hh_26,  round(sum(hh_27),1) as hh_27,  round(sum(hh_28),1) as hh_28,  round(sum(hh_29),1) as hh_29,  round(sum(hh_30),1) as hh_30,  round(sum(hh_31),1) as hh_31,  round(sum(hh_32),1) as hh_32,  round(sum(hh_33),1) as hh_33,  round(sum(hh_34),1) as hh_34,  round(sum(hh_35),1) as hh_35,  round(sum(hh_36),1) as hh_36,  round(sum(hh_37),1) as hh_37,  round(sum(hh_38),1) as hh_38,  round(sum(hh_39),1) as hh_39,  round(sum(hh_40),1) as hh_40,  round(sum(hh_41),1) as hh_41,  round(sum(hh_42),1) as hh_42,  round(sum(hh_43),1) as hh_43,  round(sum(hh_44),1) as hh_44,  round(sum(hh_45),1) as hh_45,  round(sum(hh_46),1) as hh_46,  round(sum(hh_47),1) as hh_47
    from hhblock
    group by day
) as hh1
left outer join
(select day, count(distinct LCLid) as numbSmMtrs
    from hhblock
    group by day) as hh2
on hh1.day = hh2.day
where hh1.day between '2013-01-01' and '2013-12-31'; ")

head(hhblocks_avg)
tail(hhblocks_avg)
class(hhblocks_avg)
typeof(hhblocks_avg)
str(hhblocks_avg)
nrow(hhblocks_avg)
ncol(hhblocks_avg)
dim(hhblocks_avg)
length(hhblocks_avg)

# change the datetime column to a date column
hhblocks_avg$day <- ymd(hhblocks_avg$day)
str(hhblocks_avg)




mean_t_0 <- mean(hhblocks_avg$mean_hh0)
mean_t_0

mean_1200am <- mean(hhblocks_avg$mean_hh0)
mean_1200am
mean_1230am <- mean(hhblocks_avg$mean_hh1)
mean_1am <- mean(hhblocks_avg$mean_hh2)
mean_130am <- mean(hhblocks_avg$mean_hh3)
mean_2am <- mean(hhblocks_avg$mean_hh4)
mean_230am <- mean(hhblocks_avg$mean_hh5)
mean_3am <- mean(hhblocks_avg$mean_hh6)
mean_330am <- mean(hhblocks_avg$mean_hh7)
mean_4am <- mean(hhblocks_avg$mean_hh8)
mean_430am <- mean(hhblocks_avg$mean_hh9)
mean_5am <- mean(hhblocks_avg$mean_hh10)
mean_530am <- mean(hhblocks_avg$mean_hh11)
mean_6am <- mean(hhblocks_avg$mean_hh12)
mean_630am <- mean(hhblocks_avg$mean_hh13)
mean_7am <- mean(hhblocks_avg$mean_hh14)
mean_730am <- mean(hhblocks_avg$mean_hh15)
mean_8am <- mean(hhblocks_avg$mean_hh16)
mean_830am <- mean(hhblocks_avg$mean_hh17)
mean_9am <- mean(hhblocks_avg$mean_hh18)
mean_930am <- mean(hhblocks_avg$mean_hh19)
mean_10am <- mean(hhblocks_avg$mean_hh20)
mean_1030am <- mean(hhblocks_avg$mean_hh21)
mean_11am <- mean(hhblocks_avg$mean_hh22)
mean_1130am <- mean(hhblocks_avg$mean_hh23)
mean_1200pm <- mean(hhblocks_avg$mean_hh24)
mean_1230pm <- mean(hhblocks_avg$mean_hh25)
mean_1pm <- mean(hhblocks_avg$mean_hh26)
mean_130pm <- mean(hhblocks_avg$mean_hh27)
mean_2pm <- mean(hhblocks_avg$mean_hh28)
mean_230pm <- mean(hhblocks_avg$mean_hh29)
mean_3pm <- mean(hhblocks_avg$mean_hh30)
mean_330pm <- mean(hhblocks_avg$mean_hh31)
mean_4pm <- mean(hhblocks_avg$mean_hh32)
mean_430pm <- mean(hhblocks_avg$mean_hh33)
mean_5pm <- mean(hhblocks_avg$mean_hh34)
mean_530pm <- mean(hhblocks_avg$mean_hh35)
mean_6pm <- mean(hhblocks_avg$mean_hh36)
mean_630pm <- mean(hhblocks_avg$mean_hh37)
mean_7pm <- mean(hhblocks_avg$mean_hh38)
mean_730pm <- mean(hhblocks_avg$mean_hh39)
mean_8pm <- mean(hhblocks_avg$mean_hh40)
mean_830pm <- mean(hhblocks_avg$mean_hh41)
mean_9pm <- mean(hhblocks_avg$mean_hh42)
mean_930pm <- mean(hhblocks_avg$mean_hh43)
mean_10pm <- mean(hhblocks_avg$mean_hh44)
mean_1030pm <- mean(hhblocks_avg$mean_hh45)
mean_11pm <- mean(hhblocks_avg$mean_hh46)
mean_1130pm <- mean(hhblocks_avg$mean_hh47)


half_hour <- for(i in 3:ncol(hhblocks_avg)) {       # for-loop over columns
    half_hour[ , i] <- mean[ , i]
    }



daily_hh_means <- read.csv('daily_hh_means.csv')
str(daily_hh_means)
attach(daily_hh_means)

daily_hh_means$half_hour <- as.POSIXct(daily_hh_means$half_hour, "%H:%M")
library(chron)
times(half_hour)

# create a chart of average daily energy consumption by half hour
ggplot(data = hhblocks_avg) + geom_col(aes(y = mean_1200am)) + theme_light()

    
    
    
# create a Q-Q plot of the daily_dataset for the energy_sum versus
# whether a house is on time of use pricing or not
qqplot(dd_hi$energy_sum[dd_hi$ToU_dummy == 1],
       dd_hi$energy_sum[dd_hi$ToU_dummy == 0],
       xlab = 'Houses on Dynamic Time of Use Energy Rate',
       ylab = 'Houses on the Standard Flat Energy Rate',
       main = 'Q-Q Plot of Total Daily Energy Usage vs Time of Use Pricing')


qqnorm(dd_hi$energy_sum, main = 'Q-Q Plot of the Observed Distribution of energy_sum vs a Gaussian Distribution')
qqline(dd_hi$energy_sum)


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
