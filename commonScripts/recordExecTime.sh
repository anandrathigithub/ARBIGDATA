echo "exec_time $1" > "/tmp/last_successful_$2.time"
hdfs dfs -copyFromLocal -f /tmp/last_successful_$2.time /user/oozie/workflows/data/lastExecTimes
