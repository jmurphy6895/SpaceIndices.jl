module SpaceIndices

using Reexport
using Scratch
using DelimitedFiles

@reexport using Dates
@reexport using OptionalData

############################################################################################
#                                          Types
############################################################################################

include("./types.jl")

############################################################################################
#                                        Constants
############################################################################################

# Global vector to store the registered space files.
const _SPACE_INDEX_SETS = NTuple{2, Any}[]

#Julian Day of J2000.0 epoch (2000-01-01T12:00:00.000).
#Put here to keep from importing the whole SatelliteToolboxBase Pkg
export JD_J2000_SI
const JD_J2000_SI = 2451545.0

############################################################################################
#                                         Includes
############################################################################################

include("./api.jl")
include("./destroy.jl")
include("./download.jl")
include("./initialize.jl")
include("./interpolations.jl")

include("./space_index_sets/jb2008.jl")
include("./space_index_sets/celestrak.jl")

end # module SpaceIndices
