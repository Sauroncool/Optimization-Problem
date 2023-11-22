# Genetic Algorithm
# Code by Ambuj
func(x) = (x[1]^2 + 2 * x[2]^2 - 0.3 * cos(3 * pi * x[1]) - 0.4 * cos(4 * pi * x[2]) + 0.7) #Bohachevsky Function
# func(x) = (x[1] - 1)^2 + sum(i * (2 * x[i]^2 - x[i-1])^2 for i in 2:length(x)) # Dixon Price
# func(x) = x[1] - x[2] + 2*x[1]^2 + 2*x[1]*x[2] + x[2]^2
no_of_gen = 50
dimension = 2
lower_bound = -10.0
upper_bound = 10.0
chromosome = rand(Float64, no_of_gen, dimension) .* (upper_bound - lower_bound) .+ lower_bound

max_iter = 1000
for i in 1:max_iter
    global chromosome
    func_values = func.(eachrow(chromosome))
    fitness = 1 ./ (func_values .+ 1) # In order to avoid dividing them by zero
    indi_prob = fitness ./ sum(fitness)
    cumul_prob = cumsum(indi_prob)
    roulette = rand(length(cumul_prob))
    new_chromo = []
    for i = 1:length(roulette)
        for j = 1:length(roulette)-1
            if roulette[i] > cumul_prob[j] && roulette[i] <= cumul_prob[j+1]
                push!(new_chromo, chromosome[j+1, :])
            end
        end
    end
    while length(new_chromo)!=no_of_gen
        push!(new_chromo,chromosome[argmin(reshape(func.(eachrow(chromosome)), :)),:])
        #push!(new_chromo, chromosome[end, :])
    end
    chromosome = mapreduce(permutedims, vcat, new_chromo)

    #Crossover
    crossover_rate = 0.3
    parent_index = []
    for i in 1:length(new_chromo)
        crossover_rand = rand()
        if crossover_rand <= crossover_rate
            push!(parent_index, i) # Selecting parents
        end
    end
    child = []
    if length(parent_index)>1
        for i in 1:Int(trunc(length(parent_index)/2))
            first_parent = chromosome[parent_index[2*i-1], :]
            second_parent = chromosome[parent_index[2*i], :]
            lamda = 1/3
            child_1 = lamda .* first_parent .+ (1-lamda) .* second_parent
            child_2 = lamda .* second_parent .+ (1-lamda) .* first_parent

            push!(child, child_1)
            push!(child, child_2)
        end
        for i in 1:length(child)
            chromosome[i, :] = child[i] # Replacing parents with children
        end
    end
    # if i == max_iter
    #     println("Max Iteration reached")
    #     break
    # end

    # Muhlenbein mutation
    mutation_rate = 0.1
    mutation_index = rand(1:length(chromosome), round(Int, mutation_rate * length(chromosome)))
    for index in unique(mutation_index)
        chromosome[index] = chromosome[index]+ rand((-1,1))*0.1*(upper_bound-lower_bound)*sum(rand(Float64)*2.0^(-k) for k in 1:15)
    end

    # Random Mutation
    # mutation_rate = 0.15 # 15% (After some trial and error)
    # mutation_infuncs = rand(1:length(chromosome), round(Int, mutation_rate * length(chromosome)))

    # for index in unique(mutation_infuncs)
    #     chromosome[index] = rand(Float64) .* (upper_bound - lower_bound) .+ lower_bound
    # end

    # if i%100 == 0
    #     println("Iteration reached")
    # end
    
end
#println(chromosome)
println("Value of Function: ",minimum(func.(eachrow(chromosome))))
# println(argmin(reshape(func.(eachrow(chromosome)), :)))
println("Solution: ",chromosome[argmin(reshape(func.(eachrow(chromosome)), :)),:])