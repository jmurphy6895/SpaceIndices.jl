# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==========================================================================================
#
#   Space index file: SW-Last5Years.csv
#   Default URL: https://celestrak.org/SpaceData/SW-Last5Years.csv
#
#   This file stores the historic and predicted Geomagnetic and Solar Flux data used in 
#   space weather models. Documentation can be found at 
#   https://celestrak.org/SpaceData/SpaceWx-format.php
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

############################################################################################
#                                        Structure
############################################################################################

struct Celestrak <: SpaceIndexSet
    vdate::Vector{Date}
    vBSRN::Vector{Int}
    vND::Vector{Int}
    vkp::Vector{NTuple{8, Float64}}
    vap::Vector{NTuple{8, Int}}
    vCp::Vector{Float64}
    vC9::Vector{Float64}
    vISN::Vector{Int}
    vap_daily::Vector{Int}
    vf107_obs::Vector{Float64}
    vf107_adj::Vector{Float64}
    vf107_obs_avg_center81::Vector{Float64}
    vf107_obs_avg_last81::Vector{Float64}
    vf107_adj_avg_center81::Vector{Float64}
    vf107_adj_avg_last81::Vector{Float64}
end

function urls(::Type{Celestrak}; all_history::Bool=false, kwargs...)
    return all_history ?
     ["https://celestrak.org/SpaceData/SW-All.csv"] :
     ["https://celestrak.org/SpaceData/SW-Last5Years.csv"]
end

expiry_periods(::Type{Celestrak}) = [Day(1)]

"""
Celestrak Mulitples Kp by 10 and rounds to the nearest integer this puts it back
"""
function roundKp(x::Float64)
    round(round((x / 10.0) * 3) * 1/3; digits=3)
end

function parse_files(::Type{Celestrak}, filepaths::Vector{String})
    # We only have one file here.
    filepath = first(filepaths)

    # Allocate raw data.
    vdate = Date[]
    vBSRN = Int[]
    vND = Int[]
    vkp = NTuple{8, Float64}[]
    vap = NTuple{8, Int}[]
    vCp = Float64[]
    vC9 = Float64[]
    vISN = Int[]
    vap_daily = Int[]
    vf107_obs = Float64[]
    vf107_adj = Float64[]
    vf107_obs_avg_center81 = Float64[]
    vf107_obs_avg_last81 = Float64[]
    vf107_adj_avg_center81 = Float64[]
    vf107_adj_avg_last81 = Float64[]

    # Store the latest processed day.
    date_k_1 = Date(0, 1, 1)

    file = readdlm(filepath, ','; skipstart=1)

    for i ∈ 1:size(file)[1]

        # The Julian day of the data will be computed at noon to allow using the
        # nearest-neighbor algorithm in the interpolations.
        date_str = split(file[i, 1], '-')
        year   = parse(Int, date_str[1])
        month  = parse(Int, date_str[2])
        day    = parse(Int, date_str[3])
        date_k = Date(year, month, day)

        # If the current data is equal to the last one, it means we have duplicated
        # information. In this case, always use the latest one.
        if date_k == date_k_1
            pop!(vdate)
            pop!(vBSRN)
            pop!(vND)
            pop!(vkp)
            pop!(vap)
            pop!(vCp)
            pop!(vC9)
            pop!(vISN)
            pop!(vap_daily)
            pop!(vf107_obs)
            pop!(vf107_adj)
            pop!(vf107_obs_avg_center81)
            pop!(vf107_obs_avg_last81)
            pop!(vf107_adj_avg_center81)
            pop!(vf107_adj_avg_last81)
        end

        date_k_1 = date_k

        # Skip these to Simplify Parsing, Only Grab Dates with all Indices
        if file[i, 27] == "PRM"
            continue
        end

        push!(vdate,                    date_k)
        push!(vBSRN,                    trunc(file[i, 2]))
        push!(vND,                      trunc(file[i, 3]))
        push!(vkp,                      roundKp.(Tuple(float(file[i, j]) for j∈4:11)))
        push!(vap,                      Tuple(trunc(file[i, j]) for j∈13:20))
        push!(vCp,                      float(file[i, 22]))
        push!(vC9,                      float(file[i, 23]))
        push!(vISN,                     trunc(file[i, 24]))
        push!(vap_daily,                trunc(file[i, 21]))
        push!(vf107_obs,                float(file[i, 25]))
        push!(vf107_adj,                float(file[i, 26]))
        push!(vf107_obs_avg_center81,   float(file[i, 28]))
        push!(vf107_obs_avg_last81,     float(file[i, 29]))
        push!(vf107_adj_avg_center81,   float(file[i, 30]))
        push!(vf107_adj_avg_last81,     float(file[i, 31]))

    end

    return Celestrak(
        vdate,
        vBSRN,
        vND,
        vkp,
        vap,
        vCp,
        vC9,
        vISN,
        vap_daily,
        vf107_obs,
        vf107_adj,
        vf107_obs_avg_center81,
        vf107_obs_avg_last81,
        vf107_adj_avg_center81,
        vf107_adj_avg_last81)

