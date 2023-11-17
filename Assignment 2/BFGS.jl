using ForwardDiff, LinearAlgebra

#boha(x) = (x[1]^2 + 2 * x[2]^2 - 0.3 * cos(3 * pi * x[1]) - 0.4 * cos(4 * pi * x[2]) + 0.7) #Real Function
#boha(x) = x[1] - x[2] + 2*x[1]^2 + 2*x[1]*x[2] + x[2]^2
boha(x) = (x[1] + 2 * x[2] - 7)^2 + (2 * x[1] + x[2] - 5)^2
grad_f(x) = ForwardDiff.gradient(boha, x)

X1 = [1, 2]
#X1 = [0, 0]
del_f1 = grad_f(X1)
B1 = [1 0
    0 1]


function backtracking_line_search(f, grad_f, x, d, alpha=1.0, beta=0.5, c1=1e-4, c2=0.9)
    t = alpha
    while f(x + t .* d) > f(x) + c1 * t * dot(grad_f(x), d) || dot(grad_f(x + t * d), d) < c2 * dot(grad_f(x), d)
        t *= beta
    end
    return t
end

while norm(del_f1) > 10e-6
    global X1, B1, del_f1

    S1 = -B1 * del_f1
    step_size = backtracking_line_search(boha, grad_f, X1, S1)

    X2 = X1 + step_size .* S1
    #println("New Point:",X2)
    del_f2 = grad_f(X2)
    #println("Norm:",norm(del_f2))
    g1 = del_f2 - del_f1
    d1 = step_size .* S1

    B2 = B1 + (1 + (g1' * B1 * g1) / (d1' * g1)) * (d1 * d1') / (d1'g1) - (d1 * g1' * B1) / (d1' * g1) - (B1 * g1 * d1') / (d1' * g1)

    X1 = X2
    B1 = B2
    del_f1 = del_f2
end
println("Solution:",X1)
println("Function Value",boha(X1))

println("Solution rouded off:", round.(X1; digits=3))