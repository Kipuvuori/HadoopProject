package hadoop;

import java.io.IOException;
import java.util.*;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.conf.*;
import org.apache.hadoop.io.*;
import org.apache.hadoop.mapreduce.*;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.input.TextInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.mapreduce.lib.output.TextOutputFormat;

public class ProcessUnits {
    //Mapper class
    public static class TempMap extends Mapper<LongWritable, Text, Text, DoubleWritable> {

        public void map(LongWritable key, Text value, Context context)
                throws IOException, InterruptedException {

            String record = value.toString();
            //split csv
            String[] parts = record.split(",");
            //extract date and temperature
            context.write(new Text(parts[0].substring(0,7)), new DoubleWritable(Double.parseDouble(parts[1])));
        }
    }


    //Reducer class
    public static class TempReduce extends Reducer<Text, DoubleWritable, Text, DoubleWritable> {

        public void reduce(Text key, Iterable<DoubleWritable> values,Context context) throws IOException, InterruptedException {

            double temp_sum = 0;
            int item_sum = 0;

            //Looping and calculating average for each month
            for (DoubleWritable val : values) {
                temp_sum += val.get();
                item_sum++;
            }

            context.write(key, new DoubleWritable(temp_sum/item_sum));
        }
    }




    //Main function
    public static void main(String args[]) throws Exception {
        Configuration conf = new Configuration();

        Job job = new Job(conf, "avg_temp");

        job.setJarByClass(ProcessUnits.class);

        job.setMapOutputKeyClass(Text.class);

        job.setMapOutputValueClass(DoubleWritable.class);

        job.setOutputKeyClass(Text.class);

        job.setOutputValueClass(DoubleWritable.class);

        job.setMapperClass(TempMap.class);

        job.setReducerClass(TempReduce.class);

        job.setInputFormatClass(TextInputFormat.class);

        job.setOutputFormatClass(TextOutputFormat.class);

        FileInputFormat.addInputPath(job, new Path(args[0]));

        FileOutputFormat.setOutputPath(job,new Path(args[1]));

        job.waitForCompletion(true);
    }
}