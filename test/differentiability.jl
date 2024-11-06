## Description #############################################################################
#
# Tests related to capability to interact with auto-diff packages.
#
############################################################################################
const _BACKENDS = (
    ("ForwardDiff", AutoForwardDiff()),
    ("Diffractor", AutoDiffractor()),
    ("Enzyme -- Forward", AutoEnzyme(;mode=Enzyme.EnzymeCore.Forward)),
    ("Enzyme -- Reverse", AutoEnzyme(;mode=Enzyme.EnzymeCore.Reverse)),
    ("Mooncake", AutoMooncake(;config=nothing)),
    ("PolyesterForwardDiff", AutoPolyesterForwardDiff()),
    ("ReverseDiff", AutoReverseDiff()),
    ("Tracker", AutoTracker()),
    ("Zygote", AutoZygote()),
)

@testset "Space Index Differentiability" begin
    SpaceIndices.init()
    dt = DateTime(2020, 6, 19, 9, 30, 0)
    jd = datetime2julian(dt)

    #backend = _BACKENDS[5]
    for backend in _BACKENDS
        testset_name = "Space Indices " * string(backend[1])
        @testset "$testset_name"  begin
            for index in _INDICES
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