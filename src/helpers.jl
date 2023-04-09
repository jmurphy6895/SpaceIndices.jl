# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==========================================================================================
#
#   Helpers for the space indices.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

"""
    check_timespan(itp::AbstractInterpolation, jd::Number) -> Nothing

Check if the interpolation `itp` contains the date `jd` within its nodes. If not, it throws
an `ArgumentError` exception.
"""
function check_timespan(itp::AbstractInterpolation, jd::Number)
    jd_beg = itp.knots[begin][begin]
    jd_end = itp.knots[begin][end]

    if !(jd_beg <= jd <= jd_end)
        dt_beg = julian2datetime(jd_beg)
        dt_end = julian2datetime(jd_end)
        dt     = julian2datetime(jd)

        throw(ArgumentError("""
            The data for the requested day ($dt) is not available!
            The space index current timespan is: $dt_beg -- $dt_end."""
        ))
    end

    return nothing
end
