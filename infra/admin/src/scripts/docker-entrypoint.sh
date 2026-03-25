#!/usr/bin/env bash

. ./db-script.sh

set -euo pipefail

# Trap SIGTERM and any other relevant signals
cleanup() {
    echo "Received shutdown signal (SIGTERM). Performing graceful cleanup..."
    # Your cleanup logic here (e.g., stopping services, flushing data)

    # Forward the signal to the background process
    if [ -n "$CHILD_PID" ] && kill -0 "$CHILD_PID" 2>/dev/null; then
        kill -15 "$CHILD_PID"
        wait "$CHILD_PID"
    fi
    echo "Cleanup complete. Exiting."
    exit 0
}

trap cleanup SIGTERM SIGINT

echo "Starting database initialization script from directory $PWD ..."

# Run your primary application/task in the background
# Replace `your_command_here` with the actual command to start your application
"$@" &
CHILD_PID=$!
echo "Application started in the background with PID: $CHILD_PID"

# Wait for the background process to finish
wait "$CHILD_PID"
echo "Application finished. Container will now exit."