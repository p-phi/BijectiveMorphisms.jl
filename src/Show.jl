function Base.show(io::IO, b::AbstractBijection{A,B}) where {A,B}
    if get(io, :compact, false)
        print(io, "$A↔$B")
    else
        print(io, "Bijection { $A ↔ $B }")
    end
end
