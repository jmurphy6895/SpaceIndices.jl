# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==========================================================================================
#
#   Tests related with the functions to get the space indices.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

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
