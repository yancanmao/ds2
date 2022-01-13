#!/bin/bash

### ### ###  		   ### ### ###

### ### ### INITIALIZATION ### ### ###

### ### ###  		   ### ### ###

### paths configuration ###
FLINK_BUILD_PATH="/home/myc/workspace/flink-related/flink-extended-copy/build-target/"
FLINK=$FLINK_BUILD_PATH$"bin/flink"
JAR_PATH="/home/myc/workspace/flink-related/flink-testbed/target/testbed-1.0-SNAPSHOT.jar"

### dataflow configuration ###
QUERY_CLASS="flinkapp.KafkaStatefulDemoLongRun"
SOURCE_NAME="Source: Custom Source"
MAP_NAME="Splitter FlatMap"

### operators and parallelism
if [ "$1" == "" ]; then
    echo "Please provide operators and their initial parallelism"
    exit 1
fi

### parse operator pairs
IFS='#' read -r -a array <<< "$1"
for element in "${array[@]}"
do
    IFS=',' read -r -a parallelism <<< "$element"
        ## search for SOURCE_NAME
    if [ "${parallelism[0]}" == "$SOURCE_NAME" ]; then
        echo "Source parallelism: ${parallelism[@]: -1:1}"
        P_SOURCE="${parallelism[@]: -1:1}"
    fi
    ## search for FlatMap
    if [ "${parallelism[0]}" == "$MAP_NAME" ]; then
        echo "FlatMap parallelism: ${parallelism[@]: -1:1}"
        P1="${parallelism[@]: -1:1}"
    fi
done

nohup $FLINK run -d --class $QUERY_CLASS $JAR_PATH --p1 $P_SOURCE --p2 $P1 & > job.out
