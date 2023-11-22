# BFGS Algorithm
# Code by Ambuj
# func(x) = (x[1]^2 + 2 * x[2]^2 - 0.3 * cos(3 * pi * x[1]) - 0.4 * cos(4 * pi * x[2]) + 0.7) #Bohachevsky Function
func(x) = (x[1] - 1)^2 + sum(i * (2 * x[i]^2 - x[i-1])^2 for i in 2:length(x)) # Dixon Price
# func(x) = x[1] - x[2] + 2*x[1]^2 + 2*x[1]*x[2] + x[2]^2
# func(x) = (x[1] + 2 * x[2] - 7)^2 + (2 * x[1] + x[2] - 5)^2

function grad(f, x)
    x = Float64.(x)
    # Central Finite Difference Calculation
    h = cbrt(eps(Float64))
    d = length(x)
    nabla = zeros(d)
    for i in 1:d
        x_for = copy(x)
        x_back = copy(x)
        x_for[i] = x_for[i] + h
        x_back[i] = x_back[i] - h
        nabla[i] = (f(x_for) - f(x_back)) / (2 * h)
    end
    return nabla
end

grad_f(x) = grad(func, x)

# X1 = [2, 1]
X1 = [1, 2 , 2]
del_f1 = grad_f(X1)

# B1 = [1 0
#     0 1]

B1 = [1 0 0
    0 1 0
    0 0 1]


function backtracking_line_search(f, grad_f, x, p, α=1.0, β=0.5, c1=1e-4, c2=0.9) # Backtracking Line Search with Wolfe Condition
    while f(x + α .* p) > f(x) + c1 * α * p' * grad_f(x) || p' * grad_f(x + α * p) < c2 * p' * grad_f(x) # Negative of wolfe condition (https://en.wikipedia.org/wiki/Wolfe_conditions)
        α *= β # Reducing the length for not satisfying Wolfe Condition
    end
    return α
end


max_iter = 100

for iter in 1:max_iter
    global X1, B1, del_f1
    if sqrt(sqrt(del_f1'*del_f1)) <= 10e-6 # Checking Norm
        # println(X1)
        # println(sqrt(del_f1'*del_f1))
        break
    end

    S1 = -B1 * del_f1
    step_size = backtracking_line_search(func, grad_f, X1, S1)

    X2 = X1 + step_size .* S1
    del_f2 = grad_f(X2)

    g1 = del_f2 - del_f1
    d1 = step_size .* S1

    B2 = B1 + (1 + (g1' * B1 * g1) / (d1' * g1)) * (d1 * d1') / (d1'g1) - (d1 * g1' * B1) / (d1' * g1) - (B1 * g1 * d1') / (d1' * g1)

    X1 = X2
    B1 = B2
    del_f1 = del_f2
    # println(iter)
    # println(X1)
    # println(del_f1)
end
println("Solution: ", X1)
println("Function Value: ", func(X1))

println("Solution rouded off: ", round.(X1; digits=3))

# Plots
# using Plots

# # Generate x and y values for the surface plot
# x = range(-1, stop=1, length=100)
# y = range(-1, stop=1, length=100)
# z = [func([x[i], y[j]]) for i in 1:length(x), j in 1:length(y)]

# # Create 3D surface plot
# surface_plot = surface(x, y, z, xlabel="x", ylabel="y", zlabel="f(x, y)", title="Bohachevsky Function",c=:viridis)
# plotlyjs()
# plot(surface_plot)