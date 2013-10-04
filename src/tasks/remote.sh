#!/bin/bash
# <help>add an URL to a bashing Git repository</help>

subtask="$1"
if [ -z "$subtask" ]; then fatal "Usage: remote [[add|install] <name> <git repository> | remove <name>]"; fi
shift
__run "remote.$subtask" "$@"
