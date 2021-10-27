# Start the Spark worker
source /var/scratch/$(whoami)/export_vars_graphx.sh
start-worker.sh spark://$1

