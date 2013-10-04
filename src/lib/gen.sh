#!/bin/bash

#!require io

# Code Generation/File Concatenation for Bashing

# ------------------------------------------------------------
# Header
function generateHeader() {
    print_out "#!/bin/bash"
    sep
    print_out "# $(head -c 45 /dev/zero | tr '\0' '-')"; 
    print_out "# Artifact:     $GROUP_ID/$ARTIFACT_ID"
    print_out "# Version:      $ARTIFACT_VERSION"
    print_out "# Date (UTC):   $(date -u)"
    print_out "# Generated by: bashing $BASHING_VERSION"
    print_out "# $(head -c 45 /dev/zero | tr '\0' '-')"; 
    sep
}

# ------------------------------------------------------------
# Metadata
function generateMetadata() {
    print_out "export __BASHING_VERSION='$BASHING_VERSION'"
    print_out "export __VERSION='$ARTIFACT_VERSION'"
    print_out "export __ARTIFACT_ID='$ARTIFACT_ID'"
    print_out "export __GROUP_ID='$GROUP_ID'"
    sep
}

# ------------------------------------------------------------
# Includes
function genInclude() {
    if [ -s "$SRC_PATH/$1" ]; then
        cd "$SRC_PATH"
        debug "Including File    ./$1 ..."
        includeBashFile "./$1" | redirect_out
        sep
        cd "$CWD"
    fi
}

# ------------------------------------------------------------
# Library
function includeLibFile() {
    local path=""
    while read -r path; do
        local fullPath=$(cd "$SRC_PATH/$(dirname "$path")" && pwd)/$(basename "$path");
        if bash -n "$fullPath" 1> /dev/null; then
            debug "Including Library $path ..."
            includeBashFile "$path" | redirect_out
            nl
        else
            return 1;
        fi
    done
    return 0
}

function generateLibrary() {
    comment "Library"
    nl
    cd "$SRC_PATH";
    find "./lib" -type f -name "*.sh" | sort | includeLibFile
    if [[ "$?" != "0" ]]; then exit 1; fi
    sep
    cd "$CWD";
}

# ------------------------------------------------------------
# CLI
function collectCliScripts() {
    if [ -d "$CLI_PATH" ]; then
        cd "$CLI_PATH"
        find "." -type f -name "*.sh" -not -size 0 | sort
        cd "$CWD"
    fi
    if [ -d "$HID_PATH" ]; then
        cd "$HID_PATH"
        find "." -type f -name "*.sh" -not -size 0 | sort
        cd "$CWD"
    fi
}

function toFn() {
    local n="$1"
    echo "cli_${n:2:-3}" | tr '/' '_' | sed 's/_+/_/g'
}

function toCliArg() {
    local n="$1"
    echo "${n:2:-3}" | tr '/' '.'
}

function includeCliFn() {
    local path="$1"
    local fnName=$(toFn "$path");
    local fullPath="$CLI_PATH/$path"
    local hidden="no"

    if [ -e "$fullPath" ] && [ -e "$HID_PATH/$path" ]; then
        fatal "Task and hidden Task of the same name: $path"
    else if [ -e "$HID_PATH/$path" ]; then
        local fullPath="$HID_PATH/$path";
        local hidden="yes"
    fi; fi

    # Checks
    if [[ "$fnName" == "cli_help" ]] && [[ "$BUILD_HELP" == "yes" ]]; then
        echo "WARN: CLI Function 'help' ($fullPath) overwrite built-in help." 1>&2;
        echo "WARN: Supply '--no-help' if you want to create your own help function." 1>&2;
    fi

    # Create
    if bash -n "$fullPath" 1> /dev/null; then
        if [[ "$hidden" == "no" ]]; then debug "Including Task    $path -> $fnName ..."; comment "./tasks/${path:2}";
        else debug "Including Task    $path -> $fnName (hidden) ..."; comment "./hidden-tasks/${path:2}"; fi
        print_out "function ${fnName}() {"
        includeBashFile "$fullPath" | redirect_out
        print_out '  return 0;'
        print_out "}"
        return 0;
    fi
    return 1;
}

