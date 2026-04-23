# Reusable Workflows Setup - Complete ✅

## What Was Done

### 1. regime-devops Repository ✅
Created centralized reusable workflows that any RegimeDetectionApp repo can call:

- **`reusable-python-tests.yml`** - Configurable Python test runner with coverage
- **`reusable-lint.yml`** - Code quality checks (ruff, black, mypy)
- **`reusable-security.yml`** - Security scanning (bandit, safety)
- **`reusable-docker.yml`** - Multi-platform Docker image builds

📍 **Location:** https://github.com/RegimeDetectionApp/regime-devops/.github/workflows/

### 2. RegimeDetectionModel Repository ✅
Added CI pipeline that uses the reusable workflows:

- **`ci-reusable.yml`** - Full CI/CD pipeline calling regime-devops workflows
- **`manual-tests.yml`** - Standalone manual test runner (doesn't depend on regime-devops)
- **`ci.yml`** - Original full-featured CI (kept for reference)

---

## How to Use - Quick Start

### Try It Now! 🚀

1. **Go to Actions tab:**
   - https://github.com/govid13427742/RegimeDetectionModel/actions

2. **Select workflow:**
   - **"🧪 CI Pipeline (Reusable Workflows)"** - Uses regime-devops (recommended)
   - **"🧪 Manual Test Runner"** - Standalone version

3. **Click "Run workflow"** button (top right)

4. **Choose options:**
   - **Test suite:** `all`, `unit`, `integration`, `lint-only`, `security-only`
   - **Python version:** `3.10`, `3.11`, `3.12`
   - **Verbose:** `true` for detailed output
   - **Build Docker:** `true` to build Docker image

5. **Click "Run workflow"** ✅

---

## Migrate Other Repos to Reusable Workflows

### Step 1: Create Minimal CI Workflow

In any RegimeDetectionApp repo, create `.github/workflows/ci.yml`:

```yaml
name: CI

on:
  workflow_dispatch:
    inputs:
      test_suite:
        description: 'Test suite'
        type: choice
        options: [all, unit, integration]
        default: all
      python_version:
        description: 'Python version'
        type: choice
        options: ['3.10', '3.11', '3.12']
        default: '3.11'
  push:
    branches: [main, develop]
  pull_request:

jobs:
  lint:
    name: 🔍 Lint
    uses: RegimeDetectionApp/regime-devops/.github/workflows/reusable-lint.yml@main
    with:
      python-version: ${{ inputs.python_version || '3.11' }}
      source-dirs: 'src tests'  # ← Adjust for your repo

  test:
    name: 🧪 Test
    needs: [lint]
    uses: RegimeDetectionApp/regime-devops/.github/workflows/reusable-python-tests.yml@main
    with:
      python-version: ${{ inputs.python_version || '3.11' }}
      test-suite: ${{ inputs.test_suite || 'all' }}
      source-dirs: 'src'  # ← Adjust for your repo
      requirements-file: 'requirements.txt'  # ← Adjust if different

  security:
    name: 🔒 Security
    uses: RegimeDetectionApp/regime-devops/.github/workflows/reusable-security.yml@main
    with:
      source-dirs: 'src'  # ← Adjust for your repo
```

### Step 2: Customize for Your Repo Structure

**Common directory patterns:**

| Repo Type | source-dirs Example |
|-----------|-------------------|
| Python package | `'src tests'` |
| FastAPI service | `'app tests'` |
| Dashboard app | `'dashboard tests'` |
| Multi-package | `'src regime_detection dashboard tests'` |

### Step 3: Optional - Add Docker Build

Add this job if your repo has a Dockerfile:

```yaml
  docker:
    name: 🐳 Docker
    needs: [test, security]
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'
    uses: RegimeDetectionApp/regime-devops/.github/workflows/reusable-docker.yml@main
    with:
      image-name: 'your-service-name'  # ← Change this!
      push: true
```

### Step 4: Push and Test

```bash
git add .github/workflows/ci.yml
git commit -m "Add CI using reusable workflows"
git push

# Then go to Actions tab and run manually to test
```

---

## Real-World Examples

### Example 1: regime-detection-core (Python Package)

```yaml
jobs:
  lint:
    uses: RegimeDetectionApp/regime-devops/.github/workflows/reusable-lint.yml@main
    with:
      source-dirs: 'regime_detection tests'
  
  test:
    uses: RegimeDetectionApp/regime-devops/.github/workflows/reusable-python-tests.yml@main
    with:
      source-dirs: 'regime_detection'
```

### Example 2: regime-platform (FastAPI Service)

```yaml
jobs:
  lint:
    uses: RegimeDetectionApp/regime-devops/.github/workflows/reusable-lint.yml@main
    with:
      source-dirs: 'app tests'
  
  test:
    uses: RegimeDetectionApp/regime-devops/.github/workflows/reusable-python-tests.yml@main
    with:
      source-dirs: 'app'
  
  docker:
    needs: [test]
    uses: RegimeDetectionApp/regime-devops/.github/workflows/reusable-docker.yml@main
    with:
      image-name: 'regime-platform'
      push: true
```

### Example 3: Simple Package (No Tests Yet)

```yaml
jobs:
  lint:
    uses: RegimeDetectionApp/regime-devops/.github/workflows/reusable-lint.yml@main
    with:
      source-dirs: 'src'
      run-mypy: false  # Disable if not type-hinted yet
```

---

## Available Reusable Workflows

### 🧪 Python Tests
**File:** `reusable-python-tests.yml`

**Inputs:**
- `python-version` (default: `'3.11'`)
- `test-suite` (default: `'all'`) - Options: `all`, `unit`, `integration`
- `source-dirs` (default: `'src tests'`)
- `requirements-file` (default: `'requirements.txt'`)
- `verbose` (default: `false`)

**Outputs:**
- `test-result` - Success/failure status
- `coverage` - Coverage percentage

**Features:**
- Runs pytest with coverage
- Uploads coverage to Codecov
- Creates HTML coverage report
- Caches pip dependencies

---

### 🔍 Linting
**File:** `reusable-lint.yml`

**Inputs:**
- `python-version` (default: `'3.11'`)
- `source-dirs` (default: `'src tests'`)
- `ruff-config` (default: `'pyproject.toml'`)
- `run-mypy` (default: `true`)

**Features:**
- Runs ruff (linting)
- Runs black (format check)
- Runs mypy (type checking)
- GitHub annotations on failures

---

### 🔒 Security Scan
**File:** `reusable-security.yml`

**Inputs:**
- `python-version` (default: `'3.11'`)
- `source-dirs` (default: `'src'`)
- `requirements-file` (default: `'requirements.txt'`)
- `bandit-config` (default: `'pyproject.toml'`)

**Features:**
- Runs bandit (code security)
- Runs safety (dependency vulnerabilities)
- Uploads scan reports as artifacts

---

### 🐳 Docker Build
**File:** `reusable-docker.yml`

**Inputs:**
- `image-name` (required) - e.g., `'regime-platform'`
- `dockerfile` (default: `'Dockerfile'`)
- `context` (default: `'.'`)
- `platforms` (default: `'linux/amd64,linux/arm64'`)
- `push` (default: `false`)
- `registry` (default: `'ghcr.io'`)

**Features:**
- Multi-platform builds
- Automatic tagging (latest, sha, semver)
- Pushes to GitHub Container Registry
- Uses build cache

---

## Benefits of This Approach

### ✅ For Developers
- **Consistent experience** across all repos
- **Clickable buttons** for manual testing
- **Fast feedback** with parallel jobs
- **Clear failure messages** with GitHub annotations

### ✅ For DevOps/Maintainers
- **Update once, propagate everywhere** - Fix bugs in regime-devops, all repos benefit
- **DRY principle** - No duplicated workflow code
- **Easier to review** - Less YAML boilerplate in each repo
- **Version control** - Pin to `@main` or `@v1.0` for stability

### ✅ For Organization
- **Enforce standards** - Consistent code quality checks
- **Audit compliance** - Centralized security scanning
- **Cost optimization** - Shared caching across repos
- **Better visibility** - Standardized metrics and reporting

---

## Troubleshooting

### "Workflow not found" Error

**Problem:** Can't find reusable workflow

**Solution:**
1. Ensure workflow is on `main` branch in regime-devops
2. Check spelling: `RegimeDetectionApp/regime-devops/.github/workflows/reusable-lint.yml@main`
3. Verify organization allows reusable workflows:
   - Go to: https://github.com/organizations/RegimeDetectionApp/settings/actions
   - Check: "Allow all actions and reusable workflows"

### "Required input not provided"

**Problem:** Missing required input parameter

**Solution:** Only `image-name` for Docker workflow is required. Example:
```yaml
with:
  image-name: 'my-service'  # This is required!
```

### Tests Not Running

**Problem:** Test job is skipped or doesn't run

**Solution:**
1. Check if `tests/` directory exists
2. Ensure pytest can discover tests: `pytest --collect-only tests/`
3. Verify `pyproject.toml` or `pytest.ini` configuration

### Import Errors During Tests

**Problem:** `ModuleNotFoundError` in tests

**Solution:**
1. Install package in editable mode: Add to workflow:
   ```yaml
   pip install -e .
   ```
2. Or ensure `src/` is in PYTHONPATH
3. Check `pyproject.toml` has correct package configuration

---

## Migration Checklist

For each repo in RegimeDetectionApp organization:

### Preparation
- [ ] Ensure repo has tests (or create basic smoke tests)
- [ ] Verify `pyproject.toml` or `setup.py` exists
- [ ] Check if Dockerfile exists (for Docker workflow)

### Implementation
- [ ] Create `.github/workflows/ci.yml` using template above
- [ ] Customize `source-dirs` for repo structure
- [ ] Update `image-name` if using Docker workflow
- [ ] Push to branch and test manually first

### Validation
- [ ] Run workflow manually via Actions UI
- [ ] Verify all jobs pass (lint, test, security)
- [ ] Check artifacts are uploaded (coverage, reports)
- [ ] Test on a PR to ensure auto-trigger works

### Cleanup (Optional)
- [ ] Remove old standalone workflow files
- [ ] Add status badges to README
- [ ] Document repo-specific CI configuration

---

## Status Badges

Add to your README.md:

```markdown
[![CI](https://github.com/RegimeDetectionApp/your-repo/actions/workflows/ci.yml/badge.svg)](https://github.com/RegimeDetectionApp/your-repo/actions/workflows/ci.yml)
```

For specific jobs:
```markdown
[![Lint](https://github.com/RegimeDetectionApp/your-repo/actions/workflows/ci.yml/badge.svg?job=lint)](https://github.com/RegimeDetectionApp/your-repo/actions/workflows/ci.yml)
[![Tests](https://github.com/RegimeDetectionApp/your-repo/actions/workflows/ci.yml/badge.svg?job=test)](https://github.com/RegimeDetectionApp/your-repo/actions/workflows/ci.yml)
```

---

## Next Steps

1. ✅ **Test in RegimeDetectionModel** (DONE - this repo)
2. ⏭️ **Migrate regime-detection-core** - Python package
3. ⏭️ **Migrate regime-platform** - FastAPI service with Docker
4. ⏭️ **Migrate remaining repos** - Use examples above
5. ⏭️ **Add organization secrets** - Codecov, Slack, etc.
6. ⏭️ **Document standards** - Update org-wide docs

---

## Support

**For issues with reusable workflows:**
- Open issue in: https://github.com/RegimeDetectionApp/regime-devops/issues
- Tag with: `workflow` label

**For repo-specific CI issues:**
- Open issue in the specific repository

**For questions:**
- Ask in RegimeDetectionApp discussions
- Check workflow README: https://github.com/RegimeDetectionApp/regime-devops/.github/workflows/README.md

---

## Resources

- [Reusable Workflows Docs](https://docs.github.com/en/actions/using-workflows/reusing-workflows)
- [workflow_dispatch](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#workflow_dispatch)
- [GitHub Actions Marketplace](https://github.com/marketplace?type=actions)
- [regime-devops Workflows](https://github.com/RegimeDetectionApp/regime-devops/.github/workflows/)
