# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==========================================================================================
#
#   Tests related with the functions to get the space indices.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

@testset "Dtcfile" begin
    init_space_index(SpaceIndices.Dtcfile)
    dt = DateTime(2020, 6, 19)

    r = get_space_index(Val(:DTC), dt)
    @test r ≈ 24
end

@testset "Dtcfile [ERRORS]" begin
    # The data starts on 1997-01-01.
    dt = DateTime(1996, 12, 31)
    @test_throws ArgumentError get_space_index(Val(:DTC), dt)
end

@testset "Fluxtable" begin
    init_space_index(SpaceIndices.Fluxtable)
    dt = DateTime(2020, 6, 19)

    r = get_space_index(Val(:F10obs), dt)
    @test r ≈ 71.1

    r = get_space_index(Val(:F10adj), dt)
    @test r ≈ 71.1
end

@testset "Fluxtable [ERRORS]" begin
    # The data starts on 2004-10-28.
    dt = DateTime(2003, 12, 31)
    @test_throws ArgumentError get_space_index(Val(:F10obs), dt)
    @test_throws ArgumentError get_space_index(Val(:F10adj), dt)
end

@testset "Solfsmy" begin
    init_space_index(SpaceIndices.Solfsmy)

    dt = DateTime(2020, 6, 19)

    r = get_space_index(Val(:S10), dt)
    @test r ≈ 57.7

    r = get_space_index(Val(:S81a), dt)
    @test r ≈ 58.4

    r = get_space_index(Val(:M10), dt)
    @test r ≈ 72.4

    r = get_space_index(Val(:M81a), dt)
    @test r ≈ 73.6

    r = get_space_index(Val(:Y10), dt)
    @test r ≈ 58.2

    r = get_space_index(Val(:Y81a), dt)
    @test r ≈ 62.7
end

@testset "Solfsmy [ERRORS]" begin
    # The data starts on 1997-01-01.
    dt = DateTime(1996, 12, 31)

    @test_throws ArgumentError get_space_index(Val(:S10),  dt)
    @test_throws ArgumentError get_space_index(Val(:S81a), dt)
    @test_throws ArgumentError get_space_index(Val(:M10),  dt)
    @test_throws ArgumentError get_space_index(Val(:M81a), dt)
    @test_throws ArgumentError get_space_index(Val(:Y10),  dt)
    @test_throws ArgumentError get_space_index(Val(:Y81a), dt)
end
