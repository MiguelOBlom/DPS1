module load prun
source spark.sh

DPS_TIME=$2
DPS_NNODES=$1

preserve -# $DPS_NNODES -t $DPS_TIME;
sleep 2;

while : ; do
	sleep 1;
	NODES=$(preserve -llist | tail -n+4 | grep $(whoami) | sort -r | head -n1 | awk '{$1=$2=$3=$4=$5=$6=$8=""; if($7=="R"){$7="";print $0}}')
	[[ -z "$NODES" ]] || break
done

MASTER=$(echo $NODES | awk '{print $1}')
WORKERS=$(echo $NODES | awk '{$1=""; print $0}')

for worker in $WORKERS
do
	ssh $worker "$(ifconfig | grep inet | grep -o '10\.149\.\S*' | awk -F . '$NF !~ /^255/')"
done


echo $MASTER
MASTER_IP=$(ssh $MASTER "bash -s" < dps-master.sh | grep "10\.")

echo $MASTER_IP
echo $MASTER_IP

echo $WORKERS
for worker in $WORKERS
do
	echo "Starting " $worker " with " $MASTER_IP
	ssh $worker "bash -s" < dps-worker.sh $MASTER_IP:7077
done

#spark-submit --class org.apache.spark.examples.graphx.DPSPageRankExample --master spark://$MASTER_IP:7077 spark/examples/jars/spark-examples_2.12-3.1.2.jar 100

#spark-submit --class org.apache.spark.examples.SparkPi --master spark://$MASTER_IP:7077 spark/examples/jars/spark-examples_2.12-3.1.2.jar 100

#spark-submit --master spark://$MASTER_IP:7077 graphx-pagerank_2.12-0.1.0-SNAPSHOT.jar

#spark-submit --conf spark.driver.maxResultSize="0" --executor-memory 60G --jars /home/ddps2001/HadoopWebGraph/target/hadoop-webgraph-1.0-SNAPSHOT.jar --master spark://$MASTER_IP:7077 /home/ddps2001/gp/target/scala-2.12/graphx-pagerank_2.12-0.1.0-SNAPSHOT.jar

#spark-submit --conf spark.driver.maxResultSize="0" --executor-memory 60G --jars /var/scratch/$(whoami)/HadoopWebGraph/target/hadoop-webgraph-1.0-SNAPSHOT.jar --master spark://$MASTER_IP:7077 /var/scratch/$(whoami)/graphx_pagerank_uk_2007_05/target/scala-2.12/graphx_pagerank_uk_2007_05_2.12-0.1.0-SNAPSHOT.jar
ssh $MASTER "spark-submit --conf spark.driver.maxResultSize=\"0\" --executor-memory 60G --jars /var/scratch/$(whoami)/HadoopWebGraph/target/hadoop-webgraph-1.0-SNAPSHOT.jar --master spark://$MASTER_IP:7077 /var/scratch/$(whoami)/graphx_pagerank_twitter_2010/target/scala-2.12/graphx_pagerank_twitter_2010_2.12-0.1.0-SNAPSHOT.jar"




#spark-submit --master spark://$MASTER_IP:7077 $DPS_PROG
#prun -reserve $(preserve -llist | grep $(whoami) | awk '{print $1}' | sort -r | head -n1) -np $DPS_NNODES $DPS_PROG
