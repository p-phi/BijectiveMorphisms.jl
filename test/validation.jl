@testset "Roundtrip" begin
    f = BijectiveMorphism(x -> x + 1, x -> x - 1, Int, Int)

    @test validate(f, 1:10)
end

@testset "Roundtrip overload" begin
    f = BijectiveMorphism(x -> sqrt(x), x -> x^2, Float64, Float64)

    @test validate(f, 1.0:10.0, eq = ≈)
end

@testset "Roundtrip must fail if non invertible" begin
    f = BijectiveMorphism(x -> sqrt(x), x -> x^2, Float64, Float64)

    @test !validate(f, 1.0:10.0)
end
