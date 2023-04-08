module SpaceIndices

using Dates
using Interpolations
using Reexport
using Scratch

@reexport using OptionalData

############################################################################################
#                                          Types
############################################################################################

include("./types.jl")

############################################################################################
#                                        Constants
############################################################################################

# Global vector to store the registered space files.
const _SPACE_FILES = NTuple{2, Any}[]

############################################################################################
#                                         Includes
############################################################################################

include("./helpers.jl")

include("./api.jl")
include("./destroy.jl")
include("./download.jl")
include("./initialize.jl")

include("./space_indices/dtcfile.jl")
include("./space_indices/fluxtable.jl")
include("./space_indices/solfsmy.jl")

end # module SpaceIndices
