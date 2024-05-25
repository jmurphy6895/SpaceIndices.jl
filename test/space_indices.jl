## Description #############################################################################
#
#   Tests related with the functions to obtain the space indices.
#
############################################################################################

@testset "Celestrak" begin
    # == F10.7 Indices =====================================================================

    SpaceIndices.init(SpaceIndices.Celestrak)
    dt = DateTime(2020, 6, 19, 8)
    jd = datetime2julian(dt)

    r = space_index(Val(:F10adj), dt)
    @test r ≈ 71.1
    r = space_index(Val(:F10adj), jd)
    @test r ≈ 71.1

    r = space_index(Val(:F10adj_avg_center81), dt)
    @test r ≈ 71.4
    r = space_index(Val(:F10adj_avg_center81), jd)
    @test r ≈ 71.4

    r = space_index(Val(:F10adj_avg_last81), dt)
    @test r ≈ 70.8
    r = space_index(Val(:F10adj_avg_last81), jd)
    @test r ≈ 70.8

    r = space_index(Val(:F10obs), dt)
    @test r ≈ 68.8
    r = space_index(Val(:F10obs), jd)
    @test r ≈ 68.8

    r = space_index(Val(:F10obs_avg_center81), dt)
    @test r ≈ 69.3
    r = space_index(Val(:F10obs_avg_center81), jd)
    @test r ≈ 69.3

    r = space_index(Val(:F10obs_avg_last81), dt)
    @test r ≈ 69.6
    r = space_index(Val(:F10obs_avg_last81), jd)
    @test r ≈ 69.6

    dt = DateTime(2020, 6, 19, 7, 59, 59)
    jd = datetime2julian(dt)

    r = space_index(Val(:F10adj), dt)
    @test r ≈ 70.2
    r = space_index(Val(:F10adj), jd)
    @test r ≈ 70.2

    r = space_index(Val(:F10adj_avg_center81), dt)
    @test r ≈ 71.3
    r = space_index(Val(:F10adj_avg_center81), jd)
    @test r ≈ 71.3

    r = space_index(Val(:F10adj_avg_last81), dt)
    @test r ≈ 70.8
    r = space_index(Val(:F10adj_avg_last81), jd)
    @test r ≈ 70.8

    r = space_index(Val(:F10obs), dt)
    @test r ≈ 67.9
    r = space_index(Val(:F10obs), jd)
    @test r ≈ 67.9

    r = space_index(Val(:F10obs_avg_center81), dt)
    @test r ≈ 69.3
    r = space_index(Val(:F10obs_avg_center81), jd)
    @test r ≈ 69.3

    r = space_index(Val(:F10obs_avg_last81), dt)
    @test r ≈ 69.6
    r = space_index(Val(:F10obs_avg_last81), jd)
    @test r ≈ 69.6

    dt = DateTime(2000, 6, 8, 8)
    jd = datetime2julian(dt)

    r = space_index(Val(:F10adj), dt)
    @test r ≈ 179.9
    r = space_index(Val(:F10adj), jd)
    @test r ≈ 179.9

    r = space_index(Val(:F10adj_avg_center81), dt)
    @test r ≈ 193.1
    r = space_index(Val(:F10adj_avg_center81), jd)
    @test r ≈ 193.1

    r = space_index(Val(:F10adj_avg_last81), dt)
    @test r ≈ 190.2
    r = space_index(Val(:F10adj_avg_last81), jd)
    @test r ≈ 190.2

    r = space_index(Val(:F10obs), dt)
    @test r ≈ 174.6
    r = space_index(Val(:F10obs), jd)
    @test r ≈ 174.6

    r = space_index(Val(:F10obs_avg_center81), dt)
    @test r ≈ 187.8
    r = space_index(Val(:F10obs_avg_center81), jd)
    @test r ≈ 187.8

    r = space_index(Val(:F10obs_avg_last81), dt)
    @test r ≈ 187.8
    r = space_index(Val(:F10obs_avg_last81), jd)
    @test r ≈ 187.8

    dt = DateTime(2000, 6, 8, 7, 59, 59)
    jd = datetime2julian(dt)

    r = space_index(Val(:F10adj), dt)
    @test r ≈ 185.8
    r = space_index(Val(:F10adj), jd)
    @test r ≈ 185.8

    r = space_index(Val(:F10adj_avg_center81), dt)
    @test r ≈ 192.1
    r = space_index(Val(:F10adj_avg_center81), jd)
    @test r ≈ 192.1

    r = space_index(Val(:F10adj_avg_last81), dt)
    @test r ≈ 190.5
    r = space_index(Val(:F10adj_avg_last81), jd)
    @test r ≈ 190.5

    r = space_index(Val(:F10obs), dt)
    @test r ≈ 180.3
    r = space_index(Val(:F10obs), jd)
    @test r ≈ 180.3

    r = space_index(Val(:F10obs_avg_center81), dt)
    @test r ≈ 186.8
    r = space_index(Val(:F10obs_avg_center81), jd)
    @test r ≈ 186.8

    r = space_index(Val(:F10obs_avg_last81), dt)
    @test r ≈ 188.2
    r = space_index(Val(:F10obs_avg_last81), jd)
    @test r ≈ 188.2

    # == Kp & Ap ===========================================================================

    dt = DateTime(2020, 6, 19)
    jd = datetime2julian(dt)

    r = space_index(Val(:Kp), dt)
    @test r == [0.667; 1.000; 0.333; 1.000; 0.667; 0.667; 1.333; 1.667]
    r = space_index(Val(:Kp), jd)
    @test r == [0.667; 1.000; 0.333; 1.000; 0.667; 0.667; 1.333; 1.667]

    r = space_index(Val(:Kp_daily), dt)
    @test r ≈ 0.91675
    r = space_index(Val(:Kp_daily), jd)
    @test r ≈ 0.91675

    r = space_index(Val(:Ap), dt)
    @test r == [3; 4; 2; 4; 3; 3; 5; 6]
    r = space_index(Val(:Ap), jd)
    @test r == [3; 4; 2; 4; 3; 3; 5; 6]

    r = space_index(Val(:Ap_daily), dt)
    @test r == 4
    r = space_index(Val(:Ap_daily), jd)
    @test r == 4

    dt = DateTime(2000, 6, 8)
    jd = datetime2julian(dt)

    r = space_index(Val(:Kp), dt)
    @test r == [2.667; 3.667; 4.333; 6.333; 7.0; 6.333; 6.0; 5.0]
    r = space_index(Val(:Kp), jd)
    @test r == [2.667; 3.667; 4.333; 6.333; 7.0; 6.333; 6.0; 5.0]

    r = space_index(Val(:Kp_daily), dt)
    @test r ≈ 5.166625
    r = space_index(Val(:Kp_daily), jd)
    @test r ≈ 5.166625

    r = space_index(Val(:Ap), dt)
    @test r == [12; 22; 32; 94; 132; 94; 80; 48]
    r = space_index(Val(:Ap), jd)
    @test r == [12; 22; 32; 94; 132; 94; 80; 48]

    r = space_index(Val(:Ap_daily), dt)
    @test r == 64
    r = space_index(Val(:Ap_daily), jd)
    @test r == 64

    # == Other Indices =====================================================================

    dt = DateTime(2020, 6, 19)
    jd = datetime2julian(dt)

    r = space_index(Val(:BSRN), dt)
    @test r == 2549
    r = space_index(Val(:BSRN), jd)
    @test r == 2549

    r = space_index(Val(:ND), dt)
    @test r == 3
    r = space_index(Val(:ND), jd)
    @test r == 3

    r = space_index(Val(:C9), dt)
    @test r == 0.0
    r = space_index(Val(:C9), jd)
    @test r == 0.0

    r = space_index(Val(:Cp), dt)
    @test r == 0.1
    r = space_index(Val(:Cp), jd)
    @test r == 0.1

    r = space_index(Val(:ISN), dt)
    @test r == 0
    r = space_index(Val(:ISN), jd)
    @test r == 0

    r = space_index(Val(:ND), dt)
    @test r == 3
    r = space_index(Val(:ND), jd)
    @test r == 3

    dt = DateTime(2000, 6, 8)
    jd = datetime2julian(dt)

    r = space_index(Val(:BSRN), dt)
    @test r == 2278
    r = space_index(Val(:BSRN), jd)
    @test r == 2278

    r = space_index(Val(:ND), dt)
    @test r == 4
    r = space_index(Val(:ND), jd)
    @test r == 4

    r = space_index(Val(:C9), dt)
    @test r == 7.0
    r = space_index(Val(:C9), jd)
    @test r == 7.0

    r = space_index(Val(:Cp), dt)
    @test r == 1.7
    r = space_index(Val(:Cp), jd)
    @test r == 1.7

    r = space_index(Val(:ISN), dt)
    @test r == 181
    r = space_index(Val(:ISN), jd)
    @test r == 181

    r = space_index(Val(:ND), dt)
    @test r == 4
    r = space_index(Val(:ND), jd)
    @test r == 4

    SpaceIndices.destroy()
