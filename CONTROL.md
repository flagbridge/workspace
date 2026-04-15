# FlagBridge — MVP Execution Control

> Arquivo de controle mestre. Atualizar status conforme execução.
> Última atualização: 2026-04-06
> Owner: Gabriel Gripp (@grippado)

---

## Pré-requisito: instalar agents e commands

Antes de tudo, rode estes comandos pra instalar os slash commands no Claude Code:

```bash
# Opção A — Instalação global (disponível em qualquer projeto)
cd flagbridge-kit
chmod +x setup/setup.sh
./setup/setup.sh

# Opção B — Instalação por projeto (só no workspace atual)
cd ~/flagbridge   # ou onde estiver seu workspace
chmod +x /path/to/flagbridge-kit/setup/setup.sh
/path/to/flagbridge-kit/setup/setup.sh --project

# Opção C — Manual (copiar diretamente)
mkdir -p ~/.claude/commands
cp flagbridge-kit/commands/*.md ~/.claude/commands/
```

Após instalar, teste no Claude Code:
```bash
claude
> /cto Olá Bridge, estamos online?
> /cpo Olá Flag, qual a prioridade do produto agora?
> /cmo Olá Growth, como estamos de awareness?
```

Todos os 19 comandos disponíveis:
```
C-Levels:    /cto  /cpo  /cmo
ICs:         /backend  /frontend  /sdk  /sre  /data  /design  /docs  /qa
Flows:       /feature  /api-review  /founders-circle-eval  /roadmap
             /competitive  /launch-check  /incident  /security
```

---

## Status Legend

```
⬜ Não iniciado
🟡 Em progresso
✅ Concluído
🔵 Tem doc/spec pronto, falta implementar
⏸️ Pausado / deprioritizado
```

---

## Inventário do que já existe

### Documentação produzida (chats anteriores)

| Doc | Status | Localização |
|-----|--------|-------------|
| Product doc v3 (EN + PT-BR) | ✅ | Conversa FlagBridge 1/n |
| Stitch prompts Admin UI (28 + 6 refinamento) | ✅ | flagbridge-stitch-prompts.md |
| Stitch prompts /developers + /marketplace | ✅ | flagbridge-developers-marketplace-EN.md |
| Bootstrap runbook (GitHub org, npm, repos) | ✅ | flagbridge-bootstrap-runbook.md |
| Brand guide (logo, tipografia, paleta) | ✅ | flagbridge-brand-guide.md |
| Infra decisions (CI/CD, Auth, Cache, Obs, Docs) | ✅ | flagbridge-infra-decisions.md |
| Testing API + Webhooks + Integrations spec | ✅ | Conversa FlagBridge 2/n |
| GrowthBook competitive analysis (12×3×10) | ✅ | flagbridge-vs-growthbook.md |
| SDK architecture (Dual-Mode, SSE, local eval) | ✅ | sdk-architecture.md |
| API reference (72 endpoints: 40 CE + 32 Pro) | ✅ | api-reference.md |
| 11 Claude Code Go implementation prompts | ✅ | claude-code-implementation-prompts.md |
| Founders Circle program design | ✅ | flagbridge-founders-circle.md |
| C-level agents (CTO, CPO, CMO) | ✅ | .claude/commands/ (7 commands) |
| Distinguished IC agents (8 agents) | ✅ | .claude/commands/ (8 commands) |
| Compound flows (4 flows) | ✅ | .claude/commands/ (4 commands) |

### GitHub org (github.com/flagbridge)

| Repo | Existe | Tem código | CLAUDE.md |
|------|--------|-----------|-----------|
| flagbridge (Go API) | ✅ | 🟡 | ⬜ |
| admin (Next.js) | ✅ | 🟡 | ⬜ |
| sdk-node | ✅ | 🟡 | ⬜ |
| sdk-react | ✅ | ⬜ | ⬜ |
| sdk-go | ✅ | ⬜ | ⬜ |
| sdk-python | ✅ | ⬜ | ⬜ |
| openfeature-provider | ✅ | ⬜ | ⬜ |
| plugin-sdk | ✅ | ⬜ | ⬜ |
| create-plugin | ✅ | ⬜ | ⬜ |
| cli | ✅ | ⬜ | ⬜ |
| docs (VitePress) | ✅ | ⬜ | ⬜ |
| helm-charts | ✅ | ⬜ | ⬜ |
| flagbridge-pro (private) | ✅ | ⬜ | ⬜ |
| files (private) | ✅ | ⬜ | ⬜ |
| .github | ✅ | 🟡 | — |

---

## Fases de execução até o MVP

