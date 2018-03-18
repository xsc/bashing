#!/usr/bin/env bash

# <help>create standalone bash script</help>

TARGET_PATH="$PROJECT_ROOT/target"
TARGET_FILE="$TARGET_PATH/$ARTIFACT_ID-$ARTIFACT_VERSION.sh"
TARGET_FILE_COMPRESSED="$TARGET_PATH/$ARTIFACT_ID-$ARTIFACT_VERSION.gz.sh"
TARGET_FILE_DEBUG="$TARGET_PATH/$ARTIFACT_ID-$ARTIFACT_VERSION.debug.sh"
COMPRESS="no"
DEBUGGABLE="no"

if ! mkdir -p "$TARGET_PATH" 2> /dev/null; then
    error "Could not create target directory: $TARGET_PATH";
    exit 1;
fi

while [ $# -gt 0 ]; do
    case "$1" in
        "--compress") COMPRESS="yes";;
        "--with-debug") DEBUGGABLE="yes";;
        *) ;;
    esac
    shift
done

verbose "Creating $TARGET_FILE ..."
__run "compile" "--compact" -o "$TARGET_FILE"
if [[ "$?" != "0" ]]; then fatal "An error occured while running task 'compile'."; fi
success "Uberbash created successfully."
chmod +x "$TARGET_FILE" >& /dev/null

if [[ "$DEBUGGABLE" == "yes" ]]; then
    echo "Creating $TARGET_FILE_DEBUG ..."
    cat "$TARGET_FILE" | debugBash > "$TARGET_FILE_DEBUG"
    if [[ "$?" != "0" ]]; then fatal "An error occured while running task 'compile'."; fi
    success "Uberbash (debuggable) created successfully."
    chmod +x "$TARGET_FILE_DEBUG" >& /dev/null
fi

if [[ "$COMPRESS" == "yes" ]]; then
    verbose "Compressing into $TARGET_FILE_COMPRESSED ..."
    echo "#!/usr/bin/env bash" > "$TARGET_FILE_COMPRESSED"
    echo 'tail -n +3 "$0" | gzip -d -n 2> /dev/null | bash -s "$@"; exit $?' >> "$TARGET_FILE_COMPRESSED"
    gzip -c -n "$TARGET_FILE" >> "$TARGET_FILE_COMPRESSED";
    if [[ "$?" != "0" ]]; then fatal "An error occured while running task 'compile'."; fi
    success "Uberbash (compressed) created successfully."
    chmod +x "$TARGET_FILE_COMPRESSED" >& /dev/null
fi
exit 0
