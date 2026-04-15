# CLAUDE.md — Isaac Workspace (Agendas e Conversas)

This is the root workspace for the **[Meu Arco] Agendas e Conversas** team at Arco Educacao. Claude Code operates across multiple repositories from this directory.

## Workspace Map

```
www/
├── REPOS/
│   ├── communication-api/      # Backend API — Fastify + Drizzle + MySQL + SQS (port 3334)
│   ├── backoffice-bff/          # BFF — Fastify + tRPC + GraphQL (port 3333)
│   ├── backoffice/              # School Frontend — React 19 + Vite + Turbo (port 3000)
│   ├── rf-monorepo/             # Student/Guardian Frontend — Next.js 16 + Turbo (port 3008)
│   ├── technical-refining/      # DRTs, task breakdowns, architectural diagrams
│   ├── arco-agents/             # Agent marketplace — 25 agents, 66 skills, 29 commands
│   ├── gravity-design-system/   # Shared UI components (@gravity/*)
│   ├── joy/                     # Legacy — Express + GraphQL + Bookshelf/Knex + MySQL
│   ├── payment-api/             # Go — Fiber + GORM + PostgreSQL
│   ├── school-api/              # Go — Fiber + GORM + PostgreSQL
│   └── sorting-hat/             # IAM/Auth SDK over Keycloak
├── DOCS/
│   ├── COMMS-ONBOARDING.md      # Full domain onboarding (architecture, flows, setup)
│   └── references/              # Diagrams, reference docs
├── PROJECTS/                    # Side projects (app, copy-tokens-ext, e2e, pi)
└── PROMPTS/                     # Prompt templates (refinamento.md, quebra-de-tarefas.md)
```

## Repository CLAUDE.md Files

Each repository has its own CLAUDE.md with repo-specific rules. **ALWAYS read the target repo's CLAUDE.md before making changes:**

- `REPOS/communication-api/CLAUDE.md` — Layered architecture, repository pattern, controller 6-step, Drizzle ORM rules
- `REPOS/backoffice-bff/CLAUDE.md` — Module pattern, tRPC/GraphQL, Zod validation, use-case layer
- `REPOS/backoffice-bff/GUIDE.md` — Advanced patterns and examples
- `REPOS/rf-monorepo/apps/messages/CLAUDE.md` — Messages app conventions

## Architecture Overview

```
School (REPOS/backoffice) ──tRPC──> REPOS/backoffice-bff ──REST/GraphQL──> REPOS/communication-api ──> MySQL + SQS + S3
Student (REPOS/rf-monorepo) ──tRPC──> Next.js API Routes ──REST──> REPOS/communication-api ──> MySQL + SQS + S3
```

**Key Principle:** Frontends NEVER call communication-api directly. All traffic goes through BFF layers.

## Cross-Repository Development Rules

### Feature Implementation Order
When a feature spans multiple repos, implement in this order:
1. **REPOS/communication-api** — Database migrations, repositories, services, routes
2. **REPOS/backoffice-bff** — Clients, use-cases, controllers, tRPC routers
3. **REPOS/backoffice** OR **REPOS/rf-monorepo** — UI components, state, hooks

### Contract Consistency
API contracts (types, DTOs, request/response shapes) MUST be identical across all consuming layers. When you define a type in communication-api, the same shape must appear in the BFF client and frontend types.

### Feature Flags
- Use **Unleash** for gradual rollouts
- Naming: `[TEAM_ACRONYM]_XXXX_ENABLE_<FEATURE_NAME>`
- Always create flag as first task, remove flag as last task
- Segmentation by `educationalUnitId`

### Commit Conventions
| Repo | Format | Example |
|------|--------|---------|
| communication-api | Conventional | `feat(messages): add scheduled send` |
| backoffice | Conventional | `fix(communication-hub): channel creation` |
| backoffice-bff | Task number | `[CPU-2473] Adiciona endpoint POST para canais` |
| rf-monorepo | Conventional | `feat(messages): add reply threading` |

## Technical Refining — Documentation Hub

`REPOS/technical-refining/` is the single source of truth for **DRTs** (Documentos de Refinamento Tecnico) and task breakdowns.

