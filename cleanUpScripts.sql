
# ****** daily_dataset table ********

truncate table daily_dataset;

load data infile '/var/lib/mysql/daily_dataset.csv'
into table daily_dataset
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

select count(*) from daily_dataset;

select *
from daily_dataset 
where length(trim(energy_median))=0
limit 1;

update daily_dataset
set energy_median = null
where length(trim(energy_median))=0;

alter table daily_dataset modify energy_median FLOAT;

select *
from daily_dataset 
where not(energy_median is null)
limit 10;

update daily_dataset
set energy_mean = null
where length(trim(energy_mean))=0;

alter table daily_dataset modify energy_mean FLOAT;

update daily_dataset
set energy_max = null
where length(trim(energy_max))=0;

alter table daily_dataset modify energy_max FLOAT;

update daily_dataset
set energy_count = null
where length(trim(energy_count))=0;

alter table daily_dataset modify energy_count INTEGER;

update daily_dataset
set energy_std = null
where length(trim(energy_std))=0;

alter table daily_dataset modify energy_std FLOAT;

update daily_dataset
set energy_sum = null
where length(trim(energy_sum))=0;

alter table daily_dataset modify energy_sum FLOAT;

call elimNonValsInAttrb ('daily_dataset', 'energy_min', 'float');

update daily_dataset
set energy_min = null
where length(trim(energy_min))=0;

alter table daily_dataset modify energy_min FLOAT;

alter table daily_dataset modify LCLid varchar(100);
create index idx_daily_dataset_LCLid on daily_dataset (LCLid);

alter table daily_dataset modify day datetime;

# ****** acorn_details table ******** 

truncate table acorn_details;

select count(*) from acorn_details;

load data infile '/var/lib/mysql/acorn_details.csv'
into table acorn_details
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

select * 
from acorn_details
limit 10;

# ****** prepares and creates acorn_details_transp table ********

drop table if exists acorn_details_transp;

create table acorn_details_transp
select `MAIN CATEGORIES`, CATEGORIES, `REFERENCE`, `ACORN-A` AS ACORN, 'ACORN-A' AS ACORN_Type
from acorn_details
Union
select `MAIN CATEGORIES`, CATEGORIES, `REFERENCE`, `ACORN-B` AS ACORN, 'ACORN-B' AS ACORN_Type
from acorn_details
Union
select `MAIN CATEGORIES`, CATEGORIES, `REFERENCE`, `ACORN-C` AS ACORN, 'ACORN-C' AS ACORN_Type
from acorn_details
Union
select `MAIN CATEGORIES`, CATEGORIES, `REFERENCE`, `ACORN-D` AS ACORN, 'ACORN-D' AS ACORN_Type
from acorn_details
Union
select `MAIN CATEGORIES`, CATEGORIES, `REFERENCE`, `ACORN-E` AS ACORN, 'ACORN-E' AS ACORN_Type
from acorn_details
Union
select `MAIN CATEGORIES`, CATEGORIES, `REFERENCE`, `ACORN-F` AS ACORN, 'ACORN-F' AS ACORN_Type
from acorn_details
Union
select `MAIN CATEGORIES`, CATEGORIES, `REFERENCE`, `ACORN-G` AS ACORN, 'ACORN-G' AS ACORN_Type
from acorn_details
Union
select `MAIN CATEGORIES`, CATEGORIES, `REFERENCE`, `ACORN-H` AS ACORN, 'ACORN-H' AS ACORN_Type
from acorn_details
Union
select `MAIN CATEGORIES`, CATEGORIES, `REFERENCE`, `ACORN-I` AS ACORN, 'ACORN-I' AS ACORN_Type
from acorn_details
Union
select `MAIN CATEGORIES`, CATEGORIES, `REFERENCE`, `ACORN-J` AS ACORN, 'ACORN-J' AS ACORN_Type
from acorn_details
Union
select `MAIN CATEGORIES`, CATEGORIES, `REFERENCE`, `ACORN-K` AS ACORN, 'ACORN-K' AS ACORN_Type
from acorn_details
Union
select `MAIN CATEGORIES`, CATEGORIES, `REFERENCE`, `ACORN-L` AS ACORN, 'ACORN-L' AS ACORN_Type
from acorn_details
Union
select `MAIN CATEGORIES`, CATEGORIES, `REFERENCE`, `ACORN-M` AS ACORN, 'ACORN-M' AS ACORN_Type
from acorn_details
Union
select `MAIN CATEGORIES`, CATEGORIES, `REFERENCE`, `ACORN-N` AS ACORN, 'ACORN-N' AS ACORN_Type
from acorn_details
Union
select `MAIN CATEGORIES`, CATEGORIES, `REFERENCE`, `ACORN-O` AS ACORN, 'ACORN-O' AS ACORN_Type
from acorn_details
Union
select `MAIN CATEGORIES`, CATEGORIES, `REFERENCE`, `ACORN-P` AS ACORN, 'ACORN-P' AS ACORN_Type
from acorn_details
Union
select `MAIN CATEGORIES`, CATEGORIES, `REFERENCE`, `ACORN-Q` AS ACORN, 'ACORN-Q' AS ACORN_Type
from acorn_details;

update acorn_details_transp
set ACORN = Trim(ACORN);

select *
from acorn_details_transp
where concat('', ACORN * 1) = ACORN; 

select *
from acorn_details_transp
where length(ACORN) >7;

select ACORN,substring(ACORN, 1,locate('.',ACORN)+3)
from acorn_details_transp
where length(ACORN) >6;

update acorn_details_transp
set ACORN = substring(ACORN, 1,locate('.',ACORN) + 3)
where length(ACORN) > 6;

-- NOT REGEXP '^[[:digit:]]+$';

call elimNonValsInAttrb ('acorn_details_transp', 'ACORN', 'numeric(9,3)');

select count(*)
from acorn_details_transp;

