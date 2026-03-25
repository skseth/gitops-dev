#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

INFRA_DIR="$SCRIPT_DIR/../../../../infra"

cd "$INFRA_DIR" || exit

WORKER_PIDS=()
# Cleanup function to kill all background processes
# cleanup() {
#     echo -e "\nTerminating background tasks..."
#     # kill $(jobs -p) kills all background PIDs managed by this shell
#     kill $(jobs -p) 
#     exit
# }


cleanup() {
    echo -e "\n[Main] Shutdown signal received. Requesting workers to stop..."
    
    # 1. Send SIGTERM to all tracked background processes
    for pid in "${WORKER_PIDS[@]}"; do
        if kill -0 "$pid" 2>/dev/null; then
            kill -TERM "$pid"
        fi
    done

    # 2. Wait for background processes to finish
    # 'wait' without arguments waits for ALL children to exit
    wait
    echo "[Main] All workers exited gracefully. Goodbye."
    exit
}


infra_dirs=("mariadb" "minio")
action=${1:-run}
shift

for infra_dir in "${infra_dirs[@]}"; do
  echo "processing" 
  pushd "$infra_dir" || exit
  skaffold "$action" "$@" &
  WORKER_PIDS+=($!)
  popd || exit
done


# Trap signals for exit (Ctrl+C, termination, or normal script exit)
trap cleanup SIGINT SIGTERM EXIT

sleep 2

echo "Tasks started. Press Ctrl+C to exit and stop all tasks."

# Keep the script running to maintain the background processes
wait