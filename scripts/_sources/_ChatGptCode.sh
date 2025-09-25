#!/bin/sh
# Fill Hangar API downloader
# Fetches the latest build for a project/version

_fetch_latest_hangar_file() {
    endpoint="$1"
    project="$2"
    version="$3"
    platform="$4"

    # Call Hangar API to get version download
    response="$(curl -s -H 'accept: application/json' "$endpoint/api/v1/versions/$version/$platform/download")"

    # Extract the download URL from JSON
    download_url="$(echo "$response" | jq -r '.downloads[0].url')"

    if [ -z "$download_url" ] || [ "$download_url" = "null" ]; then
        echo "Failed to fetch Hangar download URL"
        return 1
    fi

    DEFAULT_DOWNLOAD_URL="$download_url"
}

_download_type_hangar() {
    read_args endpoint project version platform
    require_args endpoint project version platform

    _fetch_latest_hangar_file "$arg_endpoint" "$arg_project" "$arg_version" "$arg_platform"
    download "$DEFAULT_DOWNLOAD_URL" "$1"
}
