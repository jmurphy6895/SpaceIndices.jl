# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==========================================================================================
#
#   Function to download files into scratch space.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Download the file in `url` to `filename` using the scratch space `key`. If
# `force_download` is `true`, it will always download the file. Otherwise, it will avoid
# downloading it again if the file exists and a time period less than `redownload_period`
# has passed.
#
# The instant in which the file was obtained is written to a file with the prefix
# `_timestamp` using the default `DateTime` format.
function _download_file(
    url::String,
    key::String,
    filename::String;
    force_download::Bool = false,
    redownload_period::DatePeriod = Day(7)
)
    # Get the scratch space where the files are located.
    cache_dir          = @get_scratch!(key)
    filepath           = joinpath(cache_dir, filename)
    filepath_timestamp = joinpath(cache_dir, filename * "_timestamp")

    # We need to verify if we must re-download the data.
    download_file = false

    if force_download ||
        isempty(readdir(cache_dir)) ||
        !isfile(filepath) ||
        !isfile(filepath_timestamp)

        download_file = true

    else
        # In this case, we should read the time stamp and verify if the file must be
        # re-downloaded.
        try
            str       = read(filepath_timestamp, String)
            tokens    = split(str, '\n')
            timestamp = tokens |> first |> DateTime

            if now() >= timestamp + redownload_period
                download_file = true
            else
                @debug "We found an file that is less than $redownload_period old (timestamp = $timestamp). Hence, we will use it."
            end
        catch
            # If any error occurred, we will download the data again.
            download_file = true

        end
    end

    # If we need to re-download, we will rebuild the scratch space.
    if download_file
        @info "Downloading the file '$filename' from '$url'..."
        download(url, filepath)
        open(filepath_timestamp, "w") do f
            write(f, string(now()))
        end
    end

    # Return the file path.
    return filepath
end
