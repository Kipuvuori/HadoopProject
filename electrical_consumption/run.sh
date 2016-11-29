#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WORKING_DIR="/user/hadoop"
INPUT_DIR="${WORKING_DIR}/input_dir"
OUTPUT_DIR="${WORKING_DIR}/output_dir"
mkdir -p ${WORKING_DIR}/units
cp ${DIR}/to_user_dir/* ${WORKING_DIR}/
javac -classpath ${WORKING_DIR}/hadoop-core.jar -d units ${WORKING_DIR}/ProcessUnits.java
jar -cvf units.jar -C ${WORKING_DIR}/units/ ${WORKING_DIR}/
${HADOOP_HOME}/bin/hadoop fs -mkdir ${INPUT_DIR}
${HADOOP_HOME}/bin/hadoop fs -put ${WORKING_DIR}/sample.txt ${INPUT_DIR}
${HADOOP_HOME}/bin/hadoop fs -ls ${INPUT_DIR}/
${HADOOP_HOME}/bin/hadoop jar units.jar hadoop.ProcessUnits ${INPUT_DIR} ${OUTPUT_DIR}
${HADOOP_HOME}/bin/hadoop fs -ls ${OUTPUT_DIR}/
${HADOOP_HOME}/bin/hadoop fs -cat ${OUTPUT_DIR}/part-00000