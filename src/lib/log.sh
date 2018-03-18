#!/usr/bin/env bash
#!require colorize

# Generic Logging Functions

function error() {
    echo -n "$(red "(ERROR)") " 1>&2
    echo "$@" 1>&2
}

function fatal() {
    error "$@";
    exit 1;
}

function success() {
    echo "$(green "$@")"
}

function verbose() {
    if [[ "$VERBOSE" != "no" ]] || [ -z "$VERBOSE" ]; then
        echo "$@"
    fi
}

function debug() {
    if [[ "$DEBUG" == "yes" ]]; then
        echo -n "$(yellow "(DEBUG)  ")";
        echo "$@";
    fi
}