alter table acorn_details_transp modify Acorn varchar(100);
create index idx_acorn_details_transp_ACORN on acorn_details_transp (Acorn);

alter table acorn_details_transp modify `MAIN CATEGORIES` varchar(200);
alter table acorn_details_transp modify `CATEGORIES` varchar(200);
alter table acorn_details_transp modify `REFERENCE` varchar(200);

create index idx_MAIN_CATEGORIES_CATEGORIES_REFERENCE on acorn_details_transp (`MAIN CATEGORIES`, `CATEGORIES`, `REFERENCE`);

# ******** informations_households table ********

truncate table informations_households;

load data infile '/var/lib/mysql/informations_households.csv'
into table informations_households
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

select *
from informations_households
limit 10 ;

select count(*)
from informations_households;

alter table informations_households modify LCLid varchar(100);
create index idx_informations_households_LCLid on informations_households (LCLid);

alter table informations_households modify Acorn varchar(100);
create index idx_informations_households_Acorn on informations_households (Acorn);

select LCLid, count(LCLid)
from informations_households
group by LCLid
having count(LCLid)>1;

select count(distinct LCLid)
from informations_households;

select count(*)
from
(
select distinct *
from informations_households
) a;

select count(*) 
from informations_households;

# ******** uk_bank_holidays table ********

truncate table uk_bank_holidays;

load data infile '/var/lib/mysql/uk_bank_holidays.csv'
into table uk_bank_holidays
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

select *
from uk_bank_holidays
limit 10 ;

select count(*)
from uk_bank_holidays;

update uk_bank_holidays
set `Type` = replace(`Type`, '?','');

# ******** weather_daily_darksky table ********

truncate table weather_daily_darksky;

load data infile '/var/lib/mysql/weather_daily_darksky.csv'
into table weather_daily_darksky
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

select *
from weather_daily_darksky
limit 10 ;

select count(*)
from weather_daily_darksky;

call elimNonValsInAttrb ('weather_daily_darksky', 'temperatureMax', 'double');
call elimNonValsInAttrb ('weather_daily_darksky', 'dewPoint', 'double');
call elimNonValsInAttrb ('weather_daily_darksky', 'cloudCover', 'double');
call elimNonValsInAttrb ('weather_daily_darksky', 'windSpeed', 'double');
call elimNonValsInAttrb ('weather_daily_darksky', 'pressure', 'double');
call elimNonValsInAttrb ('weather_daily_darksky', 'apparentTemperatureHigh', 'double');
call elimNonValsInAttrb ('weather_daily_darksky', 'visibility', 'double');
call elimNonValsInAttrb ('weather_daily_darksky', 'humidity', 'double');
call elimNonValsInAttrb ('weather_daily_darksky', 'apparentTemperatureLow', 'double');
call elimNonValsInAttrb ('weather_daily_darksky', 'apparentTemperatureMax', 'double');
call elimNonValsInAttrb ('weather_daily_darksky', 'uvIndex', 'double');
call elimNonValsInAttrb ('weather_daily_darksky', 'temperatureLow', 'double');
call elimNonValsInAttrb ('weather_daily_darksky', 'temperatureMin', 'double');
call elimNonValsInAttrb ('weather_daily_darksky', 'temperatureHigh', 'double');
call elimNonValsInAttrb ('weather_daily_darksky', 'apparentTemperatureMin', 'double');
call elimNonValsInAttrb ('weather_daily_darksky', 'moonPhase', 'double');

alter table weather_daily_darksky modify temperatureMaxTime datetime;
create index idx_weather_daily_darksky_temperatureMaxTime on weather_daily_darksky (temperatureMaxTime);

alter table weather_daily_darksky modify temperatureMinTime datetime;
create index idx_weather_daily_darksky_temperatureMinTime on weather_daily_darksky (temperatureMinTime);

alter table weather_daily_darksky modify temperatureMaxTime datetime;
alter table weather_daily_darksky modify temperatureMinTime datetime;
alter table weather_daily_darksky modify apparentTemperatureMinTime datetime;
alter table weather_daily_darksky modify apparentTemperatureHighTime datetime;
alter table weather_daily_darksky modify time datetime;
alter table weather_daily_darksky modify sunsetTime datetime;
alter table weather_daily_darksky modify sunriseTime datetime;
alter table weather_daily_darksky modify temperatureHighTime datetime;
alter table weather_daily_darksky modify temperatureLowTime datetime;
alter table weather_daily_darksky modify apparentTemperatureMaxTime datetime;
alter table weather_daily_darksky modify apparentTemperatureLowTime datetime;

update weather_daily_darksky
set uvIndexTime = null
where length(trim(uvIndexTime))=0;

select *
from weather_daily_darksky
where str_to_date(uvIndexTime, '%d,%m,%Y') is null;

alter table weather_daily_darksky modify uvIndexTime timestamp;

# ******** weather_hourly_darksky table ********

truncate table weather_hourly_darksky;

load data infile '/var/lib/mysql/weather_hourly_darksky.csv'
into table weather_hourly_darksky
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

select *
from weather_hourly_darksky
limit 10 ;

select count(*)
from weather_hourly_darksky;

call elimNonValsInAttrb ('weather_hourly_darksky', 'visibility', 'double');
call elimNonValsInAttrb ('weather_hourly_darksky', 'windBearing', 'double');
call elimNonValsInAttrb ('weather_hourly_darksky', 'temperature', 'double');
call elimNonValsInAttrb ('weather_hourly_darksky', 'dewPoint', 'double');
call elimNonValsInAttrb ('weather_hourly_darksky', 'pressure', 'double');
call elimNonValsInAttrb ('weather_hourly_darksky', 'apparentTemperature', 'double');
call elimNonValsInAttrb ('weather_hourly_darksky', 'windSpeed', 'double');
call elimNonValsInAttrb ('weather_hourly_darksky', 'humidity', 'double');

