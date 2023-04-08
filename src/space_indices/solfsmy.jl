# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==========================================================================================
#
#   Space index file: SOLFSMY.TXT
#   Default URL: http://sol.spacenvironment.net/jb2008/indices/SOLFSMY.TXT
#
#   This file contains the following indices:
#
#       f10, F81c, s10, S81c, m10, M81c, y10, Y81c
#
#   in which 81c means the 81-day averaged centered value. This information is used, for
#   example, for the JB2008 atmospheric model.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

############################################################################################
#                                        Structure
############################################################################################

const _SolfsmyItpType = Interpolations.GriddedInterpolation{
    Float64,
    1,
    Vector{Float64},
    Gridded{Constant{Nearest, Throw{OnGrid}}},
    Tuple{Array{Float64,1}}
}

struct Solfsmy <: SpaceIndexFile
    itp_f10::_SolfsmyItpType
    itp_f81a::_SolfsmyItpType
    itp_s10::_SolfsmyItpType
    itp_s81a::_SolfsmyItpType
    itp_m10::_SolfsmyItpType
    itp_m81a::_SolfsmyItpType
    itp_y10::_SolfsmyItpType
    itp_y81a::_SolfsmyItpType
end

############################################################################################
#                                           API
############################################################################################

get_url(::Type{Solfsmy}) = return "http://sol.spacenvironment.net/jb2008/indices/SOLFSMY.TXT"

get_filename(::Type{Solfsmy}) = "SOLFSMY.TXT"

get_expiry_period(::Type{Solfsmy}) = Day(1)

function parse_space_file(::Type{Solfsmy}, filepath::String)
    # Allocate the raw data.
    jd   = Float64[]
    f10  = Float64[]
    f81a = Float64[]
    s10  = Float64[]
    s81a = Float64[]
    m10  = Float64[]
    m81a = Float64[]
    y10  = Float64[]
    y81a = Float64[]

    # Read the raw data in the file.
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
            if num_toks != 12
                @warn "Line $line_num of file SOLFSMY.TXT has invalid format!"
                continue
            end

            # Parse data.
            push!(jd  , parse(Float64, tokens[ 3]))
            push!(f10 , parse(Float64, tokens[ 4]))
            push!(f81a, parse(Float64, tokens[ 5]))
            push!(s10 , parse(Float64, tokens[ 6]))
            push!(s81a, parse(Float64, tokens[ 7]))
            push!(m10 , parse(Float64, tokens[ 8]))
            push!(m81a, parse(Float64, tokens[ 9]))
            push!(y10 , parse(Float64, tokens[10]))
            push!(y81a, parse(Float64, tokens[11]))
        end
    end

    # Create the interpolations for each parameter.
    #
    # The parameters in `SOLFSMY.TXT` are computed at 12 UT. Hence, if we interpolate by the
    # nearest-neighbor, it will always return the data related to that day.
    knots    = (jd,)
    itp_f10  = interpolate(knots, f10 , Gridded(Constant()))
    itp_f81a = interpolate(knots, f81a, Gridded(Constant()))
    itp_s10  = interpolate(knots, s10 , Gridded(Constant()))
    itp_s81a = interpolate(knots, s81a, Gridded(Constant()))
    itp_m10  = interpolate(knots, m10 , Gridded(Constant()))
    itp_m81a = interpolate(knots, m81a, Gridded(Constant()))
    itp_y10  = interpolate(knots, y10 , Gridded(Constant()))
    itp_y81a = interpolate(knots, y81a, Gridded(Constant()))

    return Solfsmy(
        itp_f10,
        itp_f81a,
        itp_s10,
        itp_s81a,
        itp_m10,
        itp_m81a,
        itp_y10,
        itp_y81a
    )
end

@register Solfsmy

"""
    get_space_index(::Val{:S10}, jd_utc::Number) -> Float64

Get the EUV index (26-34 nm) scaled to F10.7 [10⁻²² W / (M² ⋅ Hz)] for the Julian day
`jd_utc`.
"""
function get_space_index(::Val{:S10}, jd_utc::Number)
    obj = @object(Solfsmy)
    itp = obj.itp_s10

    @check_timespan(itp, jd_utc)
    return itp(jd_utc)
end

"""
    get_space_index(::Val{:S81a}, jd_utc::Number) -> Float64

Get the 81-day averaged EUV index (26-34 nm) scaled to F10.7 [10⁻²² W / (M² ⋅ Hz)] for the
Julian day `jd_utc`.
"""
function get_space_index(::Val{:S81a}, jd_utc::Number)
    obj = @object(Solfsmy)
    itp = obj.itp_s81a

    @check_timespan(itp, jd_utc)
    return itp(jd_utc)
end

"""
    get_space_index(::Val{:M10}, jd_utc::Number) -> Float64

Get the MG2 index scaled to F10.7 [10⁻²² W / (M² ⋅ Hz)] for the Julian day `jd_utc`.
"""
function get_space_index(::Val{:M10}, jd_utc::Number)
    obj = @object(Solfsmy)
    itp = obj.itp_m10

    @check_timespan(itp, jd_utc)
    return itp(jd_utc)
end

"""
    get_space_index(::Val{:M81a}, jd_utc::Number) -> Float64

Get the 81-day averaged MG2 index scaled to F10.7 [10⁻²² W / (M² ⋅ Hz)] for the Julian day
`jd_utc`.
"""
function get_space_index(::Val{:M81a}, jd_utc::Number)
    obj = @object(Solfsmy)
    itp = obj.itp_m81a

    @check_timespan(itp, jd_utc)
    return itp(jd_utc)
end

"""
    get_space_index(::Val{:Y10}, jd_utc::Number) -> Float64

Get the solar X-ray & Lya index scaled to F10.7 [10⁻²² W / (M² ⋅ Hz)] for the Julian day
`jd_utc`.
"""
function get_space_index(::Val{:Y10}, jd_utc::Number)
    obj = @object(Solfsmy)
    itp = obj.itp_y10

    @check_timespan(itp, jd_utc)
    return itp(jd_utc)
end

"""
    get_space_index(::Val{:Y81a}, jd_utc::Number) -> Float64

Get the 81-day averaged solar X-ray & Lya index scaled to F10.7 [10⁻²² W / (M² ⋅ Hz)] for
the Julian day `jd_utc`.
"""
function get_space_index(::Val{:Y81a}, jd_utc::Number)
    obj = @object(Solfsmy)
    itp = obj.itp_y81a

    @check_timespan(itp, jd_utc)
    return itp(jd_utc)
end
