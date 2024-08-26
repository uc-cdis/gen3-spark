#!/bin/bash

check_namenode() {
  echo "Checking if namenode is ready"
  safe_mode_status=$(hdfs dfsadmin -safemode get | grep 'Safe mode is OFF')
  if [[ $safe_mode_status == *"Safe mode is OFF"* ]]; then
    echo "NameNode is out of Safe Mode."
    return 0
  else
    echo "NameNode is still in Safe Mode. Waiting..."
    return 1
  fi
}

# Wait for NameNode to leave Safe Mode
until check_namenode; do
  sleep 30
done

echo "Starting ResourceManager..."

$HADOOP_HOME/bin/yarn --config $HADOOP_CONF_DIR resourcemanager