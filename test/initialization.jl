# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==========================================================================================
#
#   Tests related with the initialization of space indices.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #


@testset "Functions init_space_indices and init_space_index" begin
    # Initialize all space indices.
    init_space_indices()

    # Test if the structures were initialized.
    @test SpaceIndices._OPDATA_FLUXTABLE.data isa SpaceIndices.Fluxtable

    # Destroy everything to test the individual initialization.
    destroy_space_indices()

    init_space_index(SpaceIndices.Fluxtable)

    # Test if the structures were initialized.
    @test SpaceIndices._OPDATA_FLUXTABLE.data isa SpaceIndices.Fluxtable

    # Blocklist
    # ======================================================================================

    destroy_space_indices()

    init_space_indices(; blocklist = [SpaceIndices.Fluxtable])
    @test SpaceIndices._OPDATA_FLUXTABLE.data isa Nothing
end

@testset "Errors Related To Unitialized Space Indices" begin
    destroy_space_indices()
    dt = DateTime(1900, 1, 1)
    @test_throws Exception get_space_index(Val(:F10obj), dt)
    @test_throws Exception get_space_index(Val(:F10adj), dt)
end
