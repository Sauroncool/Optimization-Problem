# Genetic Algorithm
# Code by Ambuj
func(x) = (x[1]^2 + 2 * x[2]^2 - 0.3 * cos(3 * pi * x[1]) - 0.4 * cos(4 * pi * x[2]) + 0.7) #Bohachevsky Function
# func(x) = (x[1] - 1)^2 + sum(i * (2 * x[i]^2 - x[i-1])^2 for i in 2:length(x)) # Dixon Price
# func(x) = (x[1] + 2 * x[2] - 7)^2 + (2 * x[1] + x[2] - 5)^2

population = 50
dimension = 2
lower_bound = -10.0
upper_bound = 10.0
chromosome = rand(Float64, population, dimension) .* (upper_bound - lower_bound) .+ lower_bound

max_iter = 2000
for i in 1:max_iter
    global chromosome
    func_values = func.(eachrow(chromosome))
    fitness = 1 ./ (func_values .+ 1) # In order to avoid dividing them by zero
    # Tournament Selection
    new_chromo = []
    while length(new_chromo)<population
        a = rand(1:population)
        b = rand(1:population)
        if fitness[a]>(fitness[b])
            push!(new_chromo, chromosome[a, :])
        elseif fitness[b]>(fitness[a])
            push!(new_chromo, chromosome[b, :])
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
   if length(parent_index)>1
    for i in 1:floor(Int,length(parent_index)/2)
           first_parent = chromosome[parent_index[2*i-1], :]
           second_parent = chromosome[parent_index[2*i], :]
           lamda = 1/3
           child_1 = lamda .* first_parent .+ (1-lamda) .* second_parent
           child_2 = lamda .* second_parent .+ (1-lamda) .* first_parent

           push!(child, child_1)
           push!(child, child_2)
       end
       for i in 1:length(child)
           chromosome[parent_index[i], :] = child[i] # Replacing parents with children
       end
   end

   # Muhlenbein mutation
   mutation_rate = 0.15
   mutation_index = rand(1:length(chromosome), round(Int, mutation_rate * length(chromosome)))
   for index in unique(mutation_index)
       chromosome[index] = chromosome[index]+ rand((-1,1))*0.1*(upper_bound-lower_bound)*sum(rand()*2.0^(-k) for k in 1:15)
   end 
end
println("Value of Function: ",minimum(func.(eachrow(chromosome))))
println("Solution: ",chromosome[argmin(reshape(func.(eachrow(chromosome)), :)),:])
println("Solution(rounded off): ",round.(chromosome[argmin(reshape(func.(eachrow(chromosome)), :)),:]; digits=2))