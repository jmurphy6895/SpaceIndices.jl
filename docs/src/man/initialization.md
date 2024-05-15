Initialization of Space Indices
===============================

```@meta
CurrentModule = SpaceIndices
DocTestSetup = quote
    using SpaceIndices
end
```

The files of all the registered space indices can be automatically downloaded using:

```julia
function SpaceIndices.init(; kwargs...) -> Nothing
```

If a file exists, the function checks if its expiry period has passed. If so, it downloads
the file again.

```julia-repl
julia> SpaceIndices.init()
```

If the user does not want to download a set of space indices, they can pass them in the
keyword `blocklist` to the function `SpaceIndices.init`.

```julia-repl
julia> SpaceIndices.init(; blocklist = [SpaceIndices.Celestrak])
```

If the user wants to initialize only one space index set, they can pass it to the same
function:

```julia
function SpaceIndices.init(::Type{T}; kwargs...) where T<:SpaceIndexSet -> Nothing
```

where `T` must be the space index set. In this case, the user have access to the following
keywords:

- `force_download::Bool`: If `true`, the remote files will be downloaded regardless of their
    timestamps.
    (**Default** = `false`)
- `filepaths::Union{Nothing, Vector{String}}`: If it is `nothing`, the function will
    download the space index files from the locations specified in the [`urls`](@ref)
    API function. However, the user can pass a vector with the file locations, which will be
    used instead of downloading the data. In this case, the user must provide all the files
    in the space index set `T`.
    (**Default** = `nothing`)

```julia-repl
julia> SpaceIndices.init()
[ Info: Downloading the file 'DTCFILE.TXT' from 'http://sol.spacenvironment.net/jb2008/indices/DTCFILE.TXT'...
[ Info: Downloading the file 'SOLFSMY.TXT' from 'http://sol.spacenvironment.net/jb2008/indices/SOLFSMY.TXT'...
[ Info: Downloading the file 'SW-All.csv' from 'https://celestrak.org/SpaceData/SW-All.csv'...
```

```julia-repl
julia> SpaceIndices.init(SpaceIndices.Celestrak; filepaths = ["./SW-All.csv"])
```
