# Syster CI/CD Pipeline Templates

This repository contains **reusable GitHub Actions workflows** for all syster repositories. Instead of copying workflow files, repositories reference these workflows directly, ensuring consistency and easy updates.

## 🚀 Quick Start

### 1. Create Workflow Files in Your Repository

Create `.github/workflows/ci.yml` and `.github/workflows/release.yml` in your repository:

**For Rust projects:**
```yaml
# .github/workflows/ci.yml
name: CI
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  ci:
    uses: jade-codes/syster-pipelines/.github/workflows/rust-ci.yml@main
```

```yaml
# .github/workflows/release.yml
name: Release
on:
  push:
    tags: ['v[0-9]+.[0-9]+.[0-9]+*']

jobs:
  release:
    uses: jade-codes/syster-pipelines/.github/workflows/rust-release.yml@main
    with:
      crates: 'syster-base,syster-cli,syster-lsp'  # Optional: for multi-crate repos
    secrets:
      CRATES_IO_TOKEN: ${{ secrets.CRATES_IO_TOKEN }}
```

**For npm packages:**
```yaml
# .github/workflows/ci.yml
name: CI
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  ci:
    uses: jade-codes/syster-pipelines/.github/workflows/npm-ci.yml@main
```

```yaml
# .github/workflows/release.yml
name: Release
on:
  push:
    tags: ['v[0-9]+.[0-9]+.[0-9]+*']

jobs:
  release:
    uses: jade-codes/syster-pipelines/.github/workflows/npm-release.yml@main
    secrets:
      NPM_TOKEN: ${{ secrets.NPM_TOKEN }}
```

**For VS Code extensions:**
```yaml
# .github/workflows/ci.yml
name: CI
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  ci:
    uses: jade-codes/syster-pipelines/.github/workflows/vscode-ci.yml@main
```

```yaml
# .github/workflows/release.yml
name: Release
on:
  push:
    tags: ['v[0-9]+.[0-9]+.[0-9]+*']

jobs:
  release:
    uses: jade-codes/syster-pipelines/.github/workflows/vscode-release.yml@main
    secrets:
      VSCE_PAT: ${{ secrets.VSCE_PAT }}
      OVSX_PAT: ${{ secrets.OVSX_PAT }}  # Optional
```

**For Python packages:**
```yaml
# .github/workflows/ci.yml
name: CI
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  ci:
    uses: jade-codes/syster-pipelines/.github/workflows/python-ci.yml@main
```

```yaml
# .github/workflows/release.yml
name: Release
on:
  push:
    tags: ['v[0-9]+.[0-9]+.[0-9]+*']

jobs:
  release:
    uses: jade-codes/syster-pipelines/.github/workflows/python-release.yml@main
    secrets:
      PYPI_API_TOKEN: ${{ secrets.PYPI_API_TOKEN }}
```

### 2. Configure Secrets

