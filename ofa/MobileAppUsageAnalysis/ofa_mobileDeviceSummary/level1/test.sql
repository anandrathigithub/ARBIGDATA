create table if not exists ofa_user_action_logs.cooked_app_usage_logs
(
  day bigint,
  month string,
  hour_of_day bigint,
  app_name string,
  screen_id string,
  user_id string,
  device_id string,
  android_id string,
  device_name string,
  os_name string,
  os_version string,
  screen_resolution string,
  screen_size string,
  screen_view_count bigint,
  time_spent bigint
) partitioned by (arrivaltime string);

-- Drop and re create intermediate table
drop table if exists ofa_user_action_logs.tmp_cooked_app_usage_logs;
create table if not exists ofa_user_action_logs.tmp_cooked_app_usage_logs
(
  day bigint,
  month string,
  hour_of_day bigint,
  app_name string,
  screen_id string,
  user_id string,
  device_id string,
  android_id string,
  device_name string,
  os_name string,
  os_version string,
  screen_resolution string,
  screen_size string,
  screen_view_count bigint,
  time_spent bigint
);

SET hive.exec.dynamic.partition.mode=nonstrict;
-- Populate intermediate table with data
Insert into table ofa_user_action_logs.tmp_cooked_app_usage_logs
SELECT 
from_unixtime(CAST(substr(time_stamp, 0, 10) as BIGINT), 'yyyyMMdd') AS day,
from_unixtime(CAST(substr(time_stamp, 0, 10) as BIGINT), 'yyyy-MM') AS month,
from_unixtime(time_stamp, 'HH') AS hour_of_day,
App_id AS app_name,
Screen_id AS screen_id,
User_id AS user_id,
Device_id AS device_id,
Android_id AS android_id,
concat(manufacturer, '_', model) AS device_name,
CASE WHEN upper(app_id) like '%ANDROID' THEN 'android' WHEN upper(app_id) like '%IOS' THEN 'ios' END AS os_name,
os_version AS os_version,
Resolution AS screen_resolution,
COALESCE(screen_size, 'NA') AS screen_size,
count(*) AS screen_view_count,
avg(end_time - start_time) AS time_spent
From ofa_user_action_logs.raw_app_usage_logs
WHERE
--arrivaltime >=from_unixtime(1476963547, 'yyyyMMddHH') and
--arrivaltime <from_unixtime(1477309206, 'yyyyMMddHH')
arrivaltime >from_unixtime(${execTime}, 'yyyyMMddHH') and 
arrivaltime <=from_unixtime(${currTime}, 'yyyyMMddHH')
GROUP by
from_unixtime(CAST(substr(time_stamp, 0, 10) as BIGINT), 'yyyyMMdd'),
from_unixtime(CAST(substr(time_stamp, 0, 10) as BIGINT), 'yyyy-MM'),
from_unixtime(time_stamp, 'HH'), App_id, Screen_id, User_id, Device_id,
Android_id, concat(manufacturer, '_', model),
CASE WHEN upper(app_id) like '%ANDROID' THEN 'android' WHEN upper(app_id) like '%IOS' THEN 'ios' END,
os_version, Resolution, COALESCE(screen_size, 'NA');

-- Populate final table with data

INSERT INTO table ofa_user_action_logs.cooked_app_usage_logs PARTITION (arrivaltime)
SELECT t.*, from_unixtime (unix_timestamp(), 'yyyyMMddHH')
from ofa_user_action_logs.tmp_cooked_app_usage_logs t;

-- Drop intermediate table

drop table if exists ofa_user_action_logs.tmp_cooked_app_usage_logs;
