using Test

using Dates
using DelimitedFiles
using Logging
using Scratch
using SpaceIndices

using ForwardDiff, Zygote, ReverseDiff

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
    include("./autodiff.jl")
end 