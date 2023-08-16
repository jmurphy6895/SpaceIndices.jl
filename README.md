SpaceIndices.jl
===============

[![CI](https://github.com/JuliaSpace/SpaceIndices.jl/actions/workflows/ci.yml/badge.svg)](https://github.com/JuliaSpace/SpaceIndices.jl/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/JuliaSpace/SpaceIndices.jl/branch/main/graph/badge.svg?token=6RTJKQHNPF)](https://codecov.io/gh/JuliaSpace/SpaceIndices.jl)
[![](https://img.shields.io/badge/docs-stable-blue.svg)][docs-stable-url]
[![](https://img.shields.io/badge/docs-dev-blue.svg)][docs-dev-url]
[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)

This package allows to automatically fetch and parse space indices.

The space index sets supported in this version are:

| **Space Index Set** | **File**      | **Expiry period** | **Information**                                                |
|:--------------------|:--------------|:------------------|:---------------------------------------------------------------|
| `Celestrak`         | `SW-All.csv`  | 1 day             | F10.7, AP, KP, ISN, C9, Cp, ND, BSRN (historic and predicted). |
| `JB2008`            | `DTCFILE.TXT` | 1 day             | Exospheric temperature variation caused by the Dst index.      |
|                     | `SOLFSMY.TXT` | 1 day             | Indices necessary for the JB2008 atmospheric model.            |

Those sets provide the following indices:

| **Space Index Set** | **Index**             | **Description**                                                | **Unit**            |
|:--------------------|:----------------------|:---------------------------------------------------------------|:--------------------|
| `SW-All.csv`        | `F10obs`              | Observed F10.7 (10.7-cm solar flux).                           | 10⁻²² W / (M² ⋅ Hz) |
|                     | `F10osb_avg_center81` | Observed F10.7 averaged over 81 days centered for the instant. | 10⁻²² W / (M² ⋅ Hz) |
|                     | `F10osb_avg_last81`   | Observed F10.7 averaged over the last 81 days.                 | 10⁻²² W / (M² ⋅ Hz) |
|                     | `F10adj`              | Adjusted F10.7 (10.7-cm solar flux).                           | 10⁻²² W / (M² ⋅ Hz) |
|                     | `F10adj_avg_center81` | Adjusted F10.7 averaged over 81 days centered for the instant. | 10⁻²² W / (M² ⋅ Hz) |
|                     | `F10adj_avg_last81`   | Adjusted F10.7 averaged over the last 81 days.                 | 10⁻²² W / (M² ⋅ Hz) |
|                     | `Ap`                  | Ap index computed every three hours.                           |                     |
|                     | `Ap_daily`            | Daily Ap index.                                                |                     |
|                     | `Kp`                  | Kp index computed every three hours.                           |                     |
|                     | `Kp_daily`            | Daily Kp index.                                                |                     |
|                     | `BSRN`                | BSRN index.                                                    |                     |
|                     | `ND`                  | ND index.                                                      |                     |
|                     | `Cp`                  | Cp index.                                                      |                     |
|                     | `C9`                  | C9 index.                                                      |                     |
|                     | `ISN`                 | ISN index.                                                     |                     |
| `JB2008`            | `DTC`                 | Exospheric temperature variation caused by the Dst index.      | K                   |
|                     | `S10`                 | EUV index (26-34 nm) scaled to F10.7                           | 10⁻²² W / (M² ⋅ Hz) |
|                     | `M10`                 | MG2 index scaled to F10.7.                                     | 10⁻²² W / (M² ⋅ Hz) |
|                     | `Y10`                 | Solar X-ray & Lya index scaled to F10.7                        | 10⁻²² W / (M² ⋅ Hz) |
|                     | `S81a`                | 81-day averaged EUV index (26-34 nm) scaled to F10.7           | 10⁻²² W / (M² ⋅ Hz) |
|                     | `M81a`                | 81-day averaged MG2 index scaled to F10.7.                     | 10⁻²² W / (M² ⋅ Hz) |
|                     | `Y81a`                | 81-day averaged solar X-ray & Lya index scaled to F10.7        | 10⁻²² W / (M² ⋅ Hz) |

## Installation

This package can be installed using:

``` julia
julia> using Pkg
julia> Pkg.add("SpaceIndices")
```

## Documentation

For more information, see the [documentation][docs-stable-url].

[docs-dev-url]: https://juliaspace.github.io/SpaceIndices.jl/dev
[docs-stable-url]: https://juliaspace.github.io/SpaceIndices.jl/stable
