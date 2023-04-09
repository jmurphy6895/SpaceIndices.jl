SpaceIndices.jl
===============

This package allows to automatically fetch and parse space indices.

The space index sets supported in this version are:

| Space Index Set | File            | Expiry period      | Information                                                 |
|:----------------|:----------------|:-------------------|:------------------------------------------------------------|
| `Fluxtable`     | `fluxtable.txt` | 1 day              | F10.7 flux data (observed and adjusted).                    |
| `JB2008`        | `DTCFILE.TXT`   | 1 day              | Exospheric temperature variation caused by the Dst index.   |
|                 | `SOLFSMY.TXT`   | 1 day              | Indices necessary for the JB2008 atmospheric model.         |

## Installation

This package can be installed using:

``` julia
julia> using Pkg
julia> Pkg.add("SpaceIndices")
```
