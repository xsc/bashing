#!/bin/bash

#!require log

# Initialize Directories for a Bashing Project

# ----------------------------------------------------------
# Parameters
ARTIFACT="$1"
INIT_PATH="$2"

if [ -z "$ARTIFACT" ]; then
    error "Usage: init <Artifact ID> [<Path>]"
    exit 1;
fi
if [ -z "$INIT_PATH" ]; then INIT_PATH="./$ARTIFACT"; fi
if [ -d "$INIT_PATH" ]; then
    error "$INIT_PATH already exists.";
    exit 1;
fi

# ----------------------------------------------------------
# Create Directories/Files
echo "Initializing $INIT_PATH ..."

if ! mkdir -p "$INIT_PATH/src/cli" || ! mkdir -p "$INIT_PATH/src/lib"; then
    error "Could not create Directories 'src/cli' and 'src/lib'."
    exit 1;
fi

if ! touch "$INIT_PATH/.gitignore"; then
    error "Could not create '.gitignore'."
    exit 1;
fi
for txt in "target/"; do
    echo "$txt" >> "$INIT_PATH/.gitignore"
done

if ! touch "$INIT_PATH/bashing.project"; then
    error "Could not creat 'bashing.project'."
    exit 1;
fi
echo "$ARTIFACT 0.1.0-SNAPSHOT" >> "$INIT_PATH/bashing.project"

h="$INIT_PATH/src/cli/hello.sh";
if touch "$h"; then
    echo "#!/bin/bash" > "$h"
    echo "" >> "$h"
    echo "# Run this Script with:" >> "$h"
    echo "#" >> "$h"
    echo "#  cd path/to/$ARTIFACT" >> "$h"
    echo "#  bashing uberbash" >> "$h"
    echo "#  ./target/$ARTIFACT-<Version>.sh hello" >> "$h"
    echo "" >> "$h"
    echo 'echo "Hello World!"' >> "$h"
fi

# ----------------------------------------------------------
# Done
success "Successfully initialized '$INIT_PATH'."
exit 0
