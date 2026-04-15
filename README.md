# FlagBridge Workspace

Workspace bootstrap for the [FlagBridge](https://flagbridge.io) platform — feature flags with product intelligence.

This repo contains **only the workspace scaffolding**: setup script, VS Code workspace, Docker Compose, Claude Code agents, and project context files. Each FlagBridge component lives in its own repository under [github.com/flagbridge](https://github.com/flagbridge).

## Quick Start

```bash
git clone git@github.com:flagbridge/workspace.git flagbridge
cd flagbridge
./setup.sh
```

This clones all 18 org repos into the workspace directory and checks for required tools (Node.js, Go, pnpm, Docker, Claude Code).

### Options

```bash
./setup.sh --https     # Use HTTPS instead of SSH
./setup.sh --skip-db   # Skip private repos (db, flagbridge-pro)
```

## What's Inside

```
flagbridge/
├── setup.sh                    # Bootstrap script — clones all repos
├── flagbridge.code-workspace   # VS Code multi-root workspace
├── docker-compose.yml          # Local dev stack (PostgreSQL + API + Admin + Docs)
├── CLAUDE.md                   # AI agent workspace instructions
├── CONTEXT.md                  # Master project context
├── CONTROL.md                  # Execution plan + task tracking
├── .claude/
│   ├── commands/               # 17 slash commands (CTO, CPO, CMO, ICs, flows)
│   └── settings.local.json     # Permissions + hooks
└── <repos>/                    # Cloned by setup.sh (not tracked here)
    ├── flagbridge/             # Go API server
    ├── admin/                  # Admin dashboard (Next.js)
    ├── docs/                   # Documentation (VitePress)
    ├── landing/                # Marketing website (Next.js)
    ├── sdk-node/               # Node.js SDK
    ├── sdk-react/              # React SDK
    ├── sdk-go/                 # Go SDK
    ├── sdk-python/             # Python SDK
    ├── examples/               # Example apps
    └── ...                     # 9 more repos
```

## Local Development

```bash
# Start the full stack
docker compose up -d

# Open in VS Code
code flagbridge.code-workspace

# Start Claude Code with all agents
claude
```

### Services

| Service | URL | Source |
|---------|-----|--------|
| API (Go) | http://localhost:8080 | `flagbridge/` |
| Admin (Next.js) | http://localhost:3000 | `admin/` |
| Docs (VitePress) | http://localhost:5173 | `docs/` |
| PostgreSQL | localhost:5432 | Docker |

## Claude Code Agents

This workspace ships with 17 AI agents via `/slash commands`:

**C-Levels:** `/cto` (Bridge) · `/cpo` (Flag) · `/cmo` (Growth)

**ICs:** `/backend` · `/frontend` · `/sdk` · `/sre` · `/design` · `/docs` · `/qa` · `/security`

**Workflows:** `/sync` · `/clickup` · `/brain` · `/bug`

## License

Apache 2.0
