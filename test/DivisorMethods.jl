@testset "DHondt" begin
    
    # 2019 election to the European Parliament, Belgium, Dutch speaking electoral college

    entitlements = [
        954_048,
        811_169,
        678_051,
        617_651,
        525_908,
        434_002,
        210_391,
         20_385
    ]

    app_method = DivisorMethod(12, DHondt())

    expected = [3, 3, 2, 2, 1, 1, 0, 0]

    @test apportion(entitlements, app_method) == expected
end



@testset "HuntingtonHill" begin
    
    # US House of Representatives, 2020 census
    entitlements = [
        39_538_223,
        29_145_505,
        21_538_187,
        20_201_249,
        13_002_700,
        12_812_508,
        11_799_448,
        10_711_908,
        10_439_388,
        10_077_331,
         9_288_994,
         8_631_393,
         7_705_281,
         7_151_502,
         7_029_917,
         6_910_840,
         6_785_528,
         6_177_224,
         6_154_913,
         5_893_718,
         5_773_714,
         5_706_494,
         5_118_425,
         5_024_279,
         4_657_757,
         4_505_836,
         4_237_256,
         3_959_353,
         3_605_944,
         3_271_616,
         3_190_369,
         3_104_614,
         3_011_524,
         2_961_279,
         2_937_880,
         2_117_522,
         1_961_504,
         1_839_106,
         1_793_716,
         1_455_271,
         1_377_529,
         1_362_359,
         1_097_379,
         1_084_225,
           989_948,
           886_667,
           779_094,
           733_391,
           643_077,
           576_851
    ]

    app_method = DivisorMethod(435, HuntingtonHill())

    expected = [
        52, 38, 28, 26, 17, 17, 15, 14, 14, 13,
        12, 11, 10,  9,  9,  9,  9,  8,  8,  8,
         8,  8,  7,  7,  6,  6,  6,  5,  5,  4,
         4,  4,  4,  4,  4,  3,  3,  2,  2,  2,
         2,  2,  2,  2,  1,  1,  1,  1,  1,  1
    ]

    @test apportion(entitlements, app_method) == expected
end

@testset "SainteLaguë" begin
    
    # 2019 EP election in Latvia, excluding non-competitive parties
    entitlements = [
        124_193,
        82_604,
        77_591,
        58_763,
        29_546,
        25_252,
        23_581,
        20_595,
        13_705
    ]

    app_method = DivisorMethod(8, SainteLaguë())

    expected = [2, 2, 2, 1, 1, 0, 0, 0, 0]

    @test apportion(entitlements, app_method) == expected
end

@testset "Modified Sainte-Laguë" begin
    
    # 2018 General election in Sweden, Malmö constituency.
    entitlements = [
         56_248,
         37_645,
         32_480,
         11_003,
         23_021,
          7_426,
         10_812,
         10_783
    ]

    app_method = DivisorMethod(11, ModifiedSainteLaguë(6//5))

    expected = [3, 2, 2, 1, 1, 0, 1, 1]

    @test apportion(entitlements, app_method) == expected
end