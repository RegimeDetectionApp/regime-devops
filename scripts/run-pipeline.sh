#!/usr/bin/env bash
set -euo pipefail

# Run the full regime detection pipeline against live services
GATEWAY="http://localhost:6000"
TICKER="${1:-^GSPC}"

echo ""
echo "  Running pipeline for: $TICKER"
echo "  Gateway: $GATEWAY"
echo ""

# Check gateway is up
if ! curl -sf "$GATEWAY/health" > /dev/null 2>&1; then
    echo "Error: Gateway not running. Start services with ./scripts/up.sh first."
    exit 1
fi

# Trigger pipeline
echo "[1/4] Fetching market data..."
curl -s "$GATEWAY/api/market-data/fetch?ticker=$TICKER" | python -m json.tool | head -5

echo "[2/4] Computing features..."
curl -s "$GATEWAY/api/features/build?ticker=$TICKER" | python -m json.tool | head -5

echo "[3/4] Detecting regimes..."
curl -s "$GATEWAY/api/detection/predict?ticker=$TICKER" | python -m json.tool | head -10

echo "[4/4] Running backtest..."
curl -s "$GATEWAY/api/backtest/run?ticker=$TICKER" | python -m json.tool | head -15

echo ""
echo "Pipeline complete for $TICKER"
echo ""
