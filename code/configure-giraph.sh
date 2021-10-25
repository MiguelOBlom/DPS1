TEMPLATE_CONF_DIR=/var/scratch/$(whoami)/conf
HADOOP_CONF_DIR=/var/scratch/$(whoami)/hadoop-1.2.1/conf

# Configurations taken from: http://giraph.apache.org/quick_start.html

# Configure the Hadoop environment variables
cat $TEMPLATE_CONF_DIR/hadoop-env.sh > $HADOOP_CONF_DIR/hadoop-env.sh
echo "export JAVA_HOME=$JAVA_HOME" >> $HADOOP_CONF_DIR/hadoop-env.sh
echo "export HADOOP_OPTS=-Djava.net.preferIPv4Stack=true" >> $HADOOP_CONF_DIR/hadoop-env.sh

# Configure core-site.xml
cat $TEMPLATE_CONF_DIR/core-site.xml > $HADOOP_CONF_DIR/core-site.xml
echo "<configuration>" >> $HADOOP_CONF_DIR/core-site.xml
echo "<property>" >> $HADOOP_CONF_DIR/core-site.xml
echo "<name>fs.default.name</name>" >> $HADOOP_CONF_DIR/core-site.xml
echo "<value>"hdfs://$1:54310"</value>" >> $HADOOP_CONF_DIR/core-site.xml
echo "</property>" >> $HADOOP_CONF_DIR/core-site.xml
echo "<property>" >> $HADOOP_CONF_DIR/core-site.xml
echo "<name>hadoop.tmp.dir</name>" >> $HADOOP_CONF_DIR/core-site.xml
echo "<value>/local/$(whoami)/tmp/</value>" >> $HADOOP_CONF_DIR/core-site.xml
echo "</property>" >> $HADOOP_CONF_DIR/core-site.xml
echo "</configuration>" >> $HADOOP_CONF_DIR/core-site.xml

# Configure mapred-site.xml
cat $TEMPLATE_CONF_DIR/mapred-site.xml > $HADOOP_CONF_DIR/mapred-site.xml
echo "<configuration>" >> $HADOOP_CONF_DIR/mapred-site.xml
echo "<property>" >> $HADOOP_CONF_DIR/mapred-site.xml
echo "<name>mapred.tasktracker.map.tasks.maximum</name>" >> $HADOOP_CONF_DIR/mapred-site.xml
echo "<value>4</value>" >> $HADOOP_CONF_DIR/mapred-site.xml
echo "</property>" >> $HADOOP_CONF_DIR/mapred-site.xml
echo "<property>" >> $HADOOP_CONF_DIR/mapred-site.xml
echo "<name>mapred.map.tasks</name>" >> $HADOOP_CONF_DIR/mapred-site.xml
echo "<value>4</value>" >> $HADOOP_CONF_DIR/mapred-site.xml
echo "</property>" >> $HADOOP_CONF_DIR/mapred-site.xml
echo "<property>" >> $HADOOP_CONF_DIR/mapred-site.xml
echo "<name>mapred.job.tracker</name>" >> $HADOOP_CONF_DIR/mapred-site.xml
echo "<value>$1:54311</value>" >> $HADOOP_CONF_DIR/mapred-site.xml
echo "</property>" >> $HADOOP_CONF_DIR/mapred-site.xml
echo "<property>" >> $HADOOP_CONF_DIR/mapred-site.xml
echo "<name>mapred.child.java.opts</name>" >> $HADOOP_CONF_DIR/mapred-site.xml
echo "<value>-Xmx68g</value>" >> $HADOOP_CONF_DIR/mapred-site.xml
echo "</property>" >> $HADOOP_CONF_DIR/mapred-site.xml
echo "</configuration>" >> $HADOOP_CONF_DIR/mapred-site.xml

# Configure hdfs-site.xml
cat $TEMPLATE_CONF_DIR/hdfs-site.xml > $HADOOP_CONF_DIR/hdfs-site.xml
echo "<configuration>" >> $HADOOP_CONF_DIR/hdfs-site.xml
echo "<property>" >> $HADOOP_CONF_DIR/hdfs-site.xml
echo "<name>dfs.replication</name>" >> $HADOOP_CONF_DIR/hdfs-site.xml
echo "<value>1</value>" >> $HADOOP_CONF_DIR/hdfs-site.xml
echo "</property>" >> $HADOOP_CONF_DIR/hdfs-site.xml
echo "<property>" >> $HADOOP_CONF_DIR/hdfs-site.xml
echo "<name>dfs.datanode.data.dir</name>" >> $HADOOP_CONF_DIR/hdfs-site.xml
echo "<value>/local/$(whoami)/data</value>" >> $HADOOP_CONF_DIR/hdfs-site.xml
echo "</property>" >> $HADOOP_CONF_DIR/hdfs-site.xml
echo "<property>" >> $HADOOP_CONF_DIR/hdfs-site.xml
echo "<name>dfs.datanode.max.locked.memory</name>" >> $HADOOP_CONF_DIR/hdfs-site.xml
echo "<value>9126805504</value>" >> $HADOOP_CONF_DIR/hdfs-site.xml
echo "</property>" >> $HADOOP_CONF_DIR/hdfs-site.xml
echo "</configuration>" >> $HADOOP_CONF_DIR/hdfs-site.xml

# Update the masters file with the current master IP
rm $HADOOP_CONF_DIR/masters
echo $1 > $HADOOP_CONF_DIR/masters

