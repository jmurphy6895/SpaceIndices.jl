# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==========================================================================================
#
#   Tests related with the functions to obtain the space indices.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

@testset "Fluxtable" begin
    SpaceIndices.init_set(SpaceIndices.Fluxtable)
    dt = DateTime(2020, 6, 19)
    jd = dt |> datetime2julian

    r = space_index(Val(:F10obs), dt)
    @test r ≈ 68.8
    r = space_index(Val(:F10obs), jd)
    @test r ≈ 68.8

    r = space_index(Val(:F10adj), dt)
    @test r ≈ 71.1
    r = space_index(Val(:F10adj), jd)
    @test r ≈ 71.1
end

@testset "Fluxtable [ERRORS]" begin
    # The data starts on 2004-10-28.
    dt = DateTime(2003, 12, 31)
    jd = dt |> datetime2julian

    @test_throws ArgumentError space_index(Val(:F10obs), dt)
    @test_throws ArgumentError space_index(Val(:F10obs), jd)
    @test_throws ArgumentError space_index(Val(:F10adj), dt)
    @test_throws ArgumentError space_index(Val(:F10adj), jd)
end

@testset "JB2008" begin
    SpaceIndices.init_set(SpaceIndices.JB2008)
    dt = DateTime(2020, 6, 19, 9, 30, 0)
    jd = dt |> datetime2julian

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
    @test r ≈ 72.4
    r = space_index(Val(:M10), jd)
    @test r ≈ 72.4

    r = space_index(Val(:M81a), dt)
    @test r ≈ 73.6
    r = space_index(Val(:M81a), jd)
    @test r ≈ 73.6

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
    jd = dt |> datetime2julian

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

@testset "KpAp" begin
    SpaceIndices.init_set(SpaceIndices.KpAp)
    dt = DateTime(2020, 6, 19)
    jd = dt |> datetime2julian

    r = space_index(Val(:Kp), dt)
    @test r == (0.667, 1.000, 0.333, 1.000, 0.667, 0.667, 1.333, 1.667)
    r = space_index(Val(:Kp), jd)
    @test r == (0.667, 1.000, 0.333, 1.000, 0.667, 0.667, 1.333, 1.667)

    r = space_index(Val(:Kp_daily), dt)
    @test r ≈ 0.91675
    r = space_index(Val(:Kp_daily), jd)
    @test r ≈ 0.91675

    r = space_index(Val(:Ap), dt)
    @test r == (3, 4, 2, 4, 3, 3, 5, 6)
    r = space_index(Val(:Ap), jd)
    @test r == (3, 4, 2, 4, 3, 3, 5, 6)

    r = space_index(Val(:Ap_daily), dt)
    @test r == 4
    r = space_index(Val(:Ap_daily), jd)
    @test r == 4
end

@testset "KpAp [ERRORS]" begin
    # The data starts on 1932-01-01.
    dt = DateTime(1931, 12, 31)
    jd = dt |> datetime2julian

    @test_throws ArgumentError space_index(Val(:Kp), dt)
    @test_throws ArgumentError space_index(Val(:Kp), jd)

    @test_throws ArgumentError space_index(Val(:Kp_daily), dt)
    @test_throws ArgumentError space_index(Val(:Kp_daily), jd)

    @test_throws ArgumentError space_index(Val(:Ap), dt)
    @test_throws ArgumentError space_index(Val(:Ap), jd)

    @test_throws ArgumentError space_index(Val(:Ap_daily), dt)
    @test_throws ArgumentError space_index(Val(:Ap_daily), jd)
end
