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
    ("FastDifferentiation", AutoFastDifferentiation()),
    ("FiniteDifferences", AutoFiniteDifferences(; fdm=FiniteDifferences.central_fdm(5, 1))),
    ("Mooncake", AutoMooncake(;config=nothing)),
    ("PolyesterForwardDiff", AutoPolyesterForwardDiff()),
    ("ReverseDiff", AutoReverseDiff()),
    ("Symbolics", AutoSymbolics()),
    ("Tracker", AutoTracker()),
    ("Zygote", AutoZygote()),
)

@testset "Space Index Differentiability" begin

    SpaceIndices.init()
    dt = DateTime(2020, 6, 19, 9, 30, 0)
    jd = datetime2julian(dt)

    indices = [:Kp, :Kp_daily, :F10obs, :DTC]

    for index in indices
        f_fd, df_fd = value_and_derivative(
            (x) -> space_index(Val(index), x),
            AutoFiniteDiff(),
            jd
        )

        for backend in _BACKENDS
            @eval @testset $("Space Index $index " * string(backend[1])) begin
                f_ad, df_ad = value_and_derivative(
                    (x) -> space_index(Val($index), x),
                    $backend[2],
                    $jd
                )

                @test $f_fd == f_ad
                @test $df_fd ≈ df_ad rtol=1e-4
            end
        end
    end

    SpaceIndices.destroy()

end

