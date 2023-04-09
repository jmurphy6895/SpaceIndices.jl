# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==========================================================================================
#
#   Tests related with the initialization of space indices.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #


@testset "Functions init_space_index_sets and init_space_index_set" begin
    # Initialize all space indices.
    init_space_index_sets()

    # Test if the structures were initialized.
    @test SpaceIndices._OPDATA_DTCFILE.data   isa SpaceIndices.Dtcfile
    @test SpaceIndices._OPDATA_FLUXTABLE.data isa SpaceIndices.Fluxtable
    @test SpaceIndices._OPDATA_SOLFSMY.data   isa SpaceIndices.Solfsmy

    # Destroy everything to test the individual initialization.
    destroy_space_index_sets()

    init_space_index_set(SpaceIndices.Dtcfile)
    @test SpaceIndices._OPDATA_DTCFILE.data isa SpaceIndices.Dtcfile
    @test SpaceIndices._OPDATA_FLUXTABLE.data isa Nothing
    @test SpaceIndices._OPDATA_SOLFSMY.data isa Nothing
    destroy_space_index_sets()

    init_space_index_set(SpaceIndices.Fluxtable)
    @test SpaceIndices._OPDATA_DTCFILE.data   isa Nothing
    @test SpaceIndices._OPDATA_FLUXTABLE.data isa SpaceIndices.Fluxtable
    @test SpaceIndices._OPDATA_SOLFSMY.data   isa Nothing
    destroy_space_index_sets()

    init_space_index_set(SpaceIndices.Solfsmy)
    @test SpaceIndices._OPDATA_DTCFILE.data   isa Nothing
    @test SpaceIndices._OPDATA_FLUXTABLE.data isa Nothing
    @test SpaceIndices._OPDATA_SOLFSMY.data   isa SpaceIndices.Solfsmy
    destroy_space_index_sets()

    # Blocklist
    # ======================================================================================

    init_space_index_sets(; blocklist = [SpaceIndices.Fluxtable])
    @test SpaceIndices._OPDATA_DTCFILE.data isa SpaceIndices.Dtcfile
    @test SpaceIndices._OPDATA_FLUXTABLE.data isa Nothing
    @test SpaceIndices._OPDATA_SOLFSMY.data   isa SpaceIndices.Solfsmy
end

@testset "Errors Related To Unitialized Space Indices" begin
    destroy_space_index_sets()
    dt = DateTime(1900, 1, 1)

    @test_throws Exception get_space_index(Val(:F10obj), dt)
    @test_throws Exception get_space_index(Val(:F10adj), dt)

    @test_throws Exception get_space_index(Val(:S10),  dt)
    @test_throws Exception get_space_index(Val(:S81a), dt)
    @test_throws Exception get_space_index(Val(:M10),  dt)
    @test_throws Exception get_space_index(Val(:M81a), dt)
    @test_throws Exception get_space_index(Val(:Y10),  dt)
    @test_throws Exception get_space_index(Val(:Y81a), dt)
end
