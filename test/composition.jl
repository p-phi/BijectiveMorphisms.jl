@testset "Composition" begin
    f = Bijection(x -> x + 1, x -> x - 1, Int, Int)
    g = Bijection(x -> x * 2, x -> x ÷ 2, Int, Int)

    h = f ∘ g

    @test h(3) == 7
    @test inverse(h)(7) == 3
end
