# Run with julia -L src/Cinta.jl test/runtests.jl 

include("../src/Cinta.jl")

using Test
using .Cinta

a_line_retriever = LineRetrieverFromString("alfa\nbeta")
@test typeof(a_line_retriever) == LineRetrieverFromString
@test get_next_line(a_line_retriever) == "alfa"
@test get_next_line(a_line_retriever) == "beta"
@test get_next_line(a_line_retriever) == nothing
# @test_throws DataType get_next_line(a_line_retriever)

a_line_retriever = LineRetrieverFromFile("test/datos_test.txt")
@test typeof(a_line_retriever) == LineRetrieverFromFile
@test get_next_line(a_line_retriever) == "alfa"
@test get_next_line(a_line_retriever) == "beta"
@test get_next_line(a_line_retriever) == nothing
# @test_throws DataType get_next_line(a_line_retriever)

@test !is_header("")
@test is_header("09/08/2020 06:32 cinta ruta 8 303")
@test !is_header("09/08/2020 06:36 cinta 805")

@test !is_detail("")
@test !is_detail("09/08/2020 06:32 cinta ruta 8 303")
@test is_detail("09/08/2020 06:36 cinta 805")

my_parameters = Parameters(10.5, .2)
@test typeof(my_parameters) == Parameters

a_line_retriever = LineRetrieverFromString("alfa\nbeta")
@test get_output(my_parameters, a_line_retriever) == ""

a_line_retriever = LineRetrieverFromString("09/08/2020 06:32 cinta ruta 8 303")
@test get_output(my_parameters, a_line_retriever) == "8\t3\t39:\t3\t→\t12\t︾\t10.5\n"

a_line_retriever = LineRetrieverFromString("09/08/2020 06:32 cinta ruta 8 303\n09/08/2020 06:36 cinta 805")
@test get_output(my_parameters, a_line_retriever) == "8\t3\t39:\t3\t→\t12\t︾\t10.5\n8\t5\t35:\t8\t→\t9\t︽\t10.1\n"

a_line_retriever = LineRetrieverFromString("09/08/2020 06:32 cinta ruta 8 303\n09/08/2020 06:32 cinta ruta 9 303")
@test get_output(my_parameters, a_line_retriever) == "8\t3\t39:\t3\t→\t12\t︾\t10.5\n9\t3\t39:\t3\t→\t12\t︾\t10.5\n"

a_line_retriever = LineRetrieverFromString("09/08/2020 06:32 cinta ruta 7 303\n09/08/2020 06:32 cinta ruta 2 303")
@test get_output(my_parameters, a_line_retriever) == "7\t3\t39:\t3\t→\t12\t︾\t10.5\n2\t3\t39:\t3\t→\t12\t︾\t10.5\n"
