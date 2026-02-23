#############################
# BijectiveMorphism Check Functions #
#############################

# Given a defined bijective morphism f and a range of values x,
# checks that f is valid by asserting:
# f⁻¹(f(x)) = x
"""
    validate(𝒷::AbstractBijectiveMorphism, xs; eq = isequal) -> Bool

Empirically verify the round-trip law for a bijective morphism on a finite sample.

For each `x ∈ xs`, this function checks:

    ℊ(𝒻(x)) == x

where `𝒻` is the forward map and `ℊ = inverse(𝒷)`.

# Arguments
- `𝒷` — a bijective morphism `𝒜 → ℬ`
- `xs` — a collection of values in `𝒜` used as test points
- `eq` — equality predicate (default: `isequal`)

# Returns
`true` if the round-trip property holds for all sampled values, otherwise `false`.

# Notes
This is a *validation utility*, not a proof of bijectivity.  
It allows domain-specific or approximate bijective morphisms to be checked on the
values that matter in practice.

# Examples
```julia
f = x -> x + 1
g = y -> y - 1
b = BijectiveMorphism(f, g, Int, Int)

validate(b, 1:10)  # true
```
Custom equality:
```julia
b = BijectiveMorphism(sqrt, x -> x^2, Float64, Float64)
validate(b, 1:10; eq = ≈)  # true

```
"""
function validate(f::AbstractBijectiveMorphism, xs; eq = isequal)::Bool
    all(eq(inverse(f)(f(x)), x) for x in xs)
end
