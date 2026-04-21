#!/usr/bin/env bash
set -uo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
LOG_DIR="$ROOT_DIR/.logs"

SERVICE="${1:-}"

if [ ! -d "$LOG_DIR" ]; then
    echo "  No logs directory found. Start services first: make up"
    exit 1
fi

if [ -n "$SERVICE" ]; then
    if [ -f "$LOG_DIR/${SERVICE}.log" ]; then
        tail -f "$LOG_DIR/${SERVICE}.log"
    else
        echo "  No log file for service: $SERVICE"
        echo "  Available: $(ls "$LOG_DIR"/*.log 2>/dev/null | xargs -n1 basename | sed 's/\.log//' | tr '\n' ' ')"
        exit 1
    fi
else
    tail -f "$LOG_DIR"/*.log
fi