function buildCliHandler() {
    local path="$1"
    local fnName=$(toFn "$path")
    local argName=$(toCliArg "$path")
    print_out "    \"$argName\") $fnName \"\$@\" & local pid=\"\$!\";;"
}

function buildCliHeader() {
    print_out "function __run() {"
    print_out '  local pid=""'
    print_out '  local status=255'
    print_out '  local cmd="$1"'
    genInclude "before-task.sh"
    print_out '  shift'
    print_out '  case "$cmd" in'
    print_out '    "") __run "help"; return $?;;'
}

function buildCliFooter() {
    print_out '    *) echo "Unknown Command: $cmd" 1>&2;;'
    print_out '  esac'
    print_out '  if [ ! -z "$pid" ]; then'
    print_out '      wait "$pid"'
    print_out '      local status=$?'
    print_out '  fi'
    genInclude "after-task.sh"
    print_out '  return $status'
    print_out "}"
}

function buildHelpTable() {
    local hlp="yes"
    local vrs="yes"
    for path in $@; do
        if [ -e "$CLI_PATH/$path" ]; then
            local argName=$(toCliArg "$path");
            local helpText=$(getMeta "$CLI_PATH/$path" "help")
            if [ -z "$helpText" ]; then helpText="(no help available)"; fi
            echo "$argName|:|$helpText"
            case "$argName" in
                "help") local hlp="no";;
                "version") local vrs="no";;
            esac
        fi
    done
    if [ "$hlp" == "yes" ]; then echo "help|:|display this help message"; fi
    if [ "$vrs" == "yes" ]; then echo "version|:|display version"; fi
}

function buildHelpFunction() {
    print_out '    "help")'
    print_out "      echo \"Usage: $ARTIFACT_ID <task> [...]\" 1>&2"
    print_out '      cat 1>&2 <<HELP'
    print_out ''
    buildHelpTable "$@" | column -s "|" -t\
        | sort\
        | sed 's/^/    /'\
        | redirect_out
    print_out ''
    print_out 'HELP'
    print_out '      status=0'
    print_out '      ;;'
}

function buildVersionFunction() {
    print_out '    "version")'
    print_out "      echo \"$ARTIFACT_ID $ARTIFACT_VERSION (bash \$BASH_VERSION)\""
    print_out '      status=0'
    print_out '      ;;'
}

function generateCli() {
    cliScripts=$(collectCliScripts);

    set -e
    comment "CLI Functions"
    nl
    for path in $cliScripts; do includeCliFn "$path"; done
    sep
    comment "Main Function"
    nl
    buildCliHeader
    for path in $cliScripts; do buildCliHandler "$path"; done
    if [[ "$BUILD_HELP" == "yes" ]]; then buildHelpFunction "$cliScripts"; fi
    buildVersionFunction
    buildCliFooter

    if [ -e "$SRC_PATH/main.sh" ]; then
        genInclude "main.sh";
    else
        print_out "__run \"\$@\""
    fi;

    print_out 'export __STATUS="$?"'
    sep
    cd "$CWD";
}

function generateCliExit() {
    print_out 'exit $__STATUS'
}

# ------------------------------------------------------------
# Standalone Task Generation

function generateStandaloneTask() {
    local task="$1"
    COMPACT="yes"
    OUT=""
    DEBUG="no"
    VERBOSE="no"
    generateHeader
    generateMetadata
    genInclude "init.sh"
    generateLibrary
    genInclude "before-task.sh"
    print_out 'shift'
    print_out 'function __run() { echo "__run not available when running CLI task directly!" 1>&2; exit 1; }'
    if [ -e "$CLI_PATH/$task" ]; then genInclude "tasks/$task";
    else genInclude "hidden-tasks/$task"; fi
    genInclude "after-task.sh"
    genInclude "cleanup.sh"
}
