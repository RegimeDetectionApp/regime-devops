# Centralized CI/CD Guide

## 🎯 Overview

**regime-devops** is now your **centralized CI/CD control center** for the entire RegimeDetectionApp organization!

---

## ✅ What You Get

### Before (Decentralized)
```
❌ Want to test regime-detection-core?
   → Go to regime-detection-core Actions tab
   
❌ Want to lint regime-platform?
   → Go to regime-platform Actions tab

❌ Want to scan regime-backtesting?
   → Go to regime-backtesting Actions tab
```

### After (Centralized) ✨
```
✅ Want to test ANY repo?
   → Go to regime-devops Actions tab
   → Click "🧪 Test Any Repo"
   → Select repo from dropdown
   → Done!

✅ ALL repos managed from ONE place!
```

---

## 🚀 How to Use

### Step 1: Go to regime-devops Actions

**URL:** https://github.com/RegimeDetectionApp/regime-devops/actions

### Step 2: Select a Centralized Workflow

**In the left sidebar, you'll see:**

```
All workflows

🧪 Test Any Repo          ← NEW! Test any repo
🔍 Lint Any Repo          ← NEW! Lint any repo
🔒 Security Scan Any Repo ← NEW! Scan any repo
─────────────────────────
CI                        ← Existing
Build Docker Images       ← Existing
Deploy Application        ← Existing
Run Pipeline              ← Existing
```

### Step 3: Click One of the NEW Workflows

Example: **🧪 Test Any Repo**

### Step 4: Click "Run workflow" Button (Top Right)

You'll see a form:

```
Run workflow

Branch: main           [dropdown]

Repository to test:    [dropdown ▼]
  regime-detection-core
  regime-feature-engine
  regime-backtesting
  regime-visualization
  regime-market-data
  regime-platform

Test suite to run:     [dropdown ▼]
  all
  unit
  integration

Python version:        [dropdown ▼]
  3.10
  3.11
  3.12

Verbose output:        [checkbox]

[Run workflow]
```

### Step 5: Select Options and Click "Run workflow"

Example:
- Repository: `regime-detection-core`
- Test suite: `all`
- Python version: `3.11`
- Verbose: `false`

### Step 6: Watch Tests Run!

The workflow will:
1. ✅ Checkout `regime-detection-core`
2. ✅ Install dependencies
3. ✅ Run tests
4. ✅ Upload coverage report
5. ✅ Show results

---

## 📊 What Each Workflow Does

### 🧪 Test Any Repo

**What it does:**
- Checks out selected repo
- Installs Python dependencies
- Runs pytest with coverage
- Uploads coverage reports

**Inputs:**
- Repository (dropdown)
- Test suite (all/unit/integration)
- Python version (3.10/3.11/3.12)
- Verbose output (true/false)

**Use when:**
- Verifying code changes
- Running tests before merge
- Checking specific Python version compatibility

---

### 🔍 Lint Any Repo

**What it does:**
- Checks out selected repo
- Runs ruff (linting)
- Runs black (formatting check)
- Runs mypy (type checking)

**Inputs:**
- Repository (dropdown)
- Python version (3.10/3.11/3.12)
- Run mypy (true/false)

**Use when:**
- Checking code quality
- Ensuring consistent formatting
- Type checking before merge

---

### 🔒 Security Scan Any Repo

**What it does:**
- Checks out selected repo
- Runs bandit (code security)
- Runs safety (dependency vulnerabilities)
- Uploads security reports

**Inputs:**
- Repository (dropdown)
- Python version (3.10/3.11/3.12)

**Use when:**
- Security audits
- Before production deployment
- Checking for vulnerabilities
- Compliance reviews

---

## 🎯 Example Workflows

### Example 1: Quick Test Before Merging PR

```
1. Someone opens PR in regime-detection-core
2. You want to verify tests pass
3. Go to: regime-devops Actions
4. Click: "🧪 Test Any Repo"
5. Select: regime-detection-core
6. Run workflow
7. ✅ Tests pass → Merge PR!
```

### Example 2: Security Audit All Repos

```
1. Monthly security review
2. Go to: regime-devops Actions
3. Click: "🔒 Security Scan Any Repo"
4. Run for each repo:
   - regime-detection-core
   - regime-platform
   - regime-feature-engine
   - etc.
5. Download security reports
6. Review findings
```

### Example 3: Multi-Python Testing

```
1. New Python 3.12 released
2. Want to test compatibility
3. Go to: regime-devops Actions
4. Click: "🧪 Test Any Repo"
5. Run with Python 3.12 for each repo
6. Fix any issues found
```

---

## 📋 Available Repositories

The centralized workflows currently support:

