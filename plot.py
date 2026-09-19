"""
Plots the evolution of the accepted solution costs produced by the
Threshold Acceptance heuristic.

The script reads the evaluations stored in evaluations.txt, samples one value
every fixed number of evaluations, and generates a plot saved as
evaluations.png.
"""

import matplotlib.pyplot as plt

#python3 plot.py

x = []
y = []

step = 10_000

with open("evaluations.txt", "r") as file:
    for i, line in enumerate(file):
        if i % step == 0:
            x.append(i)
            y.append(float(line.strip()))

plt.plot(x, y)

plt.xlabel("Accepted Evaluations")
plt.ylabel("Cost")
plt.title("Threshold Acceptance")
plt.grid()

plt.savefig("evaluations.png", dpi=300)
plt.show()