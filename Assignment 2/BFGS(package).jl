using Optim

#func(x) = (x[1]^2 + 2 * x[2]^2 - 0.3 * cos(3 * pi * x[1]) - 0.4 * cos(4 * pi * x[2]) + 0.7) #Bohachevsky Function
func(x) = (x[1] - 1)^2 + sum(i * (2 * x[i]^2 - x[i-1])^2 for i in 2:length(x)) # Dixon Price

# Initial guess
x₀ = [2.0, 1.0]

# Minimize the function using BFGS
result = optimize(func, x₀, BFGS())

println("Minimum at: ", result.minimizer)
println("Minimum value: ", result.minimum)

