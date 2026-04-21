.PHONY: up down health logs build test clean

# ── Local Development ──────────────────────────────────────────────
up:
	@bash scripts/up.sh

down:
	@bash scripts/down.sh

health:
	@bash scripts/health.sh

logs:
	@bash scripts/logs.sh $(SERVICE)

build:
	docker build -t regime-base:latest -f docker/base/Dockerfile .
	docker compose build

# ── Testing ────────────────────────────────────────────────────────
test:
	@echo "Running smoke tests against live services..."
	@bash scripts/health.sh

# ── Pipeline ───────────────────────────────────────────────────────
run:
	@bash scripts/run-pipeline.sh $(TICKER)

# ── Cleanup ────────────────────────────────────────────────────────
clean:
	docker compose down -v --rmi local
	rm -rf gateway services run.py
