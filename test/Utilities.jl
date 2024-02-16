import Apportionment: LazyTieBreaker, ShuffleTieBreaker
import Apportionment: choose_n, choose_one, get_largest, indicate_nlargest

function test_shuffle_tie_breaker(base, n, result)
    @test allunique(result)
    @test length(result) == n
    @test all(result .∈ Ref(base))
end

@testset "Tie Breakers" begin
    
    i = [5, 7, 3]
    tie_breaker = LazyTieBreaker()
    @test choose_one(i, tie_breaker) == 5
    @test choose_n(i, 0, tie_breaker) == []
    @test choose_n(i, 1, tie_breaker) == [5]
    @test choose_n(i, 2, tie_breaker) == [5, 7]
    @test choose_n(i, 3, tie_breaker) == [5, 7, 3]

    tie_breaker = ShuffleTieBreaker()
    @test choose_one(i, tie_breaker) ∈ i
    test_shuffle_tie_breaker(i, 0, choose_n(i, 0, tie_breaker))
    test_shuffle_tie_breaker(i, 1, choose_n(i, 1, tie_breaker))
    test_shuffle_tie_breaker(i, 2, choose_n(i, 2, tie_breaker))
    test_shuffle_tie_breaker(i, 3, choose_n(i, 3, tie_breaker))

end

@testset "Get largest" begin

    tie_breaker = LazyTieBreaker()

    @test get_largest([5], tie_breaker) == 1
    @test get_largest([5, 7], tie_breaker) == 2
    @test get_largest([5, 7, 7], tie_breaker) == 2
    
end

@testset "Indicate n largest" begin
    
    tie_breaker = LazyTieBreaker()

    @test indicate_nlargest(Int[], 0, tie_breaker) == Bool[]
    @test indicate_nlargest([3, 4], 0, tie_breaker) == [false, false]
    @test indicate_nlargest([3, 4], 2, tie_breaker) == [true , true ]

    @test indicate_nlargest([3, 7, 4], 1, tie_breaker) == [false, true, false]
    @test indicate_nlargest([3, 7, 4], 2, tie_breaker) == [false, true, true ]

    @test indicate_nlargest([4, 7, 3, 4], 1, tie_breaker) == [false, true, false, false]
    @test indicate_nlargest([4, 7, 3, 4], 2, tie_breaker) == [true , true, false, false]
    @test indicate_nlargest([4, 7, 3, 4], 3, tie_breaker) == [true , true, false, true ]

end