### FASE 0 — Foundation (pré-código)
> Objetivo: CLAUDE.md em cada repo, slash commands instalados, infra base

| # | Task | Agent | Status | Prompt |
|---|------|-------|--------|--------|
| 0.1 | Copiar CLAUDE.md pra repo Go API | — | ⬜ | Manual: `cp CLAUDE-api.md flagbridge/CLAUDE.md` |
| 0.2 | Copiar CLAUDE.md pra repo admin | — | ⬜ | Manual: `cp CLAUDE-admin.md admin/CLAUDE.md` |
| 0.3 | Copiar CLAUDE.md pra repo sdk-node | — | ⬜ | Manual: `cp CLAUDE-sdk-node.md sdk-node/CLAUDE.md` |
| 0.4 | Copiar CLAUDE.md pra repo docs | — | ⬜ | Manual: `cp CLAUDE-docs.md docs/CLAUDE.md` |
| 0.5 | Instalar slash commands | — | ⬜ | Manual: `cp -r claude-commands/ ~/.claude/commands/` |
| 0.6 | Configurar Vercel pra admin | /sre | ⬜ | `/sre Configure Vercel for flagbridge/admin repo with preview deploys` |
| 0.7 | Configurar Vercel pra docs | /sre | ⬜ | `/sre Configure Vercel for flagbridge/docs VitePress site` |
| 0.8 | GitHub Actions CI base (Go + TS) | /sre | ⬜ | `/sre Create GitHub Actions CI for Go API (lint, test, build) and Node SDK (biome, vitest, build)` |
| 0.9 | Docker Compose local dev | /sre | ⬜ | `/sre Create docker-compose.yml for local dev: Go API (8080) + PostgreSQL (5432). Admin roda via npm dev` |

---

### FASE 1 — Core API (Go)
> Objetivo: API funcional com flag CRUD, evaluation engine, e testes
> Agente primário: `/backend`
> Baseado em: 11 Claude Code implementation prompts (doc existente)

| # | Task | Agent | Status | Prompt |
|---|------|-------|--------|--------|
| 1.1 | Scaffold Go project (Chi, pgx, sqlc, goose, slog) | /backend | ⬜ | `/backend Scaffold the Go API project: Chi router, pgx, sqlc, goose migrations, slog logging. Health endpoint GET /api/v1/health. Config via env vars. Graceful shutdown.` |
| 1.2 | DB migrations base (users, projects, envs, flags, states, audit) | /backend | ⬜ | `/backend Create goose migrations: projects, environments, flags, flag_states, targeting_rules, audit_log, api_keys. Follow snake_case. Include indexes for hot queries.` |
| 1.3 | Auth middleware (API key scopes) | /backend | ⬜ | `/backend Implement API key auth middleware. 4 scopes: eval, test, mgmt, full. Keys format: fb_sk_{scope}_{hash}. Middleware extracts from Authorization: Bearer header. Reject wrong scope with 403.` |
| 1.4 | Project CRUD | /backend | ⬜ | `/backend Implement project CRUD: GET/POST /api/v1/projects, GET/PATCH/DELETE /api/v1/projects/:slug. Include environment management per project. sqlc queries + Chi handlers.` |
| 1.5 | Flag CRUD + states per env | /backend | ⬜ | `/backend Implement flag CRUD: GET/POST /projects/:project/flags, GET/PATCH/DELETE /projects/:project/flags/:key. Flag states per environment: GET/PUT /projects/:project/flags/:key/states/:env. Support boolean, string, number, json types.` |
| 1.6 | Targeting rules engine | /backend | ⬜ | `/backend Implement targeting rules engine. Rules have conditions (attribute operators: eq, ne, gt, gte, lt, lte, in, notIn, contains, regex, etc), priority ordering, and percentage allocation. Store as JSONB in PostgreSQL.` |
| 1.7 | Flag evaluation endpoint | /backend | ⬜ | `/backend Implement POST /api/v1/evaluate and POST /api/v1/evaluate/batch. Resolution order: testing session override > targeting rules > rollout percentage > environment default > flag default. Return flag value + resolution reason. Benchmark: <1ms per evaluation.` |
| 1.8 | Percentage rollout (MurmurHash3) | /backend | ⬜ | `/backend Implement percentage rollout using MurmurHash3 hashing of (userId + flagKey + salt). Map hash to range [0, 10000] for 0.01% granularity. Must be deterministic: same user always gets same bucket.` |
| 1.9 | Audit log | /backend | ⬜ | `/backend Implement immutable audit log. Record every flag change, toggle, user action. GET /api/v1/audit-log with filters: user, action type, date range, entity. Append-only table.` |
| 1.10 | Testing API (CE basic) | /backend | ⬜ | `/backend Implement Testing API CE: POST /testing/sessions, DELETE /testing/sessions/:id, PUT/GET/DELETE overrides. Scoped overrides per session. Session overrides take priority in evaluation. Only test/full scope keys allowed.` |
| 1.11 | Webhooks (CE) | /backend | ⬜ | `/backend Implement webhooks: CRUD at /projects/:project/webhooks. 9 event types (flag.created, flag.toggled, flag.deleted, etc). HMAC-SHA256 signing. Async delivery with 5 retries exponential backoff. Delivery logs with GET /webhooks/:id/logs. Test endpoint POST /webhooks/:id/test.` |
| 1.12 | Testes do evaluation engine | /qa | ⬜ | `/qa Write comprehensive table-driven tests for the flag evaluation engine: all resolution order combinations, targeting rules with all operators, percentage rollout distribution, testing session override isolation, edge cases (nil user, empty attributes, missing env).` |

