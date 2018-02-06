#!/usr/bin/env bash

name="$1"
repo="$2"

set -e

if [ -z "$name" -o -z "$repo" ]; then fatal "Usage: remote add <name> <git repository>"; fi
if [ -e "$SETTINGS" ] && grep -q "^repo:$name=" "$SETTINGS"; then fatal "Remote Application already in $SETTINGS: $name"; fi 

echo "repo:$name=$repo" >> "$SETTINGS"
success "Added Application: $name"
