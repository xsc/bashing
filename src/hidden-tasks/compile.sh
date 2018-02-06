#!/usr/bin/env bash

#!require log
#!require io
#!require gen

# -------------------------------------------------------------------
# Data
BUILD_HEADER="yes"
BUILD_METADATA="yes"
BUILD_LIBRARY="yes"
BUILD_CLI="yes"
BUILD_HELP="yes"
COMPACT="no"
OUTPUT_FILE=""

# -------------------------------------------------------------------
# Parse Command Line
while [ $# -gt 0 ]; do
    arg="$1"
    case "$arg" in
        "--out"|"-o") shift; OUTPUT_FILE="$1";;
        "--compact") COMPACT="yes";;
        "--no-metadata") BUILD_METADATA="no";;
        "--no-lib") BUILD_LIBRARY="no";;
        "--no-cli") BUILD_CLI="no";;
        "--no-header") BUILD_HEADER="no";;
        --*)
            error "Invalid command line argument: $arg"
            exit 1
            ;;
        *)
            if [ -z "$PROJECT_ROOT" ]; then PROJECT_ROOT="$arg";
            else error "Invalid command line argument: $arg"; exit 1; fi
            ;;
    esac
    shift
done

# Check Parameters
if [ ! -z "$OUTPUT_FILE" ]; then
    OUTPUT_FILE="$(cd $(dirname "$OUTPUT_FILE") && pwd)/$(basename "$OUTPUT_FILE")"
    rm -f "$OUTPUT_FILE"
    if ! touch "$OUTPUT_FILE" 2> /dev/null; then
        error "Cannot write to given Output File: $OUTPUT_FILE.";
        exit 1;
    fi
    export OUT="$OUTPUT_FILE"
fi

# -------------------------------------------------------------------
# Generate
cd "$SRC_PATH"
if [[ "$BUILD_HEADER" == "yes" ]]; then generateHeader; fi
if [[ "$BUILD_METADATA" == "yes" ]]; then generateMetadata; fi
genInclude "init.sh"
if [[ "$BUILD_LIBRARY" == "yes" ]] && [ -d "$LIB_PATH" ]; then generateLibrary; fi
if [[ "$BUILD_CLI" == "yes" ]]; then generateCli; fi
genInclude "cleanup.sh"
if [[ "$BUILD_CLI" == "yes" ]]; then generateCliExit; fi
cd "$CWD"
