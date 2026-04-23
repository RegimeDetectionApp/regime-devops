# Reusable Workflows for RegimeDetectionApp

This directory contains centralized, reusable GitHub Actions workflows that can be called from any repository in the **RegimeDetectionApp** organization.

## Available Workflows

### 🧪 Python Tests (`reusable-python-tests.yml`)
**Purpose:** Run Python tests with coverage reporting

**Inputs:**
- `python-version` (default: `'3.11'`) - Python version to use
- `test-suite` (default: `'all'`) - Test suite: `all`, `unit`, or `integration`
- `source-dirs` (default: `'src tests'`) - Space-separated source directories
- `requirements-file` (default: `'requirements.txt'`) - Requirements file path
- `verbose` (default: `false`) - Enable verbose test output

**Outputs:**
- `test-result` - Test execution result
- `coverage` - Coverage percentage

**Example usage:**
```yaml
jobs:
  test:
    uses: RegimeDetectionApp/regime-devops/.github/workflows/reusable-python-tests.yml@main
    with:
      python-version: '3.11'
      test-suite: 'all'
      source-dirs: 'src regime_detection'
```

---

### 🔍 Linting (`reusable-lint.yml`)
**Purpose:** Run code quality checks (ruff, black, mypy)

**Inputs:**
- `python-version` (default: `'3.11'`) - Python version to use
- `source-dirs` (default: `'src tests'`) - Space-separated source directories
- `ruff-config` (default: `'pyproject.toml'`) - Ruff config file path
- `run-mypy` (default: `true`) - Enable mypy type checking

**Example usage:**
```yaml
jobs:
  lint:
    uses: RegimeDetectionApp/regime-devops/.github/workflows/reusable-lint.yml@main
    with:
      source-dirs: 'src tests dashboard'
      run-mypy: true
```

---

### 🔒 Security Scan (`reusable-security.yml`)
**Purpose:** Run security checks (bandit, safety)

**Inputs:**
- `python-version` (default: `'3.11'`) - Python version to use
- `source-dirs` (default: `'src'`) - Space-separated source directories
- `requirements-file` (default: `'requirements.txt'`) - Requirements file path
- `bandit-config` (default: `'pyproject.toml'`) - Bandit config file path

**Example usage:**
```yaml
jobs:
  security:
    uses: RegimeDetectionApp/regime-devops/.github/workflows/reusable-security.yml@main
    with:
      source-dirs: 'src api'
```

---

### 🐳 Docker Build (`reusable-docker.yml`)
**Purpose:** Build and push multi-platform Docker images

**Inputs:**
- `image-name` (required) - Docker image name (without registry prefix)
- `dockerfile` (default: `'Dockerfile'`) - Path to Dockerfile
- `context` (default: `'.'`) - Build context directory
- `platforms` (default: `'linux/amd64,linux/arm64'`) - Target platforms
- `push` (default: `false`) - Push image to registry
- `registry` (default: `'ghcr.io'`) - Container registry URL

**Example usage:**
```yaml
jobs:
  docker:
    uses: RegimeDetectionApp/regime-devops/.github/workflows/reusable-docker.yml@main
    with:
      image-name: 'regime-detection-model'
      push: true
```

---

## How to Use in Your Repo

### 1. Create a workflow file in your repo

Create `.github/workflows/ci.yml`:

```yaml
name: CI Pipeline

on:
  workflow_dispatch:
    inputs:
      test_suite:
        type: choice
        options: [all, unit, integration]
        default: all
      python_version:
        type: choice
        options: ['3.10', '3.11', '3.12']
        default: '3.11'
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  lint:
    name: 🔍 Lint
    uses: RegimeDetectionApp/regime-devops/.github/workflows/reusable-lint.yml@main
    with:
      python-version: ${{ inputs.python_version || '3.11' }}
      source-dirs: 'src tests'

  security:
    name: 🔒 Security
    uses: RegimeDetectionApp/regime-devops/.github/workflows/reusable-security.yml@main
    with:
      python-version: ${{ inputs.python_version || '3.11' }}
      source-dirs: 'src'

  test:
    name: 🧪 Test
    needs: [lint]
    uses: RegimeDetectionApp/regime-devops/.github/workflows/reusable-python-tests.yml@main
    with:
      python-version: ${{ inputs.python_version || '3.11' }}
      test-suite: ${{ inputs.test_suite || 'all' }}
      source-dirs: 'src'

  docker:
    name: 🐳 Docker
    needs: [test, security]
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'
    uses: RegimeDetectionApp/regime-devops/.github/workflows/reusable-docker.yml@main
    with:
      image-name: 'your-service-name'
      push: true
```

