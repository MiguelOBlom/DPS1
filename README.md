# DPS1
## Installation
The code can be installed by running the following commands in the terminal.
```
cd ~
git clone https://github.com/MiguelOBlom/DPS1.git
mkdir /var/scratch/$(whoami)/
cp -a ~/DPS1/code/. /var/scratch/$(whoami)/
(cd /var/scratch/$(whoami)/; ./init.sh)
```

## Execution
In /var/scratch/user we can now:

```
# Run the Graphx Connected Components
./run_graphx.sh 17 02:00:00 /var/scratch/$(whoami)/graphx_twitter_connected_components.sh
```

```
# Run Giraph Connected Components
for i in {1..25}; do ./run_giraph.sh 17 00:10:00 /var/scratch/ddps2001/giraph_twitter_connected_components.sh; done
```

In GraphX we do not have to reset the environment like we have to in Giraph.


```
for i in {9 13 17 25 49 57}; do ./run_graphx_scaling.sh $i 01:00:00 /var/scratch/ddps2001/graphx_twitter_pagerank.sh; done
```


Running Hadoop:

ssh $MASTER "spark-submit --conf spark.driver.maxResultSize=\"0\" --executor-memory 60G --jars /var/scratch/$(whoami)/HadoopWebGraph/target/hadoop-webgraph-1.0-SNAPSHOT.jar --master spark://$MASTER_IP:7077 /var/scratch/$(whoami)/graphx_pagerank_twitter_2010/target/scala-2.12/graphx_pagerank_twitter_2010_2.12-0.1.0-SNAPSHOT.jar"
