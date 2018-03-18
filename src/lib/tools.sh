#!/usr/bin/env bash

# ---- SED
__SED_PATH="$(which sed)"

function check_sed() {
    local GSED=$(which gsed 2> /dev/null)

    if [ ! -z "$GSED" ]; then
        __SED_PATH="$GSED"
        return 0;
    fi

    $__SED_PATH --version >& /dev/null
    if [ ! $? -eq 0 ]; then
        fatal "Needs GNU's 'sed' to be installed."
        return 1
    fi
    return 0
}

function sed() {
    $__SED_PATH "$@"
}

# ---- Setup/Check
function check_tools() {
    check_sed
}
