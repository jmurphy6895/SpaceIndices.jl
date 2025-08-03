## Description #############################################################################
#
# Tests for differentiation across the coordinate sets.
#
# Currently Supported & Tested:
#
#   Enzyme, ForwardDiff, FiniteDiff, Mooncake, PolyesterForwardDiff, Zygote
#
############################################################################################

@testset "Space Index Differentiability" begin
    SpaceIndices.init()
    dt = DateTime(2020, 6, 19, 9, 30, 0)
    jd = datetime2julian(dt)

    for backend in _BACKENDS
        testset_name = "Space Indices " * string(backend[1])
        @testset "$testset_name"  begin
            for index in _INDICES
                f_fd, df_fd = value_and_derivative(
                    (x) -> reduce(vcat, space_index(Val(index), x)),
                    AutoFiniteDiff(),
                    jd
                )

                f_ad, df_ad = value_and_derivative(
                    (x) -> reduce(vcat, space_index(Val(index), x)),
                    backend[2],
                    jd
                )

                @test f_fd == f_ad
                if index != :DTC
                    @test df_fd ≈ df_ad rtol=1e-4
                else
                    @test df_ad ≈ 624.0 rtol=1e-8
                end
            end
        end
    end

    # Zygote is separated as the tangent of a constant function is defined by "nothing"
    # instead of 0.0. This behavior is expected it should not affect downstream derivative
    # computations as in SatelliteToolboxAtmospheric.jl.
    #
    # See https://github.com/JuliaDiff/DifferentiationInterface.jl/pull/604

    @testset "Space Indcies Zygote"  begin
        for index in _INDICES
            f_fd, df_fd = value_and_derivative(
                (x) -> reduce(vcat, space_index(Val(index), x)),
                AutoFiniteDiff(),
                jd
            )
            try
                f_ad, df_ad = value_and_derivative(
                    (x) -> reduce(vcat, space_index(Val(index), x)),
                    AutoZygote(),
                    jd
                )
                @test f_fd == f_ad
                if index != :DTC
                    @test df_fd ≈ df_ad rtol=1e-4
                else
                    @test df_ad ≈ 624.0 rtol=1e-8
                end
            catch err
                @test err isa MethodError
                @test startswith(
                    sprint(showerror, err),
                    "MethodError: no method matching iterate(::Nothing)",
                )
            end
        end
    end

    SpaceIndices.destroy()

end
