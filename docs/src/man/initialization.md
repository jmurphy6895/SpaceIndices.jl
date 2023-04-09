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
function init_space_index_sets(; kwargs...) -> Nothing
```

If a file exists, the function checks if its expiry period has passed. If so, it downloads
the file again.

```julia-repl
julia> init_space_index_sets()
```

If the user does not want to download a set of space indices, they can pass them in the
keyword `blocklist` to the function `init_space_indices`.

```julia-repl
julia> init_space_index_sets(; blocklist = [SpaceIndices.Fluxtable])
```

If the user wants to initialize only one space index set, they can use the function:

```julia
function init_space_index_set(::Type{T}; force_download::Bool = true) where T<:SpaceIndexSet -> Nothing
```

where `T` must be the desired space index set. In this case, the user can pass the keyword
`force_download`. If it is `true`, the remote files will be download regardless their
timestamp.

```jldoctest
julia> init_space_index_sets()
[ Info: Downloading the file 'DTCFILE.TXT' from 'http://sol.spacenvironment.net/jb2008/indices/DTCFILE.TXT'...
[ Info: Downloading the file 'fluxtable.txt' from 'ftp://ftp.seismo.nrcan.gc.ca/spaceweather/solar_flux/daily_flux_values/fluxtable.txt'...
[ Info: Downloading the file 'SOLFSMY.TXT' from 'http://sol.spacenvironment.net/jb2008/indices/SOLFSMY.TXT'...
```
