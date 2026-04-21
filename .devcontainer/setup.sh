#!/usr/bin/env bash
set -euo pipefail

echo "Setting up Regime Detection Platform..."

# Install git (needed for pip installs from GitHub)
sudo apt-get update -qq && sudo apt-get install -y -qq gcc g++ > /dev/null 2>&1

# The up.sh script handles venv creation, dependency installation,
# and service startup. We just need to ensure it can run.
chmod +x scripts/*.sh

echo "Setup complete. Services will start automatically."
