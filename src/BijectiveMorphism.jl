############################
# Generic BijectiveMorphism System #
############################

# Abstract interface
abstract type AbstractBijectiveMorphism{A,B} end


# Concrete BijectiveMorphism type
# F and G are the concrete function types for performance
struct BijectiveMorphism{A,B,F,G} <: AbstractBijectiveMorphism{A,B}
    forward::F   # function A → B
    backward::G  # function B → A
end


# Outer constructor (type-safe, no reflection)
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


# Make bijective morphism callable (forward direction)
function (b::BijectiveMorphism{A,B})(x::A)::B where {A,B}
    b.forward(x)
end


# Inverse operation
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

"""
function inverse(b::BijectiveMorphism{A,B}) where {A,B}
    BijectiveMorphism(b.backward, b.forward, B, A)
end

"""
    compose(g::BijectiveMorphism{B,C},
            f::BijectiveMorphism{A,B}) where {A,B,C}

Return the composition `g ∘ f`, yielding a `BijectiveMorphism{A,C}`.

The resulting morphism represents the forward transformation

    x ↦ g(f(x))

and defines its inverse automatically as

    y ↦ inverse(f)(inverse(g)(y))

The shared intermediate type `B` is enforced at the type level,
ensuring that only composable morphisms can be combined.

This operation preserves bijectivity: the composition of two
bijective morphisms is itself bijective.

# Examples
```julia
b = compose(b2, b1)
b(x) == b2(b1(x))
```
"""
function compose(g::BijectiveMorphism{B,C},
                 f::BijectiveMorphism{A,B}) where {A,B,C}
    BijectiveMorphism(
        x -> g(f(x)),
        y -> inverse(f)(inverse(g)(y)),
        A, C
    )
end

# Extend composition operator
import Base: ∘

# This method applies for ANY A,B,C where:
#   b1 is A→B
#   b2 is B→C
# The shared B is enforced by the type system.
"""
    ∘(b2::AbstractBijectiveMorphism{B,C},
      b1::AbstractBijectiveMorphism{A,B}) where {A,B,C}

Compose two bijective morphisms using the standard composition
operator `∘`.

This method enforces type compatibility at compile time:

- `b1` maps `A → B`
- `b2` maps `B → C`

and returns a morphism `A → C`.

The order follows mathematical convention:

    (b2 ∘ b1)(x) == b2(b1(x))

# Examples
```julia
b = b2 ∘ b1
b(x) == b2(b1(x))
```
"""
function(∘)(b2::AbstractBijectiveMorphism{B,C},
    b1::AbstractBijectiveMorphism{A,B}) where {A,B,C}
    compose(b2, b1)
end

# This makes the composition failed for general bijections by default,
# so co-domain-mismatched bijections fail at construction time
function (∘)(
    ::AbstractBijectiveMorphism,
    ::AbstractBijectiveMorphism
)
    throw(MethodError(∘, "BijectiveMorphism domains do not match"))
end

