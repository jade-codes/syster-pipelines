# Syster CI/CD Pipeline Templates

This directory contains GitHub Actions workflow templates for all syster repositories. Copy the appropriate workflows to each repository's `.github/workflows/` directory.

## Repository Mapping

| Repository | Type | Workflows to Use |
|------------|------|------------------|
| `syster` | Rust Workspace | `rust/ci.yml`, `rust/release.yml` |
| `syster-base` | Rust Crate | `rust/ci.yml`, `rust/release.yml` |
| `syster-cli` | Rust Binary | `rust/ci.yml`, `rust/release.yml` |
| `syster-lsp` | Rust + VS Code | `rust/ci.yml`, `rust/release.yml`, `vscode/ci.yml`, `vscode/release.yml` |
| `syster-diagram-core` | npm Package | `npm/ci.yml`, `npm/release.yml` |
| `syster-diagram-ui` | npm Package | `npm/ci.yml`, `npm/release.yml` |
| `syster-viewer` | VS Code Extension | `vscode/ci.yml`, `vscode/release.yml` |
| `syster-modeller` | VS Code Extension | `vscode/ci.yml`, `vscode/release.yml` |

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

---

## Setup Instructions

### 1. Create GitHub Environment

For release workflows, create a `release` environment for added security:

1. Go to repository **Settings → Environments**
2. Click **New environment** → Name it `release`
3. Enable **Required reviewers** (optional but recommended)
4. Add protection rules as needed

### 2. Copy Workflows

```bash
# For each repository, copy the appropriate workflows
mkdir -p .github/workflows

# Example for a Rust crate:
cp rust/ci.yml your-repo/.github/workflows/ci.yml
cp rust/release.yml your-repo/.github/workflows/release.yml

# Example for npm package:
cp npm/ci.yml your-repo/.github/workflows/ci.yml
cp npm/release.yml your-repo/.github/workflows/release.yml

# Example for VS Code extension:
cp vscode/ci.yml your-repo/.github/workflows/ci.yml
cp vscode/release.yml your-repo/.github/workflows/release.yml
```

### 3. Configure Secrets

```bash
# Using GitHub CLI (gh)
gh secret set CRATES_IO_TOKEN --repo jade-codes/syster
gh secret set NPM_TOKEN --repo jade-codes/syster-diagram-core
gh secret set VSCE_PAT --repo jade-codes/syster-viewer
gh secret set OVSX_PAT --repo jade-codes/syster-viewer
```

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

## Customization

### For syster-lsp (Dual Publishing)

The `syster-lsp` repository contains both:
- Rust LSP server (in `crates/`)
- VS Code extension (in `editors/vscode/`)

You'll need to use **both** Rust and VS Code workflows, with paths adjusted:

```yaml
# In vscode/ci.yml, change working directory
defaults:
  run:
    working-directory: editors/vscode
```

### Changing Crate Publishing Order

In `rust/release.yml`, update the publish job's crate order to match your dependency graph:

```yaml
strategy:
  matrix:
    crate: [base-crate, dependent-crate, final-crate]
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

## File Structure

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
# Check if secrets are set
gh secret list --repo jade-codes/syster

# Manually trigger a release workflow
gh workflow run release.yml --repo jade-codes/syster

# View workflow runs
gh run list --repo jade-codes/syster

# Download artifacts from a run
gh run download <run-id> --repo jade-codes/syster
```
