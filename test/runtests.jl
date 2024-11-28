using Test

using Dates
using DelimitedFiles
using Logging
using Scratch
using SpaceIndices

using DifferentiationInterface
using FiniteDiff, ForwardDiff, Diffractor, Enzyme, Mooncake, PolyesterForwardDiff, Zygote

using JET, AllocCheck

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

@testset "Performance" verbose = true begin
    include("./allocations.jl")
end

@testset "Automatic Differentiation" verbose = true begin
    include("./differentiability.jl")
end