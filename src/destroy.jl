# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==========================================================================================
#
#   Function to destroy all space indices.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export destroy_space_indices

"""
    destroy_space_indices()

Destroy the object of all space indices that were initialized.
"""
function destroy_space_indices()
    # The vector `_SPACE_FILES` contains a set of `Tuple`s with the space file structure and
    # its optional data handler.
    for (~, handler) in _SPACE_FILES
        handler.data = nothing
    end

    return nothing
end