end

@testset "Celestrak [ERRORS]" begin
    SpaceIndices.init(SpaceIndices.Celestrak)

    # The data starts on 1932-01-01.
    dt = DateTime(1931, 12, 31)
    jd = datetime2julian(dt)

    @test_throws ArgumentError space_index(Val(:F10obs), dt)
    @test_throws ArgumentError space_index(Val(:F10obs), jd)
    @test_throws ArgumentError space_index(Val(:F10adj), dt)
    @test_throws ArgumentError space_index(Val(:F10adj), jd)

    @test_throws ArgumentError space_index(Val(:Kp), dt)
    @test_throws ArgumentError space_index(Val(:Kp), jd)

    @test_throws ArgumentError space_index(Val(:Kp_daily), dt)
    @test_throws ArgumentError space_index(Val(:Kp_daily), jd)

    @test_throws ArgumentError space_index(Val(:Ap), dt)
    @test_throws ArgumentError space_index(Val(:Ap), jd)

    @test_throws ArgumentError space_index(Val(:Ap_daily), dt)
    @test_throws ArgumentError space_index(Val(:Ap_daily), jd)
end

@testset "JB2008" begin
    SpaceIndices.init(SpaceIndices.JB2008)
    dt = DateTime(2020, 6, 19, 9, 30, 0)
    jd = datetime2julian(dt)

    r = space_index(Val(:DTC), dt)
    @test r ≈ 37
    r = space_index(Val(:DTC), jd)
    @test r ≈ 37

    r = space_index(Val(:S10), dt)
    @test r ≈ 57.7
    r = space_index(Val(:S10), jd)
    @test r ≈ 57.7

    r = space_index(Val(:S81a), dt)
    @test r ≈ 58.4
    r = space_index(Val(:S81a), jd)
    @test r ≈ 58.4

    r = space_index(Val(:M10), dt)
    @test r ≈ 72.7
    r = space_index(Val(:M10), jd)
    @test r ≈ 72.7

    r = space_index(Val(:M81a), dt)
    @test r ≈ 73.9
    r = space_index(Val(:M81a), jd)
    @test r ≈ 73.9

    r = space_index(Val(:Y10), dt)
    @test r ≈ 58.2
    r = space_index(Val(:Y10), jd)
    @test r ≈ 58.2

    r = space_index(Val(:Y81a), dt)
    @test r ≈ 62.7
    r = space_index(Val(:Y81a), jd)
    @test r ≈ 62.7
end

@testset "JB2008 [ERRORS]" begin
    # The data starts on 1997-01-01.
    dt = DateTime(1996, 12, 31)
    jd = datetime2julian(dt)

    @test_throws ArgumentError space_index(Val(:DTC),  dt)
    @test_throws ArgumentError space_index(Val(:DTC),  jd)

    @test_throws ArgumentError space_index(Val(:S10),  dt)
    @test_throws ArgumentError space_index(Val(:S10),  jd)

    @test_throws ArgumentError space_index(Val(:S81a), dt)
    @test_throws ArgumentError space_index(Val(:S81a), jd)

    @test_throws ArgumentError space_index(Val(:M10),  dt)
    @test_throws ArgumentError space_index(Val(:M10),  jd)

    @test_throws ArgumentError space_index(Val(:M81a), dt)
    @test_throws ArgumentError space_index(Val(:M81a), jd)

    @test_throws ArgumentError space_index(Val(:Y10),  dt)
    @test_throws ArgumentError space_index(Val(:Y10),  jd)

    @test_throws ArgumentError space_index(Val(:Y81a), dt)
    @test_throws ArgumentError space_index(Val(:Y81a), jd)
end
