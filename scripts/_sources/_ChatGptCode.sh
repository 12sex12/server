#!/bin/sh
# Fill Hangar API downloader
# Fetches the latest build for a project/version

_fetch_latest_hangar_file() {
    endpoint="$1"
    project="$2"   # e.g. henkelmax/SimpleVoiceChat
    version="$3"   # "latest" or explicit version
    platform="$4"  # e.g. Paper, Velocity, Waterfall
    channel="Release" # or Beta/Alpha if you prefer

    if [ "$version" = "latest" ]; then
        # Get latest version metadata
        response="$(curl -s -H 'accept: application/json' \
            "$endpoint/api/v1/projects/$project/latest?channel=$channel")"

        version="$(echo "$response" | jq -r '.name')"
        if [ -z "$version" ] || [ "$version" = "null" ]; then
            echo "Failed to fetch latest version for $project"
            return 1
        fi
    fi

    # Build direct download URL
    download_url="$endpoint/api/v1/projects/$project/versions/$version/$platform/download"
    DEFAULT_DOWNLOAD_URL="$download_url"
}

_download_type_hangar() {
    read_args endpoint project version platform
    require_args endpoint project version platform

    _fetch_latest_hangar_file "$arg_endpoint" "$arg_project" "$arg_version" "$arg_platform"
    download "$DEFAULT_DOWNLOAD_URL" "$1"
}
