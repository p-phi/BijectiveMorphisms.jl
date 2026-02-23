function Base.show(io::IO, b::AbstractBijectiveMorphism{A,B}) where {A,B}
    if get(io, :compact, false)
        print(io, "$A↔$B")
    else
        print(io, "BijectiveMorphism { $A ↔ $B }")
    end
end
