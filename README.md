SpaceIndices.jl
===============

[![CI](https://github.com/JuliaSpace/SpaceIndices.jl/actions/workflows/ci.yml/badge.svg)](https://github.com/JuliaSpace/SpaceIndices.jl/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/JuliaSpace/SpaceIndices.jl/branch/main/graph/badge.svg?token=6RTJKQHNPF)](https://codecov.io/gh/JuliaSpace/SpaceIndices.jl)
[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)

This package allows to automatically fetch and parse space indices.

The files supported in this version are:

| File            | Expiry period      | Information                                                 |
|:----------------|:-------------------|:------------------------------------------------------------|
| `DTCFILE.txt`   | 1 day              | Exospheric temperature variation caused by the Dst index.   |
| `fluxtable.txt` | 1 day              | F10.7 flux data (observed and adjusted).                    |
| `SOLFSMY.txt`   | 1 day              | Indices necessary for the JB2008 atmospheric model.         |

Those files provide the following indices:

| Space file      | Index    | Description                                               | Unit               |
|-----------------|----------|-----------------------------------------------------------|--------------------|
| `DTCFILE.txt`   | `DTC`    | Exospheric temperature variation caused by the Dst index. | K                  |
| `fluxtable.txt` | `F10obs` | Observed F10.7 (10.7-cm solar flux)                       | 10⁻²² W / (M² ⋅ Hz) |
|                 | `F10adj` | Adjusted F10.7 (10.7-cm solar flux)                       | 10⁻²² W / (M² ⋅ Hz) |
| `SOLFSMY.txt`   | `S10`    | EUV index (26-34 nm) scaled to F10.7                      | 10⁻²² W / (M² ⋅ Hz) |
|                 | `M10`    | MG2 index scaled to F10.7.                                | 10⁻²² W / (M² ⋅ Hz) |
|                 | `Y10`    | Solar X-ray & Lya index scaled to F10.7                   | 10⁻²² W / (M² ⋅ Hz) |
|                 | `S81a`   | 81-day averaged EUV index (26-34 nm) scaled to F10.7      | 10⁻²² W / (M² ⋅ Hz) |
|                 | `M81a`   | 81-day averaged MG2 index scaled to F10.7.                | 10⁻²² W / (M² ⋅ Hz) |
|                 | `Y81a`   | 81-day averaged solar X-ray & Lya index scaled to F10.7   | 10⁻²² W / (M² ⋅ Hz) |

## Installation

This package can be installed using:

``` julia
julia> using Pkg
julia> Pkg.add("SpaceIndices")
```
