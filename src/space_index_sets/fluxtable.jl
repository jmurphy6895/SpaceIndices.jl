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

struct Fluxtable <: SpaceIndexSet
    vdate::Vector{Date}
    vf107_obs::Vector{Float64}
    vf107_adj::Vector{Float64}
end

############################################################################################
#                                           API
############################################################################################

function urls(::Type{Fluxtable})
    return ["ftp://ftp.seismo.nrcan.gc.ca/spaceweather/solar_flux/daily_flux_values/fluxtable.txt"]
end

expiry_periods(::Type{Fluxtable}) = [Day(1)]

function parse_files(::Type{Fluxtable}, filepaths::Vector{String})
    # We only have one file here.
    filepath = first(filepaths)

    # Allocate raw data.
    vdate     = Date[]
    vf107_obs = Float64[]
    vf107_adj = Float64[]

    # Store the latest processed day.
    date_k_1 = Date(0, 1, 1)

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

            # We will save only the flux obtained at 20h, which is the local noon at the
            # observation site:
            #
            #    https://spaceweather.gc.ca/forecast-prevision/solar-solaire/solarflux/sx-3-en.php
            #
            # This is what NRLMSISE-00 and JB2008 use.
            fluxtime = parse(Int, tokens[2])
            (fluxtime != 200000) && continue

            # The Julian day of the data will be computed at noon to allow using the
            # nearest-neighbor algorithm in the interpolations.
            year   = parse(Int, tokens[1][1:4])
            month  = parse(Int, tokens[1][5:6])
            day    = parse(Int, tokens[1][7:8])
            date_k = Date(year, month, day)

            # If the current data is equal to the last one, it means we have duplicated
            # information. In this case, always use the latest one.
            if date_k == date_k_1
                pop!(vdate)
                pop!(vf107_obs)
                pop!(vf107_adj)
            end

            date_k_1 = date_k

            # Get the raw data.
            push!(vdate,    date_k)
            push!(vf107_obs, parse(Float64, tokens[5]))
            push!(vf107_adj, parse(Float64, tokens[6]))
        end
    end

    return Fluxtable(vdate, vf107_obs, vf107_adj)
end

@register Fluxtable

"""
    space_index(::Val{:F10adj}, instant::DateTime) -> Float64

Get the adjusted F10.7 index (10.7-cm solar flux) [10⁻²² W / (M² ⋅ Hz)] for the `instant`
(UTC).
"""
function space_index(::Val{:F10adj}, instant::DateTime)
    obj    = @object(Fluxtable)
    knots  = obj.vdate
    values = obj.vf107_adj
    date   = Date(instant)
    return constant_interpolation(knots, values, date)
end

"""
    space_index(::Val{:F10obs}, instant::DateTime) -> Float64

Get the observed F10.7 index (10.7-cm solar flux) [10⁻²² W / (M² ⋅ Hz)] for the `instant`
(UTC).
"""
function space_index(::Val{:F10obs}, instant::DateTime)
    obj    = @object(Fluxtable)
    knots  = obj.vdate
    values = obj.vf107_obs
    date   = Date(instant)
    return constant_interpolation(knots, values, date)
end
