# GitHub Actions Workflow Architecture

## 📁 regime-devops Repository

**Purpose:** Centralized CI/CD orchestration for entire RegimeDetectionApp organization

### ✅ Runnable Workflows (in regime-devops)

These workflows SHOULD appear in Actions UI and CAN be run manually:

#### Centralized Organization CI/CD (NEW!)

| Workflow | File | Purpose | Manual Trigger |
|----------|------|---------|----------------|
| **🧪 Test Any Repo** | `test-any-repo.yml` | Run tests on ANY org repo from here | ✅ Yes |
| **🔍 Lint Any Repo** | `lint-any-repo.yml` | Lint ANY org repo from here | ✅ Yes |
| **🔒 Security Scan Any Repo** | `security-scan-any-repo.yml` | Security scan ANY org repo from here | ✅ Yes |

**How it works:**
1. Click workflow in Actions UI
2. Select target repo from dropdown (regime-detection-core, regime-platform, etc.)
3. Click "Run workflow"
4. Checks out target repo and runs tests/lint/security
5. All results visible in regime-devops Actions tab!

**Benefits:**
- ✅ Single place to run CI for entire organization
- ✅ No need to navigate to each repo's Actions tab
- ✅ Consistent CI/CD execution
- ✅ Easy to add new repos (just update dropdown)

#### regime-devops Specific Operations

| Workflow | File | Purpose | Manual Trigger |
|----------|------|---------|----------------|
| **CI** | `ci.yml` | Tests all 5 domain packages in regime-devops | ✅ Yes |
| **Build Docker Images** | `build-images.yml` | Builds and pushes Docker images to GHCR | ✅ Yes |
| **Deploy Application** | `deploy.yml` | Deploys to local (minikube) or production (AWS EKS) | ✅ Yes |
| **Run Pipeline** | `run-pipeline.yml` | Runs detection pipeline via gateway API | ✅ Yes |

**Where to find them:**
👉 https://github.com/RegimeDetectionApp/regime-devops/actions

---

### 🔧 Reusable Workflows (Templates - NOT Runnable)

These workflows should **NOT** appear as runnable in Actions UI:

| Workflow | File | Purpose | Used By |
|----------|------|---------|---------|
| Reusable Python Tests | `reusable-python-tests.yml` | Template for testing Python code | Other repos |
| Reusable Linting | `reusable-lint.yml` | Template for linting Python code | Other repos |
| Reusable Security | `reusable-security.yml` | Template for security scanning | Other repos |
| Reusable Docker Build | `reusable-docker.yml` | Template for Docker builds | Other repos |

**Why NOT runnable here?**
- regime-devops has NO Python source code (`src/`, `tests/`)
- These templates expect repos with Python packages
- They're designed to be CALLED BY other repos
- Running them directly would fail (no code to test)

---

## 🏗️ How Reusable Workflows Are Used

### Example: regime-detection-core

```yaml
# regime-detection-core/.github/workflows/ci.yml

name: CI

on:
  push:
  pull_request:
  workflow_dispatch:  # ← Clickable button HERE

jobs:
  test:
    uses: RegimeDetectionApp/regime-devops/.github/workflows/reusable-python-tests.yml@main
    #     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^  ← CALLS the reusable workflow
    with:
      source-dirs: 'regime_detection tests'
```

**Result:**
- ✅ regime-detection-core has `src/` and `tests/` (actual Python code)
- ✅ CI workflow in regime-detection-core IS runnable (has workflow_dispatch)
- ✅ It CALLS the reusable workflow from regime-devops
- ✅ Tests run successfully

---

## 🎯 Correct Setup

### regime-devops (This Repo)
```
.github/workflows/
├── ci.yml                         ✅ Runnable (tests regime-devops itself)
├── build-images.yml               ✅ Runnable (builds Docker images)
├── deploy.yml                     ✅ Runnable (deploys services)
├── run-pipeline.yml               ✅ Runnable (runs pipeline)
├── reusable-python-tests.yml      ⚙️  Template (called by other repos)
├── reusable-lint.yml              ⚙️  Template (called by other repos)
├── reusable-security.yml          ⚙️  Template (called by other repos)
└── reusable-docker.yml            ⚙️  Template (called by other repos)
```

