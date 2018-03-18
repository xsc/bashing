#!/usr/bin/env bash

name="$1"
repo="$2"

set -e

if [ -z "$name" ]; then fatal "Usage: remote install <name> [<git repository>]"; fi
if [ -z "$repo" ]; then repo=$(grep "^repo:$name=" "$SETTINGS" 2> /dev/null | sed "s/^repo:$name=//" | head -n 1); fi
if [ -z "$repo" ]; then fatal "Cannot resolve Remote Application: $name"; fi

#
REPO_DIR="$SETTINGS_DIR/remote"
mkdir -p "$REPO_DIR" 2> /dev/null || fatal "Could not initialize Remote Application Cache: $REPO_DIR"

#
APP="$REPO_DIR/$name"
which git >& /dev/null || fatal "Missing dependency: git"

verbose "Fetching bashing Project ($APP) ..."
if [ -d "$APP" ]; then
    cd "$APP";
    git pull
else 
    git clone "$repo" "$APP"
    cd "$APP"
fi

#
if [ ! -e "$APP/$BASHING_PROJECT_FILE" ]; then fatal "Not a bashing project at: $APP"; fi
PROJECT_ROOT="$APP"
__run "install"
