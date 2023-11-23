using Evolutionary

# Define the Bohachevsky Function
function func(x)
    return x[1]^2 + 2 * x[2]^2 - 0.3 * cos(3 * π * x[1]) - 0.4 * cos(4 * π * x[2]) + 0.7
end

# Initial guess
x0 = [2.0, 3.0]

# result = Evolutionary.optimize(func, x0,GA(populationSize = 100,crossover = DC, mutation = PLM()))
result = Evolutionary.optimize(func, x0, GA(populationSize = 100,crossover = DC, mutation = PLM()))

# Display the optimization result
println("Candidate solution")
println("Minimizer: ", result.minimizer)
println("Minimum: ", result.minimum)
println("Iterations: ", result.iterations)