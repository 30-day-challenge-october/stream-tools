package com.casey.streams

import io.eels.component.parquet.{ParquetSink, ParquetSource}
import org.apache.hadoop.conf.Configuration
import org.apache.hadoop.fs.{FileSystem, Path}

/**
 * @author ${user.name}
 */
object App {
  def main(args : Array[String]) {

        val source: String = try {args(0)} catch {case e: Exception => {println("must pass valid arg 1: source path"); throw new Exception("invalid arg1")}}
        val output: String = try {args(1)} catch {case e: Exception => {println("must pass valid arg 2: output path"); throw new Exception("invalid arg2")}}
        val appendType: String = try {args(2).toLowerCase} catch {case e: Exception => {println("must pass valid arg 3: appendType"); throw new Exception("invalid arg3")}}

        if (appendType.toLowerCase() != "primary_key") {
            println("Sorry, I can only append primary keys to source parquets. For now...\n\n" +
            "Add more functionality at https://github.com/30-day-challenge-october/stream-tools/parquet-appender")
            return
        }
        // this is needed... Don't worry, it can still run locally...
        implicit val hadoopConfiguration = new Configuration()
        implicit val hadoopFileSystem = FileSystem.get(hadoopConfiguration)

        val parquetFilePath = new Path(source)
        println("loading parquet file " + source)

        val sink = ParquetSink(new Path(output + ".appender"))
        val parquetDS = ParquetSource(parquetFilePath).toDataStream()
        val lastIndex = parquetDS.count
        println("parquet row count before append: " + lastIndex)
        parquetDS.to(sink)
        println("parquet row count after append: " + lastIndex)
        println("done")
  }

}
