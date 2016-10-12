# Example
mkdir input
cp $HADOOP_HOME/*.txt input
hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.7.2.jar  wordcount input output
