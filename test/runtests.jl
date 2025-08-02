using Test

using Dates
using DelimitedFiles
using Logging
using Scratch
using SpaceIndices

using DifferentiationInterface
using FiniteDiff, ForwardDiff, PolyesterForwardDiff, Zygote

if isempty(VERSION.prerelease)
    # Add Mooncake and Enzyme to the project if not the nightly version
    # Adding them via the Project.toml isn't working because it tries to compile them before reaching the gating
    using Pkg
    Pkg.add("Mooncake")
    Pkg.add("Enzyme")
    Pkg.add("JET")
    Pkg.add("AllocCheck")

    # Test with Mooncake and Enzyme along with the other backends
    using Mooncake, Enzyme
    const _BACKENDS = (
        ("ForwardDiff", AutoForwardDiff()),
        ("Enzyme", AutoEnzyme()),
        ("Mooncake", AutoMooncake(;config=nothing)),
        ("PolyesterForwardDiff", AutoPolyesterForwardDiff()),
    )

    using JET
    using AllocCheck

    @testset "Performance" verbose = true begin
        include("./performance.jl")
    end
else
    @warn "Mooncake.jl not guaranteed to work on julia-nightly, skipping tests"
    const _BACKENDS = (
        ("ForwardDiff", AutoForwardDiff()),
        ("PolyesterForwardDiff", AutoPolyesterForwardDiff()),
    )

    @warn "JET and AllocCheck not guaranteed to work on julia-nightly, skipping tests"

end

using Aqua

const _INDICES = [
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

@testset "Initilization" verbose = true begin
    include("./initialization.jl")
end

@testset "Obtaining Space Indices" verbose = true begin
    include("./space_indices.jl")
end

@testset "API" verbose = true begin
    include("./api.jl")
end

@testset "Interpolations" verbose = true begin
    include("./interpolations.jl")
end

@testset "Automatic Differentiation" verbose = true begin
    include("./differentiability.jl")
end

@testset "Aqua.jl" begin
    Aqua.test_all(SpaceIndices; ambiguities=(recursive = false), deps_compat=(check_extras = false))
end