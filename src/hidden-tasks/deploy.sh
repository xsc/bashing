#!/usr/bin/env bash

# <help>create uberbash and copy to deploy path</help>

path="$1"
if [ -z "$path" ]; then path="$PROJECT_ROOT/bin"; fi

set -e
__run "uberbash"

src="$PROJECT_ROOT/target/$ARTIFACT_ID-$ARTIFACT_VERSION.sh"
if [ ! -s "$src" ]; then fatal "Could not find Uberbash."; fi

dst="$path/$ARTIFACT_ID"
if ! mkdir -p "$path"; then fatal "Could not create $path."; fi
verbose "Deploying to $dst ..."
cp "$src" "$dst" 2> /dev/null || fatal "Could not copy $src to $dst ...";
success "Deployed successfully."
