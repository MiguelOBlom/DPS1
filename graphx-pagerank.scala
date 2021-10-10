//https://spark.apache.org/docs/latest/graphx-programming-guide.html#pagerank
import org.apache.spark.graphx.GraphLoader

val graph = GraphLoader.edgeListFile(sc, "data/twitter-2010@10000.txt")

val ranks = graph.pageRank(0.0001).vertices

val users = sc.textFile("data/twitter-2010-ids.txt").map { line =>
  val fields = line.split(",")
  (fields(0).toLong, fields(1))
}

val ranksByUsername = users.join(ranks).map {
  case (id, (username, rank)) => (username, rank)
}

println(ranksByUsername.collect().mkString("\n"))
