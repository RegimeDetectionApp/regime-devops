#!/usr/bin/env bash
set -uo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PID_DIR="$ROOT_DIR/.pids"

echo ""
echo "  Stopping services..."

count=0
for pidfile in "$PID_DIR"/*.pid; do
    [ -f "$pidfile" ] || continue
    svc=$(basename "$pidfile" .pid)
    pid=$(cat "$pidfile")
    if kill "$pid" 2>/dev/null; then
        printf "  %-20s stopped (pid %s)\n" "$svc" "$pid"
        count=$((count + 1))
    fi
    rm "$pidfile"
done

if [ $count -eq 0 ]; then
    echo "  No services were running."
else
    echo ""
    echo "  $count services stopped."
fi
echo ""
