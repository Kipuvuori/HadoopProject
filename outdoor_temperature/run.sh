#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -z "$1" ]
# If first argument is empty.
then
    # Set default working directory.
    WORKING_DIR="/user/hadoop/outdoor_temperature"
# If first argument is given
else
    # Set given working directory
    WORKING_DIR="${1%\/}"
fi

if [ -z "$2" ]
# If second argument is empty.
then

    #get latest example temperature data
    URL="http://huone222.hopto.me:544/temperature.csv"
    echo $(date) 'Getting latest weather data to ' ${DIR}'/to_user_dir/temperature.csv. This might take a while...'
    curl --connect-timeout 45 --retry 5 -o ${DIR}/to_user_dir/temperature.csv "${URL}"

    echo ''

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
read -p "Do you want to continue (y/N)? " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

echo ''

# Ask user for prefered unit of time
read -p "Select unit of time (y,m,D,h) " ans
    case $ans in
        [Yy]* ) echo 'Calculating yearly average temperature';TIME_UNIT="y";;
        [Mm]* ) echo 'Calculating monthly average temperature'; TIME_UNIT="m";;
		[Hh]* ) echo 'Calculating hourly average temperature'; TIME_UNIT="h";;
        * ) echo 'Calculating daily average temperature';  TIME_UNIT="d";;
esac

echo ''

# Removing working directory.
rm -rf ${WORKING_DIR}
# Making working directory
mkdir -p ${UNITS_DIR}
# Copy necessary files to working directory.
cp  ${DIR}/to_user_dir/* ${WORKING_DIR}/


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
# Clearing working directory for HDFS.
#${HADOOP_HOME}/bin/hadoop fs -rm -r -f ${WORKING_DIR}
#${HADOOP_HOME}/bin/hadoop fs -mkdir -p ${WORKING_DIR}
# Making input directory for HDFS.
${HADOOP_HOME}/bin/hadoop fs -mkdir -p ${INPUT_DIR}
# Putting sample file to HDFS's input directory.
${HADOOP_HOME}/bin/hadoop fs -put ${SAMPLE_FILE_PATH} ${INPUT_DIR}
# Checking if files are in input directory.
${HADOOP_HOME}/bin/hadoop fs -ls ${INPUT_DIR}/
# Running this application with input and output directories.
${HADOOP_HOME}/bin/hadoop jar ${WORKING_DIR}/units.jar hadoop.ProcessUnits ${INPUT_DIR} ${OUTPUT_DIR} ${TIME_UNIT}
# Checking files in output directory.
${HADOOP_HOME}/bin/hadoop fs -ls ${OUTPUT_DIR}/
# Get files form hdfs
hdfs dfs -get ${OUTPUT_DIR} ${WORKING_DIR}
# Printing result to terminal.
cat ${OUTPUT_DIR}/part-r-00000