#!/bin/bash

#!require gen

# Run CLI script in context of Library, Setup and Shutdown.

CLI="$1"
if [ -z "$CLI" ]; then
    error "Usage: run <CLI Command> <Parameters>"
    exit 1;
fi

# Derive Script Path
SRC="$(echo "$CLI" | tr '.' '/').sh"
if [ ! -e "$CLI_PATH/$SRC" ]; then
    error "No such CLI File: $SRC"
    exit 1
fi

# Generate Script
generateStandaloneTask "$SRC" | bash -s "$@" &
wait "$!"
st="$?"
exit "$st"
