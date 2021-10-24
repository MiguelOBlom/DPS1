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
        ssh $node "rm -rf /local/$(whoami); mkdir -p /local/$(whoami)/"
        ssh $node "source /var/scratch/$(whoami)/export_vars.sh; $HADOOP_PREFIX/bin/stop-all.sh"
done


MASTER=$(echo $NODES | awk '{print $1}')
WORKERS=$(echo $NODES | awk '{$1=""; print $0}')

rm -f $HADOOP_PREFIX/conf/slaves

for worker in $WORKERS
do
        echo "$(ssh $worker $'ifconfig | grep inet | grep -o \'10\.149\.\S*\' | awk -F . \'$NF !~ /^255/\'')" >> $HADOOP_PREFIX/conf/slaves
done

MASTER_IP=$(ssh $MASTER $'ifconfig | grep inet | grep -o \'10\.149\.\S*\' | awk -F . \'$NF !~ /^255/\'')
./configure-giraph.sh $MASTER_IP

#echo "$MASTER_IP" >> $HADOOP_PREFIX/conf/slaves

ssh $MASTER_IP "source /var/scratch/$(whoami)/export_vars.sh; $HADOOP_PREFIX/bin/stop-mapred.sh; $HADOOP_PREFIX/bin/stop-dfs.sh;"
ssh $MASTER_IP "source /var/scratch/$(whoami)/export_vars.sh; echo 'Y' | hadoop namenode -format; $HADOOP_PREFIX/bin/start-dfs.sh; $HADOOP_PREFIX/bin/start-mapred.sh; jps"

for node in $NODES
do
        echo $node
        ssh $node "source /var/scratch/$(whoami)/export_vars.sh; jps"
done

ssh $MASTER_IP "source /var/scratch/$(whoami)/export_vars.sh; hadoop dfs -copyFromLocal /var/scratch/$(whoami)/data/twitter-2010.txt /twitter-2010.txt"
#ssh $MASTER_IP "source /var/scratch/$(whoami)/export_vars.sh; hadoop dfs -copyFromLocal /var/scratch/$(whoami)/data/twitter-2010.ids /input/twitter-2010.ids"
#ssh $MASTER_IP "source /var/scratch/$(whoami)/export_vars.sh; hadoop dfs -copyFromLocal /var/scratch/$(whoami)/tiny_graph.txt /tiny_graph.txt"
ssh $MASTER_IP "source /var/scratch/$(whoami)/export_vars.sh; hadoop dfs -ls /"

#ssh $MASTER_IP "source /var/scratch/$(whoami)/export_vars.sh; hadoop jar /var/scratch/$(whoami)/giraph/giraph-examples/target/giraph-examples-1.4.0-SNAPSHOT-for-hadoop-1.2.1-jar-with-dependencies.jar org.apache.giraph.GiraphRunner org.apache.giraph.examples.PageRankComputation -vif org.apache.giraph.io.formats.DoubleDoubleNullTextInputFormat -vip /twitter-2010@10000.txt -op /output/twitter -w $((DPS_NNODES-1))"

ssh $MASTER_IP "source /var/scratch/$(whoami)/export_vars.sh; hadoop jar /var/scratch/$(whoami)/giraph/giraph-examples/target/giraph-examples-1.4.0-SNAPSHOT-for-hadoop-1.2.1-jar-with-dependencies.jar org.apache.giraph.GiraphRunner org.apache.giraph.examples.ConnectedComponentsComputation -vif org.apache.giraph.io.formats.IntIntNullTextVertexInputFormat -vip /twitter-2010.txt -vof org.apache.giraph.io.formats.IdWithValueTextOutputFormat -op /output/shortestpaths -w $((DPS_NNODES-1))"

#ssh $MASTER_IP "source /var/scratch/$(whoami)/export_vars.sh; hadoop jar /var/scratch/$(whoami)/giraph/giraph-examples/target/giraph-examples-1.4.0-SNAPSHOT-for-hadoop-1.2.1-jar-with-dependencies.jar org.apache.giraph.GiraphRunner org.apache.giraph.examples.PageRankComputation -vip /twitter-2010@10000.txt -op /output/twitter -w $((DPS_NNODES-1))"

ssh $MASTER_IP "source /var/scratch/$(whoami)/export_vars.sh; hadoop dfs -ls /"
ssh $MASTER_IP "source /var/scratch/$(whoami)/export_vars.sh; hadoop dfs -ls /output/"
ssh $MASTER_IP "source /var/scratch/$(whoami)/export_vars.sh; hadoop dfs -ls /output/shortestpaths"
ssh $MASTER_IP "source /var/scratch/$(whoami)/export_vars.sh; hadoop dfs -cat /output/shortestpaths/p*"

ssh $MASTER_IP "source /var/scratch/$(whoami)/export_vars.sh; $HADOOP_PREFIX/bin/stop-mapred.sh; $HADOOP_PREFIX/bin/stop-dfs.sh;"
preserve -c $(preserve -llist | tail -n+4 | grep $(whoami) | sort -r | head -n1 | awk '{print $1}')
