#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WORKING_DIR="/user/hadoop/electrical_consumption"
INPUT_DIR="${WORKING_DIR}/input_dir"
OUTPUT_DIR="${WORKING_DIR}/output_dir"
UNITS_DIR="${WORKING_DIR}/units"

rm -rf ${WORKING_DIR}
mkdir -p ${UNITS_DIR}
cp ${DIR}/to_user_dir/* ${WORKING_DIR}/
javac -classpath ${WORKING_DIR}/hadoop-core.jar -d ${UNITS_DIR} ${WORKING_DIR}/ProcessUnits.java
jar -cvf ${WORKING_DIR}/units.jar -C ${UNITS_DIR}/ .
${HADOOP_HOME}/bin/hadoop fs -mkdir ${INPUT_DIR}
${HADOOP_HOME}/bin/hadoop fs -put ${WORKING_DIR}/sample.txt ${INPUT_DIR}
${HADOOP_HOME}/bin/hadoop fs -ls ${INPUT_DIR}/
${HADOOP_HOME}/bin/hadoop jar ${WORKING_DIR}/units.jar hadoop.ProcessUnits ${INPUT_DIR} ${OUTPUT_DIR}
${HADOOP_HOME}/bin/hadoop fs -ls ${OUTPUT_DIR}/
${HADOOP_HOME}/bin/hadoop fs -cat ${OUTPUT_DIR}/part-00000