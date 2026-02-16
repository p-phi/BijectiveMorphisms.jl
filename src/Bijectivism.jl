"""
Bijectivism.jl — composable reversible transformations.

This package provides a lightweight algebra for bijections.
It does not attempt to prove global bijectivity; instead,
it offers tools to verify round-trip correctness on concrete domains.
"""
module Bijectivism

include("Bijection.jl")
include("Composition.jl")
include("Checks.jl")

export 
    Bijection,
    inverse,
    check_roundtrip
end

