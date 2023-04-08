using Test

using Dates
using DelimitedFiles
using Logging
using Scratch
using SpaceIndices

@testset "Initilization" verbose = true begin
    include("./initialization.jl")
end

@testset "Get Space Indices" verbose = true begin
    include("./get_space_indices.jl")
end

@testset "API" verbose = true begin
    include("./api.jl")
end
