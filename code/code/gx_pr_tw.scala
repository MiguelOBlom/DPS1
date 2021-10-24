package dps.graphx.pr

import org.apache.spark.graphx.GraphLoader
import org.apache.spark.SparkContext
import org.apache.spark.SparkConf
//https://spark.apache.org/docs/latest/graphx-programming-guide.html#pagerank
import org.apache.spark.graphx.Graph


object Main extends App {
  val conf = new SparkConf().setAppName("GraphX PageRank Twitter")
  val sc = new SparkContext(conf)

  val graph = GraphLoader.edgeListFile(sc, "file:///local/ddps2001/twitter-2010.txt")

  val ranks = graph.pageRank(0.0001).vertices

  val users = sc.textFile("file:///local/ddps2001/twitter-2010.ids").map { line =>
    val fields = line.split(",")
    (fields(0).toLong, fields(1))
  }

  val ranksByUsername = users.join(ranks).map {
    case (id, (username, rank)) => (username, rank)
  }

  println(ranksByUsername.collect().mkString("\n"))
}