### When to use it
- **Before implementing a feature:** Check `REPOS/technical-refining/teams/` for existing DRTs and task files with ready-to-use implementation context, contracts, and file paths
- **When breaking down work:** Follow the methodology in `REPOS/technical-refining/shared/guides/task-breakdown-from-drt.md`
- **When generating new DRTs:** Use the prompt template at `PROMPTS/refinamento.md`
- **When breaking DRTs into tasks:** Use `PROMPTS/quebra-de-tarefas.md`

### Reference Model
`REPOS/technical-refining/teams/agendas-e-conversas/ia-em-comunicados/` contains the complete example:
- 3 DRTs (configuration, moderation, improvement)
- 36 detailed tasks with contracts, file paths, and agent prompts
- 9 Mermaid architectural diagrams

### DRT Rules (from REPOS/technical-refining/RULES.md)
- NEVER invent file paths — always navigate the target codebase
- Respect "Out of Scope" boundaries in tasks
- Contracts are rigid — do not deviate from specified types
- Each task = one independent deploy unit
- Include tests in every Definition of Done

## Arco Agents — Workflow Automation

`REPOS/arco-agents/` provides a comprehensive agent marketplace. Use these workflows for structured development.

### Key Workflows

**Development Cycle (10-gate backend):**
Use `/arco:dev-cycle` for structured backend development with gates for analysis, TDD, implementation, review, and standards compliance.

**Frontend Development (9-gate):**
Use `/arco:dev-cycle-frontend` for frontend work with accessibility, visual, E2E, and performance gates.

**Pre-Development Planning:**
- `/arco:pre-dev-feature` — Plan simple features (<2 days, 5 gates)
- `/arco:pre-dev-full` — Plan complex features (>=2 days, 10 gates)

**Code Review (parallel 5-reviewer system):**
Use `/arco:codereview` to dispatch 5 specialized reviewers in parallel: architecture, business-logic, security, test, and nil-safety.

### Specialist Agents
When working across repos, dispatch the appropriate specialist agent:

| Agent | Use For |
|-------|---------|
| `arco:backend-engineer-typescript` | communication-api and backoffice-bff services |
| `arco:frontend-bff-engineer-typescript` | backoffice-bff modules (Next.js BFF, Clean Architecture, DDD) |
| `arco:frontend-engineer` | backoffice and rf-monorepo React/Next.js components |
| `arco:ui-engineer` | Design system components, accessibility |
| `arco:devops-engineer` | Docker, CI/CD, Terraform, GitHub Actions |
| `arco:sre` | Monitoring, alerting, incident response |
| `arco:qa-analyst` | Test coverage and quality |
| `arco:qa-analyst-frontend` | Frontend-specific QA |

### Research Agents (Pre-Development)
| Agent | Use For |
|-------|---------|
| `arco:repo-research-analyst` | Analyze codebase patterns before implementing |
| `arco:best-practices-researcher` | Research industry patterns and framework standards |
| `arco:framework-docs-researcher` | Lookup official framework docs |
| `arco:product-designer` | UX specs and design validation |

### Documentation Agents
| Agent | Use For |
|-------|---------|
| `arco:functional-writer` | Guides and tutorials |
| `arco:api-writer` | API reference documentation |
| `arco:docs-reviewer` | Documentation quality review |

### Standards Files
Dev-team agents enforce standards from `REPOS/arco-agents/dev-team/docs/standards/`:
- `typescript.md` — TypeScript patterns for all repos
- `frontend.md` — Component patterns, state management, testing
- `devops.md` — Dockerfile, CI/CD standards
- `sre.md` — Health endpoints, logging, monitoring
- `qa.md` — Test coverage and patterns

## Local Agents (.claude/agents/)

These workspace-specific agents complement arco-agents with Isaac platform knowledge:

