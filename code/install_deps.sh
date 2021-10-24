# Installing SBT
wget https://github.com/sbt/sbt/releases/download/v1.5.5/sbt-1.5.5.tgz
tar xzf sbt-1.5.5.tgz
rm sbt-1.5.5.tgz

# Installing Scala
wget https://downloads.lightbend.com/scala/2.13.6/scala-2.13.6.tgz
tar xzf scala-2.13.6.tgz
rm scala-2.13.6.tgz
mv scala-2.13.6/ scala

# Installing Maven
wget --no-check-certificate  https://mirror.novg.net/apache/maven/maven-3/3.8.3/binaries/apache-maven-3.8.3-bin.tar.gz
tar -xf apache-maven-3.8.3-bin.tar.gz
rm apache-maven-3.8.3-bin.tar.gz
mv apache-maven-3.8.3 apache-maven/

# Installing Spark
wget --no-check-certificate https://dlcdn.apache.org/spark/spark-3.2.0/spark-3.2.0-bin-hadoop3.2.tgz
tar xzf spark-3.2.0-bin-hadoop3.2.tgz
rm spark-3.2.0-bin-hadoop3.2.tgz
mv spark-3.2.0-bin-hadoop3.2/ spark

source ./export_vars.sh

# Getting Hadoop WebGraph
git clone https://github.com/helgeho/HadoopWebGraph.git
(cd HadoopWebGraph/; mvn package)

# Getting Hadoop
#wget --no-check-certificate https://dlcdn.apache.org/hadoop/common/hadoop-3.2.2/hadoop-3.2.2.tar.gz
#tar xvf hadoop-3.2.2.tar.gz
#rm hadoop-3.2.2.tar.gz
#wget http://archive.apache.org/dist/hadoop/core/hadoop-0.20.203.0/hadoop-0.20.203.0rc1.tar.gz
#tar xzf hadoop-0.20.203.0rc1.tar.gz
#rm hadoop-0.20.203.0rc1.tar.gz
wget http://archive.apache.org/dist/hadoop/core/hadoop-1.2.1/hadoop-1.2.1.tar.gz
tar xzf hadoop-1.2.1.tar.gz

# Getting giraph
git clone https://github.com/apache/giraph.git
#grep -rl 'mapred.output.dir' /var/scratch/$(whoami)/giraph/* | xargs sed -i 's/mapred.output.dir/mapreduce.output.fileoutputformat.outputdir/g'
#grep -rl 'mapreduce.job.counters.limit' /var/scratch/$(whoami)/giraph/* | xargs sed -i 's/mapreduce.job.counters.limit/mapreduce.job.counters.max/g'
#grep -rl 'mapred.job.map.memory.mb' /var/scratch/$(whoami)/giraph/* | xargs sed -i 's/mapred.job.map.memory.mb/mapreduce.map.memory.mb/g'
#grep -rl 'mapred.job.reduce.memory.mb' /var/scratch/$(whoami)/giraph/* | xargs sed -i 's/mapred.job.reduce.memory.mb/mapreduce.reduce.memory.mb/g'
#grep -rl 'mapred.map.tasks.speculative.execution' /var/scratch/$(whoami)/giraph/* | xargs sed -i 's/mapred.map.tasks.speculative.execution/mapreduce.map.speculative/g'
#grep -rl 'mapreduce.user.classpath.first' /var/scratch/$(whoami)/giraph/* | xargs sed -i 's/mapreduce.user.classpath.first/mapreduce.job.user.classpath.first/g'
#grep -rl 'mapred.map.max.attempts' /var/scratch/$(whoami)/giraph/* | xargs sed -i 's/mapred.map.max.attempts/mapreduce.map.maxattempts/g'
#grep -rl 'mapred.job.tracker' /var/scratch/$(whoami)/giraph/* | xargs sed -i 's/mapred.job.tracker/mapreduce.jobtracker.address/g'
(cd giraph; mvn package -DskipTests)


# Getting the data
mkdir data
(
	cd data; 
	
	# Twitter 2010 data
	wget https://snap.stanford.edu/data/twitter-2010.txt.gz
	gzip -d twitter-2010.txt.gz
	wget https://snap.stanford.edu/data/twitter-2010-ids.csv.gz
	gzip -d twitter-2010-ids.csv.gz
	tail -n+2 twitter-2010-ids.csv > twitter-2010-ids.temp
	mv twitter-2010-ids.temp twitter-2010.ids
	
	# UK 2007 05 data
	wget https://chato.cl/webspam/datasets/uk2007/links/uk-2007-05.urls.gz
	wget https://chato.cl/webspam/datasets/uk2007/links/uk-2007-05.graph.gz
	gzip -d uk-2007-05.graph.gz
	wget https://chato.cl/webspam/datasets/uk2007/links/uk-2007-05.offsets.gz
	gzip -d	uk-2007-05.offsets.gz
	wget https://chato.cl/webspam/datasets/uk2007/links/uk-2007-05.properties
)

