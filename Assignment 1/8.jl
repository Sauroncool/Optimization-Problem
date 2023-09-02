using JuMP
using CPLEX

model = Model(CPLEX.Optimizer)


demand = [1500, 2100, 1800, 1950]
regular_hrs = 480
max_overtime = 80
production_rate = 160
max_subcontract = 500
regular_pay = 50
overtime_pay = 55
subcontracting_cost = 9000
backlog_cost = 1200
inventory_holding_cost = 50
hiring_cost = 1000
firing_cost = 1200
w0 = 600
inventory_start = 200
inventory_end = 300

@variable(model, total_overtime_hrs[1:4], lower_bound = 0)
@variable(model, w[1:4], lower_bound = 0, Int)
@variable(model, w_h[1:4], lower_bound = 0, Int)
@variable(model, w_f[1:4], lower_bound = 0, Int)
@variable(model, production[1:4], lower_bound = 0, Int)
@variable(model, subcontract[1:4], lower_bound = 0, Int)
@variable(model, inventory[1:4], lower_bound = 0, Int)
@variable(model, backlog[1:4], lower_bound = 0, Int)

@constraint(model, w[1]== w0 + w_h[1] + w_f[1])
@constraint(model, production[1] + inventory_start + subcontract[1] == demand[1] + inventory[1] + backlog[1])

@constraint(model, w[2:4]== w[1:3] + w_h[2:4] + w_f[2:4])
@constraint(model,production[2:4] + inventory[1:3] + subcontract[2:4] == demand[2:4] + inventory[2:4] + backlog[1:3] + backlog[2:4])
@constraint(model, total_overtime_hrs <= max_overtime * w[1:4])
@constraint(model, production <= w[1:4] * regular_hrs / production_rate + total_overtime_hrs / production_rate)
@constraint(model, subcontract[1:4] .<= max_subcontract)


@constraint(model, inventory[4] == inventory_end)
total_cost = sum(w .* regular_hrs .* regular_pay) + sum(hiring_cost .* w_h) + sum(firing_cost .* w_f) + sum(inventory_holding_cost .* inventory) + sum(backlog_cost .* backlog) + sum(subcontracting_cost .* subcontract) + sum(overtime_pay .* total_overtime_hrs)

@objective(model, Min, total_cost)
optimize!(model)
@show objective_value(model)