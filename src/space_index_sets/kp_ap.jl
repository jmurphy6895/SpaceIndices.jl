# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==========================================================================================
#
#   Space index set: Kp_Ap
#   Remote file: https://kp.gfz-potsdam.de/app/files/Kp_ap_Ap_SN_F107_since_1932.txt
#
#   This set contains the Kp and Ap.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

############################################################################################
#                                        Structure
############################################################################################

struct KpAp <: SpaceIndexSet
    vdate::Vector{Date}
    vkp::Vector{NTuple{8, Float64}}
    vap::Vector{NTuple{8, Int}}
    vap_daily::Vector{Int}
end

############################################################################################
#                                           API
############################################################################################

urls(::Type{KpAp}) = ["https://kp.gfz-potsdam.de/app/files/Kp_ap_Ap_SN_F107_since_1932.txt"]

expiry_periods(::Type{KpAp}) = [Day(1)]

function parse_files(::Type{KpAp}, filepaths::Vector{String})
    # We only have one file here.
    filepath = first(filepaths)

    # Allocate the raw data.
    vdate     = Date[]
    vkp       = NTuple{8, Float64}[]
    vap       = NTuple{8, Int64}[]
    vap_daily = Int64[]

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
            if num_toks != 28
                @warn "Line $line_num of file Kp_ap_Ap_SN_F107_since_1932.txt has invalid format!"
                continue
            end

            # Compute the Julian day at midnight of the day.
            year  = parse(Int, tokens[1])
            month = parse(Int, tokens[2])
            day   = parse(Int, tokens[3])
            date  = Date(year, month, day)

            # Parse the data.
            kp       = Tuple(parse(Float64, tokens[ 8 + i]) for i in 0:7)
            ap       = Tuple(parse(Int,     tokens[16 + i]) for i in 0:7)
            ap_daily = parse(Int, tokens[24])

            # Add to the containers.
            push!(vdate,     date)
            push!(vkp,       kp)
            push!(vap,       ap)
            push!(vap_daily, ap_daily)
        end
    end

    # Create the output structure.
    return KpAp(vdate, vkp, vap, vap_daily)
end

@register KpAp

"""
    space_index(::Val{:Ap}, instant::DateTime) -> NTuple{8, Int64}

Get the Ap index for the day at `instant` computed every three hours.
"""
function space_index(::Val{:Ap}, instant::DateTime)
    obj    = @object(KpAp)
    knots  = obj.vdate
    values = obj.vap
    date   = Date(instant)
    return constant_interpolation(knots, values, date)
end

"""
    space_index(::Val{:Ap_daily}, instant::DateTime) -> Int64

Get the daily Ap index for the day at `instant`.
"""
function space_index(::Val{:Ap_daily}, instant::DateTime)
    obj    = @object(KpAp)
    knots  = obj.vdate
    values = obj.vap_daily
    date   = Date(instant)
    return constant_interpolation(knots, values, date)
end

"""
    space_index(::Val{:Kp}, instant::DateTime) -> NTuple{8, Int64}

Get the Kp index for the day at `instant` compute every three hours.
"""
function space_index(::Val{:Kp}, instant::DateTime)
    obj    = @object(KpAp)
    knots  = obj.vdate
    values = obj.vkp
    date   = Date(instant)
    return constant_interpolation(knots, values, date)
end

"""
    space_index(::Val{:Kp_daily}, instant::DateTime) -> Float64

Get the daily Kp index for the day at `instant`.
"""
function space_index(::Val{:Kp_daily}, instant::DateTime)
    obj    = @object(KpAp)
    knots  = obj.vdate
    values = obj.vkp
    date   = Date(instant)
    vkp    = constant_interpolation(knots, values, date)

    return sum(vkp) / length(vkp)
end
