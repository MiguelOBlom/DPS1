source /var/scratch/$(whoami)/export_vars.sh
start-master.sh
echo $(ifconfig | grep inet | grep -o '10\.149\.\S*' | awk -F . '$NF !~ /^255/')