end

@register Celestrak

"""
    space_index(::Val{:BSRN}, instant::DateTime) -> Int64

Get the BSRN index for the day at `instant`
"""
function space_index(::Val{:BSRN}, instant::DateTime)
    obj    = @object(Celestrak)
    knots  = obj.vdate
    values = obj.vBSRN
    date   = Date(instant)
    return constant_interpolation(knots, values, date)
end

"""
    space_index(::Val{:ND}, instant::DateTime) -> Int64

Get the ND index for the day at `instant`
"""
function space_index(::Val{:ND}, instant::DateTime)
    obj    = @object(Celestrak)
    knots  = obj.vdate
    values = obj.vND
    date   = Date(instant)
    return constant_interpolation(knots, values, date)
end

"""
    space_index(::Val{:Kp}, instant::DateTime) -> NTuple{8, Float64}

    Get the Kp index for the day at `instant` compute every three hours.
"""
function space_index(::Val{:Kp}, instant::DateTime)
    obj    = @object(Celestrak)
    knots  = obj.vdate
    values = obj.vkp
    date   = Date(instant)
    return constant_interpolation(knots, values, date)
end

"""
    space_index(::Val{:Ap}, instant::DateTime) -> NTuple{8, Float64}

    Get the Ap index for the day at `instant` compute every three hours.
"""
function space_index(::Val{:Ap}, instant::DateTime)
    obj    = @object(Celestrak)
    knots  = obj.vdate
    values = obj.vap
    date   = Date(instant)
    return constant_interpolation(knots, values, date)
end

"""
    space_index(::Val{:Cp}, instant::DateTime) -> Float64

Get the Cp index for the day at `instant`
"""
function space_index(::Val{:Cp}, instant::DateTime)
    obj    = @object(Celestrak)
    knots  = obj.vdate
    values = obj.vCp
    date   = Date(instant)
    return constant_interpolation(knots, values, date)
end

"""
    space_index(::Val{:C9}, instant::DateTime) -> Float64

Get the C9 index for the day at `instant`
"""
function space_index(::Val{:C9}, instant::DateTime)
    obj    = @object(Celestrak)
    knots  = obj.vdate
    values = obj.vC9
    date   = Date(instant)
    return constant_interpolation(knots, values, date)
end

"""
    space_index(::Val{:ISN}, instant::DateTime) -> Int64

Get the ISN index for the day at `instant`
"""
function space_index(::Val{:ISN}, instant::DateTime)
    obj    = @object(Celestrak)
    knots  = obj.vdate
    values = obj.vISN
    date   = Date(instant)
    return constant_interpolation(knots, values, date)
end

"""
    space_index(::Val{:Ap_daily}, instant::DateTime) -> Int64

Get the daily Ap index for the day at `instant`.
"""
function space_index(::Val{:Ap_daily}, instant::DateTime)
    obj    = @object(Celestrak)
    knots  = obj.vdate
    values = obj.vap_daily
    date   = Date(instant)
    return constant_interpolation(knots, values, date)
end

"""
    space_index(::Val{:Kp_daily}, instant::DateTime) -> Float64

Get the daily Kp index for the day at `instant`.
"""
function space_index(::Val{:Kp_daily}, instant::DateTime)
    obj    = @object(Celestrak)
    knots  = obj.vdate
    values = obj.vkp
    date   = Date(instant)
    vkp    = constant_interpolation(knots, values, date)

    return sum(vkp) / length(vkp)
