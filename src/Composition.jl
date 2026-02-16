################################
# Bijection Composition System #
################################

# 1️⃣. Composed bijection type
# Represents:  A --b1--> B --b2--> C
struct ComposedBijection{A,B,C,B1,B2} <: AbstractBijection{A,C}
    b1::B1  # first bijection  A → B
    b2::B2  # second bijection B → C
end


# 2️⃣. Outer constructor for composition
# The `where` clause does something very powerful:
#
#   F <: AbstractBijection{A,B}
#   G <: AbstractBijection{B,C}
#
# This means:
#   - b1 must be a bijection from A to B
#   - b2 must be a bijection from B to C
#   - The intermediate type B must MATCH
#
# Julia infers A,B,C automatically from the argument types.
ComposedBijection(b1::F, b2::G) where
    {A,B,C,
     F<:AbstractBijection{A,B},
     G<:AbstractBijection{B,C}} =
    ComposedBijection{A,B,C,F,G}(b1, b2)

# 3. Make ComposedBijection callable
(b::ComposedBijection)(x) =
    b.b2(b.b1(x))


# 4️⃣. Inverse of a composition
# If b = b2 ∘ b1, then b⁻¹ = b1⁻¹ ∘ b2⁻¹
# The same type parameters A,B,C are reused here.
inverse(b::ComposedBijection) =
    inverse(b.b1) ∘ inverse(b.b2)


# 5️⃣. Extend composition operator
import Base: ∘

# This method applies for ANY A,B,C where:
#   b1 is A→B
#   b2 is B→C
# The shared B is enforced by the type system.
(∘)(b2::AbstractBijection{B,C},
    b1::AbstractBijection{A,B}) where {A,B,C} =
    ComposedBijection(b1, b2)

