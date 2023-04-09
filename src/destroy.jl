# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==========================================================================================
#
#   Function to destroy all space indices.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export destroy_space_index_sets

"""
    destroy_space_index_sets() -> Nothing

Destroy the objects of all space index sets that were initialized.
"""
function destroy_space_index_sets()
    # The vector `_SPACE_INDEX_SETS` contains a set of `Tuple`s with the space file
    # structure and its optional data handler.
    for (~, handler) in _SPACE_INDEX_SETS
        handler.data = nothing
    end

    return nothing
end
