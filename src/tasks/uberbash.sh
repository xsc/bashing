#!/bin/bash

# <help>create standalone bash script</help>

TARGET_PATH="$PROJECT_ROOT/target"
TARGET_FILE="$TARGET_PATH/$ARTIFACT_ID-$ARTIFACT_VERSION.sh"
TARGET_FILE_COMPRESSED="$TARGET_PATH/$ARTIFACT_ID-$ARTIFACT_VERSION.gz.sh"

if ! mkdir -p "$TARGET_PATH" 2> /dev/null; then
    error "Could not create target directory: $TARGET_PATH";
    exit 1;
fi

echo "Creating $TARGET_FILE ..."
__run "compile" "--compact" -o "$TARGET_FILE"
if [[ "$?" != "0" ]]; then
    error "An Error occured while running task 'compile'."
    exit 1;
fi
success "Uberbash created successfully."
chmod +x "$TARGET_FILE" >& /dev/null

if [[ "$1" == "--compress" ]]; then
    echo "Compressing into $TARGET_FILE_COMPRESSED ..."
    echo "#!/bin/bash" > "$TARGET_FILE_COMPRESSED"
    echo 'tail -n +3 "$0" | gzip -d -n 2> /dev/null | bash -s "$@"; exit $?' >> "$TARGET_FILE_COMPRESSED"
    gzip -c -n "$TARGET_FILE" >> "$TARGET_FILE_COMPRESSED";
    success "Uberbash (compressed) created successfully."
    chmod +x "$TARGET_FILE_COMPRESSED" >& /dev/null
fi
exit 0
