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
chmod +x "$TARGET_FILE" >& /dev/null
success "Uberbash created successfully."
exit 0
