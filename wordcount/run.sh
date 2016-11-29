#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -z "$1" ]
# If first argument is empty.
then
    # Set default working directory.
    WORKING_DIR=DIR
# If first argument is given
else
    # Set given working directory
    WORKING_DIR="${1%\/}"
fi

# Setting directories to use.
INPUT_DIR="${WORKING_DIR}/input"
OUTPUT_DIR="${WORKING_DIR}/output"

# Removing input and output directories.
rm -rf ${INPUT_DIR}
rm -rf ${OUTPUT_DIR}
# Making input directory.
mkdir -p ${INPUT_DIR}
# Adding input files to input directory.
cp ${DIR}/input_files/* ${INPUT_DIR}/
# Run wordcount program on input dir and output results to output dir.
hadoop jar /usr/local/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.7.2.jar wordcount ${INPUT_DIR} ${OUTPUT_DIR}