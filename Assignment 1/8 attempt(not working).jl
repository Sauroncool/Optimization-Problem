using JuMP
using CPLEX
hiring_cost(w_h) = 1000 * w_h
firing_cost(w_f) = 1000 * w_f

num_workers(w_i, w_h, w_f) = w_i + w_h + w_f

regular_hrs(w_i, w_h, w_f) = num_workers(w_i, w_h, w_f) * 480
overtime_hrs(w_i, w_h, w_f, h_0) = num_workers(w_i, w_h, w_f) * h_0
total_hrs(w_i, w_h, w_f, h_0) = regular_hrs(w_i, w_h, w_f) + overtime_hrs(w_i, w_h, w_f, h_0)

regular_pay(w_i, w_h, w_f) = regular_hrs(w_i, w_h, w_f) * 50
overtime_pay(w_i, w_h, w_f, h_0) = overtime_hrs(w_i, w_h, w_f, h_0) * 55
total_pay(w_i, w_h, w_f, h_0) = regular_pay(w_i, w_h, w_f) + overtime_pay(w_i, w_h, w_f, h_0)

subcontracting_cost(s_u) = s_u * 9000

total_production(w_i, w_h, w_f, h_0, s_u) = total_hrs(w_i, w_h, w_f, h_0) / 160 + s_u

back_order(w_i, w_h, w_f, h_0, s_u, inventory, demand) = demand - (inventory + total_production(w_i, w_h, w_f, h_0, s_u))
back_order_cost(w_i, w_h, w_f, h_0, s_u, inventory, demand) = back_order(w_i, w_h, w_f, h_0, s_u, inventory, demand) * 1200


inventory_left(w_i, w_h, w_f, h_0, s_u, inventory, demand) = inventory + total_production(w_i, w_h, w_f, h_0, s_u) - demand
inventory_carry_cost(w_i, w_h, w_f, h_0, s_u, inventory, demand) = inventory_left(w_i, w_h, w_f, h_0, s_u, inventory, demand) * 50


model = Model(CPLEX.Optimizer)

inv_1 = 200
d_1 = 1500
w_i_1 = 600

@variable(model, w_h_1 >= 0, Int)
@variable(model, w_f_1 >= 0, Int)
@variable(model, h_0_1 <= 80)
@variable(model, s_u_1 <= 500, Int)

if back_order_cost(w_i_1, w_h_1, w_f_1, h_0_1, s_u_1, inv_1, d_1) > 0
    bo_1=back_order_cost(w_i_1, w_h_1, w_f_1, h_0_1, s_u_1, inv_1, d_1)
else
    bo_1 = 0
end

if inventory_carry_cost(w_i_1, w_h_1, w_f_1, h_0_1, s_u_1, inv_1, d_1) > 0
    ic_1=inventory_carry_cost(w_i_1, w_h_1, w_f_1, h_0_1, s_u_1, inv_1, d_1)
else
    ic_1 = 0
end

cost_quarter_1 = total_pay(w_i_1, w_h_1, w_f_1, h_0_1) + subcontracting_cost(s_u_1) + bo_1 + ic_1



inv_2 = inventory_left(w_i_1, w_h_1, w_f_1, h_0_1, s_u_1, inv_1, d_1)
d_2 = 2100
w_i_2 = num_workers(w_i_1, w_h_1, w_f_1)

@variable(model, w_h_2 >= 0, Int)
@variable(model, w_f_2 >= 0, Int)
@variable(model, h_0_2 <= 80)
@variable(model, s_u_2 <= 500, Int)

if back_order_cost(w_i_2, w_h_2, w_f_2, h_0_2, s_u_2, inv_2, d_2) > 0
    bo_2=back_order_cost(w_i_2, w_h_2, w_f_2, h_0_2, s_u_2, inv_2, d_2)
else
    bo_2 = 0
end

if inventory_carry_cost(w_i_2, w_h_2, w_f_2, h_0_2, s_u_2, inv_2, d_2) > 0
    ic_2=inventory_carry_cost(w_i_2, w_h_2, w_f_2, h_0_2, s_u_2, inv_2, d_2)
else
    ic_2 = 0
end

cost_quarter_2 = total_pay(w_i_2, w_h_2, w_f_2, h_0_2) + subcontracting_cost(s_u_2) + bo_2 + ic_2



inv_3 = inventory_left(w_i_2, w_h_2, w_f_2, h_0_2, s_u_2, inv_2, d_2)
d_3 = 1800
w_i_3 = num_workers(w_i_2, w_h_2, w_f_2)

@variable(model, w_h_3 >= 0, Int)
@variable(model, w_f_3 >= 0, Int)
@variable(model, h_0_3 <= 80)
@variable(model, s_u_3 <= 500, Int)

cost_quarter_3 = total_pay(w_i_3, w_h_3, w_f_3, h_0_3) + subcontracting_cost(s_u_3) + back_order_cost(w_i_3, w_h_3, w_f_3, h_0_3, s_u_3, inv_3, d_3)



inv_4 = inventory_left(w_i_3, w_h_3, w_f_3, h_0_3, s_u_3, inv_3, d_3)
d_4 = 1950
w_i_4 = num_workers(w_i_3, w_h_3, w_f_3)

@variable(model, w_h_4 >= 0, Int)
@variable(model, w_f_4 >= 0, Int)
@variable(model, h_0_4 <= 80)
@variable(model, s_u_4 <= 500, Int)

cost_quarter_4 = total_pay(w_i_4, w_h_4, w_f_4, h_0_4) + subcontracting_cost(s_u_4) + back_order_cost(w_i_4, w_h_4, w_f_4, h_0_4, s_u_4, inv_4, d_4)


yearly_cost = cost_quarter_1 + cost_quarter_2 + cost_quarter_3 + cost_quarter_4
final_inventory = inventory_left(w_i_4, w_h_4, w_f_4, h_0_4, s_u_4, inv_4, d_4)

@constraint(model, final_inventory == 300)

@objective(model, Min, yearly_cost)

@show model
optimize!(model)
@show value(w_h_1)