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
    SpaceIndices.init()

    # Test if the structures were initialized.
    @test SpaceIndices._OPDATA_JB2008.data    isa SpaceIndices.JB2008
    @test SpaceIndices._OPDATA_CELESTRAK.data isa SpaceIndices.Celestrak

    # Destroy everything to test the individual initialization.
    SpaceIndices.destroy()

    SpaceIndices.init(SpaceIndices.JB2008)
    @test SpaceIndices._OPDATA_JB2008.data    isa SpaceIndices.JB2008
    @test SpaceIndices._OPDATA_CELESTRAK.data isa Nothing
    SpaceIndices.destroy()

    SpaceIndices.init(SpaceIndices.Celestrak)
    @test SpaceIndices._OPDATA_JB2008.data    isa Nothing
    @test SpaceIndices._OPDATA_CELESTRAK.data isa SpaceIndices.Celestrak
    SpaceIndices.destroy()

    # Blocklist
    # ======================================================================================

    SpaceIndices.init(; blocklist = [SpaceIndices.Celestrak])
    @test SpaceIndices._OPDATA_JB2008.data    isa SpaceIndices.JB2008
    @test SpaceIndices._OPDATA_CELESTRAK.data isa Nothing
    SpaceIndices.destroy()

    # All History
    # ======================================================================================

    SpaceIndices.init(; all_history=true)
    @test SpaceIndices._OPDATA_JB2008.data    isa SpaceIndices.JB2008
    @test SpaceIndices._OPDATA_CELESTRAK.data isa SpaceIndices.Celestrak
    SpaceIndices.destroy()

end

@testset "Errors Related To Unitialized Space Indices" begin
    SpaceIndices.destroy()
    dt = DateTime(1900, 1, 1)

    @test_throws Exception space_index(Val(:BSRN),                  dt)
    @test_throws Exception space_index(Val(:ND),                    dt)
    @test_throws Exception space_index(Val(:C9),                    dt)
    @test_throws Exception space_index(Val(:Cp),                    dt)
    @test_throws Exception space_index(Val(:ISN),                   dt)
    @test_throws Exception space_index(Val(:ND),                    dt)
    @test_throws Exception space_index(Val(:Kp),                    dt)
    @test_throws Exception space_index(Val(:Kp_daily),              dt)
    @test_throws Exception space_index(Val(:Ap),                    dt)
    @test_throws Exception space_index(Val(:Ap_daily),              dt)
    @test_throws Exception space_index(Val(:F10obj),                dt)
    @test_throws Exception space_index(Val(:F10obj_avg_center81),   dt)
    @test_throws Exception space_index(Val(:F10obj_avg_last81),     dt)
    @test_throws Exception space_index(Val(:F10adj),                dt)
    @test_throws Exception space_index(Val(:F10adj_avg_center81),   dt)
    @test_throws Exception space_index(Val(:F10adj_avg_last81),     dt)

    @test_throws Exception space_index(Val(:S10),  dt)
    @test_throws Exception space_index(Val(:S81a), dt)
    @test_throws Exception space_index(Val(:M10),  dt)
    @test_throws Exception space_index(Val(:M81a), dt)
    @test_throws Exception space_index(Val(:Y10),  dt)
    @test_throws Exception space_index(Val(:Y81a), dt)
end
