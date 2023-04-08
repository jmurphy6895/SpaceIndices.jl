API for Space Files
===================

This document describes the API that must be followed for space files.

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
get_redownload_period(::Type{T}) where T<:SpaceIndexFile -> DatePeriod
```

This function must return the re-download period for the space index file `T`. The remote
file will always be downloaded again if a time larger than this period has passed after the
last download. If this function is not defined, it returns `Day(7)` by default.
