## Description #############################################################################
#
# Tests related to capability to interact with auto-diff packages.
#
############################################################################################
using SpaceIndices
using DifferentiationInterface
using Enzyme
using FiniteDiff
using Test

_INDICES = [
    :F10obs
    :F10obs_avg_center81
    :F10obs_avg_last81
    :F10adj
    :F10adj_avg_center81
    :F10adj_avg_last81
    :Ap
    :Ap_daily
    :Kp
    :Kp_daily
    :Cp
    :C9
    :ISN
    :BSRN
    :ND
    :DTC
    :S10
    :M10
    :Y10
    :S81a
    :M81a
    :Y81a
]

_BACKENDS = (
    #("ForwardDiff", AutoForwardDiff()),
    #("Diffractor", AutoDiffractor()),
    ("Enzyme", AutoEnzyme()),
    #("Mooncake", AutoMooncake(;config=nothing)),
    #("PolyesterForwardDiff", AutoPolyesterForwardDiff())
    #("ReverseDiff", AutoReverseDiff()),
    #("Tracker", AutoTracker()),
    #("Zygote", AutoZygote()),
)

using StaticArraysCore
# Create a straic vector 

x = SVector{3}
x = SArray{Tuple{3}, Float64, 1, 3}(1.0, 2.0, 4.0)
space_index(Val(:Ap), jd)

#@testset "Space Index Differentiability" begin
    SpaceIndices.init()
    dt = DateTime(2020, 6, 19, 9, 30, 0)
    jd = datetime2julian(dt)
    djd = 0.0

    #backend = _BACKENDS[5]
    for backend in _BACKENDS
        testset_name = "Space Indices " * string(backend[1])
        @testset "$testset_name"  begin
            for index in _INDICES
                println(index)
                f_fd, df_fd = value_and_derivative(
                    (x) -> space_index(Val(index), x),
                    AutoFiniteDiff(),
                    jd
                )

                f_ad, df_ad = value_and_derivative(
                    (x) -> space_index(Val(index), x),
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

    SpaceIndices.destroy()

end