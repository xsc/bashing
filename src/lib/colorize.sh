#!/usr/bin/env bash

# Generic Colorize Functions

RED="`tput setaf 1`"
GREEN="`tput setaf 2`"
YELLOW="`tput setaf 3`"
BLUE="`tput setaf 4`"
MAGENTA="`tput setaf 5`"
CYAN="`tput setaf 6`"
WHITE="`tput setaf 7`"
RESET="`tput sgr0`"

function colorize() {
    if [[ "$USE_COLORS" != "no" ]]; then
        c="$1"
        shift
        echo -n ${c}${@}${RESET};
    else
        shift
        echo -n "$@";
    fi
}

function green() { colorize "${GREEN}" "${@}"; }
function red() { colorize "${RED}" "${@}"; }
function yellow() { colorize "${YELLOW}" "${@}"; }
function blue() { colorize "${BLUE}" "${@}"; }
function magenta() { colorize "${MAGENTA}" "${@}"; }
function cyan() { colorize "${CYAN}" "${@}"; }
function white() { colorize "${WHITE}" "${@}"; }
