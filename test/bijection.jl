@testset "Bijection basics" begin
    f = Bijection(x -> sqrt(x), x -> x^2, Float64, Float64)

    @test f(4.0) == 2.0
    @test inverse(f)(4.0) == 16.0
end

@testset "Bijection multi-domain" begin
    f = Bijection(x -> Char(x), x -> Int(x), Int, Char)

    @test f(97) == 'a'
    @test inverse(f)('a') == 97
end

@testset "Non invertible bijection must fail" begin
    f = Bijection(x -> Char(x), x -> Int(x + 1), Int, Char)

    @test f(97) == 'a'
    @test inverse(f)('a') != 97
end

@testset "Wrong input type must fail" begin
    f = Bijection(x -> sqrt(x), x -> x^2, Float64, Float64)

    @test_throws MethodError f(4)
end

@testset "Wrong input domain must fail" begin
    f = Bijection(x -> sqrt(x), x -> x^2, Float64, Float64)

    @test_throws DomainError f(-4.0)
end

