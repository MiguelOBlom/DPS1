# Set a couple of environment variables
DPS_DIR=/var/scratch/$(whoami)

# Maven
export M2_HOME=$DPS_DIR/apache-maven
export MAVEN_HOME=$DPS_DIR/apache-maven
export PATH=${M2_HOME}/bin:${PATH}

# SBT
export PATH=$DPS_DIR/sbt/bin:${PATH}

# Scala
export SCALA_HOME=$DPS_DIR/scala
export PATH=${SCALA_HOME}/bin:${PATH}

# Spark
export SPARK_HOME=$DPS_DIR/spark
export PATH=${SPARK_HOME}/sbin:${SPARK_HOME}/bin:${PATH}

# Hadoop
export HADOOP_PREFIX=$DPS_DIR/hadoop-1.2.1
export PATH=${HADOOP_PREFIX}/bin:${PATH}

# Java
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.161-0.b14.el7_4.x86_64
export PATH=${JAVA_HOME}/bin:${PATH}

# Giraph
export GIRAPH_HOME=$DPS_DIR/giraph

