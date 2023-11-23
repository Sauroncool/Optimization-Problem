using Evolutionary


func(x) = (x[1] - 1)^2 + sum(i * (2 * x[i]^2 - x[i-1])^2 for i in 2:length(x)) # Dixon Price

# Initial guess
x0 = [2.0, 3.0]

# result = Evolutionary.optimize(func, x0,GA(populationSize = 100,crossover = DC, mutation = PLM()))
result = Evolutionary.optimize(func, x0, GA(populationSize = 100,crossover = DC, mutation = PLM()))

# Display the optimization result
println("Candidate solution")
println("Minimizer: ", result.minimizer)
println("Minimum: ", result.minimum)
println("Iterations: ", result.iterations)