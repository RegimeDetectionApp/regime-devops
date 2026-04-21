#!/usr/bin/env bash
set -uo pipefail

cd "$(dirname "$0")/.."

SERVICE="${1:-}"
if [ -n "$SERVICE" ]; then
    docker compose logs -f "$SERVICE"
else
    docker compose logs -f --tail=50
fi
