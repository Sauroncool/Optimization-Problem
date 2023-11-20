# Coded by Ambuj
import numpy as np


# def func(x):
#     return (x[0] ** 2 + 2 * x[1] ** 2 - 0.3 * np.cos(3 * np.pi * x[0]) - 0.4 * np.cos(
#         4 * np.pi * x[1]) + 0.7)  # Bohachevsky Function


def func(x):
    return (x[0] + 2 * x[1] - 7) ** 2 + (2 * x[0] + x[1] - 5) ** 2


def grad(f, x):
    x = np.array(x, dtype=float)
    h = np.cbrt(np.finfo(float).eps)
    d = len(x)
    nabla = np.zeros(d)
    for i in range(d):
        x_for = x.copy()
        x_back = x.copy()
        x_for[i] = x_for[i] + h
        x_back[i] = x_back[i] - h
        nabla[i] = (f(x_for) - f(x_back)) / (2 * h)
    return nabla


def grad_f(x):
    return grad(func, x)


def backtracking_line_search(f, grad_f, x, p, alpha=1.0, beta=0.5, c1=1e-4, c2=0.9):  # Backtracking Line Search with
    # Wolfe Condition
    while f(x + alpha * p) > f(x) + c1 * alpha * np.dot(p, grad_f(x)) or np.dot(p, grad_f(x + alpha * p)) < c2 * np.dot(
            p, grad_f(x)):  # Negative of Wolfe Condition (https://en.wikipedia.org/wiki/Wolfe_conditions)
        alpha *= beta  # Reducing the length for not satisfying Wolfe Condition
    return alpha


max_iter = 100
X1 = np.array([1, 2], dtype=float)
# X1 = np.array([0, 0], dtype=float)
del_f1 = grad_f(X1)
B1 = np.eye(len(X1))

for i in range(max_iter):
    if np.linalg.norm(del_f1) <= 1e-6:
        break

    S1 = -np.dot(B1, del_f1)
    step_size = backtracking_line_search(func, grad_f, X1, S1)

    X2 = X1 + step_size * S1
    del_f2 = grad_f(X2)

    g1 = del_f2 - del_f1
    d1 = step_size * S1

    d1_g1 = np.dot(d1, g1)
    B2 = B1 + (1 + np.dot(g1, np.dot(B1, g1)) / d1_g1) * np.outer(d1, d1) / d1_g1 - \
         (np.outer(d1, g1) @ B1 + B1 @ np.outer(g1, d1)) / d1_g1

    X1 = X2
    B1 = B2
    del_f1 = del_f2

print("Solution:", X1)
print("Function Value:", func(X1))
print("Solution rounded off:", np.round(X1, decimals=3))
