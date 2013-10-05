#!/bin/bash

# ----------------------------------------------------------------
# Write Functions for bashing. They check if a variable $OUT is set,
# printing to the path given by it, using stdout otherwise.
# Another Option is $COMPACT which removes comments from the output.

function print_out() {
    if [ -z "$OUT" ]; then
        echo "$@";
    else
        echo "$@" >> "$OUT"
    fi
}

function redirect_out() {
    local line=""
    while IFS='' read -r line; do
        print_out "$line";
    done
}

function sep() { 
    if [[ "$COMPACT" != "yes" ]]; then
        print_out -n "# ";  
        print_out "$(head -c 45 /dev/zero | tr '\0' '-')"; 
    fi
}
function comment() { 
    if [[ "$COMPACT" != "yes" ]]; then print_out "# $@"; fi; 
}

function nl() { 
    if [[ "$COMPACT" != "yes" ]]; then print_out ""; fi; 
}

# ----------------------------------------------------------------
# This always writes to stdout
function includeBashFile() {
    if [ -s "$1" ] && bash -n "$1"; then
        if [[ "$PLAIN" == "yes" ]]; then
            cat "$1";
        else if [[ "$COMPACT" == "yes" ]]; then
            sed '/^\s*#.*$/d' "$1" | sed '/^\s*$/d';
        else
            echo "# $1";
            sed '/^\s*#.*$/d' "$1";
        fi; fi;
    fi
}

function includeBashFileIndent() {
    local indent="$2"
    includeBashFile "$1" | sed "s/^/$indent/"
}
