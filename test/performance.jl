## Description #############################################################################
#
# Tests related to performance and memory allocations.
#
############################################################################################
@testset "Aqua.jl" begin
    Aqua.test_all(SpaceIndices; ambiguities=(recursive = false))
end

@testset "JET Testing" begin
    rep = JET.test_package(SpaceIndices; toplevel_logger=nothing, target_modules=(@__MODULE__,))
end

@testset "Allocations Check" begin
    SpaceIndices.init()

    for index in _INDICES
        @test length(check_allocs(space_index, (Val{index}, Float64))) == 0
    end

    SpaceIndices.destroy()
end