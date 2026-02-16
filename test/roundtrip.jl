@testset "Roundtrip" begin
    f = Bijection(x -> x + 1, x -> x - 1, Int, Int)

    @test check_roundtrip(f, 1:10)
end
