-- table is with name : ofa_user_action_logs.raw_app_usage_logs
SET hive.support.sql11.reserved.keywords=false;
CREATE TABLE if not exists ofa_user_action_logs.raw_app_usage_logs
(
    action string,
    start_time bigint,
    end_time bigint,
    screen_id string,
    event_id string,
    app_id string,
    time_stamp bigint,
    scale_density string,
    data_type_name string,
    api_level string,
    version string,
    session_id string,
    resolution string,
    screen_size string,
    os string,
    os_version string,
    manufacturer string,
    biz_id string,
    user_id string,
    android_id string,
    device_id string,
    model string
) partitioned by (arrivaltime string);

-- Intermediate table to keep processed data
DROP TABLE if exists ofa_user_action_logs.tmp_raw_app_usage_logs;
CREATE TABLE ofa_user_action_logs.tmp_raw_app_usage_logs
(
    action string,
    start_time bigint,
    end_time bigint,
    screen_id string,
    event_id string,
    app_id string,
    time_stamp bigint,
    scale_density string,
    data_type_name string,
    api_level string,
    version string,
    session_id string,
    resolution string,
    screen_size string,
    os string,
    os_version string,
    manufacturer string,
    biz_id string,
    user_id string,
    android_id string,
    device_id string,
    model string
);

Insert into table ofa_user_action_logs.tmp_raw_app_usage_logs
SELECT 
v1.action, v2.start_time, v2.end_time, COALESCE(v2.screen_id, 'NA') as screen_id, v3.eventId, v3.app_id, v3.timestamp, v3.scale_density, v3.dataTypeName, v3.api_level, v3.version, v3.session_id, v3.resolution, v3.screen_size, v3.os, v3.os_version, v3.manufacturer, v3.biz_id, v3.user_id, v3.android_id, v3.device_id, v3.model 
    FROM personalisation.ofa_user_actions jt 
    LATERAL VIEW json_tuple (jt.tuplestring, 'action', 'actionProps', 'otherProps') v1 
        AS action, actionProps, otherProps 
        LATERAL VIEW json_tuple(v1.actionProps, 'start_time', 'end_time', 'screen_id') v2
        AS start_time, end_time, screen_id
        LATERAL VIEW json_tuple(v1.otherProps, 'eventId', 'app_id', 'timestamp', 'scale_density', 'dataTypeName', 'api_level', 'version', 'session_id', 'resolution', 'screen_size', 'os', 'os_version', 'manufacturer', 'biz_id', 'user_id', 'android_id', 'device_id', 'model') v3
        AS eventId, app_id, timestamp, scale_density, dataTypeName, api_level, version, session_id, resolution, screen_size, os,  os_version, manufacturer, biz_id, user_id, android_id, device_id, model
        WHERE
        v1.action like 'app_usage' or v1.action like 'screen_usage'
        AND (
        arrivaltime >from_unixtime(${execTime}, 'yyyyMMddHH') and 
        arrivaltime <=from_unixtime(${currTime}, 'yyyyMMddHH')
        --arrivaltime >=from_unixtime(1476963547, 'yyyyMMddHH') and
        --arrivaltime <from_unixtime(1477309206, 'yyyyMMddHH')
);

-- Populate final table with new data.
SET hive.exec.dynamic.partition.mode=nonstrict;
insert into table  ofa_user_action_logs.raw_app_usage_logs partition(arrivaltime)
select t.*, from_unixtime (unix_timestamp(), 'yyyyMMddHH')
from ofa_user_action_logs.tmp_raw_app_usage_logs t;
-- Drop intermediate table
drop table if exists ofa_user_action_logs.tmp_raw_app_usage_logs;

