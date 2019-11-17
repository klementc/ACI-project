import matplotlib.pyplot as plt
import csv

x = []
y = []

with open('dataSET.dat','r') as file:
	for row in file:
		row = row.strip().split("  ")
		print(row)
		x.append(float(row[0]))
		y.append(float(row[1]))
x2 = []
y2 = []
with open('dataSETrpc.dat','r') as file:
        for row in file:
                row = row.strip().split(" ")
                print(row)
                x.append(float(row[0]))
                y.append(float(row[1]))

fig, ax1 = plt.subplots()

col='tab:red'
ax1.set_xlabel('Number of requests')
ax1.set_ylabel('Duration to complete all requests (s)')
ax1.plot(x,y, marker="o", color=col)
ax1.set_xscale("log")

ax2 = ax1.twinx()
col='tab:blue'
ax2.set_ylabel('Duration to complete all requests (s)')
ax2.bar(x,y, color=col)

plt.legend()
plt.savefig("grownbcl.pdf")


