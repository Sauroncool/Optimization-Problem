import numpy as np
from geneticalgorithm import geneticalgorithm as ga


# def func(x):
#     return x[0] ** 2 + 2 * x[1] ** 2 - 0.3 * np.cos(3 * np.pi * x[0]) - 0.4 * np.cos(4 * np.pi * x[1]) + 0.7

def func(x):
   return (x[0] - 1)**2 + sum(i * (2 * x[i]**2 - x[i-1])**2 for i in range(1, len(x))) # DIxon Price


varbound = np.array([[-10.0, 10.0]] * 2)

model = ga(function=func, dimension=2, variable_type='real', variable_boundaries=varbound)

model.run()
