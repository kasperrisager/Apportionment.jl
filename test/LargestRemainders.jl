@testset "Largest remainders" begin
    
    lr3 = LargestRemainders(3)
    entitlements = [5.6, 2.6]

    @test apportion(entitlements, lr3) == [2, 1]

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

end
