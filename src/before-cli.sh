#!/bin/bash

# Read Project File

GROUP_ID=""
ARTIFACT_ID=""
ARTIFAT_VERSION=""

if [[ "$1" == "compile" ]]; then
    s=$(artifactString)
    GROUP_ID=$(artifactGroupId "$s")
    ARTIFACT_ID=$(artifactId "$s")
    ARTIFACT_VERSION=$(artifactVersion "$s")
    if [ -z "$ARTIFACT_ID" -o -z "$ARTIFACT_VERSION" ]; then 
        error "Invalid Artifact String in $BASHING_PROJECT_FILE: $s";
        exit 1;
    fi
    if [ -z "$GROUP_ID" ]; then GROUP_ID="$ARTIFACT_ID"; fi
fi