end


"""
    space_index(::Val{:F10obs}, instant::DateTime) -> Float64

Get the observed F10.7 index (10.7-cm solar flux) [10⁻²² W / (M² ⋅ Hz)] for the `instant`
(UTC).
"""
function space_index(::Val{:F10obs}, instant::DateTime)
    obj    = @object(Celestrak)
    knots  = obj.vdate 
    values = obj.vf107_obs
    # Shift 8 Hours to Move Center of Interval to Midnight Since F10.7 Measurement occurs at 20:00 UTC
    date   = Date(instant - Hour(8))
    return constant_interpolation(knots, values, date)
end

"""
    space_index(::Val{:F10adj}, instant::DateTime) -> Float64

Get the adjusted F10.7 index (10.7-cm solar flux) [10⁻²² W / (M² ⋅ Hz)] for the `instant`
(UTC).
"""
function space_index(::Val{:F10adj}, instant::DateTime)
    obj    = @object(Celestrak)
    knots  = obj.vdate
    values = obj.vf107_adj
    # Shift 8 Hours to Move Center of Interval to Midnight Since F10.7 Measurement occurs at 20:00 UTC
    date   = Date(instant - Hour(8))
    return constant_interpolation(knots, values, date)
end

"""
    space_index(::Val{:F10obs_avg_center81}, instant::DateTime) -> Float64

Get the observed F10.7 index (10.7-cm solar flux) [10⁻²² W / (M² ⋅ Hz)] averaged over 81 days centered for the `instant`
(UTC).
"""
function space_index(::Val{:F10obs_avg_center81}, instant::DateTime)
    obj    = @object(Celestrak)
    knots  = obj.vdate
    values = obj.vf107_obs_avg_center81
    # Shift 8 Hours to Move Center of Interval to Midnight Since F10.7 Measurement occurs at 20:00 UTC
    date   = Date(instant - Hour(8))
    return constant_interpolation(knots, values, date)
end

"""
    space_index(::Val{:F10obs_avg_last81}, instant::DateTime) -> Float64

Get the observed F10.7 index (10.7-cm solar flux) [10⁻²² W / (M² ⋅ Hz)] averaged over the last 81 days for the `instant`
(UTC).
"""
function space_index(::Val{:F10obs_avg_last81}, instant::DateTime)
    obj    = @object(Celestrak)
    knots  = obj.vdate
    values = obj.vf107_obs_avg_last81
    # Shift 8 Hours to Move Center of Interval to Midnight Since F10.7 Measurement occurs at 20:00 UTC
    date   = Date(instant - Hour(8))
    return constant_interpolation(knots, values, date)
end

"""
    space_index(::Val{:F10adj_avg_center81}, instant::DateTime) -> Float64

Get the adjusted F10.7 index (10.7-cm solar flux) [10⁻²² W / (M² ⋅ Hz)] averaged over 81 days centered for the `instant`
(UTC).
"""
function space_index(::Val{:F10adj_avg_center81}, instant::DateTime)
    obj    = @object(Celestrak)
    knots  = obj.vdate
    values = obj.vf107_adj_avg_center81
    # Shift 8 Hours to Move Center of Interval to Midnight Since F10.7 Measurement occurs at 20:00 UTC
    date   = Date(instant - Hour(8))
    return constant_interpolation(knots, values, date)
end

"""
    space_index(::Val{:F10adj_avg_last81}, instant::DateTime) -> Float64

Get the adjusted F10.7 index (10.7-cm solar flux) [10⁻²² W / (M² ⋅ Hz)] averaged over the last 81 days for the `instant`
(UTC).
"""
function space_index(::Val{:F10adj_avg_last81}, instant::DateTime)
    obj    = @object(Celestrak)
    knots  = obj.vdate
    values = obj.vf107_adj_avg_last81
    # Shift 8 Hours to Move Center of Interval to Midnight Since F10.7 Measurement occurs at 20:00 UTC
    date   = Date(instant - Hour(8)) 
    return constant_interpolation(knots, values, date)
end