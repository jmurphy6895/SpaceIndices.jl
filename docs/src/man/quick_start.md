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
julia> init_space_indices()
[ Info: Downloading the file 'fluxtable.txt' from 'ftp://ftp.seismo.nrcan.gc.ca/spaceweather/solar_flux/daily_flux_values/fluxtable.txt'...
```

Afterward, we can obtain the desired space index using:

```julia
julia> get_space_index(Val(:F10adj), DateTime(2020, 6, 19))
71.1
```
