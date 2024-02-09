@testset "Largest remainders" begin
    
    lr3 = LargestRemainders(3)

    @test apportion([5.6, 2.6], lr3) == [2, 1]
    @test apportion([3.0, 3.0], lr3) == [2, 1] # uses LazyTieBreaker, so always chooses first

    @test apportion([5, 3], lr3) == [2, 1]
    @test apportion([3, 3], lr3) ∈ [[2, 1], [1, 2]] # uses ShuffleTieBreaker, so we don't know which

    @test apportion([5+1//3, 3+5//13], lr3) == [2, 1]
    @test apportion([5+1//3, 5+1//3], lr3) ∈ [[2, 1], [1, 2]] # uses ShuffleTieBreaker, so we don't know which


    # Danish general election 2019, only parties above threshold
    entitlements = [
        915393,
        304273,
        233349,
        83228,
        272093,
        82228,
        308219,
        825486,
        244664,
        104148
    ]

    expected_apportionment = [
        48, 16, 12, 4, 14, 4, 16, 43, 13, 5
    ]

    @test apportion(entitlements, LargestRemainders(175)) == expected_apportionment
    @test apportion(float(entitlements), LargestRemainders(175)) == expected_apportionment

end
