using Test

using Dates
using Logging
using SpaceIndices

@testset "Initilization" verbose = true begin
    include("./initialization.jl")
end

@testset "Get Space Indices" verbose = true begin
    include("./get_space_indices.jl")
end
