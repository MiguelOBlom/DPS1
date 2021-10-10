//https://spark.apache.org/docs/latest/graphx-programming-guide.html#connected-components
import org.apache.spark.graphx.GraphLoader

val graph = GraphLoader.edgeListFile(sc, "data/twitter-2010@10000.txt")

val cc = graph.connectedComponents().vertices

val users = sc.textFile("data/twitter-2010-ids.txt").map { line =>
  val fields = line.split(",")
  (fields(0).toLong, fields(1))
}

val ccByUsername = users.join(cc).map {
  case (id, (username, cc)) => (username, cc)
}

println(ccByUsername.collect().mkString("\n"))