alter table weather_hourly_darksky modify time datetime;
create index idx_weather_hourly_darksky_time on weather_hourly_darksky (time);

# ******** hhblock table ********

truncate table hhblock;

load data infile '/var/lib/mysql/block_0.csv'
into table hhblock
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

select *
from hhblock
limit 10;

select count(*)
from hhblock
limit 10;

-- run the command below, highlight the resultset, right click it and open it in Viewer, 
-- swith tabs to Text and get all the statements to switch the data type of the hh_xyz block 
-- column of hhblock table in this query window to run them 
call cngAttrbDtTypeStmts ('hhblock', 'hh', 'double', 48);

call elimNonValsInAttrb ('hhblock', 'hh_0', 'double');
call elimNonValsInAttrb ('hhblock', 'hh_1', 'double');
call elimNonValsInAttrb ('hhblock', 'hh_2', 'double');
call elimNonValsInAttrb ('hhblock', 'hh_3', 'double');
call elimNonValsInAttrb ('hhblock', 'hh_4', 'double');
call elimNonValsInAttrb ('hhblock', 'hh_5', 'double');
call elimNonValsInAttrb ('hhblock', 'hh_6', 'double');
call elimNonValsInAttrb ('hhblock', 'hh_7', 'double');
call elimNonValsInAttrb ('hhblock', 'hh_8', 'double');
call elimNonValsInAttrb ('hhblock', 'hh_9', 'double');
call elimNonValsInAttrb ('hhblock', 'hh_10', 'double');
call elimNonValsInAttrb ('hhblock', 'hh_11', 'double');
call elimNonValsInAttrb ('hhblock', 'hh_12', 'double');
call elimNonValsInAttrb ('hhblock', 'hh_13', 'double');
call elimNonValsInAttrb ('hhblock', 'hh_14', 'double');
call elimNonValsInAttrb ('hhblock', 'hh_15', 'double');
call elimNonValsInAttrb ('hhblock', 'hh_16', 'double');
call elimNonValsInAttrb ('hhblock', 'hh_17', 'double');
call elimNonValsInAttrb ('hhblock', 'hh_18', 'double');
call elimNonValsInAttrb ('hhblock', 'hh_19', 'double');
call elimNonValsInAttrb ('hhblock', 'hh_20', 'double');
call elimNonValsInAttrb ('hhblock', 'hh_21', 'double');
call elimNonValsInAttrb ('hhblock', 'hh_22', 'double');
call elimNonValsInAttrb ('hhblock', 'hh_23', 'double');
call elimNonValsInAttrb ('hhblock', 'hh_24', 'double');
call elimNonValsInAttrb ('hhblock', 'hh_25', 'double');
call elimNonValsInAttrb ('hhblock', 'hh_26', 'double');
call elimNonValsInAttrb ('hhblock', 'hh_27', 'double');
call elimNonValsInAttrb ('hhblock', 'hh_28', 'double');
call elimNonValsInAttrb ('hhblock', 'hh_29', 'double');
call elimNonValsInAttrb ('hhblock', 'hh_30', 'double');
call elimNonValsInAttrb ('hhblock', 'hh_31', 'double');
call elimNonValsInAttrb ('hhblock', 'hh_32', 'double');
call elimNonValsInAttrb ('hhblock', 'hh_33', 'double');
call elimNonValsInAttrb ('hhblock', 'hh_34', 'double');
call elimNonValsInAttrb ('hhblock', 'hh_35', 'double');
call elimNonValsInAttrb ('hhblock', 'hh_36', 'double');
call elimNonValsInAttrb ('hhblock', 'hh_37', 'double');
call elimNonValsInAttrb ('hhblock', 'hh_38', 'double');
call elimNonValsInAttrb ('hhblock', 'hh_39', 'double');
call elimNonValsInAttrb ('hhblock', 'hh_40', 'double');
call elimNonValsInAttrb ('hhblock', 'hh_41', 'double');
call elimNonValsInAttrb ('hhblock', 'hh_42', 'double');
call elimNonValsInAttrb ('hhblock', 'hh_43', 'double');
call elimNonValsInAttrb ('hhblock', 'hh_44', 'double');
call elimNonValsInAttrb ('hhblock', 'hh_45', 'double');
call elimNonValsInAttrb ('hhblock', 'hh_46', 'double');
call elimNonValsInAttrb ('hhblock', 'hh_47', 'double');

alter table hhblock modify LCLid varchar(100);
create index idx_hhblock_LCLid on hhblock (LCLid);

alter table hhblock modify day datetime;

# ******** tariffs table ********

truncate table tariffs;

load data infile '/var/lib/mysql/Tariffs.csv'
into table tariffs
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

select *
from tariffs
limit 10;

alter table tariffs modify TariffDateTime datetime;
create index idx_tarrifs_TariffDateTime on tariffs (TariffDateTime);

update tariffs 
set Tariff = left(Tariff,6)
where Tariff like 'Normal%'

update tariffs 
set Tariff = left(Tariff,4)
where Tariff like 'High%'

update tariffs 
set Tariff = left(Tariff,3)
where Tariff like 'Low%'

select Tariff, count(Tariff)
from tariffs t 
group by Tariff 

select count(*)
from 
(
select distinct Tariff ,TariffDateTime 
from tariffs t 
) a


# *************************** Analysis Section *************************
# run below statement and take its result to run it as a separate statement to
# add all hh_x values for each record in hhblock table
SELECT CONCAT('SELECT ', group_concat(`COLUMN_NAME` SEPARATOR ' + '), ' FROM hhblock') 
FROM  `INFORMATION_SCHEMA`.`COLUMNS` 
WHERE `TABLE_SCHEMA` = (select database()) 
AND   `TABLE_NAME`   = 'hhblock'
AND   `COLUMN_NAME` LIKE 'hh_%';


