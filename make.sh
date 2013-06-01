#!/bin/bash

SELF=$(cd "$(dirname "$0")" && pwd)
BASHING="$SELF/build/bashing.dev"
OUT="$SELF/build/bashing-0.1.0-SNAPSHOT"

$BASHING compile --compact -o "$OUT" && chmod u+x "$OUT"
