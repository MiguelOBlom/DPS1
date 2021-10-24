mkdir -p $1/$2/{lib,project,target}
mkdir -p $1/$2/src/{main,test}/{java,resources,scala}
touch $1/$2/build.sbt

echo "name := \"$2\"" >> $1/$2/build.sbt
echo "libraryDependencies += \"org.apache.spark\" %% \"spark-core\" % \"3.2.0\"" >> $1/$2/build.sbt
echo "libraryDependencies += \"org.apache.spark\" %% \"spark-graphx\" % \"3.2.0\"" >> $1/$2/build.sbt
