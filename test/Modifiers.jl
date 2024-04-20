import Apportionment: modify

@testset "Thresholds" begin
    
    abs_threshold = AbsoluteThreshold(4)

    @test modify([6, 5, 89], abs_threshold) == [6, 5, 89] # >
    @test modify([6, 4, 89], abs_threshold) == [6, 4, 89] # >=
    @test modify([6, 3, 89], abs_threshold) == [6, 0, 89] # <

    rel_threshold = RelativeThreshold(1//20)

    @test modify([6, 45, 50], rel_threshold) == [6, 45, 50] # >
    @test modify([5, 45, 50], rel_threshold) == [5, 45, 50] # >=
    @test modify([4, 45, 50], rel_threshold) == [0, 45, 50] # <

    rank_threshold = RankThreshold(2)

    @test modify([6, 5, 89], rank_threshold) == [6, 0, 89]
    @test modify([6.0, 5.0, 89.0], rank_threshold) == [6.0, 0.0, 89.0]

end