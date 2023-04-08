# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==========================================================================================
#
#   Function to initialize all space indices.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export init_space_index, init_space_indices

"""
    init_space_index(::Type{T}) where T<:SpaceIndexFile -> Nothing

Initialize the space index `T`.

This function will download the remote file associated to the space index `T` if it does
not exist or if the redownload period has been passed. Aftward, it will parse the file and
populate the object handler to be accesses by the function [`get_space_index`](@ref).
"""
function init_space_index(::Type{T}) where T<:SpaceIndexFile
    id = findfirst(x -> first(x) === T, _SPACE_FILES)
    isnothing(id) && throw(ArgumentError("The space file $T is not registered!"))

    # Get the space index file handler.
    handler = _SPACE_FILES[id] |> last

    # Fetch the space file, if necessary, and parse it.
    filepath = fetch_space_file(T)
    obj = parse_space_file(T, filepath)
    push!(handler, obj)

    return nothing
end

"""
    init_space_indices(; blocklist::Vector = []) -> Nothing

Initialize all the registered space indices.

This function will download the remote files associated to the space indices if they do
not exist or if the redownload period has been passed. Aftward, it will parse the files and
populate the object handlers to be accesses by the function [`get_space_index`](@ref).
"""
function init_space_indices(; blocklist::Vector = [])
    # The vector `_SPACE_FILES` contains a set of `Tuple`s with the space file structure and
    # its optional data handler.
    for (T, handler) in _SPACE_FILES
        # If `T` is in block list, just continue.
        if (T ∈ blocklist)
            @debug "Skipping the space file $T."
            continue
        end

        # Fetch the space file, if necessary, and parse it.
        filepath = fetch_space_file(T)
        obj = parse_space_file(T, filepath)
        push!(handler, obj)
    end
end
