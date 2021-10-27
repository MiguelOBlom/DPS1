DPS_NNODES=$1
MASTER_IP=$2

for i in {1..25};
do
  	echo $i " start"
        (time spark-submit --executor-memory 60G --conf spark.driver.bindAddress=$MASTER_IP --master spark://$MASTER_IP:7077 /var/scratch/$(whoami)/graphx_connected_components_twitter_2010/target/scala-2.12/graphx_connected_components_twitter_2010_2.12-0.1.0-SNAPSHOT.jar) &>> /var/scratch/$(whoami)/timings/graphx/twitter_connectedcomponents.txt 
        echo $i " stop"
done
