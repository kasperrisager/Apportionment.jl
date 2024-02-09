import Apportionment: LazyTieBreaker, ShuffleTieBreaker
import Apportionment: chosen, indicate_largest

function test_shuffle_tie_breaker(base, n, result)
    @test allunique(result)
    @test length(result) == n
    @test all(result .∈ Ref(base))
end

@testset "Tie Breakers" begin
    
    i = [5, 7, 3]
    tie_breaker = LazyTieBreaker()
    @test chosen(i, 0, tie_breaker) == []
    @test chosen(i, 1, tie_breaker) == [5]
    @test chosen(i, 2, tie_breaker) == [5, 7]
    @test chosen(i, 3, tie_breaker) == [5, 7, 3]

    tie_breaker = ShuffleTieBreaker()
    test_shuffle_tie_breaker(i, 0, chosen(i, 0, tie_breaker))
    test_shuffle_tie_breaker(i, 1, chosen(i, 1, tie_breaker))
    test_shuffle_tie_breaker(i, 2, chosen(i, 2, tie_breaker))
    test_shuffle_tie_breaker(i, 3, chosen(i, 3, tie_breaker))

end

@testset "Indicate largest" begin
    
    tie_breaker = LazyTieBreaker()

    @test indicate_largest(Int[], 0, tie_breaker) == Bool[]
    @test indicate_largest([3, 4], 0, tie_breaker) == [false, false]
    @test indicate_largest([3, 4], 2, tie_breaker) == [true , true ]

    @test indicate_largest([3, 7, 4], 1, tie_breaker) == [false, true, false]
    @test indicate_largest([3, 7, 4], 2, tie_breaker) == [false, true, true ]

    @test indicate_largest([4, 7, 3, 4], 1, tie_breaker) == [false, true, false, false]
    @test indicate_largest([4, 7, 3, 4], 2, tie_breaker) == [true , true, false, false]
    @test indicate_largest([4, 7, 3, 4], 3, tie_breaker) == [true , true, false, true ]

end