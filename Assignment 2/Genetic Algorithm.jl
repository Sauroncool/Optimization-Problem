# Genetic Algorithm
# Code by Ambuj

dice(x) = (x[1] - 1)^2 + sum(i * (2 * x[i]^2 - x[i-1])^2 for i in 2:length(x))
no_of_gen = 20
dimension = 3
chromosome = rand(-10:10, no_of_gen, dimension)


for i in 1:20
    global chromosome
    func_values = dice.(eachrow(chromosome))
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
    if length(chromosome)!=no_of_gen
        push!(new_chromo, chromosome[end, :])
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

    # Mutation
    mutation_rate = 0.06 # 6%
    mutation_indices = rand(1:length(chromosome), round(Int, mutation_rate * length(chromosome)))

    for index in unique(mutation_indices)
        chromosome[index] = rand(-10:10)
    end
    func_values = dice.(eachrow(chromosome))
    println(sum(func_values) / length(func_values))
end
println(chromosome)