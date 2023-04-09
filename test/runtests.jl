using Test

using Dates
using DelimitedFiles
using Logging
using Scratch
using SpaceIndices

@testset "Initilization" verbose = true begin
    include("./initialization.jl")
end

@testset "Obtaining Space Indices" verbose = true begin
    include("./space_indices.jl")
end

@testset "API" verbose = true begin
    include("./api.jl")
end