---

### FASE 2 — SDK Node v1
> Objetivo: SDK funcional publicado no npm
> Agente primário: `/sdk`

| # | Task | Agent | Status | Prompt |
|---|------|-------|--------|--------|
| 2.1 | SDK core (client, evaluator, http, types) | /sdk | ⬜ | `/sdk Implement @flagbridge/sdk-node core: FlagBridge client class, isEnabled(), getString(), getNumber(), getJSON(), evaluateBatch(). Zero deps, native fetch. TypeScript strict. Sensible defaults. Graceful degradation (return default on error).` |
| 2.2 | Testing helpers | /sdk | ⬜ | `/sdk Add testing helpers to sdk-node: fb.testing.createSession(), destroySession(), setOverride(), setOverridesBatch(). Ergonomic for Playwright/Cypress. Session ID flows via header X-FlagBridge-Session.` |
| 2.3 | In-memory cache | /sdk | ⬜ | `/sdk Add client-side in-memory cache with configurable TTL. Idempotent: same input returns cached result. Cache invalidation on flag change event.` |
| 2.4 | ESM + CJS build | /sre | ⬜ | `/sre Configure sdk-node for dual ESM+CJS publishing. tsup or unbuild. package.json exports field. Tree-shakeable. Bundle size tracking in CI.` |
| 2.5 | README + JSDoc | /docs | ⬜ | `/docs Write comprehensive README for @flagbridge/sdk-node: installation, quick start (5 lines), full API reference, testing helpers, TypeScript generics, error handling. Copy-pasteable examples.` |
| 2.6 | Publish npm | — | ⬜ | Manual: `cd sdk-node && npm publish --access public` |

---

### FASE 3 — Admin UI (Next.js)
> Objetivo: admin funcional com flag management
> Agente primário: `/frontend` + `/design`

| # | Task | Agent | Status | Prompt |
|---|------|-------|--------|--------|
| 3.1 | App shell (layout, sidebar, auth, i18n) | /frontend | ⬜ | `/frontend Scaffold Next.js admin app: App Router, Biome.js, next-intl (EN+PT-BR), TanStack Query provider, Radix UI theme, Tailwind config. Dark theme default. Sidebar with: Dashboard, Projects, Plugins, Settings, Audit Log. Auth via Supabase Auth.` |
| 3.2 | Dashboard page | /frontend | ⬜ | `/frontend Build dashboard page: overview cards (total flags, active, stale), activity feed (recent changes), health badge. Use TanStack Query. Loading skeletons, error states, empty states. i18n all strings.` |
| 3.3 | Project list + CRUD | /frontend | ⬜ | `/frontend Build projects page: list with search/filter, create project dialog (Radix Dialog), project card with environment count and flag count. CRUD via TanStack Query mutations with optimistic updates.` |
| 3.4 | Flag list + filter | /frontend | ⬜ | `/frontend Build flag list page at /projects/[id]/flags: table with columns (name, type, status per env, last modified). Filters: status, type, tags. Bulk toggle. TanStack Query with pagination.` |
| 3.5 | Flag detail + toggle + targeting editor | /frontend | ⬜ | `/frontend Build flag detail page: toggle switch, visual targeting rule editor (add/remove conditions, set operators and values, drag to reorder priority), environment comparison side-by-side. Radix Tabs for sections.` |
| 3.6 | API keys management | /frontend | ⬜ | `/frontend Build API keys page in settings: create key (select scope), copy-once dialog, list with last used date, revoke with confirmation. Mask key value after creation (show only fb_sk_eval_****).` |
| 3.7 | Audit log viewer | /frontend | ⬜ | `/frontend Build audit log page: filterable table (user, action, date range, entity). Expandable rows showing before/after diff. Infinite scroll via TanStack Query useInfiniteQuery.` |
| 3.8 | Webhook management | /frontend | ⬜ | `/frontend Build webhook management at /projects/[id]/webhooks: list, create (URL + event selection), delivery log per webhook, test button that sends sample payload. Status indicator (healthy/failing).` |
| 3.9 | ProGate component | /frontend | ⬜ | `/frontend Build ProGate component: wraps Pro-only UI. Reads from _flagbridge internal project. If flag off → renders upgrade CTA card with feature description and "Upgrade to Pro" button. Used on: analytics, product cards, lifecycle, integrations.` |
| 3.10 | Deploy to Vercel | /sre | ⬜ | `/sre Configure admin repo for Vercel deployment. Environment variables for API URL, Supabase keys. Preview deploys on PR. Production on main merge.` |

