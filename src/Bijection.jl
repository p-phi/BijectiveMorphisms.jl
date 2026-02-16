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
function Bijection(f::Function, g::Function, ::Type{A}, ::Type{B}) where {A,B}
    Bijection{A,B,typeof(f),typeof(g)}(f, g)
end


# 4️⃣. Make bijection callable (forward direction)
# `where {A,B}` binds the type parameters from the struct to names
# so we can require the input to be exactly type A.
(b::Bijection)(x)  = b.forward(x)


# 5️⃣. Inverse operation
# This works for ANY A,B that the bijection uses.
# `where` exposes those types so the return type becomes Bijection{B,A}.
function inverse(b::Bijection{A,B}) where {A,B}
    # returns a function
    Bijection(b.backward, b.forward, B, A)
end
