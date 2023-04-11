SpaceIndices.jl
===============

This package allows to automatically fetch and parse space indices.

The space index sets supported in this version are:

| **Space Index Set** | **File**                          | **Expiry period**  | **Information**                                             |
|:--------------------|:----------------------------------|:-------------------|:------------------------------------------------------------|
| `Fluxtable`         | `fluxtable.txt`                   | 1 day              | F10.7 flux data (observed and adjusted).                    |
| `JB2008`            | `DTCFILE.TXT`                     | 1 day              | Exospheric temperature variation caused by the Dst index.   |
|                     | `SOLFSMY.TXT`                     | 1 day              | Indices necessary for the JB2008 atmospheric model.         |
| `KpAp`              | `Kp_ap_Ap_SN_F107_since_1932.txt` | 1 day              | Kp and Ap indices.                                          |

## Installation

This package can be installed using:

``` julia
julia> using Pkg
julia> Pkg.add("SpaceIndices")
```
