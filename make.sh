#!/bin/bash

SELF=$(cd "$(dirname "$0")" && pwd)
BASHING="$SELF/build/bashing.dev"

$BASHING uberbash
