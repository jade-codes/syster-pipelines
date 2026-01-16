# DevContainer Templates

Reusable development container templates for Syster projects.

## Available Templates

### 1. **Rust Template** (`rust/`)
For Rust-only projects like `syster-lsp` and `syster-base`.

**Includes:**
- Rust 1.x (Debian Bookworm base)
- GitHub CLI
- VS Code extensions: rust-analyzer, TOML support, crates
- Clippy pre-configured

### 2. **Node.js Template** (`node/`)
For Node.js/TypeScript projects like `syster-diagram-*` and `syster-vscode-*`.

**Includes:**
- Node.js 20 LTS
- Bun runtime
- GitHub CLI
- VS Code extensions: ESLint, Prettier, TypeScript
- Auto-formatting on save

### 3. **Rust + Node.js Monorepo Template** (`rust-node-monorepo/`)
For mixed projects like the main `syster` repo.

**Includes:**
- All features from both Rust and Node.js templates
- Suitable for workspaces with multiple languages

## Usage

### Using the Setup Script

```bash
# From syster-pipelines root
./scripts/setup-devcontainer.sh <template-type> <target-repo-path>

# Examples:
./scripts/setup-devcontainer.sh rust ~/Work/syster-repos/syster-lsp
./scripts/setup-devcontainer.sh node ~/Work/syster-repos/syster-diagram-core
```

### Manual Copy

```bash
# Copy template to your project
cp -r devcontainer-templates/rust/.devcontainer /path/to/your/project/
```

## Customization

After applying a template, you can customize:
- Add project-specific VS Code extensions
- Modify `postCreateCommand` for project setup
- Add additional features from [devcontainers/features](https://containers.dev/features)
- Adjust port forwarding for your app

## Maintenance

To update all templates:
1. Edit the template files in this directory
2. Re-run the setup script for each repo, or
3. Manually copy updated configs to projects

## Template Structure

Each template contains:
- `devcontainer.json` - Main configuration file
- Base image from Microsoft's official devcontainer images
- Common VS Code extensions for the stack
- GitHub CLI for repo operations
