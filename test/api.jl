# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==========================================================================================
#
#   Tests related to the API to create new space indices.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

struct LeapSeconds <: SpaceIndexFile
    jd::Vector{Float64}
    leap_seconds::Vector{Float64}
end

SpaceIndices.get_url(::Type{LeapSeconds}) = "https://ronanarraes.com/space-indices/leap_seconds.csv"
SpaceIndices.get_filename(::Type{LeapSeconds}) = "leap_seconds.csv"
SpaceIndices.get_expiry_period(::Type{LeapSeconds}) = Day(365)

function SpaceIndices.parse_space_file(::Type{LeapSeconds}, filepath::String)
    raw_data, ~ = readdlm(filepath, ';'; header = true)
    return LeapSeconds(raw_data[:, 1], raw_data[:, 2])
end

function SpaceIndices.get_space_index(::Val{:LeapSeconds}, jd_utc::Number)
    obj = SpaceIndices.@object(LeapSeconds)
    id = findfirst(>=(jd_utc), obj.jd)

    if isnothing(id)
        id = length(obj.jd)
    end

    return obj.leap_seconds[id]
end

SpaceIndices.@register LeapSeconds

@testset "Default Operations" begin
    # Make sure the scratch space is clean.
    delete_scratch!(SpaceIndices, "LeapSeconds")

    # Download the file.
    @test_logs (
        :info,
        "Downloading the file 'leap_seconds.csv' from 'https://ronanarraes.com/space-indices/leap_seconds.csv'..."
    ) match_mode = :any init_space_index(LeapSeconds)

    # Test some values.
    @test get_space_index(Val(:LeapSeconds), DateTime(1000, 1, 1)) == 11.0
    @test get_space_index(Val(:LeapSeconds), DateTime(1979, 1, 1)) == 18.0
    @test get_space_index(Val(:LeapSeconds), DateTime(1980, 1, 1)) == 19.0

    # Delete all objects.
    destroy_space_indices()

    # Obtain the timestamp for the following tests.
    cache_dir      = get_scratch!(SpaceIndices, "LeapSeconds")
    file_timestamp = joinpath(cache_dir, "leap_seconds.csv_timestamp")
    timestamp      = split(read(file_timestamp, String), '\n') |> first |> DateTime

    # If we fetch again, we should not download the file.
    @test_logs (
        :debug,
        "We found a file that is less than 365 days old (timestamp = $timestamp). Hence, we will use it."
    ) min_level = Logging.Debug match_mode = :any init_space_index(LeapSeconds)

    # Test the some data.
    @test get_space_index(Val(:LeapSeconds), DateTime(1000, 1, 1)) == 11.0
    @test get_space_index(Val(:LeapSeconds), DateTime(1979, 1, 1)) == 18.0
    @test get_space_index(Val(:LeapSeconds), DateTime(1980, 1, 1)) == 19.0
end

@testset "Expiry date" begin
    # Obtain the timestamp for the following tests.
    cache_dir      = get_scratch!(SpaceIndices, "LeapSeconds")
    file_timestamp = joinpath(cache_dir, "leap_seconds.csv_timestamp")
    timestamp      = split(read(file_timestamp, String), '\n') |> first |> DateTime
    new_timestamp  = timestamp - Day(196)

    # If the timestamp is 196 days old, we should not download the file.
    open(file_timestamp, "w") do f
        write(f, string(new_timestamp))
    end

    @test_logs (
        :debug,
        "We found a file that is less than 365 days old (timestamp = $new_timestamp). Hence, we will use it."
    ) min_level = Logging.Debug match_mode = :any init_space_index(LeapSeconds)

    # Test the some data.
    @test get_space_index(Val(:LeapSeconds), DateTime(1000, 1, 1)) == 11.0
    @test get_space_index(Val(:LeapSeconds), DateTime(1979, 1, 1)) == 18.0
    @test get_space_index(Val(:LeapSeconds), DateTime(1980, 1, 1)) == 19.0

    # Now we change the timestamp to be 365 days old. In this case, the file should be
    # downloaded again.
    new_timestamp  = timestamp - Day(365)
    open(file_timestamp, "w") do f
        write(f, string(new_timestamp))
    end

    @test_logs (
        :info,
        "Downloading the file 'leap_seconds.csv' from 'https://ronanarraes.com/space-indices/leap_seconds.csv'..."
    ) match_mode = :any init_space_index(LeapSeconds)

    # Test the some data.
    @test get_space_index(Val(:LeapSeconds), DateTime(1000, 1, 1)) == 11.0
    @test get_space_index(Val(:LeapSeconds), DateTime(1979, 1, 1)) == 18.0
    @test get_space_index(Val(:LeapSeconds), DateTime(1980, 1, 1)) == 19.0

    # If we set `force_download = true`, the file must be downloads.
    @test_logs (
        :info,
        "Downloading the file 'leap_seconds.csv' from 'https://ronanarraes.com/space-indices/leap_seconds.csv'..."
    ) match_mode = :any init_space_index(LeapSeconds, force_download = true)

    # Test the some data.
    @test get_space_index(Val(:LeapSeconds), DateTime(1000, 1, 1)) == 11.0
    @test get_space_index(Val(:LeapSeconds), DateTime(1979, 1, 1)) == 18.0
    @test get_space_index(Val(:LeapSeconds), DateTime(1980, 1, 1)) == 19.0
end