✅ **regime-detection-core** - Core ML package  
✅ **regime-feature-engine** - Feature engineering  
✅ **regime-backtesting** - Strategy backtesting  
✅ **regime-visualization** - Plotting and visualization  
✅ **regime-market-data** - Market data acquisition  
✅ **regime-platform** - FastAPI gateway service  

### Adding New Repos

To add a new repo to the dropdown, edit the workflow file:

```yaml
# .github/workflows/test-any-repo.yml
inputs:
  repository:
    options:
      - regime-detection-core
      - regime-platform
      - your-new-repo  # ← Add here
```

Then commit and push:
```bash
git add .github/workflows/test-any-repo.yml
git commit -m "Add your-new-repo to centralized test runner"
git push
```

Repeat for `lint-any-repo.yml` and `security-scan-any-repo.yml`.

---

## 🎨 Visual Guide

### What You'll See in Actions UI

```
┌─────────────────────────────────────────────┐
│ RegimeDetectionApp / regime-devops          │
│                                             │
│ ┌─────────────────┐                        │
│ │ All workflows   │                        │
│ │                 │                        │
│ │ 🧪 Test Any Repo         [Run workflow] │ ← Click here!
│ │ 🔍 Lint Any Repo         [Run workflow] │
│ │ 🔒 Security Scan Any...  [Run workflow] │
│ │ ───────────────────────                 │
│ │ CI                                      │
│ │ Build Docker Images                     │
│ │ Deploy Application                      │
│ │ Run Pipeline                            │
│ └─────────────────┘                        │
└─────────────────────────────────────────────┘
```

After clicking "Run workflow":

```
┌─────────────────────────────────────────────┐
│ Run workflow                                │
│                                             │
│ Branch: main                    [▼]         │
│                                             │
│ Repository to test:             [▼]         │
│   regime-detection-core                     │
│   regime-feature-engine                     │
│   regime-backtesting                        │
│   regime-visualization                      │
│   regime-market-data                        │
│   regime-platform                           │
│                                             │
│ Test suite to run:              [▼]         │
│   all                                       │
│   unit                                      │
│   integration                               │
│                                             │
│ Python version:                 [▼]         │
│   3.10                                      │
│   3.11                                      │
│   3.12                                      │
│                                             │
│ Verbose output:                 [ ]         │
│                                             │
│             [Run workflow]                  │
└─────────────────────────────────────────────┘
```

---

## 💡 Best Practices

### 1. Test Before Merging
Run tests from regime-devops before merging PRs in any repo

### 2. Regular Security Scans
Schedule monthly security scans of all repos

### 3. Multi-Python Testing
Test on multiple Python versions before major releases

### 4. Centralized Reporting
All test results, coverage, and security reports in one place

### 5. Team Collaboration
Share regime-devops Actions URL with team for easy access

---

## 🔧 Troubleshooting

### "Repository not found"
- Ensure repo exists in RegimeDetectionApp org
- Check spelling in dropdown matches repo name

### "Tests failed"
- This means the target repo has failing tests
- Go to target repo and fix the issues
- Re-run from regime-devops

### "No tests found"
- Target repo may not have a `tests/` directory
- Or tests are in different location
- Check target repo structure

### "Permission denied"
- Ensure GITHUB_TOKEN has access to target repo
- Check organization permissions

---

## 📊 Metrics and Reporting

### View Test Results
1. Go to workflow run
2. Click on job name
3. See detailed test output
4. Download coverage report from artifacts

### Track History
- All workflow runs logged in regime-devops
- Easy to see testing trends
- Track which repos are tested most often

### Download Reports
- Coverage reports: XML format
- Security reports: JSON format
- Available as artifacts for 30 days

---

## 🚀 Next Steps

1. **Try it now!**
   ```
   Go to: https://github.com/RegimeDetectionApp/regime-devops/actions
   Click: "🧪 Test Any Repo"
   Select: regime-detection-core
   Run workflow
   ```

2. **Bookmark the page**
   ```
   Bookmark: https://github.com/RegimeDetectionApp/regime-devops/actions
   Use as your CI/CD dashboard
   ```

3. **Share with team**
   ```
   Tell collaborators about centralized CI/CD
   Everyone uses same interface
   Consistent testing across org
   ```

4. **Automate regular checks**
   ```
   Schedule weekly security scans
   Test all repos on new Python versions
   Regular lint checks
   ```

---

## ✨ Summary

✅ **One place to rule them all:** regime-devops Actions  
✅ **Clickable buttons:** Easy to use interface  
✅ **All repos covered:** Full organization support  
✅ **Comprehensive testing:** Tests, linting, security  
✅ **Centralized reporting:** All results in one place  

**Your CI/CD control center is ready! 🎉**
