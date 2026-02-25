"""
BijectiveMorphisms.jl — composable reversible transformations.

This package provides a lightweight algebra for bijections.
It does not attempt to prove global bijectivity; instead,
it offers tools to verify round-trip correctness on concrete domains.
"""
module BijectiveMorphisms

include("BijectiveMorphism.jl")
include("Validation.jl")
include("Show.jl")

export 
    BijectiveMorphism,
    inverse,
    compose,
    validate
end
