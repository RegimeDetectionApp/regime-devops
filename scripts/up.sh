#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$ROOT_DIR"

VENV_DIR="$ROOT_DIR/.venv"
PID_DIR="$ROOT_DIR/.pids"
LOG_DIR="$ROOT_DIR/.logs"

echo ""
echo "  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Regime Detection — Starting Services (native)"
echo "  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

mkdir -p "$PID_DIR" "$LOG_DIR"

# ── 1. Clone platform code if needed ────────────────────────────────
if [ ! -d "$ROOT_DIR/gateway" ] || [ ! -d "$ROOT_DIR/services" ]; then
    echo "[1/4] Cloning platform code..."
    TMPDIR=$(mktemp -d)
    git clone --depth 1 https://github.com/RegimeDetectionApp/regime-platform.git "$TMPDIR" 2>/dev/null
    cp -r "$TMPDIR/gateway" "$ROOT_DIR/gateway"
    cp -r "$TMPDIR/services" "$ROOT_DIR/services"
    cp "$TMPDIR/run.py" "$ROOT_DIR/run.py"
    rm -rf "$TMPDIR"
else
    echo "[1/4] Platform code present"
fi

# ── 2. Create venv + install deps (one-time) ───────────────────────
if [ ! -f "$VENV_DIR/bin/activate" ]; then
    echo "[2/4] Creating virtual environment..."
    python3 -m venv "$VENV_DIR"
fi

source "$VENV_DIR/bin/activate"

# Check if packages already installed
if ! python -c "import regime_detection_core" 2>/dev/null; then
    echo "[2/4] Installing dependencies (one-time)..."
    pip install --quiet --upgrade pip
    pip install --quiet \
        "fastapi>=0.104" \
        "uvicorn[standard]>=0.24" \
        "httpx>=0.25" \
        "python-jose[cryptography]>=3.3" \
        "numpy>=1.24" \
        "pandas>=2.0" \
        "scikit-learn>=1.3" \
        "hmmlearn>=0.3" \
        "yfinance>=0.2.30" \
        "matplotlib>=3.7" \
        "regime-market-data@git+https://github.com/RegimeDetectionApp/regime-market-data.git@main" \
        "regime-feature-engine@git+https://github.com/RegimeDetectionApp/regime-feature-engine.git@main" \
        "regime-detection-core@git+https://github.com/RegimeDetectionApp/regime-detection-core.git@main" \
        "regime-backtesting@git+https://github.com/RegimeDetectionApp/regime-backtesting.git@main" \
        "regime-visualization@git+https://github.com/RegimeDetectionApp/regime-visualization.git@main"
    echo "       Dependencies cached in .venv/ — won't download again."
else
    echo "[2/4] Dependencies already installed"
fi

# ── 3. Kill any existing services ───────────────────────────────────
echo "[3/4] Cleaning up old processes..."
for pidfile in "$PID_DIR"/*.pid; do
    [ -f "$pidfile" ] || continue
    pid=$(cat "$pidfile")
    kill "$pid" 2>/dev/null || true
    rm "$pidfile"
done

# ── 4. Start all services ──────────────────────────────────────────
echo "[4/4] Starting services..."

export MPLBACKEND=Agg
export PYTHONPATH="$ROOT_DIR"

SERVICES=(
    "market_data:7001"
    "feature_engine:7002"
    "detection_core:7003"
    "backtesting:7004"
    "visualization:7005"
)

for entry in "${SERVICES[@]}"; do
    SVC="${entry%%:*}"
    PORT="${entry##*:}"
    uvicorn "services.${SVC}.app:app" \
        --host 0.0.0.0 --port "$PORT" \
        --log-level info \
        > "$LOG_DIR/${SVC}.log" 2>&1 &
    echo $! > "$PID_DIR/${SVC}.pid"
    printf "  %-20s → port %s  (pid %s)\n" "$SVC" "$PORT" "$!"
done

# Gateway last (depends on others)
sleep 1

export MARKET_DATA_URL="http://localhost:7001"
export FEATURE_ENGINE_URL="http://localhost:7002"
export DETECTION_CORE_URL="http://localhost:7003"
export BACKTESTING_URL="http://localhost:7004"
export VISUALIZATION_URL="http://localhost:7005"

uvicorn "gateway.app:app" \
    --host 0.0.0.0 --port 7000 \
    --log-level info \
    > "$LOG_DIR/gateway.log" 2>&1 &
echo $! > "$PID_DIR/gateway.pid"
printf "  %-20s → port %s  (pid %s)\n" "gateway" "7000" "$!"

echo ""
echo "  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  Gateway:        http://localhost:7000"
echo "  Market Data:    http://localhost:7001"
echo "  Feature Engine: http://localhost:7002"
echo "  Detection Core: http://localhost:7003"
echo "  Backtesting:    http://localhost:7004"
echo "  Visualization:  http://localhost:7005"
echo ""
echo "  Logs:   .logs/<service>.log"
echo "  Stop:   make down"
echo "  Health: make health"
echo ""
echo "  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
