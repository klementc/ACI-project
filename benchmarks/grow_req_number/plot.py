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

x2=[]
y2=[]
with open('../grow_req_number/dataSET.dat','r') as file:
        for row in file:
                row = row.strip().split("$
                print(row)
                x2.append(float(row[0]))
                y2.append(float(row[1]))


plt.xlabel('Number of requests')
plt.ylabel('Duration to complete all requests (s)')
plt.plot(x,y, marker="o")
plt.plot(x,y, marker="*")
plt.xscale("log")
plt.legend()
plt.savefig("growreq.pdf")


