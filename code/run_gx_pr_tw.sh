module load prun
source export_vars.sh

DPS_TIME=$2
DPS_NNODES=$1

preserve -# $DPS_NNODES -t $DPS_TIME;

while : ; do
	sleep 1;
	NODES=$(preserve -llist | tail -n+4 | grep $(whoami) | sort -r | head -n1 | awk '{$1=$2=$3=$4=$5=$6=$8=""; if($7=="R"){$7="";print $0}}')
	[[ -z "$NODES" ]] || break
done


for node in $NODES
do
	(
	ssh $node "mkdir -p /local/$(whoami)"
        scp /var/scratch/$(whoami)/data/twitter-2010.ids $node:/local/$(whoami)/twitter-2010.ids
        scp /var/scratch/$(whoami)/data/twitter-2010@10000.txt $node:/local/$(whoami)/twitter-2010.txt
	) & 
done
wait


MASTER=$(echo $NODES | awk '{print $1}')
/var/scratch/$(whoami)/configure-spark.sh $MASTER.ib.cluster
WORKERS=$(echo $NODES | awk '{$1=""; print $0}')

echo $MASTER
MASTER_IP=$(ssh $MASTER "/var/scratch/$(whoami)/dps-master.sh" | grep "10\.")

echo "Master IP: \""$MASTER_IP"\""

echo $WORKERS
for worker in $WORKERS
do
	(
	echo "Starting " $worker " with " $MASTER_IP
	ssh $worker "/var/scratch/$(whoami)/dps-worker.sh $MASTER_IP:7077"
	) &
done
wait

ssh $MASTER "source /var/scratch/$(whoami)/export_vars.sh; spark-submit --executor-memory 68G --conf spark.driver.maxResultSize=\"0\" --master spark://$MASTER_IP:7077 /var/scratch/$(whoami)/graphx_pagerank_twitter_2010/target/scala-2.12/graphx_pagerank_twitter_2010_2.12-0.1.0-SNAPSHOT.jar"

