# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==========================================================================================
#
#   Tests related to the interpolations.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

############################################################################################
#                                  Constant Interpolation
############################################################################################

@testset "Constant Interpolation" begin
    knots  = collect(0.0:1.0:100.0)
    values = collect(0.0:2.0:200.0)

    for k in 0:0.01:100
        @test SpaceIndices.constant_interpolation(knots, values, k) == floor(k) * 2
    end

    @test_throws ArgumentError SpaceIndices.constant_interpolation(knots, values, -1000.0)
    @test_throws ArgumentError SpaceIndices.constant_interpolation(knots, values, +1000.0)
end

@testset "Constant Interpolation [ERRORS]" begin
    knots  = collect(0.0:1.0:100.0)
    values = collect(0.0:2.0:200.0)
    @test_throws ArgumentError SpaceIndices.constant_interpolation(knots, values, -1000.0)
    @test_throws ArgumentError SpaceIndices.constant_interpolation(knots, values, +1000.0)
end

############################################################################################
#                                   Linear Interpolation
############################################################################################

@testset "Linear interpolation" begin
    knots  = collect(0.0:1.0:100.0)
    values = collect(0.0:2.0:200.0)

    for k in 0:0.01:100
        @test SpaceIndices.linear_interpolation(knots, values, k) == 2k
    end

    @test_throws ArgumentError SpaceIndices.linear_interpolation(knots, values, -1000.0)
    @test_throws ArgumentError SpaceIndices.linear_interpolation(knots, values, +1000.0)
end

@testset "Linear interpolation [ERRORS]" begin
    knots  = collect(0.0:1.0:100.0)
    values = collect(0.0:2.0:200.0)
    @test_throws ArgumentError SpaceIndices.linear_interpolation(knots, values, -1000.0)
    @test_throws ArgumentError SpaceIndices.linear_interpolation(knots, values, +1000.0)
end
