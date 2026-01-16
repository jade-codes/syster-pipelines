#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES_DIR="$(dirname "$SCRIPT_DIR")/devcontainer-templates"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

usage() {
    echo "Usage: $0 <template-type> <target-repo-path> [--dry-run]"
    echo ""
    echo "Template types:"
    echo "  rust               - Rust-only projects"
    echo "  node               - Node.js/TypeScript projects"
    echo "  rust-node-monorepo - Mixed Rust + Node.js projects"
    echo ""
    echo "Options:"
    echo "  --dry-run         - Show what would be done without making changes"
    echo ""
    echo "Examples:"
    echo "  $0 rust ~/Work/syster-repos/syster-lsp"
    echo "  $0 node ~/Work/syster-repos/syster-diagram-core --dry-run"
    exit 1
}

# Check arguments
if [ $# -lt 2 ]; then
    usage
fi

TEMPLATE_TYPE="$1"
TARGET_PATH="$2"
DRY_RUN=false

if [ "$3" = "--dry-run" ]; then
    DRY_RUN=true
fi

# Validate template type
TEMPLATE_PATH="$TEMPLATES_DIR/$TEMPLATE_TYPE"
if [ ! -d "$TEMPLATE_PATH" ]; then
    echo -e "${RED}Error: Template '$TEMPLATE_TYPE' not found${NC}"
    echo "Available templates:"
    ls -1 "$TEMPLATES_DIR" | grep -v README.md
    exit 1
fi

# Validate target path
if [ ! -d "$TARGET_PATH" ]; then
    echo -e "${RED}Error: Target path '$TARGET_PATH' does not exist${NC}"
    exit 1
fi

TARGET_DEVCONTAINER="$TARGET_PATH/.devcontainer"

# Show plan
echo -e "${YELLOW}DevContainer Setup Plan:${NC}"
echo "  Template: $TEMPLATE_TYPE"
echo "  Source: $TEMPLATE_PATH"
echo "  Target: $TARGET_DEVCONTAINER"
echo ""

if [ -d "$TARGET_DEVCONTAINER" ]; then
    echo -e "${YELLOW}Warning: .devcontainer directory already exists${NC}"
    echo "  Existing directory will be backed up to .devcontainer.backup"
    echo ""
fi

if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}[DRY RUN] No changes will be made${NC}"
    exit 0
fi

# Prompt for confirmation
read -p "Continue? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted"
    exit 1
fi

# Backup existing devcontainer if present
if [ -d "$TARGET_DEVCONTAINER" ]; then
    BACKUP_PATH="${TARGET_DEVCONTAINER}.backup"
    echo -e "${YELLOW}Backing up existing .devcontainer to $BACKUP_PATH${NC}"
    rm -rf "$BACKUP_PATH"
    mv "$TARGET_DEVCONTAINER" "$BACKUP_PATH"
fi

# Copy template
echo -e "${GREEN}Copying template...${NC}"
mkdir -p "$TARGET_DEVCONTAINER"
cp "$TEMPLATE_PATH/devcontainer.json" "$TARGET_DEVCONTAINER/devcontainer.json"

echo -e "${GREEN}✓ DevContainer setup complete!${NC}"
echo ""
echo "Next steps:"
echo "  1. Review the configuration in $TARGET_DEVCONTAINER/devcontainer.json"
echo "  2. Customize if needed (ports, extensions, postCreateCommand)"
echo "  3. Open the project in VS Code and select 'Reopen in Container'"
