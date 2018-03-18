#!/usr/bin/env bash

# Checks
check_tools

# Generate Config Dir
mkdir -p "$SETTINGS_DIR" 2> /dev/null || fatal "Could not initialize directory: $SETTINGS_DIR";

# Dev Paths
PROJECT_FILE="$PROJECT_ROOT/$BASHING_PROJECT_FILE"
SRC_PATH="$PROJECT_ROOT/src"
CLI_PATH="$SRC_PATH/tasks"
LIB_PATH="$SRC_PATH/lib"
HID_PATH="$SRC_PATH/hidden-tasks"

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
        "compile"|"uberbash"|"run"|"deploy"|"install")
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