### regime-detection-core (Python Package)
```
.github/workflows/
└── ci.yml                         ✅ Runnable (calls regime-devops reusables)
```

### regime-platform (FastAPI Service)
```
.github/workflows/
└── ci.yml                         ✅ Runnable (calls regime-devops reusables)
```

---

## 🔄 Workflow Triggers Explained

### `workflow_dispatch` - Manual Button
```yaml
on:
  workflow_dispatch:  # ← Clickable "Run workflow" button in Actions UI
```
**Use for:** Workflows you want to run manually via GitHub Actions UI

### `workflow_call` - Called by Other Repos
```yaml
on:
  workflow_call:  # ← Can be called by other workflows
```
**Use for:** Reusable workflow templates that other repos call

### Both (When Appropriate)
```yaml
on:
  workflow_dispatch:  # Manual trigger
  workflow_call:      # Can also be called by others
```
**Use for:** Workflows that need both (rare, usually not for templates)

---

## ❌ Why Reusable Workflows Failed

When we added `workflow_dispatch` to reusable workflows:

1. **They appeared in Actions UI** ✓ (what you wanted)
2. **But they failed when run** ✗ (because no code to test)

**Error example:**
```
Error: Directory 'src' not found
Error: Directory 'tests' not found
Error: File 'requirements.txt' not found
```

**Why:** regime-devops doesn't have these - it's a DevOps repo, not a Python package!

---

## ✅ Solution

### For regime-devops:
- **Keep** the 4 reusable workflows as templates (`workflow_call` only)
- **Use** the existing runnable workflows (ci.yml, build-images.yml, etc.)

### For other repos (regime-detection-core, regime-platform, etc.):
- **Create** simple `ci.yml` that calls regime-devops reusables
- **Add** `workflow_dispatch` to THEIR ci.yml (not the reusables)
- **Now** they have clickable buttons that work!

---

## 🎯 What You Should See in Actions UI

### regime-devops Actions
👉 https://github.com/RegimeDetectionApp/regime-devops/actions

**Left sidebar should show:**
- CI
- Build Docker Images
- Deploy Application  
- Run Pipeline

**Should NOT show (these are templates):**
- ~~Reusable Python Tests~~
- ~~Reusable Linting~~
- ~~Reusable Security Scan~~
- ~~Reusable Docker Build~~

### regime-detection-core Actions (After Setup)
👉 https://github.com/RegimeDetectionApp/regime-detection-core/actions

**Left sidebar should show:**
- CI  ← Calls regime-devops reusables

**Click "CI" → "Run workflow"** ✅ This works!

---

## 📝 Next Steps

1. **Push the fix** (removes workflow_dispatch from reusables)
   ```bash
   cd /Users/gurkirat.bindra/Development/LearnGeminiAI/regime-devops
   chmod +x fix-reusable-workflows.sh
   ./fix-reusable-workflows.sh
   ```

2. **Set up regime-detection-core** with runnable CI
   - Create `.github/workflows/ci.yml` that calls reusables
   - Add `workflow_dispatch` trigger
   - Now THAT repo has clickable tests

3. **Repeat for other repos** (regime-platform, regime-feature-engine, etc.)

---

## 💡 Key Takeaway

**Reusable workflows = Templates/Libraries**
- Like a Python package you import
- Not meant to run directly
- Called by OTHER repos

**Runnable workflows = Applications**
- Like a Python script you execute
- Have workflow_dispatch for manual runs
- Can CALL reusable workflows

**Analogy:**
```python
# reusable workflow = library function
def test_python_code(source_dirs):
    # ...testing logic

# runnable workflow = script
if __name__ == "__main__":
    test_python_code("src tests")  # ← Calls the reusable function
```

---

## 🚀 After Fix

Run this to fix:
```bash
cd /Users/gurkirat.bindra/Development/LearnGeminiAI/regime-devops
bash fix-reusable-workflows.sh
```

Then verify:
- regime-devops Actions: Only shows CI, Build, Deploy, Run Pipeline ✓
- Reusable workflows: Not shown (as templates should be) ✓
- Other repos: Add ci.yml that CALLS these reusables ✓
