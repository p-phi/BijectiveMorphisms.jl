@testset "Composition" begin
    f = Bijection(x -> x + 1, x -> x - 1, Int, Int)
    g = Bijection(x -> x * 2, x -> x ÷ 2, Int, Int)

    h = f ∘ g

    @test h(3) == 7
    @test inverse(h)(7) == 3
end

@testset "Composition is associative" begin
    f = Bijection(x -> x + 1, x -> x - 1, Int, Int)
    g = Bijection(x -> x * 2, x -> x ÷ 2, Int, Int)
    i = Bijection(x -> Char(x), x -> Int(x), Int, Char)

    h = f ∘ g
    j = i ∘ f

    @test (i ∘ h)(3) == (j ∘ g)(3)
    @test inverse(i ∘ h)('\a') == inverse(j ∘ g)('\a')
end

@testset "Composition of inverses" begin
    f = Bijection(x -> x + 1, x -> x - 1, Int, Int)
    g = Bijection(x -> x * 2, x -> x ÷ 2, Int, Int)

    h = f ∘ g
    i = inverse(g) ∘ inverse(f)

    @test inverse(h)(7) == i(7)
end

@testset "Compositioni must fail if domain mismatch" begin
    f = Bijection(x -> x + 1, x -> x - 1, Int, Int)
    g = Bijection(x -> x * 2, x -> x / 2, Float64, Float64)

    @test_throws MethodError h = f ∘ g

end
