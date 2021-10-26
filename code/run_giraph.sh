module load prun
source export_vars_giraph.sh

DPS_CMD=$3
DPS_TIME=$2
DPS_NNODES=$1

# Reserve nodes and get their names
NODES=$(./reserve_nodes.sh $DPS_NNODES $DPS_TIME)

# Remove local directory for each node
for node in $NODES
do
        ssh $node "rm -rf /local/$(whoami); mkdir -p /local/$(whoami)/"
done

# Seperate the master from the workers
MASTER=$(echo $NODES | awk '{print $1}')
WORKERS=$(echo $NODES | awk '{$1=""; print $0}')

# Reinitialize the slaves file with the current workers
rm -f $HADOOP_PREFIX/conf/slaves
for worker in $WORKERS
do
        echo "$(ssh $worker $'ifconfig | grep inet | grep -o \'10\.149\.\S*\' | awk -F . \'$NF !~ /^255/\'')" >> $HADOOP_PREFIX/conf/slaves
done

# Configure Hadoop and Giraph with the current Master IP
MASTER_IP=$(ssh $MASTER $'ifconfig | grep inet | grep -o \'10\.149\.\S*\' | awk -F . \'$NF !~ /^255/\'')
./configure-giraph.sh $MASTER_IP

# Make sure all services are stopped, format the nodes and start the services
ssh $MASTER_IP "source /var/scratch/$(whoami)/export_vars_giraph.sh; $HADOOP_PREFIX/bin/stop-mapred.sh; $HADOOP_PREFIX/bin/stop-dfs.sh;"
ssh $MASTER_IP "source /var/scratch/$(whoami)/export_vars_giraph.sh; echo 'Y' | hadoop namenode -format; $HADOOP_PREFIX/bin/start-dfs.sh; $HADOOP_PREFIX/bin/start-mapred.sh;"

# Can be used to make sure all services are running accordingly
#for node in $NODES
#do
#        echo $node
#        ssh $node "source /var/scratch/$(whoami)/export_vars_giraph.sh; jps"
#done

# Copy the data to the hdfs
echo "Copying file"
ssh $MASTER_IP "source /var/scratch/$(whoami)/export_vars_giraph.sh; hadoop dfs -copyFromLocal /var/scratch/$(whoami)/data/twitter-2010.txt /twitter-2010.txt"
ssh $MASTER_IP "source /var/scratch/$(whoami)/export_vars_giraph.sh; hadoop dfs -ls /"

# Run our experiment
ssh $MASTER_IP "source /var/scratch/$(whoami)/export_vars_giraph.sh; $DPS_CMD $DPS_NNODES"

# Can be used to retrieve the structure of the hdfs files
#ssh $MASTER_IP "source /var/scratch/$(whoami)/export_vars_giraph.sh; hadoop dfs -lsr /"

# Can be used to retrieve the data
#ssh $MASTER_IP "source /var/scratch/$(whoami)/export_vars_giraph.sh; hadoop dfs -cat /output/p*"

# Stop all services
ssh $MASTER_IP "source /var/scratch/$(whoami)/export_vars_giraph.sh; $HADOOP_PREFIX/bin/stop-mapred.sh; $HADOOP_PREFIX/bin/stop-dfs.sh;"

# Release the nodes
preserve -c $(preserve -llist | tail -n+4 | grep $(whoami) | sort -r | head -n1 | awk '{print $1}')
