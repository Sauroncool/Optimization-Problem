using Optim

func(x) = (x[1]^2 + 2 * x[2]^2 - 0.3 * cos(3 * pi * x[1]) - 0.4 * cos(4 * pi * x[2]) + 0.7) #Bohachevsky Function

# Initial guess
x₀ = [1.0, 2.0]

# Minimize the function using BFGS
result = optimize(func, x₀, BFGS())

println("Minimum at: ", result.minimizer)
println("Minimum value: ", result.minimum)

