## Description #############################################################################
#
# Tests related to capability to interact with auto-diff packages.
#
############################################################################################

@testset "Forward Mode AD" begin

    SpaceIndices.init()
    dt = DateTime(2020, 6, 19, 9, 30, 0)
    jd = datetime2julian(dt)

    ∂SI = ForwardDiff.derivative((x) -> space_index(Val(:Kp), x), jd)
    for i ∈ 1:8
        @test ∂SI[i] ≈ 0.0
    end

    ∂SI = ForwardDiff.derivative((x) -> space_index(Val(:F10obs), x), jd)
    @test ∂SI ≈ 0.0

    ∂SI = ForwardDiff.derivative((x) -> space_index(Val(:DTC), x), jd)
    @test ∂SI ≈ 624.0

    SpaceIndices.destroy()

end

@testset "Reverse Mode AD (Zygote)" begin

    SpaceIndices.init()
    dt = DateTime(2020, 6, 19, 9, 30, 0)
    jd = datetime2julian(dt)

    space_index(Val(:Kp), jd)

    ∂SI = Zygote.jacobian((x) -> space_index(Val(:Kp), x), jd)
    for i ∈ 1:8
        @test ∂SI[1][i] ≈ 0.0
    end

    ∂SI = Zygote.gradient((x) -> space_index(Val(:Kp_daily), x), jd)
    @test ∂SI[1] === nothing

    ∂SI = Zygote.gradient((x) -> space_index(Val(:F10obs), x), jd)
    @test ∂SI[1] === nothing

    ∂SI = Zygote.gradient((x) -> space_index(Val(:DTC), x), jd)
    @test ∂SI[1] ≈ 624.0

    SpaceIndices.destroy()

end


@testset "Reverse Mode AD (ReverseDiff)" begin

    SpaceIndices.init()
    dt = DateTime(2020, 6, 19, 9, 30, 0)
    jd = datetime2julian(dt)

    ∂SI = ReverseDiff.jacobian((x) -> space_index(Val(:Kp), x[1]), [jd])
    for i ∈ 1:8
        @test ∂SI[i][1] ≈ 0.0
    end

    ∂SI = ReverseDiff.gradient((x) -> space_index(Val(:Kp_daily), x[1]), [jd])
    @test ∂SI[1] ≈ 0.0

    ∂SI = ReverseDiff.gradient((x) -> space_index(Val(:F10obs), x[1]), [jd])
    @test ∂SI[1] ≈ 0.0

    ∂SI = ReverseDiff.gradient((x) -> space_index(Val(:DTC), x[1]), [jd])
    @test ∂SI[1] ≈ 624.0

    SpaceIndices.destroy()

end
