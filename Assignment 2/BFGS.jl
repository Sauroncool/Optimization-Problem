#func(x) = (x[1]^2 + 2 * x[2]^2 - 0.3 * cos(3 * pi * x[1]) - 0.4 * cos(4 * pi * x[2]) + 0.7) #Bohachevsky Function
#func(x) = x[1] - x[2] + 2*x[1]^2 + 2*x[1]*x[2] + x[2]^2
func(x) = (x[1] + 2 * x[2] - 7)^2 + (2 * x[1] + x[2] - 5)^2

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

X1 = [1, 2]
#X1 = [0, 0]
del_f1 = grad_f(X1)
B1 = [1 0
    0 1]


function backtracking_line_search(f, grad_f, x, p, α=1.0, beta=0.5, c1=1e-4, c2=0.9)
    while f(x + α .* p) > f(x) + c1 * α * p' * grad_f(x) || p' * grad_f(x + α * p) < c2 * p' * grad_f(x) # https://en.wikipedia.org/wiki/Wolfe_conditions
        α *= beta
    end
    return α
end


max_iter = 100

for iter in 1:max_iter
    global X1, B1, del_f1

    if sqrt(sum(del_f1 .* del_f1)) <= 10e-6 # Checking Norm
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
end
println("Solution: ", X1)
println("Function Value: ", func(X1))

println("Solution rouded off: ", round.(X1; digits=3))