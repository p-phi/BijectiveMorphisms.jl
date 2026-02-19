############################
# Generic Bijection System #
############################

# 1️⃣. Abstract interface
# A bijection maps values of type A to values of type B
abstract type AbstractBijection{A,B} end


# 2️⃣. Concrete bijection type
# F and G are the concrete function types for performance
struct Bijection{A,B,F,G} <: AbstractBijection{A,B}
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
    Bijection(𝒻, ℊ, ::Type{𝒜}, ::Type{ℬ})

Construct a type-safe reversible transformation between types 𝒜 and ℬ.

# Arguments
- 𝒻::Function — forward transformation 𝒜 → ℬ
- ℊ::Function — backward transformation ℬ → 𝒜
- ::Type{𝒜}, ::Type{ℬ} — domain and codomain types

# Returns
A Bijection{𝒜,ℬ,typeof(𝒻),typeof(ℊ)} object that is callable on values of type 𝒜.

# Notes
The user is responsible for ensuring that `𝒻` and `ℊ` actually form a bijection.
Round-trip correctness can be verified with `validate`.

# Example
```julia
f = x -> x + 1
g = y -> y - 1
b = Bijection(f, g, Int, Int)
b(3)  # returns 4
inverse(b)(4)  # returns 3
```
"""
function Bijection(f::Function, g::Function, ::Type{A}, ::Type{B}) where {A,B}
    Bijection{A,B,typeof(f),typeof(g)}(f, g)
end


# 4️⃣. Make bijection callable (forward direction)
function (b::Bijection{A,B})(x::A)::B where {A,B}
    b.forward(x)
end


# 5️⃣. Inverse operation
# This works for ANY A,B that the bijection uses.
# `where` exposes those types so the return type becomes Bijection{B,A}.
"""
    inverse(𝒻::Bijection) -> Bijection{ℬ,𝒜}

Return the inverse bijection.

# Arguments
𝒻 — a Bijection{𝒜,ℬ}

# Returns
A Bijection{ℬ,𝒜} where forward = original backward and backward = original forward.

# Example
```julia
𝒻 = Bijection(x -> x + 1, y -> y - 1, Int, Int)
𝒻⁻¹ = inverse(𝒻)
𝒻⁻¹(4)  # returns 3
```

---
    inverse(𝒷::ComposedBijection) -> ComposedBijection

Return the inverse composed bijection.

If:

    𝒷 = 𝒷₂ ∘ 𝒷₁

then:

    𝒷⁻¹ = 𝒷₁⁻¹ ∘ 𝒷₂⁻¹

# Example
```julia
𝒻 = Bijection(x -> x + 1, y -> y - 1, Int, Int)
ℊ = Bijection(x -> x + 10, y -> y - 10, Int, Int)
inverse(ℊ ∘ 𝒻)(13)  # returns 2
(inverse(𝒻) ∘ inverse(ℊ))(13)  # returns 2
```
"""
function inverse(b::Bijection{A,B}) where {A,B}
    # returns a function
    Bijection(b.backward, b.forward, B, A)
end
