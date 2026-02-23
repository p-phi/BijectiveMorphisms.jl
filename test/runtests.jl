using BijectiveMorphisms
using Test

@testset "BijectiveMorphisms.jl" begin
    include("bijective_morphism.jl")
    include("composition.jl")
    include("validation.jl")
end