---

### FASE 4 — Docs Site (VitePress)
> Objetivo: documentação funcional com getting started, API ref, SDK docs
> Agente primário: `/docs`

| # | Task | Agent | Status | Prompt |
|---|------|-------|--------|--------|
| 4.1 | VitePress scaffold + i18n | /docs | ⬜ | `/docs Scaffold VitePress site with i18n (EN default + PT-BR). Configure sidebar, nav, search. Dark theme. Deploy-ready for Vercel.` |
| 4.2 | Getting started (quickstart) | /docs | ⬜ | `/docs Write getting started guide: zero to first flag in 5 minutes. Docker compose up → create project → create flag → evaluate from SDK. curl + Node SDK examples. Must be copy-pasteable and work first try.` |
| 4.3 | API reference (all CE endpoints) | /docs | ⬜ | `/docs Write API reference for all 40 CE endpoints. Each endpoint: method, path, auth scope required, request body, response body, error codes, curl example + Node SDK example. Group by resource.` |
| 4.4 | SDK Node docs | /docs | ⬜ | `/docs Write SDK Node documentation: installation, initialization, evaluation methods, testing helpers, TypeScript generics, error handling, configuration options. Code groups with Node + Go examples.` |
| 4.5 | Testing E2E guide (differentiator) | /docs | ⬜ | `/docs Write E2E testing guide: the #1 FlagBridge differentiator. Show Playwright + Cypress examples with session creation, overrides, deterministic tests, cleanup. Compare to LaunchDarkly/Unleash approach (show why FlagBridge is better). CE and Pro badges.` |
| 4.6 | Self-hosted installation guide | /docs | ⬜ | `/docs Write self-hosted installation guide: Docker Compose (recommended), Kubernetes (Helm), manual. Include: env vars reference, PostgreSQL setup, first run, health check verification, upgrade procedure.` |
| 4.7 | Deploy to Vercel | /sre | ⬜ | Junto com 0.7 |

---

### FASE 5 — Landing Page
> Objetivo: flagbridge.io com messaging, CTAs, e conversão
> Agente primário: `/frontend` + `/cmo`

| # | Task | Agent | Status | Prompt |
|---|------|-------|--------|--------|
| 5.1 | Landing page hero + quick start | /frontend | ⬜ | `/frontend Build landing page hero section: headline "Feature flags with product intelligence", subheadline, 2 CTAs (Get Started Free, GitHub). Terminal mockup showing npm install + flagbridge init. Dark theme.` |
| 5.2 | Features section | /frontend | ⬜ | `/frontend Build features section: 6 cards (Testing API, Plugin Marketplace, Product Intelligence, OpenFeature, Self-hosted, Flat-rate pricing). CE/Pro badges. Icons via Lucide.` |
| 5.3 | SDK showcase + code tabs | /frontend | ⬜ | `/frontend Build SDK section: "SDKs for every stack" with tabbed code editor showing Node, Go, Python examples. SDK badges row. OpenFeature compatibility callout.` |
| 5.4 | Pricing section | /frontend | ⬜ | `/frontend Build pricing section: 3 tiers (CE free, Pro $29/mo, Enterprise contact us). Feature comparison table. CE column highlighted as "Most popular". Toggle annual/monthly.` |
| 5.5 | /developers page | /frontend | ⬜ | `/frontend Build /developers page: Testing API highlight with Playwright code example, SDK showcase, API overview (72 endpoints), webhooks, integrations grid. Stitch prompts available as reference.` |
| 5.6 | /founders-circle page | /frontend | ⬜ | `/frontend Build /founders-circle page: program explanation, revenue share model, vesting timeline visualization, roadmap of open contributions (Waves 1-4), application CTA. Inspirational tone.` |
| 5.7 | GA4 + GTM setup | /cmo | ⬜ | `/cmo Define GA4 event tracking plan for flagbridge.io: pageview, CTA clicks (get-started, github, docs), scroll depth, pricing tier clicks, /founders-circle application clicks. GTM container setup.` |

