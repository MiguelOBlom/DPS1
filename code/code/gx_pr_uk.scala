package dps.graphx.pr

import de.l3s.mapreduce.webgraph.io._
import org.apache.spark.SparkContext
import org.apache.spark.SparkConf
import org.apache.hadoop.io.IntWritable;
//https://spark.apache.org/docs/latest/graphx-programming-guide.html#pagerank
import org.apache.spark.graphx.Graph


object Main extends App {

  val conf = new SparkConf().setAppName("Simple Application")
  val sc = new SparkContext(conf)

  WebGraphInputFormat.setBasename(sc.hadoopConfiguration, "file:/local/ddps2001/uk-2007-05")
  WebGraphInputFormat.setNumberOfSplits(sc.hadoopConfiguration, 100)
  val rdd = sc.newAPIHadoopRDD(sc.hadoopConfiguration, classOf[WebGraphInputFormat], classOf[IntWritable], classOf[IntArrayWritable])

  val edges = rdd.flatMap{case (id, out) => out.values.map(outId => (id.get.toLong, outId.toLong))}
  val graph = Graph.fromEdgeTuples(edges, true)

  val ranks = graph.pageRank(0.0001).vertices

  //val users = sc.textFile("/local/ddps2001/uk-2007-05.urls").map { line =>
  //  val fields = line.split(",")
  //  (fields(0).toLong, fields(1))
  //}

  val users = sc.textFile("file:/local/ddps2001/uk-2007-05.urls").zipWithIndex().map { case (line, i) =>
    (i.toLong, line)
  }

  val ranksByUsername = users.join(ranks).map {
    case (id, (username, rank)) => (username, rank)
  }

  println(ranksByUsername.collect().mkString("\n"))
}


