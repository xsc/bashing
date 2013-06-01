#!/bin/bash
#!require colorize

# Generic Logging Functions

function error() {
    echo -n "$(red "(ERROR)") " 1>&2
    echo "$@" 1>&2
}
