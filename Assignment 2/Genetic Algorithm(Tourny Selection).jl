# Genetic Algorithm
# Code by Ambuj

dice(x) = (x[1] - 1)^2 + sum(i * (2 * x[i]^2 - x[i-1])^2 for i in 2:length(x))
no_of_gen = 500
dimension = 3
lower_bound = -10.0
upper_bound = 10.0
chromosome = rand(Float64, no_of_gen, dimension) .* (upper_bound - lower_bound) .+ lower_bound

max_iter= 200
for i in 1:max_iter
    global chromosome
    func_values = dice.(eachrow(chromosome))
    fitness = 1 ./ (func_values .+ 1) # In order to avoid dividing them by zero
    # Tournament Selection
    new_chromo = []
    while length(new_chromo)<no_of_gen
        i = rand(1:no_of_gen)
        if fitness[i]>rand((fitness[fitness.!=fitness[i]]))
            push!(new_chromo, chromosome[i, :])
        end
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
    if length(parent_index)>0
        for i in 1:length(parent_index)
            first_parent = chromosome[parent_index[i], :]
            if length(parent_index)>1
                second_parent = chromosome[rand((parent_index[parent_index.!=parent_index[i]])), :]
            else
                second_parent = first_parent
            end
            crossover_point = rand(1:length(chromosome[1, :])-1)
            push!(child, [first_parent[1:crossover_point]; second_parent[crossover_point+1:end]])
        end
        for i in 1:length(parent_index)
            chromosome[i, :] = child[i] # Replacing parents with children
        end
    end

    if i == max_iter
        println("haha")
        break
    end

    # Mutation
    mutation_rate = 0.06 # 6%
    mutation_indices = rand(1:length(chromosome), round(Int, mutation_rate * length(chromosome)))

    for index in unique(mutation_indices)
        chromosome[index] = rand(Float64) .* (upper_bound - lower_bound) .+ lower_bound
    end
    #func_values = dice.(eachrow(chromosome))
    #println(sum(func_values) / length(func_values))
end
#println(chromosome)
println("Value of Function: ",minimum(dice.(eachrow(chromosome))))
# println(argmin(reshape(dice.(eachrow(chromosome)), :)))
println("Solution: ",chromosome[argmin(reshape(dice.(eachrow(chromosome)), :)),:])