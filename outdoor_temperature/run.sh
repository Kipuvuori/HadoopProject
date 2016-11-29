#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -z "$1" ]
# If first argument is empty.
then
    # Set default working directory.
    WORKING_DIR="/user/hadoop/outdoor_temperature"

    #get latest example temperature data

    URL="http://huone222.hopto.me:544/temperature.csv"

    echo $(date) 'Getting latest weather data. This might take a while...'
    curl -O --connect-timeout 45 --retry 5 "${URL}"

# If first argument is given
else
    # Set given working directory
    WORKING_DIR="${1%\/}"
fi

if [ -z "$2" ]
# If second argument is empty.
then
    # Set default sample filename directory.
    SAMPLE_FILE_PATH=${WORKING_DIR}/"temperature.csv"
# If second argument is given
else
    # Set given working directory
    SAMPLE_FILE_PATH="$2"
fi

# Setting used directories.
INPUT_DIR="${WORKING_DIR}/input_dir"
OUTPUT_DIR="${WORKING_DIR}/output_dir"
UNITS_DIR="${WORKING_DIR}/units"

echo "Working directory: ${WORKING_DIR}"
echo "Sample file: ${SAMPLE_FILE_PATH}"

# Ask user if he wants to continue with current settings.
read -p "Do you want to continue? " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

# Removing working directory.
rm -rf ${WORKING_DIR}
# Making working directory
mkdir -p ${UNITS_DIR}
# Copy necessary files to working directory.
cp ${DIR}/to_user_dir/* ${WORKING_DIR}/

# If sample file is not found.
if [ ! -f "$SAMPLE_FILE_PATH" ]
then
    # Print error
	echo "Sample file ${SAMPLE_FILE_PATH} not found!"
	# and exit.
	exit 1;
fi

# Compiling the ProcessUnits.java program.
javac -classpath ${WORKING_DIR}/hadoop-core.jar -d ${UNITS_DIR} ${WORKING_DIR}/ProcessUnits.java
# Making jar for the ProcessUnits.java program.
jar -cvf ${WORKING_DIR}/units.jar -C ${UNITS_DIR}/ .
# Making input directory for HDFS.
${HADOOP_HOME}/bin/hadoop fs -mkdir /${INPUT_DIR}
# Putting sample file to HDFS's input directory.
${HADOOP_HOME}/bin/hadoop fs -put ${SAMPLE_FILE_PATH} ${INPUT_DIR}
# Checking if files are in input directory.
${HADOOP_HOME}/bin/hadoop fs -ls ${INPUT_DIR}/
# Running Eleunit_max application with input and output directories.
${HADOOP_HOME}/bin/hadoop jar ${WORKING_DIR}/units.jar hadoop.ProcessUnits ${INPUT_DIR} ${OUTPUT_DIR}
# Checking files in output directory.
${HADOOP_HOME}/bin/hadoop fs -ls ${OUTPUT_DIR}/
# Printing result to terminal.
hdfs dfs -get output_dir /user/hadoop