---

### FASE 6 — Launch Prep
> Objetivo: tudo pronto pra Show HN, Product Hunt, e primeira tração
> Agente primário: `/cmo` + `/cpo`

| # | Task | Agent | Status | Prompt |
|---|------|-------|--------|--------|
| 6.1 | Launch readiness check | /launch-check | ⬜ | `/launch-check` |
| 6.2 | README do repo principal | /docs | ⬜ | `/docs Write the main flagbridge repo README: badges, hero image, what is FlagBridge (3 lines), quick start (docker compose), feature highlights, architecture diagram, SDK links, contributing, license. Bilingual.` |
| 6.3 | Show HN post | /cmo | ⬜ | `/cmo Write a Show HN post for FlagBridge launch. Hook: Testing API differentiator. Tone: humble, technical, honest about what's built and what's planned. Include: what it is, why we built it, what makes it different, link to GitHub + live demo.` |
| 6.4 | Product Hunt assets | /cmo | ⬜ | `/cmo Prepare Product Hunt launch: tagline (60 chars), description (260 chars), 5 screenshots/GIFs to prepare, maker comment draft, first day strategy.` |
| 6.5 | Blog post: "Why we built FlagBridge" | /cmo | ⬜ | `/cmo Write launch blog post: problem (feature flags without product context), solution (FlagBridge), differentiators (Testing API, Product Intelligence, Plugin Marketplace, Founders Circle). Technical but accessible. EN + PT-BR.` |
| 6.6 | Competitive pages | /docs | ⬜ | `/competitive LaunchDarkly` then `/competitive GrowthBook` then `/competitive Unleash` |
| 6.7 | Docker Hub / ghcr.io image | /sre | ⬜ | `/sre Build and publish FlagBridge Docker image to ghcr.io. Multi-stage build: Go binary on scratch (<20MB). Tag with semver. README with docker pull instructions.` |

---

## Ordem de execução recomendada

```
Semana 1-2: FASE 0 (foundation) + FASE 1.1-1.5 (API scaffold + CRUD)
Semana 3-4: FASE 1.6-1.9 (evaluation engine + audit)
Semana 5:   FASE 1.10-1.12 (testing API + webhooks + testes)
Semana 6:   FASE 2 (SDK Node completo)
Semana 7-8: FASE 3.1-3.5 (Admin UI core)
Semana 9:   FASE 3.6-3.10 (Admin UI restante)
Semana 10:  FASE 4 (Docs site)
Semana 11:  FASE 5 (Landing page)
Semana 12:  FASE 6 (Launch prep)
```

**MVP total: ~12 semanas** de desenvolvimento focado com Claude Code.

Isso assume dedicação parcial (side project, ~15-20h/semana). Com dedicação full-time, comprime pra 6-8 semanas.

---

## Como usar este arquivo

1. Abra no seu editor (VS Code, Obsidian, etc.)
2. Atualize o status de cada task conforme executa
3. Antes de cada sessão de Claude Code, consulte este arquivo pra saber o próximo item
4. Use o slash command indicado na coluna "Agent" pra ter o contexto certo
5. Quando completar uma fase, rode `/launch-check` pra verificar readiness

## Prompts rápidos por fase

```bash
# Começar o dia — ver o que falta
"Leia o CONTROL.md e me diga: qual é o próximo item ⬜ na sequência?"

# Executar um item
/backend [colar o prompt da coluna "Prompt"]

# Revisar antes de commitar
/cto Review o que foi implementado nessa sessão

# Fim do dia — atualizar controle
"Atualize o CONTROL.md: marque items X, Y, Z como ✅"
```

---

## Decisões em aberto (resolver com C-levels)

| Decisão | Usar agent | Status |
|---------|-----------|--------|
| VPS HostGator: mover Go API de Fly.io pra VPS? | /cto + /sre | ⬜ |
| Pro pricing: $29/mo é o certo? | /cpo | ⬜ |
| Founders Circle: quando anunciar publicamente? | /cmo | ⬜ |
| SDK React: priorizar antes ou depois do launch? | /cpo | ⬜ |
| Helm charts: prioridade MVP ou post-launch? | /cto | ⬜ |