select cast(dd.day as date), cast(dd.all_meter_day_energy_mean as decimal(6,4)) as all_meter_day_energy_mean, wdd.temperatureMin, wdd.temperatureMax 
FROM 
(
	select day, sum(energy_sum) / sum(energy_count)  as all_meter_day_energy_mean
	from daily_dataset
	group by day
) dd
left outer join
weather_daily_darksky wdd
on substring(dd.day, 1, locate(' ', dd.day)) = substring(wdd.time, 1, locate(' ', wdd.time)) 
order by day


select *
from SMIL.weather_daily_darksky; 


select day, stdorToU, Acorn_grouped, sum(energy_sum) / sum(energy_count) as all_meter_day_energy_mean
FROM 
(
SELECT dd.LCLid , dd.day, ih.stdorToU, ih.Acorn_grouped, energy_sum , energy_count 
FROM daily_dataset dd 
left outer join
informations_households ih
on ih.LCLid = dd.LCLid 
) hih 
group by day, stdorToU, Acorn_grouped 
;


create table daily_dataset_hhblocks
select stdorToU, Acorn_grouped, day, sum(hh_0) as hh_0, sum(hh_1) as hh_1,  sum(hh_2) as hh_2,  sum(hh_3) as hh_3,  sum(hh_4) as hh_4,  sum(hh_5) as hh_5,  sum(hh_6) as hh_6,  sum(hh_7) as hh_7,  sum(hh_8) as hh_8,  sum(hh_9) as hh_9,  sum(hh_10) as hh_10,  sum(hh_11) as hh_11,  sum(hh_12) as hh_12,  sum(hh_13) as hh_13,  sum(hh_14) as hh_14,  sum(hh_15) as hh_15,  sum(hh_16) as hh_16,  sum(hh_17) as hh_17,  sum(hh_18) as hh_18,  sum(hh_19) as hh_19,  sum(hh_20) as hh_20,  sum(hh_21) as hh_21,  sum(hh_22) as hh_22,  sum(hh_23) as hh_23,  sum(hh_24) as hh_24,  sum(hh_25) as hh_25,  sum(hh_26) as hh_26,  sum(hh_27) as hh_27,  sum(hh_28) as hh_28,  sum(hh_29) as hh_29,  sum(hh_30) as hh_30,  sum(hh_31) as hh_31,  sum(hh_32) as hh_32,  sum(hh_33) as hh_33,  sum(hh_34) as hh_34,  sum(hh_35) as hh_35,  sum(hh_36) as hh_36,  sum(hh_37) as hh_37,  sum(hh_38) as hh_38,  sum(hh_39) as hh_39,  sum(hh_40) as hh_40,  sum(hh_41) as hh_41,  sum(hh_42) as hh_42,  sum(hh_43) as hh_43,  sum(hh_44) as hh_44,  sum(hh_45) as hh_45,  sum(hh_46) as hh_46,  sum(hh_47) as hh_47
FROM 
(
select ih.Acorn_grouped , ih.stdorToU, h2.* 
from hhblock h2 
left outer join
informations_households ih
on h2.LCLid  = ih.LCLid
) a
group by stdorToU , Acorn_grouped,day  



select *
from daily_dataset_hhblocks
limit 10;


call ctreLongUnion('daily_dataset_hhblocks_transp', 'daily_dataset_hhblocks', 'day', 'hh', 'hhblock', 48)


create table daily_dataset_hhblocks_transp 
select  stdorToU, Acorn_grouped, day, hh_0 + hh_1, '01:00:00' as hhblock FROM daily_dataset_hhblocks UNION
select  stdorToU, Acorn_grouped, day, hh_2 + hh_3, '02:00:00' as hhblock FROM daily_dataset_hhblocks UNION
select  stdorToU, Acorn_grouped, day, hh_4 + hh_5, '03:00:00' as hhblock FROM daily_dataset_hhblocks UNION
select  stdorToU, Acorn_grouped, day, hh_6 + hh_7, '04:00:00' as hhblock FROM daily_dataset_hhblocks UNION
select  stdorToU, Acorn_grouped, day, hh_8 + hh_9, '05:00:00' as hhblock FROM daily_dataset_hhblocks UNION
select  stdorToU, Acorn_grouped, day, hh_10 + hh_11, '06:00:00' as hhblock FROM daily_dataset_hhblocks UNION
select  stdorToU, Acorn_grouped, day, hh_12 + hh_13, '07:00:00' as hhblock FROM daily_dataset_hhblocks UNION
select  stdorToU, Acorn_grouped, day, hh_14 + hh_15, '08:00:00' as hhblock FROM daily_dataset_hhblocks UNION
select  stdorToU, Acorn_grouped, day, hh_16 + hh_17, '09:00:00' as hhblock FROM daily_dataset_hhblocks UNION
select  stdorToU, Acorn_grouped, day, hh_18 + hh_19, '10:00:00' as hhblock FROM daily_dataset_hhblocks UNION
select  stdorToU, Acorn_grouped, day, hh_20 + hh_21, '11:00:00' as hhblock FROM daily_dataset_hhblocks UNION
select  stdorToU, Acorn_grouped, day, hh_22 + hh_23, '12:00:00' as hhblock FROM daily_dataset_hhblocks UNION
select  stdorToU, Acorn_grouped, day, hh_24 + hh_25, '13:00:00' as hhblock FROM daily_dataset_hhblocks UNION
select  stdorToU, Acorn_grouped, day, hh_26 + hh_27, '14:00:00' as hhblock FROM daily_dataset_hhblocks UNION
select  stdorToU, Acorn_grouped, day, hh_28 + hh_29, '15:00:00' as hhblock FROM daily_dataset_hhblocks UNION
select  stdorToU, Acorn_grouped, day, hh_30 + hh_31, '16:00:00' as hhblock FROM daily_dataset_hhblocks UNION
select  stdorToU, Acorn_grouped, day, hh_32 + hh_33, '17:00:00' as hhblock FROM daily_dataset_hhblocks UNION
select  stdorToU, Acorn_grouped, day, hh_34 + hh_35, '18:00:00' as hhblock FROM daily_dataset_hhblocks UNION
select  stdorToU, Acorn_grouped, day, hh_36 + hh_37, '19:00:00' as hhblock FROM daily_dataset_hhblocks UNION
select  stdorToU, Acorn_grouped, day, hh_38 + hh_39, '20:00:00' as hhblock FROM daily_dataset_hhblocks UNION
select  stdorToU, Acorn_grouped, day, hh_40 + hh_41, '21:00:00' as hhblock FROM daily_dataset_hhblocks UNION
select  stdorToU, Acorn_grouped, day, hh_42 + hh_43, '22:00:00' as hhblock FROM daily_dataset_hhblocks UNION
select  stdorToU, Acorn_grouped, day, hh_44 + hh_45, '23:00:00' as hhblock FROM daily_dataset_hhblocks UNION
select  stdorToU, Acorn_grouped, day, hh_46 + hh_47, '00:00:00' as hhblock FROM daily_dataset_hhblocks 


