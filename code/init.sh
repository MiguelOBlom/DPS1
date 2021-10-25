# Create the filestructure SBT expects when compiling a .scala file
./make_sbt_file_structure.sh /var/scratch/$(whoami)/ graphx_pagerank_twitter_2010 &
./make_sbt_file_structure.sh /var/scratch/$(whoami)/ graphx_connected_components_twitter_2010 &
./make_sbt_file_structure.sh /var/scratch/$(whoami)/ graphx_pagerank_uk_2007_05 &
./make_sbt_file_structure.sh /var/scratch/$(whoami)/ graphx_connected_components_uk_2007_05 &

wait

# Install dependencies of our project and download the used datasets
./install_deps.sh

# Use environment variables (for SBT)
source ./export_vars.sh

# Copy the code to the right locations in the SBT filestructures, then build
(cp ./code/gx_pr_tw.scala /var/scratch/$(whoami)/graphx_pagerank_twitter_2010/src/main/scala/main.scala
(cd /var/scratch/$(whoami)/graphx_pagerank_twitter_2010; sbt clean package)) &

(cp ./code/gx_cc_tw.scala /var/scratch/$(whoami)/graphx_connected_components_twitter_2010/src/main/scala/main.scala
(cd /var/scratch/$(whoami)/graphx_connected_components_twitter_2010; sbt clean package)) &

#(cp ./code/gx_pr_uk.scala /var/scratch/$(whoami)/graphx_pagerank_uk_2007_05/src/main/scala/main.scala
#cp /var/scratch/$(whoami)/HadoopWebGraph/target/hadoop-webgraph-1.0-SNAPSHOT.jar /var/scratch/$(whoami)/graphx_pagerank_uk_2007_05/lib/
#(cd /var/scratch/$(whoami)/graphx_pagerank_uk_2007_05; sbt clean package)) &

#(cp ./code/gx_cc_uk.scala /var/scratch/$(whoami)/graphx_connected_components_uk_2007_05/src/main/scala/main.scala
#cp /var/scratch/$(whoami)/HadoopWebGraph/target/hadoop-webgraph-1.0-SNAPSHOT.jar /var/scratch/$(whoami)/graphx_connected_components_uk_2007_05/lib/
#(cd /var/scratch/$(whoami)/graphx_connected_components_uk_2007_05; sbt clean package)) &

wait

mkdir -p timings/{graphx,giraph}/
