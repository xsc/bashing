#!/usr/bin/env bash
# <help>handle remote bashing applications</help>

subtask="$1"
if [ -z "$subtask" ]; then fatal "Usage: remote [[add|install] <name> <git repository> | remove <name>]"; fi
shift
__run "remote.$subtask" "$@"
