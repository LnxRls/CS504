
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