### 2. Customize for your project

Adjust the `source-dirs`, `image-name`, and other inputs to match your repository structure.

### 3. Manual Test Runner

For a clickable button interface, add workflow_dispatch:

```yaml
on:
  workflow_dispatch:
    inputs:
      test_suite:
        description: 'Test suite to run'
        required: true
        default: 'all'
        type: choice
        options:
          - all
          - unit
          - integration
```

Then go to **Actions → Your Workflow → Run workflow** to trigger manually.

---

## Benefits

✅ **Centralized:** Update workflow logic in one place  
✅ **Consistent:** All repos use same CI/CD patterns  
✅ **Maintainable:** Fix bugs once, all repos benefit  
✅ **Reusable:** DRY principle for workflows  
✅ **Versioned:** Pin to `@main` or `@v1.0` for stability  

---

## Version Pinning

### Use `@main` for latest (recommended for development)
```yaml
uses: RegimeDetectionApp/regime-devops/.github/workflows/reusable-lint.yml@main
```

### Use tags for stability (recommended for production)
```yaml
uses: RegimeDetectionApp/regime-devops/.github/workflows/reusable-lint.yml@v1.0.0
```

### Use commit SHA for maximum control
```yaml
uses: RegimeDetectionApp/regime-devops/.github/workflows/reusable-lint.yml@a1b2c3d
```

---

## Organization Setup

### Required Permissions

1. **Organization Settings → Actions → General:**
   - ✅ Allow all actions and reusable workflows
   - ✅ Allow actions created by GitHub

2. **Each Repository → Settings → Actions:**
   - Workflow permissions: **Read and write permissions**
   - ✅ Allow GitHub Actions to create and approve pull requests

### Optional Organization Secrets

Set at: `https://github.com/organizations/RegimeDetectionApp/settings/secrets/actions`

- `CODECOV_TOKEN` - For coverage uploads
- `SLACK_WEBHOOK_URL` - For notifications
- `DOCKER_HUB_TOKEN` - If using Docker Hub instead of GHCR

---

## Troubleshooting

### "workflow not found" error
- Ensure workflow file is on `main` branch
- Check the workflow path is correct
- Verify organization allows reusable workflows

### "No permission to access" error
- Organization must allow access to regime-devops workflows
- Check: Org Settings → Actions → General → "Allow all actions"

### "Required input not provided"
- Check that all required inputs are specified
- Only `image-name` for Docker workflow is required

---

## Examples by Repository Type

### Python Package
```yaml
jobs:
  test:
    uses: RegimeDetectionApp/regime-devops/.github/workflows/reusable-python-tests.yml@main
    with:
      source-dirs: 'src tests'
```

### FastAPI Service
```yaml
jobs:
  test:
    uses: RegimeDetectionApp/regime-devops/.github/workflows/reusable-python-tests.yml@main
    with:
      source-dirs: 'app tests'
  
  docker:
    uses: RegimeDetectionApp/regime-devops/.github/workflows/reusable-docker.yml@main
    with:
      image-name: 'my-api-service'
      dockerfile: 'Dockerfile'
      push: true
```

### Dashboard App
```yaml
jobs:
  lint:
    uses: RegimeDetectionApp/regime-devops/.github/workflows/reusable-lint.yml@main
    with:
      source-dirs: 'dashboard assets'
      run-mypy: false  # Dash apps often skip mypy
```

---

## Migration Checklist

For each repo in RegimeDetectionApp:

- [ ] Create `.github/workflows/ci.yml` calling reusable workflows
- [ ] Adjust `source-dirs` to match repo structure
- [ ] Test with workflow_dispatch trigger
- [ ] Add status badges to README
- [ ] Remove old standalone workflow files (optional)

---

## Support

For issues with reusable workflows:
- Open an issue in [regime-devops](https://github.com/RegimeDetectionApp/regime-devops/issues)
- Tag with `workflow` label

For repo-specific CI issues:
- Open an issue in the specific repository
