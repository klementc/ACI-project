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
                x2.append(row[0])
                y2.append(float(row[1]))


plt.xlabel('Number of requests')
plt.ylabel('Requests per second')
plt.bar(x2,y2, )
#ax1.set_xscale("log")
plt.legend()
plt.savefig("grownbcl2.pdf")

#ax2 = ax1.twinx()
#col='tab:blue'
#ax2.set_ylabel('Duration to complete all requests (s)')
#ax2.bar(x2,y2, color=col)




