import matplotlib.pyplot as plt

x = []
y = []

step = 10_000

with open("evaluations.txt", "r") as file:
    for i, line in enumerate(file):
        if i % step == 0:
            x.append(i)
            y.append(float(line.strip()))

plt.plot(x, y)

plt.xlabel("Evaluaciones aceptadas")
plt.ylabel("Costo")
plt.title("Threshold Acceptance")
plt.grid()

plt.savefig("evaluations.png", dpi=300)
plt.show()