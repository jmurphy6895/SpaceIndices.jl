SpaceIndices.jl
===============

[![CI](https://github.com/JuliaSpace/SpaceIndices.jl/actions/workflows/ci.yml/badge.svg)](https://github.com/JuliaSpace/SpaceIndices.jl/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/JuliaSpace/SpaceIndices.jl/branch/main/graph/badge.svg?token=6RTJKQHNPF)](https://codecov.io/gh/JuliaSpace/SpaceIndices.jl)
[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)

This package allows to automatically fetch and parse space indices.

## Initialization

First, we need to initialize the space indices using the function:

```julia
function init_space_indices()
```

It will download all the supported files, if necessary.

The supported files are:

|      File       | Download frequency | Information                                                  |
|-----------------|--------------------|--------------------------------------------------------------|
| `fluxtable.txt` | Daily              | This file contains the F10.7 flux data in different formats. |

## Getting the Space Indices

After the initialization of the files, the space indices can be obtained by the
following function:

```julia
function get_space_index(index, date::DateTime)
function get_space_index(index, jd::Number)
```

in which `date` is a `DateTime` object with the instant in which the index will be computed,
and `index` is the desired space index as described in the following table. The instant can
also be passed as a Julian day `jd`.

| `index`        | Space index                                                                                                                  |
|----------------|------------------------------------------------------------------------------------------------------------------------------|
| `Val(:F10adj)` | 10.7-cm adjusted solar flux                                                                                                  |
| `Val(:F10obs)` | 10.7-cm observed solar flux                                                                                                  |

```julia-repl
julia> init_space_indices()
[ Info: Downloading the file 'fluxtable.txt' from 'ftp://ftp.seismo.nrcan.gc.ca/spaceweather/solar_flux/daily_flux_values/fluxtable.txt'...

julia> get_space_index(Val(:F10adj), DateTime(2020, 6, 19))
71.1

julia> get_space_index(Val(:F10adj), 2.4590195e6)
71.1
```
