#!/bin/bash

#!require gen

# Run CLI script in context of Library, Setup and Shutdown.

CLI="$1"
if [ -z "$CLI" ]; then
    error "Usage: run <CLI Command> <Parameters>"
    exit 1;
fi
shift

# Derive Script Path
SRC="$(echo "$CLI" | tr '.' '/').sh"
if [ ! -e "$CLI_PATH/$SRC" ]; then
    error "No such CLI File: $SRC"
    exit 1
fi

# Generate Script
COMPACT="yes"
OUT="$(mktemp)"
generateHeader
generateMetadata
genInclude "setup.sh"
generateLibrary
genInclude "before-cli.sh"
genInclude "cli/$SRC"
genInclude "after-cli.sh"
genInclude "shutdown.sh"

# Run Script
cat "$OUT" | bash -s "$@" &
wait "$!"
st="$?"
rm "$OUT"
exit "$st"
