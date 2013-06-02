#!/bin/bash

# Read Project File

GROUP_ID=""
ARTIFACT_ID=""
ARTIFACT_VERSION=""

while [ $# -gt 0 ]; do
    case "$1" in
        "--debug")
            DEBUG="yes"
            shift
            ;;
        "compile"|"uberbash"|"run")
            s=$(artifactString)
            GROUP_ID=$(artifactGroupId "$s")
            ARTIFACT_ID=$(artifactId "$s")
            ARTIFACT_VERSION=$(artifactVersion "$s")
            if [ -z "$ARTIFACT_ID" -o -z "$ARTIFACT_VERSION" ]; then 
                error "Invalid Artifact String in $BASHING_PROJECT_FILE: $s";
                exit 1;
            fi
            if [ -z "$GROUP_ID" ]; then GROUP_ID="$ARTIFACT_ID"; fi
            debug "Artifact: $ARTIFACT_ID"
            debug "Group ID: $GROUP_ID"
            debug "Version:  $ARTIFACT_VERSION"
            debug "Root:     $PROJECT_ROOT"
            break;;
        *) break;;
    esac
done
