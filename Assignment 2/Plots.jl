func(x) = (x[1]^2 + 2 * x[2]^2 - 0.3 * cos(3 * pi * x[1]) - 0.4 * cos(4 * pi * x[2]) + 0.7) #Bohachevsky Function
using Plots

# Generate x and y values for the surface plot
x = range(-1, stop=1, length=100)
y = range(-1, stop=1, length=100)
z = [func([x[i], y[j]]) for i in 1:length(x), j in 1:length(y)]

# Create 3D surface plot
surface_plot = surface(x, y, z, xlabel="x", ylabel="y", zlabel="f(x, y)", title="Bohachevsky Function",c=:viridis)
plotlyjs()
plot(surface_plot)
