drop table if exists ofa_user_action_logs.cooked_aggr_app_usage_logs;
create table if not exists ofa_user_action_logs.cooked_aggr_app_usage_logs
(
  month string,
  hour_of_day string,
  app_name string,
  screen_id string,
  device_name string,
  os_name string,
  os_version string,
  screen_resolution string,
  screen_size string,
  city string,
  screen_view_count bigint,
  uniq_users bigint,
  time_spent double
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';

-- ALL RECORDS
INSERT INTO TABLE ofa_user_action_logs.cooked_aggr_app_usage_logs
SELECT
regexp_replace(month, '\t', ' ') AS month, regexp_replace(hour_of_day, '\t', ' ') AS hour_of_day, regexp_replace(app_name, '\t', ' ') AS app_name, regexp_replace(screen_id, '\t', ' ') AS screen_id, regexp_replace(device_name, '\t', ' ') AS device_name, regexp_replace(os_name, '\t', ' ') AS os_name, regexp_replace(os_version, '\t', ' ') AS os_version, regexp_replace(screen_resolution, '\t', ' ') AS screen_resolution, regexp_replace(screen_size, '\t', ' ') AS screen_size, null as city, regexp_replace(sum(screen_view_count), '\t', ' ') AS screen_view_count, regexp_replace(count(distinct(user_id)), '\t', ' ') AS user_id, regexp_replace(avg(time_spent), '\t', ' ') AS time_spent
FROM
ofa_user_action_logs.cooked_app_usage_logs
GROUP BY
regexp_replace(month, '\t', ' '), regexp_replace(hour_of_day, '\t', ' '), regexp_replace(app_name, '\t', ' '), regexp_replace(screen_id, '\t', ' '), regexp_replace(device_name, '\t', ' '), regexp_replace(os_name, '\t', ' '), regexp_replace(os_version, '\t', ' '), regexp_replace(screen_resolution, '\t', ' '), regexp_replace(screen_size, '\t', ' ');

-- ALL screen ids
INSERT INTO TABLE ofa_user_action_logs.cooked_aggr_app_usage_logs
SELECT
regexp_replace(month, '\t', ' ') AS month, regexp_replace(hour_of_day, '\t', ' ') AS hour_of_day, regexp_replace(app_name, '\t', ' ') AS app_name, 'ALL' AS screen_id, regexp_replace(device_name, '\t', ' ') AS device_name, regexp_replace(os_name, '\t', ' ') AS os_name, regexp_replace(os_version, '\t', ' ') AS os_version, regexp_replace(screen_resolution, '\t', ' ') AS screen_resolution, regexp_replace(screen_size, '\t', ' ') AS screen_size, null as city, regexp_replace(sum(screen_view_count), '\t', ' ') AS screen_view_count, regexp_replace(count(distinct(user_id)), '\t', ' ') AS user_id, regexp_replace(avg(time_spent), '\t', ' ') AS time_spent
FROM
ofa_user_action_logs.cooked_app_usage_logs
GROUP BY
regexp_replace(month, '\t', ' '), regexp_replace(hour_of_day, '\t', ' '), regexp_replace(app_name, '\t', ' '), 'ALL', regexp_replace(device_name, '\t', ' '), regexp_replace(os_name, '\t', ' '), regexp_replace(os_version, '\t', ' '), regexp_replace(screen_resolution, '\t', ' '), regexp_replace(screen_size, '\t', ' ');

-- ALL hour_of_day
INSERT INTO TABLE ofa_user_action_logs.cooked_aggr_app_usage_logs
SELECT
regexp_replace(month, '\t', ' ') AS month, 'ALL' AS hour_of_day, regexp_replace(app_name, '\t', ' ') AS app_name, regexp_replace(screen_id, '\t', ' ') AS screen_id, regexp_replace(device_name, '\t', ' ') AS device_name, regexp_replace(os_name, '\t', ' ') AS os_name, regexp_replace(os_version, '\t', ' ') AS os_version, regexp_replace(screen_resolution, '\t', ' ') AS screen_resolution, regexp_replace(screen_size, '\t', ' ') AS screen_size,null as city, regexp_replace(sum(screen_view_count), '\t', ' ') AS screen_view_count, regexp_replace(count(distinct(user_id)), '\t', ' ') AS user_id, regexp_replace(avg(time_spent), '\t', ' ') AS time_spent
FROM
ofa_user_action_logs.cooked_app_usage_logs
GROUP BY
regexp_replace(month, '\t', ' '), 'ALL', regexp_replace(app_name, '\t', ' '), regexp_replace(screen_id, '\t', ' '), regexp_replace(device_name, '\t', ' '), regexp_replace(os_name, '\t', ' '), regexp_replace(os_version, '\t', ' '), regexp_replace(screen_resolution, '\t', ' '), regexp_replace(screen_size, '\t', ' ');

-- ALL hour_of_day and ALL screen_id
INSERT INTO TABLE ofa_user_action_logs.cooked_aggr_app_usage_logs
SELECT
regexp_replace(month, '\t', ' ') AS month, 'ALL' AS hour_of_day, regexp_replace(app_name, '\t', ' ') AS app_name, 'ALL' AS screen_id, regexp_replace(device_name, '\t', ' ') AS device_name, regexp_replace(os_name, '\t', ' ') AS os_name, regexp_replace(os_version, '\t', ' ') AS os_version, regexp_replace(screen_resolution, '\t', ' ') AS screen_resolution, regexp_replace(screen_size, '\t', ' ') AS screen_size,null as city, regexp_replace(sum(screen_view_count), '\t', ' ') AS screen_view_count, regexp_replace(count(distinct(user_id)), '\t', ' ') AS user_id, regexp_replace(avg(time_spent), '\t', ' ') AS time_spent
FROM
ofa_user_action_logs.cooked_app_usage_logs
GROUP BY
regexp_replace(month, '\t', ' '), regexp_replace(app_name, '\t', ' '), regexp_replace(device_name, '\t', ' '), regexp_replace(os_name, '\t', ' '), regexp_replace(os_version, '\t', ' '), regexp_replace(screen_resolution, '\t', ' '), regexp_replace(screen_size, '\t', ' ');