select * 
from SMIL.weather_daily_darksky
limit 100;


select precipType , count(*) as cnt
from SMIL.weather_hourly_darksky
group by precipType 
  

select precipType 
from SMIL.weather_hourly_darksky
limit 200;

select *
from daily_dataset dd 
limit 10;

select distinct stdorToU ,Acorn ,Acorn_grouped 
from informations_households adt 
limit 10 ;


# avg(hh_0) as hh_0, avg(hh_1) as hh_1,  avg(hh_2) as hh_2,  avg(hh_3) as hh_3,  avg(hh_4) as hh_4,  avg(hh_5) as hh_5,  avg(hh_6) as hh_6,  avg(hh_7) as hh_7,  avg(hh_8) as hh_8,  avg(hh_9) as hh_9,  avg(hh_10) as hh_10,  avg(hh_11) as hh_11,  avg(hh_12) as hh_12,  avg(hh_13) as hh_13,  avg(hh_14) as hh_14,  avg(hh_15) as hh_15,  avg(hh_16) as hh_16,  avg(hh_17) as hh_17,  avg(hh_18) as hh_18,  avg(hh_19) as hh_19,  avg(hh_20) as hh_20,  avg(hh_21) as hh_21,  avg(hh_22) as hh_22,  avg(hh_23) as hh_23,  avg(hh_24) as hh_24,  avg(hh_25) as hh_25,  avg(hh_26) as hh_26,  avg(hh_27) as hh_27,  avg(hh_28) as hh_28,  avg(hh_29) as hh_29,  avg(hh_30) as hh_30,  avg(hh_31) as hh_31,  avg(hh_32) as hh_32,  avg(hh_33) as hh_33,  avg(hh_34) as hh_34,  avg(hh_35) as hh_35,  avg(hh_36) as hh_36,  avg(hh_37) as hh_37,  avg(hh_38) as hh_38,  avg(hh_39) as hh_39,  avg(hh_40) as hh_40,  avg(hh_41) as hh_41,  avg(hh_42) as hh_42,  avg(hh_43) as hh_43,  avg(hh_44) as hh_44,  avg(hh_45) as hh_45,  avg(hh_46) as hh_46,  avg(hh_47) as hh_47



create table daily_dataset_hhblocks_byACORN
select stdorToU, Acorn_grouped,  avg(hh_0+hh_1) as h_1,  avg(hh_2+hh_3) as h_2,  avg(hh_4+hh_5) as h_3,  avg(hh_6+hh_7) as h_4,  avg(hh_8+hh_9) as h_5,  avg(hh_10+hh_11) as h_6,  avg(hh_12+hh_13) as h_7,  avg(hh_14+hh_15) as h_8,  avg(hh_16+hh_17) as h_9,  avg(hh_18+hh_19) as h_10,  avg(hh_20+hh_21) as h_11,  avg(hh_22+hh_23) as h_12,  avg(hh_24+hh_25) as h_13,  avg(hh_26+hh_27) as h_14,  avg(hh_28+hh_29) as h_15,  avg(hh_30+hh_31) as h_16,  avg(hh_32+hh_33) as h_17,  avg(hh_34+hh_35) as h_18,  avg(hh_36+hh_37) as h_19,  avg(hh_38+hh_39) as h_20,  avg(hh_40+hh_41) as h_21,  avg(hh_42+hh_43) as h_22,  avg(hh_44+hh_45) as h_23,  avg(hh_46+hh_47) as h_24
FROM 
(
select ih.Acorn_grouped , ih.stdorToU, h2.day, hh_0, hh_1, hh_2, hh_3, hh_4, hh_5, hh_6, hh_7, hh_8, hh_9, hh_10, hh_11, hh_12, hh_13, hh_14, hh_15, hh_16, hh_17, hh_18, hh_19, hh_20, hh_21, hh_22, hh_23, hh_24, hh_25, hh_26, hh_27, hh_28, hh_29, hh_30, hh_31, hh_32, hh_33, hh_34, hh_35, hh_36, hh_37, hh_38, hh_39, hh_40, hh_41, hh_42, hh_43, hh_44, hh_45, hh_46, hh_47 
from hhblock h2 
left outer join
informations_households ih
on h2.LCLid  = ih.LCLid
) a
group by stdorToU, Acorn_grouped


select *
from daily_dataset_hhblocks_byACORN
limit 10;


