Obtaining the Space Indices
===========================

```@meta
CurrentModule = SpaceIndices
DocTestSetup = quote
    using Dates
    using SpaceIndices
end
```

After the initialization shown in [Initialization of Space Indices](@ref), the user can
obtain the space index value using the function:

```julia
function get_space_index(::Val{:index}, jd::Number; kwargs...) -> Number
function get_space_index(::Val{:index}, instant::DateTime; kwargs...) -> Number
```

where `index` is the desired space index and `jd` is the Julian Day to obtain the
information. The latter can also be specified using `instant`, which is a `DateTime` object.

```jldoctest
julia> init_space_indices()

julia> get_space_index(Val(:F10adj), DateTime(2020, 6, 19))
71.1

julia> get_space_index(Val(:F10adj), 2.4590195e6)
71.1
```

The following space indices are currently supported:

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
