#!/bin/sh
# Hangar API downloader
# See https://docs.papermc.io/hangar/api

_fetch_latest_hangar_file() {
    endpoint="$1"
    project="$2"   # e.g. henkelmax/SimpleVoiceChat
    version="$3"   # "latest" or explicit version like 2.5.14
    platform="$4"  # Paper / Velocity / Waterfall
    channel="Release"

    if [ "$version" = "latest" ]; then
        debug "fetch: $endpoint/api/v1/projects/$project/latest?channel=$channel"
        response="$(fetch -so- "$endpoint/api/v1/projects/$project/latest?channel=$channel")"
        version="$(echo "$response" | jq -r '.name')"
        if [ -z "$version" ] || [ "$version" = "null" ]; then
            echo "❌ Failed to fetch latest version for $project"
            return 1
        fi
    fi

    DEFAULT_DOWNLOAD_URL="$endpoint/api/v1/projects/$project/versions/$version/$platform/download"
}

_download_type_hangar() {
    read_args endpoint project version platform
    require_args endpoint project version platform

    _fetch_latest_hangar_file "$arg_endpoint" "$arg_project" "$arg_version" "$arg_platform"
    download "$DEFAULT_DOWNLOAD_URL" "$1"
}
