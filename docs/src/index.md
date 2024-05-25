# SpaceIndices.jl

This package allows to automatically fetch and parse space indices.

The space index sets supported in this version are:

| **Space Index Set** | **File**      | **Expiry period** | **Information**                                                |
|:--------------------|:--------------|:------------------|:---------------------------------------------------------------|
| `Celestrak`         | `SW-All.csv`  | 1 day             | F10.7, AP, KP, ISN, C9, Cp, ND, BSRN (historic and predicted). |
| `JB2008`            | `DTCFILE.TXT` | 1 day             | Exospheric temperature variation caused by the Dst index.      |
|                     | `SOLFSMY.TXT` | 1 day             | Indices necessary for the JB2008 atmospheric model.            |

## Installation

This package can be installed using:

```julia-repl
julia> using Pkg
julia> Pkg.add("SpaceIndices")
```
