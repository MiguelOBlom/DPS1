# DPS1
## Installation
The code can be installed by running the following commands in the terminal.
```
cd ~
git clone https://github.com/MiguelOBlom/DPS1.git
mkdir /var/scratch/$(whoami)/
cp -a ~/DPS1/code/. /var/scratch/$(whoami)/
(cd /var/scratch/$(whoami)/; ./init.sh)
```

## Execution
The following commands should all be run in the /var/scratch/<USER> directory.
In /var/scratch/user we can now run the performance experiment for GraphX:

```
# Run the Graphx Connected Components
./run_graphx.sh 17 02:00:00 /var/scratch/$(whoami)/graphx_twitter_connected_components.sh
```
... and for Giraph:
```
# Run Giraph Connected Components
for i in {1..25}; do ./run_giraph.sh 17 00:10:00 /var/scratch/ddps2001/giraph_twitter_connected_components.sh; done
```
Note: In GraphX we do not have to reset the environment like we have to in Giraph.

The second experiment for scalability is run using the following command:

```
for i in 9 13 17 25 33 41 49 57 64; do ./run_graphx.sh $i 02:00:00 /var/scratch/ddps2001/graphx_twitter_connected_components_map.sh; done
```
We supplied a python script to create the images, but these are also already provided in the timings folder.
