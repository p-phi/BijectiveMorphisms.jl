############################
# Generic BijectiveMorphism System #
############################

# 1️⃣. Abstract interface
abstract type AbstractBijectiveMorphism{A,B} end


# 2️⃣. Concrete BijectiveMorphism type
# F and G are the concrete function types for performance
struct BijectiveMorphism{A,B,F,G} <: AbstractBijectiveMorphism{A,B}
    forward::F   # function A → B
    backward::G  # function B → A
end


# 3️⃣. Outer constructor (type-safe, no reflection)
# The `where {A,B}` introduces method-level type variables.
# It means:
#   "This constructor works for ANY A and B,
#    as long as f takes A and returns B,
#    and g takes B and returns A."
"""
    BijectiveMorphism(𝒻, ℊ, ::Type{𝒜}, ::Type{ℬ})

Construct a type-safe reversible transformation between types 𝒜 and ℬ.

# Arguments
- 𝒻::Function — forward transformation 𝒜 → ℬ
- ℊ::Function — backward transformation ℬ → 𝒜
- ::Type{𝒜}, ::Type{ℬ} — domain and codomain types

# Returns
A BijectiveMorphism{𝒜,ℬ,typeof(𝒻),typeof(ℊ)} object that is callable on values of type 𝒜.

# Notes
The user is responsible for ensuring that `𝒻` and `ℊ` actually form a bijective morphism.
Round-trip correctness can be verified with `validate`.

# Example
```julia
f = x -> x + 1
g = y -> y - 1
b = BijectiveMorphism(f, g, Int, Int)
b(3)  # returns 4
inverse(b)(4)  # returns 3
```
"""
function BijectiveMorphism(f::Function, g::Function, ::Type{A}, ::Type{B}) where {A,B}
    BijectiveMorphism{A,B,typeof(f),typeof(g)}(f, g)
end


# 4️⃣. Make bijective morphism callable (forward direction)
function (b::BijectiveMorphism{A,B})(x::A)::B where {A,B}
    b.forward(x)
end


# 5️⃣. Inverse operation
# This works for ANY A,B that the bijective morphism uses.
# `where` exposes those types so the return type becomes BijectiveMorphism{B,A}.
"""
    inverse(𝒻::BijectiveMorphism) -> BijectiveMorphism{ℬ,𝒜}

Return the inverse bijective morphism.

# Arguments
𝒻 — a BijectiveMorphism{𝒜,ℬ}

# Returns
A BijectiveMorphism{ℬ,𝒜} where forward = original backward and backward = original forward.

# Example
```julia
𝒻 = BijectiveMorphism(x -> x + 1, y -> y - 1, Int, Int)
𝒻⁻¹ = inverse(𝒻)
𝒻⁻¹(4)  # returns 3
```

---
    inverse(𝒷::ComposedBijectiveMorphism) -> ComposedBijectiveMorphism

Return the inverse composed bijective morphism.

If:

    𝒷 = 𝒷₂ ∘ 𝒷₁

then:

    𝒷⁻¹ = 𝒷₁⁻¹ ∘ 𝒷₂⁻¹

# Example
```julia
𝒻 = BijectiveMorphism(x -> x + 1, y -> y - 1, Int, Int)
ℊ = BijectiveMorphism(x -> x + 10, y -> y - 10, Int, Int)
inverse(ℊ ∘ 𝒻)(13)  # returns 2
(inverse(𝒻) ∘ inverse(ℊ))(13)  # returns 2
```
"""
function inverse(b::BijectiveMorphism{A,B}) where {A,B}
    BijectiveMorphism(b.backward, b.forward, B, A)
end
