module load prun
source export_vars_graphx.sh

DPS_CMD=$3
DPS_TIME=$2
DPS_NNODES=$1

NODES=$(./reserve_nodes.sh $DPS_NNODES $DPS_TIME)

echo "Copying file"
for node in $NODES
do
	(
		ssh $node "rm -rf /local/$(whoami); mkdir -p /local/$(whoami)"
        	scp /var/scratch/$(whoami)/data/twitter-2010.txt $node:/local/$(whoami)/twitter-2010.txt
		scp /var/scratch/$(whoami)/data/twitter-2010.ids $node:/local/$(whoami)/twitter-2010.ids
	) & 
done
wait

# Configuring Spark
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

ssh $MASTER_IP "source /var/scratch/$(whoami)/export_vars_graphx.sh; $DPS_CMD $DPS_NNODES $MASTER_IP"
 

#ssh $MASTER "source /var/scratch/$(whoami)/export_vars_graphx.sh; spark-submit --executor-memory 60G --conf spark.driver.maxResultSize=\"0\" --master spark://$MASTER_IP:7077 /var/scratch/$(whoami)/graphx_pagerank_twitter_2010/target/scala-2.12/graphx_pagerank_twitter_2010_2.12-0.1.0-SNAPSHOT.jar"

# Release the nodes
preserve -llist
echo $(preserve -llist | tail -n+4 | grep $(whoami) | sort -r | head -n1 | awk '{print $1}')
preserve -c $(preserve -llist | tail -n+4 | grep $(whoami) | sort -r | head -n1 | awk '{print $1}')
preserve -llist