create table daily_dataset_hhblocks_byACORN_transp 
select  stdorToU, Acorn_grouped,  h_1, '01:00:00' as hblock FROM daily_dataset_hhblocks_byACORN UNION
select  stdorToU, Acorn_grouped,  h_2, '02:00:00' as hblock FROM daily_dataset_hhblocks_byACORN UNION
select  stdorToU, Acorn_grouped,  h_3, '03:00:00' as hblock FROM daily_dataset_hhblocks_byACORN UNION
select  stdorToU, Acorn_grouped,  h_4, '04:00:00' as hblock FROM daily_dataset_hhblocks_byACORN UNION
select  stdorToU, Acorn_grouped,  h_5, '05:00:00' as hblock FROM daily_dataset_hhblocks_byACORN UNION
select  stdorToU, Acorn_grouped,  h_6, '06:00:00' as hblock FROM daily_dataset_hhblocks_byACORN UNION
select  stdorToU, Acorn_grouped,  h_7, '07:00:00' as hblock FROM daily_dataset_hhblocks_byACORN UNION
select  stdorToU, Acorn_grouped,  h_8, '08:00:00' as hblock FROM daily_dataset_hhblocks_byACORN UNION
select  stdorToU, Acorn_grouped,  h_9, '09:00:00' as hblock FROM daily_dataset_hhblocks_byACORN UNION
select  stdorToU, Acorn_grouped,  h_10, '10:00:00' as hblock FROM daily_dataset_hhblocks_byACORN UNION
select  stdorToU, Acorn_grouped,  h_11, '11:00:00' as hblock FROM daily_dataset_hhblocks_byACORN UNION
select  stdorToU, Acorn_grouped,  h_12, '12:00:00' as hblock FROM daily_dataset_hhblocks_byACORN UNION
select  stdorToU, Acorn_grouped,  h_13, '13:00:00' as hblock FROM daily_dataset_hhblocks_byACORN UNION
select  stdorToU, Acorn_grouped,  h_14, '14:00:00' as hblock FROM daily_dataset_hhblocks_byACORN UNION
select  stdorToU, Acorn_grouped,  h_15, '15:00:00' as hblock FROM daily_dataset_hhblocks_byACORN UNION
select  stdorToU, Acorn_grouped,  h_16, '16:00:00' as hblock FROM daily_dataset_hhblocks_byACORN UNION
select  stdorToU, Acorn_grouped,  h_17, '17:00:00' as hblock FROM daily_dataset_hhblocks_byACORN UNION
select  stdorToU, Acorn_grouped,  h_18, '18:00:00' as hblock FROM daily_dataset_hhblocks_byACORN UNION
select  stdorToU, Acorn_grouped,  h_19, '19:00:00' as hblock FROM daily_dataset_hhblocks_byACORN UNION
select  stdorToU, Acorn_grouped,  h_20, '20:00:00' as hblock FROM daily_dataset_hhblocks_byACORN UNION
select  stdorToU, Acorn_grouped,  h_21, '21:00:00' as hblock FROM daily_dataset_hhblocks_byACORN UNION
select  stdorToU, Acorn_grouped,  h_22, '22:00:00' as hblock FROM daily_dataset_hhblocks_byACORN UNION
select  stdorToU, Acorn_grouped,  h_23, '23:00:00' as hblock FROM daily_dataset_hhblocks_byACORN UNION
select  stdorToU, Acorn_grouped,  h_24, '00:00:00' as hblock FROM daily_dataset_hhblocks_byACORN



select *
from daily_dataset_hhblocks_byACORN_transp
order by stdorToU, Acorn_grouped
limit 10;




create table daily_dataset_hhblocks_byACORNAndHour
select stdorToU, Acorn_grouped, day,  avg(hh_0+hh_1) as h_1,  avg(hh_2+hh_3) as h_2,  avg(hh_4+hh_5) as h_3,  avg(hh_6+hh_7) as h_4,  avg(hh_8+hh_9) as h_5,  avg(hh_10+hh_11) as h_6,  avg(hh_12+hh_13) as h_7,  avg(hh_14+hh_15) as h_8,  avg(hh_16+hh_17) as h_9,  avg(hh_18+hh_19) as h_10,  avg(hh_20+hh_21) as h_11,  avg(hh_22+hh_23) as h_12,  avg(hh_24+hh_25) as h_13,  avg(hh_26+hh_27) as h_14,  avg(hh_28+hh_29) as h_15,  avg(hh_30+hh_31) as h_16,  avg(hh_32+hh_33) as h_17,  avg(hh_34+hh_35) as h_18,  avg(hh_36+hh_37) as h_19,  avg(hh_38+hh_39) as h_20,  avg(hh_40+hh_41) as h_21,  avg(hh_42+hh_43) as h_22,  avg(hh_44+hh_45) as h_23,  avg(hh_46+hh_47) as h_24
FROM 
(
select ih.Acorn_grouped , ih.stdorToU, h2.day, hh_0, hh_1, hh_2, hh_3, hh_4, hh_5, hh_6, hh_7, hh_8, hh_9, hh_10, hh_11, hh_12, hh_13, hh_14, hh_15, hh_16, hh_17, hh_18, hh_19, hh_20, hh_21, hh_22, hh_23, hh_24, hh_25, hh_26, hh_27, hh_28, hh_29, hh_30, hh_31, hh_32, hh_33, hh_34, hh_35, hh_36, hh_37, hh_38, hh_39, hh_40, hh_41, hh_42, hh_43, hh_44, hh_45, hh_46, hh_47 
from hhblock h2 
left outer join
informations_households ih
on h2.LCLid  = ih.LCLid
) a
group by stdorToU, Acorn_grouped, day



