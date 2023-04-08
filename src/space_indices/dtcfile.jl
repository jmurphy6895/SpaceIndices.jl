# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==========================================================================================
#
#   Space index file: DTCFILE.txt
#   Default URL: http://sol.spacenvironment.net/jb2008/indices/DTCFILE.TXT
#
#   This file stores the temperature variation `ΔTc` caused by the `Dst`. This information
#   is used, for example, for the JB2008 atmospheric model.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

############################################################################################
#                                        Structure
############################################################################################

const _DtcfileItpType = Interpolations.GriddedInterpolation{
    Float64,
    1,
    Vector{Float64},
    Gridded{Linear{Throw{OnGrid}}},
    Tuple{Array{Float64,1}}
}

struct Dtcfile <: SpaceIndexFile
    itp_dtc::_DtcfileItpType
end

############################################################################################
#                                           API
############################################################################################

get_url(::Type{Dtcfile}) = return "http://sol.spacenvironment.net/jb2008/indices/DTCFILE.TXT"

get_filename(::Type{Dtcfile}) = "DTCFILE.TXT"

get_expiry_period(::Type{Dtcfile}) = Day(1)

function parse_space_file(::Type{Dtcfile}, filepath::String)
    # Allocate the raw data.
    jd  = Float64[]
    dtc = Float64[]

    open(filepath) do file
        line_num = 0

        for ln in eachline(file)
            line_num += 1

            # Ignore comments.
            (ln[1] == '#') && continue

            tokens   = split(ln)
            num_toks = length(tokens)

            # Ignore blank lines.
            (num_toks == 0) && continue

            # Ignore and print warning about lines with bad format.
            if (num_toks != 27) || (tokens[1] != "DTC")
                @warn "Line $line_num of file DTCFILE.TXT has invalid format!"
                continue
            end

            # Compute the Julian day at midnight of the day.
            year = parse(Int,     tokens[2])
            doy  = parse(Float64, tokens[3])

            jd_0h = datetime2julian(DateTime(year, 1, 1, 0, 0, 0)) - 1 + doy

            # Parse the data.
            for k = 1:24
                dtc_h = parse(Float64, tokens[k + 3])
                push!(jd,  jd_0h + (k - 1) / 24)
                push!(dtc, dtc_h)
            end

        end
    end

    # Create the interpolations for each parameter.
    knots   = (jd,)
    itp_dtc = interpolate(knots, dtc, Gridded(Linear()))

    return Dtcfile(itp_dtc)
end

@register Dtcfile

"""
    get_space_index(::Val{:DTC}, jd_utc::Number) -> Float64

Get the exospheric temperature variation [K] caused by the Dst index.
"""
function get_space_index(::Val{:DTC}, jd_utc::Number)
    obj = @object(Dtcfile)
    itp = obj.itp_dtc

    @check_timespan(itp, jd_utc)
    return itp(jd_utc)
end
