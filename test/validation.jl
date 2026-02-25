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

@testset "Roundtrip on composition" begin
    f = BijectiveMorphism(x -> x + 1, x -> x - 1, Int, Int)
    g = BijectiveMorphism(x -> Char(x), x -> Int(x), Int, Char)

    h = g ∘ f

    @test validate(h, 1:10)
    @test validate(inverse(h), ['1','a','v','^',';','∘','Z','*',' ','\n'])
end

@testset "Roundtrip on composition must fail if non bijective" begin
    f = BijectiveMorphism(x -> x + 1, x -> x - 2, Int, Int)
    g = BijectiveMorphism(x -> Char(x), x -> Int(x), Int, Char)

    h = g ∘ f

    @test !validate(h, 1:10)
    @test !validate(inverse(h), ['1','a','v','^',';','∘','Z','*',' ','\n'])
end
