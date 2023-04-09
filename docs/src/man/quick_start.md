Quick Start
===========

```@meta
CurrentModule = SpaceIndices
DocTestSetup = quote
    using SpaceIndices
end
```

This quick tutorial will show how to use **SpaceIndicies.jl** to obtain the F10.7 index at
2020-06-19.

First, we need to initialize all the space indices:

```julia
julia> init_space_index_sets()
[ Info: Downloading the file 'DTCFILE.TXT' from 'http://sol.spacenvironment.net/jb2008/indices/DTCFILE.TXT'...
[ Info: Downloading the file 'fluxtable.txt' from 'ftp://ftp.seismo.nrcan.gc.ca/spaceweather/solar_flux/daily_flux_values/ fluxtable.txt'...
[ Info: Downloading the file 'SOLFSMY.TXT' from 'http://sol.spacenvironment.net/jb2008/indices/SOLFSMY.TXT'...
```

Afterward, we can obtain the desired space index using:

```julia
julia> space_index(Val(:F10adj), DateTime(2020, 6, 19))
71.1
```
