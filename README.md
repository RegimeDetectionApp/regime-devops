# Regime Detection — DevOps

CI/CD pipelines and Docker orchestration for the Regime Detection microservices.

## Quick Start

```bash
# Start all 6 services locally
make up

# Check health
make health

# View logs
make logs

# Run the detection pipeline
make run TICKER=^GSPC

# Stop everything
make down
```

## Architecture

```
Gateway (6000) ─┬─ Market Data    (6001)
                 ├─ Feature Engine (6002)
                 ├─ Detection Core (6003)
                 ├─ Backtesting    (6004)
                 └─ Visualization  (6005)
```

## CI/CD Pipelines

| Workflow | Trigger | Description |
|----------|---------|-------------|
| `ci.yml` | Push/PR to main | Tests all 5 domain packages |
| `build-images.yml` | Push to main (docker/** changes) | Builds and pushes Docker images to GHCR |
| `deploy.yml` | Manual dispatch | Deploys to local (minikube) or production (AWS EKS) |

## Repository Map

| Repo | Purpose |
|------|---------|
| **regime-devops** (this) | CI/CD, Docker Compose, operational scripts |
| [regime-platform](https://github.com/RegimeDetectionApp/regime-platform) | FastAPI gateway + service application code |
| [regime-infra](https://github.com/RegimeDetectionApp/regime-infra) | Terraform (AWS) + Kubernetes manifests |
| [regime-detection-core](https://github.com/RegimeDetectionApp/regime-detection-core) | Gaussian HMM fitting and regime detection |
| [regime-feature-engine](https://github.com/RegimeDetectionApp/regime-feature-engine) | 7-feature engineering pipeline |
| [regime-backtesting](https://github.com/RegimeDetectionApp/regime-backtesting) | Strategy simulation and performance metrics |
| [regime-visualization](https://github.com/RegimeDetectionApp/regime-visualization) | Dark-theme publication-quality plots |
| [regime-market-data](https://github.com/RegimeDetectionApp/regime-market-data) | Yahoo Finance data acquisition |

## Scripts

| Script | Description |
|--------|-------------|
| `scripts/up.sh` | Build and start all services |
| `scripts/down.sh` | Stop all services |
| `scripts/health.sh` | Check service health endpoints |
| `scripts/logs.sh [service]` | Tail logs (all or specific service) |
| `scripts/run-pipeline.sh [ticker]` | Run detection pipeline via gateway API |
