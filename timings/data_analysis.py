import matplotlib.pyplot as plt
import numpy as np
import pandas
import datetime
import glob
import csv
import sys

plt.rcParams.update({'font.size': 13})

def convert_to_seconds(s):
    split = s.split('m')
    minutes = split[0]
    seconds = split[1].replace('s', '')
    return int(minutes)*60 + float(seconds)

cm = 1/2.54
size = [14*cm, 18*cm]

scaling_files = [
    "graphx/clean_09.txt",
    "graphx/clean_13.txt",
    "graphx/clean_17.txt",
    "graphx/clean_25.txt",
    "graphx/clean_33.txt",
    "graphx/clean_41.txt",
    "graphx/clean_49.txt",
    "graphx/clean_57.txt",
    "graphx/clean_63.txt"
]

li = []

for filename in scaling_files:
    df = pandas.read_csv(filename, lineterminator='\n', header=None)
    li.append(df)


gx_sc = pandas.concat(li, axis=1, ignore_index=True)
gx_sc.columns = scaling_files
gx_sc = gx_sc.applymap(lambda x: convert_to_seconds(x))

gr = pandas.read_csv('giraph/twitter_connectedcomponents_corrected.txt', sep='\t', lineterminator='\n', names=['type', 'time'], header=None)
gr['time'] = gr['time'].apply(lambda x: convert_to_seconds(x))
gr = gr[gr['type']=='real']
gr_five = gr.loc[:5]
gr_mean = gr_five.mean().iloc[0]
gr_std = gr_five.std().iloc[0]

gx = pandas.read_csv('graphx/clean.txt', sep='\t', lineterminator='\n', names=['type', 'time'], header=None)
gx['time'] = gx['time'].apply(lambda x: convert_to_seconds(x))
gx = gx[gx['type']=='real']
gx_five = gx.loc[:5]
gx_mean = gx_five.mean().iloc[0]
gx_std = gx_five.std().iloc[0]


# Improved box plot
fig2 = plt.figure()
ax2 = fig2.add_subplot(111)
ax2.tick_params(axis='both', direction='in', length=8)
ax2.set_ylabel("Runtime in seconds")
ax2.set_title("Runtime of Conn. Comp. \non Twitter data")
bars = ['Giraph', 'GraphX']
ax2.boxplot([gr.loc[:,'time'], gx.loc[:,'time']], labels=bars, whis=[1,99])
fig2.set_size_inches(size)
fig2.savefig("images/system_perf_boxplot.png", dpi=300)
# plt.show()


# Replication of original bar plot
fig1 = plt.figure()
ax1 = fig1.add_subplot(111)
ax1.tick_params(axis='both', direction='in', length=8)
ax1.set_ylabel("Runtime in seconds")
ax1.set_title("Runtime (mean) of Conn. Comp. \non Twitter data")
bars = ['Giraph', 'GraphX']
runtime = [gr_mean, gx_mean]
std = [gr_std, gx_std]
ax1.bar(bars, runtime, width=0.8, color='grey', linewidth=1, capsize=8, yerr = std, ec='black')
fig1.set_size_inches(size)
fig1.savefig("images/system_perf_barplot.png", dpi=300)
# plt.show()

# Distribution of Giraph data
fig3 = plt.figure()
ax3 = fig3.add_subplot(111)
ax3.tick_params(axis='both', direction='in', length=8)
ax3.set_ylabel("Occurrence")
ax3.set_xlabel("Runtime in seconds")
ax3.set_title("Giraph runtime distribution \nof Conn. Comp. on Twitter data")
ax3.set_xticks(np.arange(100, 130, 2))
ax3.set_xticklabels(ax3.get_xticks(), rotation = 45)
ax3.hist(gr[gr['type']=='real'].loc[:,'time'], 5, facecolor='grey', ec='black')
fig3.set_size_inches(size)
fig3.savefig("images/giraph_distribution.png", dpi=300)
# plt.show()

# Distribution of GraphX data
fig4 = plt.figure()
ax4 = fig4.add_subplot(111)
ax4.tick_params(axis='both', direction='in', length=8)
ax4.set_ylabel("Occurrence")
ax4.set_xlabel("Runtime in seconds")
ax4.set_title("GraphX runtime distribution \nof Conn. Comp. on Twitter data")
ax4.set_xticks(np.arange(150, 180, 2))
ax4.set_xticklabels(ax4.get_xticks(), rotation = 45)
ax4.hist(gx[gx['type']=='real'].loc[:,'time'], 5, facecolor='grey', ec='black')
fig4.set_size_inches(size)
fig4.savefig("images/graphx_distribution.png", dpi=300)
# plt.show()


# Scaling boxplot
fig5 = plt.figure()
ax5 = fig5.add_subplot(111)
ax5.tick_params(axis='both', direction='in', length=8)
ax5.set_ylabel("Runtime in seconds")
ax5.set_xlabel("Number of nodes")
ax5.set_xlim([0, 72])
# ax5.set_xscale('log', basex=2)
ax5.set_title("GraphX strong scaling \nof Conn. Comp. on Twitter data")
positions = np.array([8,12,16,24,32,40,48,56,62])
ax5.boxplot(gx_sc, labels=positions, whis=[1,99], positions=positions, widths=2)
ax5.set_ylim([100,275])
fig5.set_size_inches(size[0]*2,size[1])
fig5.savefig("images/graphx_scaling.png", dpi=300)
# plt.show()

sys.exit()
