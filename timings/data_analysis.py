import matplotlib.pyplot as plt
import numpy as np
import pandas
import datetime


seconds_per_unit = {"s": 1, "m": 60, "h": 3600, "d": 86400, "w": 604800}

def convert_to_seconds(s):
    split = s.split('m')
    minutes = split[0]
    seconds = split[1].replace('s', '')
    return int(minutes)*60 + float(seconds)


gr = pandas.read_csv('giraph/twitter_connectedcomponents_corrected.txt', sep='\t', lineterminator='\n', names=['type', 'time'], header=None)
gr['time'] = gr['time'].apply(lambda x: convert_to_seconds(x))
gr = gr[gr['type']=='real']
gr_five = gr.loc[:5]
gr_mean = gr_five.mean().iloc[0]
gr_std = gr_five.std().iloc[0]

gx = pandas.read_csv('graphx/twitter_connectedcomponents.txt', sep='\t', lineterminator='\n', names=['type', 'time'], header=None)
gx['time'] = gx['time'].apply(lambda x: convert_to_seconds(x))
gx = gx[gx['type']=='real']
gx_five = gx.loc[:5]
gx_mean = gx_five.mean().iloc[0]
gx_std = gx_five.std().iloc[0]

print(gr.loc[:,'time'])

plt.rcParams.update({'font.size': 18})

# Improved box plot
fig2 = plt.figure()
ax2 = fig2.add_subplot(111)
ax2.tick_params(axis='both', direction='in', length=8)
ax2.set_ylabel("Runtime in seconds")
ax2.set_title("(Real) median runtime for Conn. Comp. on Twitter data")
bars = ['Giraph', 'GraphX']
ax2.boxplot([gr.loc[:,'time'], gx.loc[:,'time']], labels=bars, whis=[1,99])
plt.show()

# Replication of original bar plot
fig1 = plt.figure()
ax1 = fig1.add_subplot(111)
ax1.tick_params(axis='both', direction='in', length=8)
ax1.set_ylabel("Runtime in seconds")
ax1.set_title("(Real) mean runtime for Conn. Comp. on Twitter data")
bars = ['Giraph', 'GraphX']
runtime = [gr_mean, gx_mean]
std = [gr_std, gx_std]
ax1.bar(bars, runtime, width=0.8, color='grey', linewidth=1, capsize=8, yerr = std, ec='black')
plt.show()

fig3 = plt.figure()
ax3 = fig3.add_subplot(111)
ax3.tick_params(axis='both', direction='in', length=8)
ax3.set_ylabel("Occurrence")
ax3.set_xlabel("Runtime in seconds")
ax3.set_title("Giraph distribution of (real) runtime for Conn. Comp. on Twitter data")
ax3.hist(gr[gr['type']=='real'].loc[:,'time'], 5, facecolor='grey', ec='black')
plt.show()

fig4 = plt.figure()
ax4 = fig4.add_subplot(111)
ax4.tick_params(axis='both', direction='in', length=8)
ax4.set_ylabel("Occurrence")
ax4.set_xlabel("Runtime in seconds")
ax4.set_title("GraphX distribution of (real) runtime for Conn. Comp. on Twitter data")
ax4.hist(gx[gx['type']=='real'].loc[:,'time'], 5, facecolor='grey', ec='black')
plt.show()
