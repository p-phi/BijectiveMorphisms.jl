@testset "Bijection basics" begin
    f = Bijection(x -> x + 1, x -> x - 1, Int, Int)

    @test f(1) == 2
    @test inverse(f)(2) == 1
end
