SpaceIndices.jl API
===================

```@meta
CurrentModule = SpaceIndices
DocTestSetup = quote
    using SpaceIndices
end
```

This package defines an API to allow user to defin new space indices. We describe this API
in the following.

## Structure

Each space file must have a structure that has `SpaceIndexFile` as its super-type. This
structure must contain all the required field to process and return the indices related with
the 

```julia
struct MySpaceFile <: SpaceIndexFile
    ...
end
```

## Required API Functions

We must define the following functions for every space file structure creates as in the
previous section.

```julia
get_url(::Type{T}) where T<:SpaceIndexFile -> String
```

This function must return a `String` with the space file URL. For example:

```julia
get_url(::Type{MySpaceFile}) = "https://url.for.my/space.file.txt"
```

```julia
get_filename(::Type{T}) where T<:SpaceIndexFile -> String
```

This function must return a `String` with the filename for the space file. The system will
used this information to save the data in the package scratch space. For example:

```julia
get_filename(::Type{MySpaceFile}) = "my_space_file.txt"
```

```julia
parse_space_file(::Type{T}, filepath::String) where T<:SpaceIndexFile -> T
```

This function must parse the space index file `T` using the file in `filepath` and return an
structure of type `T` with the parsed data. For example,

```julia
function parse_space_file(::Type{MySpaceFile}, filepath::String)
    open(filepath, "r") do f
        ...
        return MySpaceFile(index_1, index_2, index_3)
    end
end
```

Finally, the new space file must also implement a set of functions with the following
signature:

```julia
get_space_index(::Val{:index}, jd::Number; kwargs...) -> Number
```

where the space `index` for the Julian day `jd` will be returned.

## Optional API Function

```julia
get_expiry_period(::Type{T}) where T<:SpaceIndexFile -> DatePeriod
```

This function must return the expiry period for the space index file `T`. The remote file
will always be downloaded again if a time larger than this period has passed after the last
download. If this function is not defined, it returns `Day(7)` by default.

## Example: Leap Seconds

We will use the API to define a new space index that has the GPS leap seconds. The file has a
CSV-like format but the values are separated by `;`. It has two columns. The first contains
the Julian days in which the leap seconds were modified to the values in the second column:

```text
Julian Day;Leap Seconds
2441499.500000;11.0
2441683.500000;12.0
2442048.500000;13.0
2442413.500000;14.0
...
```

First, we need to load the required packages to process the information in the space index
file:

```julia
julia> using DelimitedFiles, Dates
```

Now, we need to create its structure:

```julia
struct LeapSeconds <: SpaceIndexFile
    jd::Vector{Float64}
    leap_seconds::Vector{Float64}
end
```

where `jd` contains the Julian days in which the leap seconds were modified to the values in
`leap_seconds`.

We also need to overload the API functions:

```julia
SpaceIndices.get_url(::Type{LeapSeconds}) = "https://ronanarraes.com/space-indices/leap_seconds.csv"
SpaceIndices.get_filename(::Type{LeapSeconds}) = "leap_seconds.csv"
SpaceIndices.get_expiry_period(::Type{LeapSeconds}) = Day(365)

function SpaceIndices.parse_space_file(::Type{LeapSeconds}, filepath::String)
    raw_data, ~ = readdlm(filepath, ';'; header = true)
    return LeapSeconds(raw_data[:, 1], raw_data[:, 2])
end
```

We also need to populate the `get_space_index` with the supported index in this file:

```julia
function SpaceIndices.get_space_index(::Val{:LeapSeconds}, jd_utc::Number)
    obj = SpaceIndices.@object(LeapSeconds)
    id = findfirst(>=(jd_utc), obj.jd)

    if isnothing(id)
        id = length(obj.jd)
    end

    return obj.leap_seconds[id]
end
```

Finally, we need to register the new space index file:

```julia
SpaceIndices.@register LeapSeconds
```

We can now use the **SpaceIndices.jl** system to fetch the information:

```julia
julia> init_space_indices()
[ Info: Downloading the file 'DTCFILE.TXT' from 'http://sol.spacenvironment.net/jb2008/indices/DTCFILE.TXT'...
[ Info: Downloading the file 'fluxtable.txt' from 'ftp://ftp.seismo.nrcan.gc.ca/spaceweather/solar_flux/daily_flux_values/ fluxtable.txt'...
[ Info: Downloading the file 'SOLFSMY.TXT' from 'http://sol.spacenvironment.net/jb2008/indices/SOLFSMY.TXT'...
[ Info: Downloading the file 'leap_seconds.csv' from 'https://ronanarraes.com/space-indices/leap_seconds.csv'...

julia> get_space_index(Val(:LeapSeconds), now())
37.0
```
