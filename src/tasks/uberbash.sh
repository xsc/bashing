#!/bin/bash

# Build a Bashing Project by automatically selecting the output path and filename.

TARGET_PATH="$PROJECT_ROOT/target"
TARGET_FILE="$TARGET_PATH/$ARTIFACT_ID-$ARTIFACT_VERSION.sh"

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

if [[ "$1" == "--compress" ]]; then
    echo "Compressing $TARGET_FILE ..."
    mv "$TARGET_FILE" "$TARGET_FILE.raw"
    echo "#!/bin/bash" > "$TARGET_FILE"
    echo 'tail -n +3 "$0" | gzip -d -n 2> /dev/null | bash -s "$@"; exit $?' >> "$TARGET_FILE"
    gzip -c -n "$TARGET_FILE.raw" >> "$TARGET_FILE";
    success "Uberbash (compressed) created successfully."
    rm "$TARGET_FILE.raw"
fi

chmod +x "$TARGET_FILE" >& /dev/null
exit 0
