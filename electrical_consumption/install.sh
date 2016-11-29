#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
USER_DIR="/user/hadoop"
su hadoop
cd /user/hadoop/
cp ${DIR}/to_user_dir/* ${USER_DIR}/
mkdir /user/hadoop/units
javac -classpath hadoop-core.jar -d units ProcessUnits.java
jar -cvf units.jar -C units/ .
${HADOOP_HOME}/bin/hadoop fs -mkdir input_dir
${HADOOP_HOME}/bin/hadoop fs -put ${USER_DIR}/sample.txt input_dir
${HADOOP_HOME}/bin/hadoop fs -ls input_dir/
${HADOOP_HOME}/bin/hadoop jar units.jar hadoop.ProcessUnits input_dir output_dir
${HADOOP_HOME}/bin/hadoop fs -ls output_dir/
${HADOOP_HOME}/bin/hadoop fs -cat output_dir/part-00000
${HADOOP_HOME}/bin/hadoop fs -cat output_dir/part-00000/bin/hadoop dfs get output_dir ${USER_DIR}
