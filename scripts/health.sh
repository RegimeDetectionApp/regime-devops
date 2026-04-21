#!/usr/bin/env bash
set -uo pipefail

SERVICES=(
    "Gateway:6000"
    "Market Data:6001"
    "Feature Engine:6002"
    "Detection Core:6003"
    "Backtesting:6004"
    "Visualization:6005"
)

echo ""
echo "  Service Health Check"
echo "  ────────────────────────────────────────"

ALL_OK=true
for entry in "${SERVICES[@]}"; do
    NAME="${entry%%:*}"
    PORT="${entry##*:}"
    if curl -sf "http://localhost:${PORT}/health" > /dev/null 2>&1; then
        printf "  %-20s \033[1;32m● healthy\033[0m  (port %s)\n" "$NAME" "$PORT"
    else
        printf "  %-20s \033[1;31m● down\033[0m     (port %s)\n" "$NAME" "$PORT"
        ALL_OK=false
    fi
done

echo "  ────────────────────────────────────────"
if $ALL_OK; then
    echo "  All services healthy"
else
    echo "  Some services are not responding"
fi
echo ""
