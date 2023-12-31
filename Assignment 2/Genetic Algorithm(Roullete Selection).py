import numpy as np
from numpy.random import rand
import time


# def func(x):
#     return x[0] ** 2 + 2 * x[1] ** 2 - 0.3 * np.cos(3 * np.pi * x[0]) - 0.4 * np.cos(4 * np.pi * x[1]) + 0.7
# Bohachevsky

def func(x):
    return (x[0] - 1) ** 2 + sum(i * (2 * x[i] ** 2 - x[i - 1]) ** 2 for i in range(1, len(x)))  # Dixon Price


population = 50
dimension = 2
lower_bound = -10.0
upper_bound = 10.0
chromosome = np.random.rand(population, dimension) * (upper_bound - lower_bound) + lower_bound

max_iter = 2000
start_time = time.time()
for iter in range(max_iter):
    func_values = np.apply_along_axis(func, 1, chromosome)
    fitness = 1 / (func_values + 1)
    indi_prob = fitness / np.sum(fitness)

    cumul_prob = np.concatenate(([0], np.cumsum(indi_prob)))
    roulette = rand(population)
    new_chromo = []

    for i in range(population):
        for j in range(population):
            if cumul_prob[j] < roulette[i] <= cumul_prob[j + 1]:
                new_chromo.append(chromosome[j])

    chromosome = np.array(new_chromo)

    # Crossover
    crossover_rate = 0.3
    parent_index = [i for i in range(len(new_chromo)) if rand() <= crossover_rate]

    children = []
    if len(parent_index) > 1:
        # Ensure even number of parents
        if len(parent_index) % 2 != 0:
            parent_index = parent_index[:-1]

        for i in range(0, len(parent_index), 2):
            first_parent = chromosome[parent_index[i]]
            second_parent = chromosome[parent_index[i + 1]]
            lamda = 1 / 3
            child_1 = lamda * first_parent + (1 - lamda) * second_parent
            child_2 = lamda * second_parent + (1 - lamda) * first_parent

            children.extend([child_1, child_2])

        for i in range(len(children)):
            chromosome[parent_index[i]] = children[i]

    # Muhlenbein mutation
    mutation_rate = 0.15
    mutation_index = np.random.choice(range(len(chromosome)), size=int(mutation_rate * len(chromosome)), replace=False)
    for index in mutation_index:
        mutation_value = np.random.choice([-1, 1]) * 0.1 * (upper_bound - lower_bound) * sum(
            rand() * 2.0 ** (-k) for k in range(1, 16)
        )
        chromosome[index] = chromosome[index] + mutation_value

elapsed_time = time.time() - start_time
best_solution_index = np.argmin(np.apply_along_axis(func, 1, chromosome))
best_solution = chromosome[best_solution_index]
print("Value of Function:", func(best_solution))
print("Solution:", best_solution)
print("Solution (rounded off):", np.round(best_solution, decimals=2))
print("Execution time:", elapsed_time, "seconds")
