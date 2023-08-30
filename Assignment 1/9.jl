# Question 9
# code by Ambuj

using JuMP
using CPLEX

# Defining values given to us
order_details = [14 5 200; 31 10 350; 36 15 400; 45 5 500]
scrap_price = 5

original_order = order_details[:, 2] # copying orginal order quantities for comparison at last

# As there are 10 rolls thus iterating it 10 times
for iteration in 1:10
    model = Model(CPLEX.Optimizer)

    @variable(model, x[i=1:4], lower_bound = 0, Int) # Defining variable as the number of order of rolls of each type

    # Defining constraints
    @constraint(model, x <= order_details[:, 2]) # variable value do not exceed the order quantity
    @constraint(model, sum(x .* order_details[:, 1]) <= 100) # sum of length of rolls cut do not exceed 100

    scrap = 100 - sum(x .* order_details[:, 1]) # calculating scrap length
    profit = sum(x .* order_details[:, 3]) + scrap * scrap_price

    @objective(model, Max, profit)
    optimize!(model)

    order_details[:, 2] = order_details[:, 2] .- value.(x) # Updating new order details after each 100 m roll is used
end

optimal_order = original_order .- order_details[:, 2]
total_scrap = 10 * 100 - sum(optimal_order .* order_details[:, 1])
revenue = sum(optimal_order .* order_details[:, 3]) + total_scrap * scrap_price

# printing results
println("Optimal Order Quantity = ", optimal_order)
println("Total Scrap = ", total_scrap)
println("Revenue = ", revenue)