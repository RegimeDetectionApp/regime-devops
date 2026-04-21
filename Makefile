.PHONY: up down health logs test run clean

# ── Local Development (native Python — no Docker) ─────────────────
up:
	@bash scripts/up.sh

down:
	@bash scripts/down.sh

health:
	@bash scripts/health.sh

logs:
	@bash scripts/logs.sh $(SERVICE)

# ── Testing ────────────────────────────────────────────────────────
test:
	@echo "Running smoke tests against live services..."
	@bash scripts/health.sh

# ── Pipeline ───────────────────────────────────────────────────────
run:
	@bash scripts/run-pipeline.sh $(TICKER)

# ── Cleanup ────────────────────────────────────────────────────────
clean:
	@bash scripts/down.sh
	rm -rf .venv .pids .logs gateway services run.py
