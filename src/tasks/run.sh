#!/usr/bin/env bash
# <help>run task in the project's context</help>

# Run CLI script in context of Library, Setup and Shutdown.

CLI="$1"
if [ -z "$CLI" ]; then
    error "Usage: run <CLI Command> <Parameters>"
    exit 1;
fi

# Derive Script Path
SRC="$(echo "$CLI" | tr '.' '/').sh"
path="$CLI_PATH/$SRC"
if [ ! -e "$path" -a -e "$HID_PATH/$SRC" ]; then path="$HID_PATH/$SRC"; fi
if [ ! -e "$path" ]; then fatal "No such Task: $CLI"; fi

# Generate Script
generateStandaloneTask "$SRC" | bash -s "$@" &
wait "$!"
st="$?"
debug "Task exitted with status $st."
exit "$st"
