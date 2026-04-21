#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$ROOT_DIR"

echo ""
echo "  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Regime Detection — Starting Services"
echo "  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Clone platform code if not present
if [ ! -d "gateway" ] || [ ! -d "services" ]; then
    echo "[1/4] Cloning platform code..."
    git clone --depth 1 https://github.com/RegimeDetectionApp/regime-platform.git /tmp/regime-platform-src 2>/dev/null || true
    cp -r /tmp/regime-platform-src/gateway ./gateway 2>/dev/null || true
    cp -r /tmp/regime-platform-src/services ./services 2>/dev/null || true
    cp /tmp/regime-platform-src/run.py ./run.py 2>/dev/null || true
    rm -rf /tmp/regime-platform-src
else
    echo "[1/4] Platform code present"
fi

# Build base image
echo "[2/4] Building base image..."
docker build -t regime-base:latest -f docker/base/Dockerfile . 2>&1 | tail -3

# Build and start all services
echo "[3/4] Building service images..."
docker compose build 2>&1 | tail -5

echo "[4/4] Starting services..."
docker compose up -d

echo ""
echo "  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Services starting up..."
echo ""
echo "  Gateway:        http://localhost:6000"
echo "  Market Data:    http://localhost:6001"
echo "  Feature Engine: http://localhost:6002"
echo "  Detection Core: http://localhost:6003"
echo "  Backtesting:    http://localhost:6004"
echo "  Visualization:  http://localhost:6005"
echo ""
echo "  Run './scripts/health.sh' to check status"
echo "  Run './scripts/down.sh' to stop"
echo "  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