create table daily_dataset_hblocks_byACORNAndHour_transp 
select  stdorToU, Acorn_grouped, day,  h_1, '01:00:00' as hblock FROM daily_dataset_hblocks_byACORNAndHour UNION
select  stdorToU, Acorn_grouped, day,  h_2, '02:00:00' as hblock FROM daily_dataset_hblocks_byACORNAndHour UNION
select  stdorToU, Acorn_grouped, day,  h_3, '03:00:00' as hblock FROM daily_dataset_hblocks_byACORNAndHour UNION
select  stdorToU, Acorn_grouped, day,  h_4, '04:00:00' as hblock FROM daily_dataset_hblocks_byACORNAndHour UNION
select  stdorToU, Acorn_grouped, day,  h_5, '05:00:00' as hblock FROM daily_dataset_hblocks_byACORNAndHour UNION
select  stdorToU, Acorn_grouped, day,  h_6, '06:00:00' as hblock FROM daily_dataset_hblocks_byACORNAndHour UNION
select  stdorToU, Acorn_grouped, day,  h_7, '07:00:00' as hblock FROM daily_dataset_hblocks_byACORNAndHour UNION
select  stdorToU, Acorn_grouped, day,  h_8, '08:00:00' as hblock FROM daily_dataset_hblocks_byACORNAndHour UNION
select  stdorToU, Acorn_grouped, day,  h_9, '09:00:00' as hblock FROM daily_dataset_hblocks_byACORNAndHour UNION
select  stdorToU, Acorn_grouped, day,  h_10, '10:00:00' as hblock FROM daily_dataset_hblocks_byACORNAndHour UNION
select  stdorToU, Acorn_grouped, day,  h_11, '11:00:00' as hblock FROM daily_dataset_hblocks_byACORNAndHour UNION
select  stdorToU, Acorn_grouped, day,  h_12, '12:00:00' as hblock FROM daily_dataset_hblocks_byACORNAndHour UNION
select  stdorToU, Acorn_grouped, day,  h_13, '13:00:00' as hblock FROM daily_dataset_hblocks_byACORNAndHour UNION
select  stdorToU, Acorn_grouped, day,  h_14, '14:00:00' as hblock FROM daily_dataset_hblocks_byACORNAndHour UNION
select  stdorToU, Acorn_grouped, day,  h_15, '15:00:00' as hblock FROM daily_dataset_hblocks_byACORNAndHour UNION
select  stdorToU, Acorn_grouped, day,  h_16, '16:00:00' as hblock FROM daily_dataset_hblocks_byACORNAndHour UNION
select  stdorToU, Acorn_grouped, day,  h_17, '17:00:00' as hblock FROM daily_dataset_hblocks_byACORNAndHour UNION
select  stdorToU, Acorn_grouped, day,  h_18, '18:00:00' as hblock FROM daily_dataset_hblocks_byACORNAndHour UNION
select  stdorToU, Acorn_grouped, day,  h_19, '19:00:00' as hblock FROM daily_dataset_hblocks_byACORNAndHour UNION
select  stdorToU, Acorn_grouped, day,  h_20, '20:00:00' as hblock FROM daily_dataset_hblocks_byACORNAndHour UNION
select  stdorToU, Acorn_grouped, day,  h_21, '21:00:00' as hblock FROM daily_dataset_hblocks_byACORNAndHour UNION
select  stdorToU, Acorn_grouped, day,  h_22, '22:00:00' as hblock FROM daily_dataset_hblocks_byACORNAndHour UNION
select  stdorToU, Acorn_grouped, day,  h_23, '23:00:00' as hblock FROM daily_dataset_hblocks_byACORNAndHour UNION
select  stdorToU, Acorn_grouped, day,  h_24, '00:00:00' as hblock FROM daily_dataset_hblocks_byACORNAndHour



create table SMIL.daily_dataset_hhblocks_byHour
select day, (hh_0+ hh_1+ hh_2+ hh_3+ hh_4+ hh_5+ hh_6+ hh_7+ hh_8+ hh_9+ hh_10+ hh_11+ hh_12+ hh_13+ hh_14+ hh_15+ hh_16+ hh_17+ hh_18+ hh_19+ hh_20+ hh_21+ hh_22+ hh_23+ hh_24+ hh_25+ hh_26+ hh_27+ hh_28+ hh_29+ hh_30+ hh_31+ hh_32+ hh_33+ hh_34+ hh_35+ hh_36+ hh_37+ hh_38+ hh_39+ hh_40+ hh_41+ hh_42+ hh_43+ hh_44+ hh_45+ hh_46+ hh_47) / NumbSmrtMetrs / 24 as Avg_Energy_Consump
from (
select h.day, count(LCLid) as NumbSmrtMetrs, sum(hh_0) as hh_0, sum(hh_1) as hh_1,  sum(hh_2) as hh_2,  sum(hh_3) as hh_3,  sum(hh_4) as hh_4,  sum(hh_5) as hh_5,  sum(hh_6) as hh_6,  sum(hh_7) as hh_7,  sum(hh_8) as hh_8,  sum(hh_9) as hh_9,  sum(hh_10) as hh_10,  sum(hh_11) as hh_11,  sum(hh_12) as hh_12,  sum(hh_13) as hh_13,  sum(hh_14) as hh_14,  sum(hh_15) as hh_15,  sum(hh_16) as hh_16,  sum(hh_17) as hh_17,  sum(hh_18) as hh_18,  sum(hh_19) as hh_19,  sum(hh_20) as hh_20,  sum(hh_21) as hh_21,  sum(hh_22) as hh_22,  sum(hh_23) as hh_23,  sum(hh_24) as hh_24,  sum(hh_25) as hh_25,  sum(hh_26) as hh_26,  sum(hh_27) as hh_27,  sum(hh_28) as hh_28,  sum(hh_29) as hh_29,  sum(hh_30) as hh_30,  sum(hh_31) as hh_31,  sum(hh_32) as hh_32,  sum(hh_33) as hh_33,  sum(hh_34) as hh_34,  sum(hh_35) as hh_35,  sum(hh_36) as hh_36,  sum(hh_37) as hh_37,  sum(hh_38) as hh_38,  sum(hh_39) as hh_39,  sum(hh_40) as hh_40,  sum(hh_41) as hh_41,  sum(hh_42) as hh_42,  sum(hh_43) as hh_43,  sum(hh_44) as hh_44,  sum(hh_45) as hh_45,  sum(hh_46) as hh_46,  sum(hh_47) as hh_47
from hhblock h 
group by h.day 
) f



