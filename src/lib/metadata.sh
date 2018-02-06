#!/usr/bin/env bash

# Read metadata from source files. Metadata is identified by
# XML tags in commented lines.

function getMeta() {
    local path="$1"
    local key="$2"
    if  [ ! -s "$1" ]; then return 1; fi

    sed '/^\s*$/d' "$path"\
        | sed '/^\s*\([^#]\|#!\)/d'\
        | sed 's/^\s*# \?//'\
        | sed -n "/<$key>/,\$p"\
        | sed -n "0,/<\/$key>/p"\
        | sed "s/<\/\?$key>//g"
}
