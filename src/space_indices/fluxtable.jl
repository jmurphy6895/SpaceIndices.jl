# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==========================================================================================
#
#   Space index file: fluxtable.txt
#   Default URL: ftp://ftp.seismo.nrcan.gc.ca/spaceweather/solar_flux/daily_flux_values/fluxtable.txt
#
#   This file stores the F10.7 in different formats.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

############################################################################################
#                                        Structure
############################################################################################

const _FluxtableItpType = Interpolations.GriddedInterpolation{
    Float64,
    1,
    Vector{Float64},
    Gridded{Constant{Nearest, Throw{OnGrid}}},
    Tuple{Array{Float64,1}}
}

struct Fluxtable <: SpaceIndexFile
    itp_f107_obs::_FluxtableItpType
    itp_f107_adj::_FluxtableItpType
end

############################################################################################
#                                           API
############################################################################################

function get_url(::Type{Fluxtable})
    return "ftp://ftp.seismo.nrcan.gc.ca/spaceweather/solar_flux/daily_flux_values/fluxtable.txt"
end

get_filename(::Type{Fluxtable}) = "fluxtable.txt"

get_expiry_period(::Type{Fluxtable}) = Day(1)

function parse_space_file(::Type{Fluxtable}, filepath::String)
    # Allocate raw data.
    jd       = Float64[]
    f107_obs = Float64[]
    f107_adj = Float64[]

    # Store the latest processed Julian day.
    jd_k_1 = zero(Float64)

    open(filepath) do file
        line_num = 0

        for ln in eachline(file)
            line_num += 1

            # Jump comments at the beginning of the file.
            (line_num in [1, 2]) && continue

            # Get the tokens.
            tokens     = split(ln)
            num_tokens = length(tokens)

            # Check if the line is valid.
            (num_tokens != 7) && @error """
                Error parsing the line $line_num of fluxtable.txt.
                File path: $path"""

            # We will save only the flux obtained at 20h. This is what NRLMSISE-00 and
            # JB2008 use.
            fluxtime = parse(Int, tokens[2])
            (fluxtime != 200000) && continue

            # The Julian day of the data will be computed at noon to allow using the
            # nearest-neighbor algorithm in the interpolations.
            year  = parse(Int, tokens[1][1:4])
            month = parse(Int, tokens[1][5:6])
            day   = parse(Int, tokens[1][7:8])
            jd_k  = datetime2julian(DateTime(year, month, day, 12, 0, 0))

            # If the current data is equal to the last one, it means we have duplicated
            # information. In this case, always use the latest one.
            if jd_k == jd_k_1
                pop!(jd)
                pop!(f107_obs)
                pop!(f107_adj)
            end

            jd_k_1 = jd_k

            # Get the raw data.
            push!(jd,       jd_k)
            push!(f107_obs, parse(Float64, tokens[5]))
            push!(f107_adj, parse(Float64, tokens[6]))
        end
    end

    # Create the interpolations for each parameter.
    knots = (jd,)
    itp_f107_obs = interpolate( knots, f107_obs,  Gridded(Constant()) )
    itp_f107_adj = interpolate( knots, f107_adj,  Gridded(Constant()) )

    return Fluxtable(itp_f107_obs, itp_f107_adj)
end

@register Fluxtable

"""
    get_space_index(::Val{:F10adj}, jd_utc::Number) -> Float64

Get the adjusted F10.7 index (10.7-cm solar flux) [10⁻²² W / (M² ⋅ Hz)] for the Julian day
`jd_utc`.
"""
function get_space_index(::Val{:F10adj}, jd_utc::Number)
    obj = @object(Fluxtable)
    itp = obj.itp_f107_adj

    @check_timespan(itp, jd_utc)
    return itp(jd_utc)
end

"""
    get_space_index(::Val{:F10obs}, jd_utc::Number) -> Float64

Get the observed F10.7 index (10.7-cm solar flux) [10⁻²² W / (M² ⋅ Hz)] for the Julian day
`jd_utc`.
"""
function get_space_index(::Val{:F10obs}, jd_utc::Number)
    obj = @object(Fluxtable)
    itp = obj.itp_f107_adj

    @check_timespan(itp, jd_utc)
    return itp(jd_utc)
end