| Agent | Use For |
|-------|---------|
| `backend-engineer` | Backend work across ALL repos (communication-api, backoffice-bff, payment-api, school-api, joy, sorting-hat) |
| `frontend-engineer` | Frontend work across backoffice, rf-monorepo, gravity-design-system |
| `specialist-engineer` | Fullstack end-to-end features, technical refinements, cross-repo refactoring |
| `cross-repo-feature` | Orchestrating multi-repo feature implementation with contract consistency |
| `bug-investigator` | Tracing and fixing bugs through the full stack |
| `drt-context-loader` | Loading task/DRT context from REPOS/technical-refining/ before implementation |
| `comms-api-reviewer` | Code review for communication-api using 40+ team-extracted rules |

### Local Commands (.claude/commands/)

| Command | Use For |
|---------|---------|
| `/implement-task` | Load a task from technical-refining and implement it with dev-cycle gates |
| `/investigate-bug` | Investigate and fix a bug by tracing through the full stack |

## Working with Bugs

1. **Identify the layer:** Determine which repo(s) are affected
2. **Read the relevant CLAUDE.md** of the affected repo(s)
3. **Dispatch `bug-investigator`** agent or use `/investigate-bug` command
4. **Check REPOS/technical-refining/** for any related DRT context
5. **Use `arco:repo-research-analyst`** to analyze patterns in the affected area
6. **Apply TDD:** Write a failing test first, then fix
7. **Run `comms-api-reviewer`** (for communication-api) or `/arco:codereview` before submitting

## Working with Features

1. **Load context:** Use `drt-context-loader` to check REPOS/technical-refining/ for existing DRT and tasks
2. **If no DRT exists:** Use `/arco:pre-dev-feature` or `/arco:pre-dev-full` to plan
3. **Use `/implement-task`** to implement from a task breakdown, or dispatch `cross-repo-feature` for multi-repo work
4. **Follow implementation order:** API -> BFF -> Frontend
5. **Use `/arco:dev-cycle`** (backend) or `/arco:dev-cycle-frontend` (frontend) for structured gates
6. **Dispatch specialist agents** per layer: `backend-engineer`, `frontend-engineer`, or arco-agents specialists
7. **Run `/arco:codereview`** on each repo's changes

## Testing Commands Quick Reference

| Repo | Unit | Integration | Coverage |
|------|------|-------------|----------|
| communication-api | `pnpm test` | `make test/integration/run` | `make test/integration/coverage` |
| backoffice | `make test` | — | `make test-coverage` |
| backoffice-bff | `make test` | — | `make test-coverage` |
| rf-monorepo | `pnpm test` | `pnpm e2e` (Playwright) | `pnpm test:coverage` |

## Domain Reference

For comprehensive domain knowledge (message types, data flows, recipient resolution, media upload, moments, surveys, permissions), see **`DOCS/COMMS-ONBOARDING.md`**.

## Knowledge Sync

Use `/sync-knowledge` to manually sync workspace knowledge. The `knowledge-sync` agent scans all repos, compares against current agent knowledge, and updates agents/docs where patterns have meaningfully changed.

Tracking is stored in `.claude/last-sync.json`.

### When to Sync

- **After major work:** After implementing a feature that introduces new patterns, run `/sync-knowledge`.
- **After team convention changes:** When `.cursor/rules/`, CLAUDE.md, or GUIDE.md files change in any repo.
- **Periodically:** Run `/sync-knowledge` weekly to stay current.

### What Gets Updated

| Source | Updates |
|--------|---------|
| Repo CLAUDE.md / GUIDE.md changes (in REPOS/) | Local agents + root CLAUDE.md |
| New `.cursor/rules/` files (in REPOS/) | Corresponding local agent |
| New modules/services/patterns (in REPOS/) | Backend/frontend engineer agents |
| New DRTs in REPOS/technical-refining/ | DRT context loader agent |
| New team PR review patterns | Comms-api-reviewer agent |

## Critical Don'ts

- **NEVER** call communication-api directly from frontends — always go through BFF
- **NEVER** put business logic in repositories (communication-api) or controllers (backoffice-bff)
- **NEVER** use `console.log` — use structured loggers (`@/lib/logger` or `@monorepo/observability/logger`)
- **NEVER** use `any` type — use `unknown` if type is truly unknown
- **NEVER** skip reading the target repo's CLAUDE.md before making changes
- **NEVER** invent file paths — always verify by navigating the codebase
- **NEVER** create tasks that span multiple repos — one task = one repo = one deploy