See [Required Secrets](#required-secrets) section below.

---

## Available Reusable Workflows

| Workflow | Purpose | Repository Types |
|----------|---------|------------------|
| `rust-ci.yml` | Rust CI: format, lint, test, build | syster, syster-base, syster-cli, syster-lsp |
| `rust-release.yml` | Rust release: crates.io + GitHub | syster, syster-base, syster-cli, syster-lsp |
| `npm-ci.yml` | npm CI: typecheck, lint, test | syster-diagram-core, syster-diagram-ui |
| `npm-release.yml` | npm release: registry + GitHub | syster-diagram-core, syster-diagram-ui |
| `vscode-ci.yml` | VS Code CI: compile, test, package | syster-viewer, syster-modeller |
| `vscode-release.yml` | VS Code release: Marketplace + Open VSX | syster-viewer, syster-modeller |
| `python-ci.yml` | Python CI: lint, type check, test | systree, syster-tree |
| `python-release.yml` | Python release: PyPI + GitHub | systree, syster-tree |

---

## Required Secrets

Each repository needs specific secrets configured in **Settings → Secrets and variables → Actions**.

### For Rust Repositories (crates.io)

| Secret | Description | How to Get |
|--------|-------------|------------|
| `CRATES_IO_TOKEN` | API token for publishing to crates.io | [crates.io/settings/tokens](https://crates.io/settings/tokens) |

### For npm Repositories

| Secret | Description | How to Get |
|--------|-------------|------------|
| `NPM_TOKEN` | Automation token for npm publishing | [npmjs.com/settings/tokens](https://www.npmjs.com/settings/~/tokens) - Create "Automation" type |

### For VS Code Extensions

| Secret | Description | How to Get |
|--------|-------------|------------|
| `VSCE_PAT` | Personal Access Token for VS Code Marketplace | [Azure DevOps PAT](https://code.visualstudio.com/api/working-with-extensions/publishing-extension#get-a-personal-access-token) |
| `OVSX_PAT` | Access token for Open VSX Registry | [open-vsx.org/user-settings/tokens](https://open-vsx.org/user-settings/tokens) |

### For Python Packages (PyPI)

| Secret | Description | How to Get |
|--------|-------------|------------|
| `PYPI_API_TOKEN` | API token for publishing to PyPI | [pypi.org/manage/account/token](https://pypi.org/manage/account/token/) - Create project-scoped token |

---

## Advanced Configuration

### Workflow Inputs

Each reusable workflow accepts optional inputs for customization:

#### `rust-ci.yml`
```yaml
with:
  rust-version: 'stable'      # Rust toolchain version
  working-directory: '.'       # Working directory
```

#### `rust-release.yml`
```yaml
with:
  working-directory: '.'                    # Working directory
  crates: 'crate1,crate2,crate3'           # Crates to publish (in order)
  skip-crates-publish: false                # Skip crates.io publishing
secrets:
  CRATES_IO_TOKEN: ${{ secrets.CRATES_IO_TOKEN }}
```

#### `npm-ci.yml`
```yaml
with:
  working-directory: '.'                    # Working directory
  node-versions: '[18, 20, 22]'            # Node versions to test
```

#### `npm-release.yml`
```yaml
with:
  working-directory: '.'                    # Working directory
secrets:
  NPM_TOKEN: ${{ secrets.NPM_TOKEN }}
```

#### `vscode-ci.yml`
```yaml
with:
  working-directory: '.'       # Working directory
  node-version: '20'          # Node.js version
```

#### `vscode-release.yml`
```yaml
with:
  working-directory: '.'       # Working directory
  node-version: '20'          # Node.js version
secrets:
  VSCE_PAT: ${{ secrets.VSCE_PAT }}
  OVSX_PAT: ${{ secrets.OVSX_PAT }}  # Optional
```

#### `python-ci.yml`
```yaml
with:
  working-directory: '.'                      # Working directory
  python-versions: '["3.10", "3.11", "3.12"]' # Python versions to test
  install-extras: 'dev'                       # pip extras to install
```

#### `python-release.yml`
```yaml
with:
  working-directory: '.'                    # Working directory
secrets:
  PYPI_API_TOKEN: ${{ secrets.PYPI_API_TOKEN }}
```

### Example: syster-lsp (Dual Publishing)

For repositories with multiple components (like `syster-lsp` with both Rust LSP and VS Code extension):

```yaml
# .github/workflows/ci.yml
name: CI
on: [push, pull_request]

jobs:
  rust-ci:
    uses: jade-codes/syster-pipelines/.github/workflows/rust-ci.yml@main
  
  vscode-ci:
    uses: jade-codes/syster-pipelines/.github/workflows/vscode-ci.yml@main
    with:
      working-directory: 'editors/vscode'
```

```yaml
# .github/workflows/release.yml
name: Release
on:
  push:
    tags: ['v[0-9]+.[0-9]+.[0-9]+*']

jobs:
  rust-release:
    uses: jade-codes/syster-pipelines/.github/workflows/rust-release.yml@main
    with:
      crates: 'syster-lsp'
    secrets:
      CRATES_IO_TOKEN: ${{ secrets.CRATES_IO_TOKEN }}
  
  vscode-release:
    needs: rust-release
    uses: jade-codes/syster-pipelines/.github/workflows/vscode-release.yml@main
    with:
      working-directory: 'editors/vscode'
    secrets:
      VSCE_PAT: ${{ secrets.VSCE_PAT }}
      OVSX_PAT: ${{ secrets.OVSX_PAT }}
```

---

## Legacy Templates

The `rust/`, `npm/`, and `vscode/` directories contain example caller workflows showing how to use the reusable workflows. These replace the old copy-paste templates.

---

## Triggering Releases

All release workflows are triggered by pushing a version tag:

```bash
# For a stable release
git tag v1.0.0
git push origin v1.0.0

# For a pre-release
git tag v1.0.0-beta.1
git push origin v1.0.0-beta.1
```

### Before Releasing

1. **Update version** in `Cargo.toml` or `package.json`
2. **Update CHANGELOG.md** (optional but recommended)
3. **Commit changes**: `git commit -am "Release v1.0.0"`
4. **Create and push tag**: `git tag v1.0.0 && git push origin v1.0.0`

---

## Benefits of Reusable Workflows

✅ **Single source of truth** - Update all repos by changing one file  
✅ **Consistency** - All repos use the same tested workflow logic  
✅ **Easy updates** - No need to sync changes across multiple repos  
✅ **Version control** - Pin to specific versions with `@v1` or use `@main` for latest  
✅ **Reduced maintenance** - Fix bugs once, benefit everywhere

---

## Workflow Features

### Rust Workflows

**CI (`rust/ci.yml`):**
- ✅ Format checking (`cargo fmt`)
- ✅ Linting with Clippy
- ✅ Cross-platform testing (Linux, macOS Intel/ARM, Windows)
- ✅ Dependency caching

**Release (`rust/release.yml`):**
- ✅ Multi-platform binary builds
- ✅ Automatic crates.io publishing (respects dependency order)
- ✅ GitHub Release with downloadable artifacts
- ✅ Pre-release support

### npm Workflows

**CI (`npm/ci.yml`):**
- ✅ Bun for fast package management
- ✅ TypeScript type checking
- ✅ Linting and testing
- ✅ Node.js version matrix (18, 20, 22)

**Release (`npm/release.yml`):**
- ✅ Version validation (tag must match package.json)
- ✅ npm publish with provenance (supply chain security)
- ✅ GitHub Release creation

### VS Code Extension Workflows

**CI (`vscode/ci.yml`):**
- ✅ Cross-platform testing (Linux, macOS, Windows)
- ✅ VSIX packaging as artifact
- ✅ Extension compilation

**Release (`vscode/release.yml`):**
- ✅ VS Code Marketplace publishing
- ✅ Open VSX Registry publishing
- ✅ Pre-release flag support
- ✅ GitHub Release with VSIX download

---

## Migration Guide

### Migrating from Copied Templates

If you're currently using copied workflow files:

1. **Backup** your current `.github/workflows/` files
2. **Replace** with the simple caller workflows shown above
3. **Verify** that inputs/secrets match your needs
4. **Test** by pushing to a branch and checking the workflow runs
5. **Delete** old workflow files once verified

### Testing Changes

Before tagging a release, test the workflows by:
```bash
# Trigger CI on a branch
git push origin feature-branch

# Check workflow status
gh run list --repo jade-codes/your-repo

# View workflow logs
gh run view <run-id> --repo jade-codes/your-repo
```

---

## Troubleshooting

### "crates.io token not authorized"
- Ensure the token has `publish-update` scope
- Check that you're a crate owner: `cargo owner --list <crate-name>`

### "npm ERR! 403 Forbidden"
- Ensure token is "Automation" type
- Package name must be available or you must have publish rights
- Check 2FA settings on npm

### "VSCE: Access Denied"
- PAT must have **Marketplace (Publish)** scope
- Organization must match your publisher ID
- PAT must not be expired

### "Extension tests failing on Linux"
- Ensure `xvfb-run` is used (already included in workflows)
- Check that `@vscode/test-electron` is a devDependency

---

## File Structure (Deprecated)

```
syster-pipelines/
├── README.md           # This file
├── rust/
│   ├── ci.yml          # Rust CI: format, lint, test, build
│   └── release.yml     # Rust release: crates.io + GitHub
├── npm/
│   ├── ci.yml          # npm CI: typecheck, lint, test, build
│   └── release.yml     # npm release: npm registry + GitHub
└── vscode/
    ├── ci.yml          # Extension CI: compile, test, package
    └── release.yml     # Extension release: Marketplace + Open VSX
```

---

## Quick Reference

```bash
# Configure secrets (one-time setup per repo)
gh secret set CRATES_IO_TOKEN --repo jade-codes/syster
gh secret set NPM_TOKEN --repo jade-codes/syster-diagram-core
gh secret set VSCE_PAT --repo jade-codes/syster-viewer
gh secret set OVSX_PAT --repo jade-codes/syster-viewer

# Check workflow status
gh run list --repo jade-codes/syster

# View workflow logs
gh run view <run-id> --repo jade-codes/syster

# Manually trigger a workflow (if workflow_dispatch is enabled)
gh workflow run release.yml --repo jade-codes/syster
```

---

## DevContainer Templates

This repository also provides **reusable DevContainer templates** for consistent development environments across all Syster projects.

### Available Templates

- **`rust/`** - For Rust-only projects (syster-lsp, syster-base)
- **`node/`** - For Node.js/TypeScript projects (syster-diagram-*, syster-vscode-*)
- **`rust-node-monorepo/`** - For mixed projects (main syster repo)

### Using DevContainer Templates

```bash
# Apply a template to your project
./scripts/setup-devcontainer.sh <template-type> <target-repo-path>

# Examples:
./scripts/setup-devcontainer.sh rust ~/Work/syster-repos/syster-lsp
./scripts/setup-devcontainer.sh node ~/Work/syster-repos/syster-diagram-core
```

See [`devcontainer-templates/README.md`](devcontainer-templates/README.md) for detailed documentation.

---

## Repository Structure

```
syster-pipelines/
├── .github/workflows/          # Reusable workflows (the actual implementation)
│   ├── rust-ci.yml
│   ├── rust-release.yml
│   ├── npm-ci.yml
│   ├── npm-release.yml
│   ├── vscode-ci.yml
│   └── vscode-release.yml
├── devcontainer-templates/     # Reusable DevContainer templates
│   ├── rust/                   # Rust-only template
│   ├── node/                   # Node.js template
│   ├── rust-node-monorepo/     # Mixed Rust+Node template
│   └── README.md               # DevContainer documentation
├── scripts/                    # Utility scripts
│   └── setup-devcontainer.sh   # Apply templates to repos
├── rust/                       # Example caller workflows
│   ├── ci.yml
│   └── release.yml
├── npm/                        # Example caller workflows
│   ├── ci.yml
│   └── release.yml
├── vscode/                     # Example caller workflows
│   ├── ci.yml
│   └── release.yml
└── README.md                   # This file
```
