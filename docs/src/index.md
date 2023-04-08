SpaceIndices.jl
===============

This package allows to automatically fetch and parse space indices.

The files supported in this version are:

| File            | Expiry period      | Information                                                                 |
|:----------------|:-------------------|:----------------------------------------------------------------------------|
| `fluxtable.txt` | 1 day              | It contains the F10.7 flux data (observed and adjusted).                    |
| `SOLFSMY.txt`   | 1 day              | This files contains the indices necessary for the JB2008 atmospheric model. |

## Installation

This package can be installed using:

``` julia
julia> using Pkg
julia> Pkg.add("SpaceIndices")
```
