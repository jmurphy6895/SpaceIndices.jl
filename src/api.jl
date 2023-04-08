# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==========================================================================================
#
#   API definitions for the space files.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export get_expiry_period, get_filename, get_space_index, get_url

############################################################################################
#                                          Macros
############################################################################################

"""
    @register(T)

Register the the space index file structure `T`. This macro push the data into the global
vector of space files and also creates the optinal data handler for the processed structure.
"""
macro register(T)
    op_data_handler = "_" * "OPDATA_" * uppercase(string(T)) |> Symbol
    space_index_name = string(T)

    ex = quote
        @OptionalData(
            SpaceIndices.@data_handler($T),
            $T,
            "The space index SpaceIndices." * $space_index_name * " was not initialized yet."
        )

        push!(SpaceIndices._SPACE_FILES, ($T, $op_data_handler))

        return nothing
    end

    return esc(ex)
end

"""
    @data_handler(T)

Get the variable with the optional data handler for space index file structure `T`.
"""
macro data_handler(T)
    op_data_handle = "_" * "OPDATA_" * uppercase(string(T)) |> Symbol
    return :($op_data_handle) |> esc
end

"""
    @object(T)

Get the data handler for the space index file structure `T`.
"""
macro object(T)
    space_index_name = string(T)
    ex = quote
        isavailable(SpaceIndices.@data_handler($T)) || error(
            """
            The space index SpaceIndices.$($space_index_name) was not initialized yet.
            See the function init_space_indices() for more information."""
        )
        get(SpaceIndices.@data_handler($T))
    end


    return esc(ex)
end

############################################################################################
#                                        Functions
############################################################################################

"""
    fetch_space_file(::Type{T}; kwargs...) where T<:SpaceIndexFile -> String

Fetch the space file related to the space index `T`. This function returns the space index
file path.

# Keywords

- `force_download::Bool`: If `true`, the space file will be downloaded regardless of its
    timestamp. (**Default** = `false`)
"""
function fetch_space_file(::Type{T}; force_download::Bool = false) where T<:SpaceIndexFile
    url = get_url(T)
    filename = get_filename(T)
    expiry_period = get_expiry_period(T)
    return _download_file(url, string(T), filename; force_download, expiry_period)
end

"""
    get_expiry_period(::Type{T}) where T<:SpaceIndexFile -> DatePeriod

Return the expiry period for the space index file `T`. The remote file will always be
downloaded again if a time larger than this period has passed after the last download.

If this function is not defined for `T`, the default expiry period of 7 days is used.
"""
get_expiry_period(::Type{T}) where T<:SpaceIndexFile = Day(7)

"""
    get_filename(::Type{T}) where T<:SpaceIndexFile -> String

Return the filename for the space index file `T`.
"""
get_filename

"""
    get_url(::Type{T}) where T<:SpaceIndexFile -> String

Return the URL to obtain the space index file `T`.
"""
get_url

"""
    get_space_index(::Val{:index}, jd::Number; kwargs...) -> Number
    get_space_index(::Val{:index}, instant::DateTime; kwargs...) -> Number

Get the space `index` for the Julian day `jd` or `instant`, which can be an object of type
`DateTime`. `kwargs...` can be used to pass additional configuration for the space index.
"""
get_space_index

function get_space_index(index::Val, instant::DateTime)
    return get_space_index(index, datetime2julian(instant))
end

"""
    parse_space_file(::Type{T}, filepath::String) where T<:SpaceIndexFile -> T

Parse the space index file `T` using the file in `filepath`. It must return an object of
type `T` with the parsed data.
"""
parse_space_file
