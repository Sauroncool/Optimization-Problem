import numpy as np
from scipy.optimize import minimize


def func(x):
    return (x[0] ** 2 + 2 * x[1] ** 2 - 0.3 * np.cos(3 * np.pi * x[0]) - 0.4 * np.cos(
        4 * np.pi * x[1]) + 0.7)  # Bohachevsky Function


# Initial guess
# x0 = [1.0, 2.0]
x0 = [2.0, 2.0]

# Minimize the function using BFGS
result = minimize(func, x0, method='BFGS')

print("Minimum at:", result.x)
print("Minimum value:", result.fun)
