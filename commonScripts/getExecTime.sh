if [ -f "/tmp/last_successful_$1" ]; then
  rm -f "/tmp/last_successful_$1"
fi
OUTPUT=`hdfs dfs -cat /user/oozie/workflows/data/lastExecTimes/last_successful_$1.time`
if [ -z "$OUTPUT" ]; then
  echo "exec_time 0" > "/tmp/last_successful_$1.time"
  hdfs dfs -copyFromLocal -f /tmp/last_successful_$1.time /user/oozie/workflows/data/lastExecTimes/
  OUTPUT="exec_time 0"
fi
echo $OUTPUT
