#!/usr/bin/env bash

# Parameters
task="$1"
hidden="no"
if [ "$task" == "--hidden" ]; then task="$2"; hidden="yes"; fi
if [ -z "$task" ]; then fatal "Usage: new.task [--hidden] <Task>"; fi

# Path to File
file="$(echo "$task" | tr '.' '/').sh"
if [ "$hidden" == "yes" ]; then path="$HID_PATH/$file";
else path="$CLI_PATH/$file"; fi
dir="$(dirname "$path")"

# Create
if ! mkdir -p "$dir"; then fatal "Could not create Directory: $dir"; fi
if [ -e "$path" ]; then fatal "File does already exist: $path"; fi
if ! touch "$path"; then fatal "Could not create File: $path"; fi

echo "#!/usr/bin/env bash" > "$path"
echo "" >> "$path"
echo "# Run with: 'bashing run $task'" >> "$path"
echo "" >> "$path" >> "$path"
echo "echo \"Hello from Task '$task'\"" >> "$path"

success "Created Task '$task'."
