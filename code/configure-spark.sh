# Set the SPARK_MASTER_HOST to the current master IP
cat /var/scratch/$(whoami)/conf/spark-env.sh > /var/scratch/$(whoami)/spark/conf/spark-env.sh
echo "export SPARK_MASTER_HOST=$1" >> /var/scratch/$(whoami)/spark/conf/spark-env.sh
