#!/usr/bin/env bash

# <help>initialize directories for a bashing project</help>

# ----------------------------------------------------------
# Parameters
ARTIFACT="$1"
INIT_PATH="$2"

if [ -z "$ARTIFACT" ]; then
    error "Usage: new <Artifact ID> [<Path>]"
    exit 1;
fi
if [ -z "$INIT_PATH" ]; then INIT_PATH="./$ARTIFACT"; fi
if [ -d "$INIT_PATH" ]; then
    error "$INIT_PATH already exists.";
    exit 1;
fi

SRC="$INIT_PATH/src"
TASKS="$SRC/tasks"
LIB="$SRC/lib"
HIDDEN="$SRC/hidden-tasks"
PROJ="$INIT_PATH/bashing.project"

# ----------------------------------------------------------
# Create Directories/Files
echo "Initializing $INIT_PATH ..."

for dir in "$TASKS" "$LIB" "$HIDDEN"; do
    if ! mkdir -p "$dir"; then fatal "Could not create Directory: $dir"; fi
done

if ! touch "$INIT_PATH/.gitignore"; then fatal "Could not create '.gitignore'."; fi
for txt in "target/" "*.swp" "*~"; do
    echo "$txt" >> "$INIT_PATH/.gitignore"
done

if ! touch "$PROJ"; then fatal "Could not create File: $PROJ"; fi
echo "$ARTIFACT 0.1.0-SNAPSHOT" >> "$PROJ"
echo "" >> "$PROJ"
echo "YOUR DESCRIPTION HERE." >> "$PROJ"

path="$TASKS/hello.sh"
if ! touch "$path"; then fatal "Could not create File: $path"; fi
echo "#!/usr/bin/env bash" > "$path"
echo "" >> "$path"
echo "# Run with: 'bashing run hello'" >> "$path"
echo "" >> "$path" >> "$path"
echo "echo \"Hello, World!\"" >> "$path"

# ----------------------------------------------------------
# Done
success "Successfully initialized '$INIT_PATH'."
exit 0
