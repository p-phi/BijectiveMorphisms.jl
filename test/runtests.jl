using Bijectivism
using Test

@testset "Bijectivism.jl" begin
    include("bijection.jl")
    include("composition.jl")
    include("validation.jl")
end
