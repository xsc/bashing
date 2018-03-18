#!/usr/bin/env bash

# Project File Examination

RX_ID='[a-zA-Z][a-zA-Z0-9_-]*'
RX_INT='\(0\|[1-9][0-9]*\)'
RX_VERSION="$RX_INT\\.$RX_INT\\.$RX_INT\(-$RX_ID\\)\\?"
RX_ARTIFACT_STRING="^\\s*\\(\\($RX_ID\\)\\/\\)\\?\\($RX_ID\\)\\s\\+\\($RX_VERSION\\)\\s*$"

function artifactString() { head -n 1 "$PROJECT_FILE"; }
function artifactGet() { echo "$1" | sed -n "s/$RX_ARTIFACT_STRING/\\$2/p"; }
function artifactVersion() { artifactGet "$1" 4; }
function artifactId() { artifactGet "$1" 3; }
function artifactGroupId() { artifactGet "$1" 2; }
