# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==========================================================================================
#
#   Space index set: JB2008
#   Remote files:
#       - http://sol.spacenvironment.net/jb2008/indices/DTCFILE.TXT
#       - http://sol.spacenvironment.net/jb2008/indices/SOLFSMY.TXT
#
#   This set contains the space indices used for the JB2008 atmospheric model.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

############################################################################################
#                                        Structure
############################################################################################

const _JB2008LinearItp = Interpolations.GriddedInterpolation{
    Float64,
    1,
    Vector{Float64},
    Gridded{Linear{Throw{OnGrid}}},
    Tuple{Array{Float64,1}}
}

const _JB2008NearestItp = Interpolations.GriddedInterpolation{
    Float64,
    1,
    Vector{Float64},
    Gridded{Constant{Nearest, Throw{OnGrid}}},
    Tuple{Array{Float64,1}}
}

struct JB2008 <: SpaceIndexSet
    itp_dtc::_JB2008LinearItp
    itp_f10::_JB2008NearestItp
    itp_f81a::_JB2008NearestItp
    itp_s10::_JB2008NearestItp
    itp_s81a::_JB2008NearestItp
    itp_m10::_JB2008NearestItp
    itp_m81a::_JB2008NearestItp
    itp_y10::_JB2008NearestItp
    itp_y81a::_JB2008NearestItp
end

############################################################################################
#                                           API
############################################################################################

urls(::Type{JB2008}) = [
    "http://sol.spacenvironment.net/jb2008/indices/DTCFILE.TXT"
    "http://sol.spacenvironment.net/jb2008/indices/SOLFSMY.TXT"
]

expiry_periods(::Type{JB2008}) = [Day(1), Day(1)]

function parse_files(::Type{JB2008}, filepaths::Vector{String})
    itp_dtc      = _parse_dtcfile(filepaths |> first)
    itps_solfsmy = _parse_solfsmy(filepaths |> last)
    itp_f10, itp_f81a, itp_s10, itp_s81a, itp_m10, itp_m81a, itp_y10, itp_y81a = itps_solfsmy

    return JB2008(
        itp_dtc,
        itp_f10,
        itp_f81a,
        itp_s10,
        itp_s81a,
        itp_m10,
        itp_m81a,
        itp_y10,
        itp_y81a,
    )
end

@register JB2008

"""
    space_index(::Val{:DTC}, jd_utc::Number) -> Float64

Get the exospheric temperature variation [K] caused by the Dst index.
"""
function space_index(::Val{:DTC}, jd_utc::Number)
    obj = @object(JB2008)
    itp = obj.itp_dtc

    check_timespan(itp, jd_utc)
    return itp(jd_utc)
end

"""
    space_index(::Val{:S10}, jd_utc::Number) -> Float64

Get the EUV index (26-34 nm) scaled to F10.7 [10⁻²² W / (M² ⋅ Hz)] for the Julian day
`jd_utc`.
"""
function space_index(::Val{:S10}, jd_utc::Number)
    obj = @object(JB2008)
    itp = obj.itp_s10

    check_timespan(itp, jd_utc)
    return itp(jd_utc)
end

"""
    space_index(::Val{:S81a}, jd_utc::Number) -> Float64

Get the 81-day averaged EUV index (26-34 nm) scaled to F10.7 [10⁻²² W / (M² ⋅ Hz)] for the
Julian day `jd_utc`.
"""
function space_index(::Val{:S81a}, jd_utc::Number)
    obj = @object(JB2008)
    itp = obj.itp_s81a

    check_timespan(itp, jd_utc)
    return itp(jd_utc)
end

"""
    get_space_index(::Val{:M10}, jd_utc::Number) -> Float64

Get the MG2 index scaled to F10.7 [10⁻²² W / (M² ⋅ Hz)] for the Julian day `jd_utc`.
"""
function space_index(::Val{:M10}, jd_utc::Number)
    obj = @object(JB2008)
    itp = obj.itp_m10

    check_timespan(itp, jd_utc)
    return itp(jd_utc)
end

"""
    space_index(::Val{:M81a}, jd_utc::Number) -> Float64

Get the 81-day averaged MG2 index scaled to F10.7 [10⁻²² W / (M² ⋅ Hz)] for the Julian day
`jd_utc`.
"""
function space_index(::Val{:M81a}, jd_utc::Number)
    obj = @object(JB2008)
    itp = obj.itp_m81a

    check_timespan(itp, jd_utc)
    return itp(jd_utc)
end

"""
    space_index(::Val{:Y10}, jd_utc::Number) -> Float64

Get the solar X-ray & Lya index scaled to F10.7 [10⁻²² W / (M² ⋅ Hz)] for the Julian day
`jd_utc`.
"""
function space_index(::Val{:Y10}, jd_utc::Number)
    obj = @object(JB2008)
    itp = obj.itp_y10

    check_timespan(itp, jd_utc)
    return itp(jd_utc)
end

"""
    space_index(::Val{:Y81a}, jd_utc::Number) -> Float64

Get the 81-day averaged solar X-ray & Lya index scaled to F10.7 [10⁻²² W / (M² ⋅ Hz)] for
the Julian day `jd_utc`.
"""
function space_index(::Val{:Y81a}, jd_utc::Number)
    obj = @object(JB2008)
    itp = obj.itp_y81a

    check_timespan(itp, jd_utc)
    return itp(jd_utc)
end

############################################################################################
#                                    Private Functions
############################################################################################

# Parse the DTCFILE.TXT and return the interpolators.
function _parse_dtcfile(filepath::String)
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

    return itp_dtc
end

# Parse the SOLFSMY.TXT and return the interpolators.
function _parse_solfsmy(filepath::String)
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

    return itp_f10, itp_f81a, itp_s10, itp_s81a, itp_m10, itp_m81a, itp_y10, itp_y81a
end