select *
from acorn_details_transp adt 
limit 10;

select count(*)
FROM (
select distinct *
from informations_households ih 
) a


select count(*)
from informations_households ih 

select *
from informations_households ih 
limit 10;



####### scripts to bring relations closer to 3NF  #####################



CREATE TABLE SMIL.AllAcornGroups (ACORN_ID int, Acorn varchar(20));

insert into SMIL.AllAcornGroups (ACORN_ID, Acorn)
Values(1, 'ACORN-'),
(2, 'ACORN-A'),
(3, 'ACORN-B'),
(4, 'ACORN-C'),
(5, 'ACORN-D'),
(6, 'ACORN-E'),
(7, 'ACORN-F'),
(8, 'ACORN-G'),
(9, 'ACORN-H'),
(10, 'ACORN-I'),
(11, 'ACORN-J'),
(12, 'ACORN-K'),
(13, 'ACORN-L'),
(14, 'ACORN-M'),
(15, 'ACORN-N'),
(16, 'ACORN-O'),
(17, 'ACORN-P'),
(18, 'ACORN-Q'),
(19, 'ACORN-U')



select *
from SMIL.AllAcornGroups ih ;


create table SMIL.informations_households_revamped
select *
from SMIL.informations_households


create table info_hous_Acorn
select LCLid, aag.ACORN_ID from SMIL.informations_households_revamped ih
left outer join SMIL.AllAcornGroups aag 
on ih.Acorn = aag.Acorn 


select *
from info_hous_Acorn
limit 10;


select ihr.LCLid , ihr.stdorToU ,ihr.Acorn_grouped ,ihr.file , aag.Acorn
from informations_households_revamped ihr
inner join 
info_hous_Acorn rv
on ihr.LCLid = rv.LCLid 
inner join AllAcornGroups aag
on rv.ACORN_ID = aag.ACORN_ID 
limit 10 ;


alter table SMIL.informations_households_revamped
drop column Acorn



select *
from informations_households_revamped ihr 
limit 10;



select *
from SMIL.acorn_details_transp ihr 
limit 10;


select count(*)
from (
select distinct LCLid 
from hhblock
) a


select  dd.LCLid 
from (select distinct LCLid from hhblock)  hh
right outer join ( select distinct LCLid  from daily_dataset) dd 
on hh.LCLid = dd.LCLid 
where hh.LCLid is null


select lclid, count(LCLid) as cntL  
from daily_dataset
group by LCLid
having count(LCLid) < 10



select lclid, count(LCLid) as cntL  
from hhblock
group by LCLid
having count(LCLid) <2


select count(*)
from (
select distinct LCLid 
from daily_dataset
) a


# 3,510,433
select count(*)
from daily_dataset



# 3,510,433
select count(*)
from (
select distinct LCLid, day 
from daily_dataset
) a


# 3,469,352
select count(*)
from (
select distinct LCLid, day 
from hhblock h2 
) a


# 3,469,352
select count(*)
from  hhblock


create table AllDates
select distinct day as dayDate
from daily_dataset dd 
order by `day`




######  more analysis scripts  ######

select  ddhh.*, ta.Tariff
from
(
select stdorToU , Acorn_grouped , Avg_Energy_Consump, substr(day, 1, locate(' ', day)) as dayDate, hhblock
from 
daily_dataset_hhblocks_byACORNAndHour_transp 
) ddhh
left outer join
(
select Tariff, substr(t.TariffDateTime, 1, locate' ', t.TariffDateTime)) as tariffDate,
Trim(substr(t.TariffDateTime, locate(" ", t.TariffDateTime), length(cast(t.TariffDateTime as char(30))))) as tariffTime
from
tariffs t
where right(t.TariffDateTime, 5) = '00:00'
) ta
on 
ddhh.dayDate = ta.tariffDate
AND 
ddhh.hhblock = ta.tariffTime
;



select Acorn_grouped, Tariff, sum(energy_sum)/sum(energy_count) as Avg_Energy_Consump
from (
    select distinct a.LCLid, a.dayDate, ih.stdorToU , ih.Acorn_grouped, c.Tariff, energy_median, energy_mean, energy_max, energy_count, energy_std, energy_sum, energy_min
    from 
    (
        select dd.*, substr(day, 1, locate(' ', day)) as dayDate
        from daily_dataset dd
    ) a
    left outer join
    SMIL.informations_households ih
    on a.LCLid = ih.LCLid 
    left outer join 
    (
    select *, substr(t.TariffDateTime, 1, locate(' ', t.TariffDateTime)) as tariffDate
    from tariffs t 
    ) c
    on a.dayDate = c.TariffDate
) d
where (stdorToU = 'std') and (Tariff != 'NA')
group by Acorn_grouped, Tariff
;


select *
from SMIL.daily_dataset_hhblocks_byACORN
limit 10;


###### time series predictive #####

select dayDate, stdorToU, Tariff, Acorn_grouped, sum(energy_sum)/sum(energy_count) as Avg_Energy_Consump
from (
    select distinct a.dayDate, a.LCLid, energy_count, energy_sum, stdorToU, Acorn_grouped, Tariff
    from 
    (
        select substr(day, 1, locate(' ', day)) as dayDate, dd.LCLid, dd.energy_sum, dd.energy_count
        from daily_dataset dd
    ) a
    inner join
    (
	    select LCLid, stdorToU, Acorn_grouped 
		from SMIL.informations_households 
    ) ih
    on a.LCLid = ih.LCLid 
    inner join 
    (
	    select distinct substr(t.TariffDateTime, 1, locate(' ', t.TariffDateTime)) as tariffDate, Tariff
	    from tariffs t 
    ) c
    on a.dayDate = c.TariffDate
) d
group by dayDate, stdorToU, Tariff, Acorn_grouped
order by dayDate, stdorToU, Tariff, Acorn_grouped