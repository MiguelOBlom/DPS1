package dps.graphx.pr

import org.apache.spark.graphx.GraphLoader
import org.apache.spark.SparkContext
import org.apache.spark.SparkConf
//https://spark.apache.org/docs/latest/graphx-programming-guide.html#connected-components
import org.apache.spark.graphx.Graph


object Main extends App {
  val conf = new SparkConf().setAppName("GraphX PageRank Twitter")
  val sc = new SparkContext(conf)

  val graph = GraphLoader.edgeListFile(sc, "/local/ddps2001/twitter-2010.txt")

  val cc = graph.connectedComponents().vertices

  val users = sc.textFile("/local/ddps2001/twitter-2010.ids").map { line =>
    val fields = line.split(",")
    (fields(0).toLong, fields(1))
  }

  val ccByUsername = users.join(cc).map {
    case (id, (username, cc)) => (username, cc)
  }

  println(ccByUsername.collect().mkString("\n"))
}


