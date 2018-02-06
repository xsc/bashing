#!/usr/bin/env bash

name="$1"

if [ -z "$name" ]; then fatal "Usage: remote remove <name>"; fi
if [ -e "$SETTINGS" ]; then
    sed -i "/^repo:$name=/d" "$SETTINGS"
    if [ "$?" != "0" ]; then fatal "Could not modify $SETTINGS correctly."; fi
fi
success "Removed Application: $name"
