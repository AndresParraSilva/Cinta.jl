using Pkg
using SafeTestsets

# Start Test Script

@time begin
@time @safetestset "Tests básicos" begin include("cinta_test.jl") end
end  # @time