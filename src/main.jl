include("../src/Cinta.jl")

using .Cinta

my_parameters = Parameters(10.5, .2)
my_line_retriever = LineRetrieverFromFile("src/datos_cinta.txt")

# println("Ruta\tInc\tMin\tVel ofrecida\t\tBotón\tSubir o bajar\tVel")
println(get_output(my_parameters, my_line_retriever))