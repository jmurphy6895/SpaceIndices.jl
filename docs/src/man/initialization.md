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
function init_space_indices(; kwargs...) -> Nothing
```

If a file exists, the function checks if its expiry period has passes. If so, it downloads
the file again.

```julia-repl
julia> init_space_indices()
```

If the user does not want to download a set of space indices, they can pass them in the
keyword `blocklist` to the function `init_space_indices`.

```julia-repl
julia> init_space_indices(; blocklist = [SpaceIndices.Fluxtable])
```

If the user wants to download only one space index file, they can use the function:

```julia
function init_space_index(::Type{T}; force_download::Bool = true) where T<:SpaceIndexFile -> Nothing
```

where `T` must be the desired space index file structure name. In this case, the user can
pass the keyword `force_download`. If it is `true`, the related files will be download
regardless their timestamp.

```jldoctest
julia> init_space_indices()
[ Info: Downloading the file 'DTCFILE.TXT' from 'http://sol.spacenvironment.net/jb2008/indices/DTCFILE.TXT'...
[ Info: Downloading the file 'fluxtable.txt' from 'ftp://ftp.seismo.nrcan.gc.ca/spaceweather/solar_flux/daily_flux_values/ fluxtable.txt'...
[ Info: Downloading the file 'SOLFSMY.TXT' from 'http://sol.spacenvironment.net/jb2008/indices/SOLFSMY.TXT'...
```
