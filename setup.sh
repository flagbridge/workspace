#!/usr/bin/env bash
# ============================================================
# FlagBridge Workspace Bootstrap
# Clones all org repos and sets up local dev environment.
#
# Usage:
#   git clone git@github.com:flagbridge/workspace.git flagbridge
#   cd flagbridge && ./setup.sh
#
# Options:
#   --https    Use HTTPS instead of SSH for git clone
#   --skip-db  Skip private repos (db, flagbridge-pro)
# ============================================================

set -euo pipefail

# ── Config ────────────────────────────────────────────────
GH_ORG="flagbridge"
USE_HTTPS=false
SKIP_PRIVATE=false

# Public repos
PUBLIC_REPOS=(
  flagbridge
  admin
  landing
  docs
  sdk-node
  sdk-react
  sdk-go
  sdk-python
  openfeature-provider
  plugin-sdk
  cli
  create-plugin
  helm-charts
  examples
  files
  .github
)

# Private repos (require org access)
PRIVATE_REPOS=(
  db
  flagbridge-pro
)

# ── Parse args ────────────────────────────────────────────
for arg in "$@"; do
  case $arg in
    --https)    USE_HTTPS=true ;;
    --skip-db)  SKIP_PRIVATE=true ;;
    -h|--help)
      echo "Usage: ./setup.sh [--https] [--skip-db]"
      echo "  --https    Use HTTPS instead of SSH"
      echo "  --skip-db  Skip private repos (db, flagbridge-pro)"
      exit 0
      ;;
    *) echo "Unknown option: $arg"; exit 1 ;;
  esac
done

# ── Functions ─────────────────────────────────────────────
clone_url() {
  local repo=$1
  if $USE_HTTPS; then
    echo "https://github.com/${GH_ORG}/${repo}.git"
  else
    echo "git@github.com:${GH_ORG}/${repo}.git"
  fi
}

clone_repo() {
  local repo=$1
  if [ -d "$repo" ]; then
    echo "  [skip] $repo/ already exists"
  else
    echo "  [clone] $repo..."
    git clone --quiet "$(clone_url "$repo")" "$repo" 2>/dev/null \
      && echo "  [ok] $repo" \
      || echo "  [fail] $repo (check access)"
  fi
}

# ── Main ──────────────────────────────────────────────────
echo ""
echo "  FlagBridge Workspace Bootstrap"
echo "  =============================="
echo ""

# Clone public repos
echo "Public repos:"
for repo in "${PUBLIC_REPOS[@]}"; do
  clone_repo "$repo"
done

# Clone private repos
if ! $SKIP_PRIVATE; then
  echo ""
  echo "Private repos:"
  for repo in "${PRIVATE_REPOS[@]}"; do
    clone_repo "$repo"
  done
fi

# ── Post-setup checks ────────────────────────────────────
echo ""
echo "Post-setup:"

# Check Node.js
if command -v node &> /dev/null; then
  echo "  [ok] Node.js $(node -v)"
else
  echo "  [warn] Node.js not found — install via fnm: fnm install --lts"
fi

# Check Go
if command -v go &> /dev/null; then
  echo "  [ok] Go $(go version | awk '{print $3}')"
else
  echo "  [warn] Go not found — install from https://go.dev/dl/"
fi

# Check pnpm
if command -v pnpm &> /dev/null; then
  echo "  [ok] pnpm $(pnpm -v)"
else
  echo "  [warn] pnpm not found — install: corepack enable && corepack prepare pnpm@latest --activate"
fi

# Check Docker
if command -v docker &> /dev/null; then
  echo "  [ok] Docker $(docker --version | awk '{print $3}' | tr -d ',')"
else
  echo "  [warn] Docker not found — needed for docker-compose.yml"
fi

# Check Claude Code
if command -v claude &> /dev/null; then
  echo "  [ok] Claude Code installed"
else
  echo "  [info] Claude Code not found — install: npm i -g @anthropic-ai/claude-code"
fi

# ── Summary ───────────────────────────────────────────────
total=$(ls -d */ .github/ 2>/dev/null | wc -l)
echo ""
echo "  Done! $total repos ready."
echo ""
echo "  Next steps:"
echo "    code flagbridge.code-workspace   # Open in VS Code"
echo "    docker compose up -d             # Start local dev stack"
echo "    claude                            # Start Claude Code"
echo ""
