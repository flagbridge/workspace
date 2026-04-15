# FlagBridge — Master Context

> Este arquivo é a fonte de verdade do projeto.
> Colocar na raiz do workspace: ~/flagbridge/CONTEXT.md
> Todos os agents leem este arquivo primeiro.
> Última atualização: 2026-04-08

---

## O que é o FlagBridge

Open-core Feature Flag Management platform com product intelligence. Ponte entre engenharia e estratégia de produto.

**Site:** flagbridge.io
**Admin:** admin.flagbridge.io
**Docs:** docs.flagbridge.io
**Org:** github.com/flagbridge (15 repos)
**License:** Apache 2.0 (CE), Commercial (Pro)
**Founder:** Gabriel Gripp (@grippado)

---

## Business Model

| Stream | Modelo | Preço |
|--------|--------|-------|
| Community Edition | Free, Apache 2.0 | $0 |
| Pro | License key, self-hosted | $29/mo |
| SaaS | Managed hosting (futuro) | TBD |
| Marketplace | 80/20 Stripe Connect (dev keeps 80%) | % da venda |
| Founders Circle | Revenue share — 10% pool do faturamento líquido | 0.1-2% por contribuição |

---

## Stack Atual

### Deploy

| Componente | Tech | Deploy | Custo |
|------------|------|--------|-------|
| Go API | Go 1.22+, Chi, pgx, sqlc, goose, slog | Fly.io (gru) → VPS HostGator | ~$5/mo |
| Admin UI | Next.js (App Router), Biome, next-intl, TanStack Query, Radix, Tailwind | **Vercel** | free |
| Docs site | VitePress (Vue), i18n built-in | **Vercel** | free |
| Landing | Next.js (same app or separate) | **Vercel** | free |
| Database | PostgreSQL | Supabase (free → $25) | $0 |
| Auth SaaS | Supabase Auth (GitHub, Google, email, magic link) | Supabase | $0 |
| Auth self-hosted | Local bcrypt + JWT | Docker | $0 |
| Cache | In-memory Go (CacheProvider interface) | — | $0 |
| Assets | Cloudflare R2 | Cloudflare | $0 |
| Errors | Sentry | Sentry | $0 |
| Uptime | Betterstack | Betterstack | $0 |
| CI/CD | GitHub Actions | GitHub | $0 |
| Email | Resend | Resend | $0 |
| Payments | Stripe Connect | Stripe | tx fees |
| **Total MVP** | | | **~$16/mo** |

**Regras de deploy:**
- Frontend SEMPRE na Vercel (não Cloudflare Pages)
- Next.js SEMPRE na versão mais recente (não referenciar versões específicas)
- VPS HostGator disponível e compartilhada com OpenGateway, DeclareUI, VOZES
- Labor.city pausado até FlagBridge lançar

### Convenções de código

**Go API:**
- Chi router, pgx, sqlc (type-safe queries), goose (migrations), slog (structured logging)
- snake_case DB, camelCase JSON, PascalCase Go types
- Table-driven tests com testify, errors wrapped com contexto
- CacheProvider interface (in-memory), AuthProvider interface (Supabase/local)

**Admin UI:**
- Biome.js (NÃO ESLint), next-intl (EN + PT-BR obrigatório), TanStack Query v5
- Radix UI pra primitivos, Tailwind CSS only (sem CSS modules)
- Server Components default, "use client" só com interatividade
- Toda string via next-intl, todo componente com loading/error/empty states

**SDKs (TypeScript):**
- Zero runtime dependencies (native fetch), ESM + CJS dual publish
- TypeScript strict, Vitest, Biome.js, JSDoc em todo método público
- Graceful degradation: nunca throw em produção, retorna default

**Docs (VitePress):**
- Vue + VitePress, i18n EN + PT-BR via built-in
- Code groups pra multi-language, custom containers pra callouts
- Deploy na Vercel

---

## API Surface — 72 Endpoints (40 CE + 32 Pro)

### Scopes de API Key
```
fb_sk_eval_...  → evaluation only (SDKs prod)
fb_sk_test_...  → testing (E2E, QA)
fb_sk_mgmt_...  → management (admin, CI/CD)
fb_sk_full_...  → all (local dev)
```

### Endpoints por grupo

**Flag Management (CE):** CRUD flags, flag states per environment
**Evaluation (CE):** POST /evaluate, /evaluate/batch, GET /sdk/payload
**Testing API (CE+Pro):** sessions CRUD, overrides, snapshot/restore (Pro), metrics (Pro)
**Webhooks (CE):** CRUD, delivery logs, test endpoint. 9 event types, HMAC-SHA256
**Segments (CE):** CRUD saved groups, id_lists
**Prerequisites (CE):** flag dependencies, cycle detection
**Product Cards (Pro):** hypothesis, success metrics per flag
**Metrics (Pro):** evaluation volume, error rates, dashboard overview
**Lifecycle (Pro):** stale detection, cleanup suggestions, code references
**Plugin System (CE+Pro):** install, config, status
**Marketplace (Pro):** listings CRUD, purchase, earnings
**Integrations (Pro):** Mixpanel, Customer.io, Amplitude, Segment, Datadog, Slack
**SSE Streaming (CE):** real-time flag updates, no proxy needed
**Change Requests (Pro):** publishing/approval flows
**Guardrails (Pro):** safe rollouts with auto-rollback
**Admin (CE):** audit log, health check

### Resolution Order (evaluation engine)
```
Testing session override
  → Targeting rules (conditions + segments + prerequisites)
    → Percentage rollout (MurmurHash3 deterministic)
      → Environment default
        → Flag default
```

---

## Pro Gating — ADR-001 Dogfooding

FlagBridge usa ele mesmo pra gating:
- Internal project: `_flagbridge`
- Flags: `pro.*` namespace
- UI: `<ProGate flag="pro.analytics">` → CTA de upgrade se off
- Trial: 14 dias pra novos installs

---

## Competitive Positioning

| vs | FlagBridge wins | They win |
|----|----------------|----------|
| LaunchDarkly | Open-source, $29 vs $72K, Testing API, self-hosted | Enterprise features, brand awareness |
| Unleash | Product intelligence, plugin marketplace, managed integrations | Community size, maturity |
| GrowthBook | Dual-Mode SDK (3 modes vs 1), Testing API, SSE nativo (sem proxy) | Visual Editor, data warehouse integration |
| Flagsmith | OpenFeature native, Testing API | Broader SDK coverage |

**Diferenciador #1:** Testing API com sessões isoladas — ninguém tem isso nativo.

---

## Founders Circle

Revenue share program pra devs que contribuem plugins/SDKs oficiais ao core:
- Pool: 10% do faturamento líquido
- Tiers: S (1-2%), A (0.5-1%), B (0.2-0.5%), C (0.1-0.2%)
- Vesting: 6 meses cliff + 18 meses linear, com aceleradores de milestone
- 4 waves no roadmap: SDKs de linguagem → Integrations → Framework adapters → Infra plugins
- Doc completo: docs/founders-circle-program.md

---

## Repos (github.com/flagbridge)

| Repo | O que é | Stack | Prioridade MVP |
|------|---------|-------|---------------|
| flagbridge | Go API server | Go | 🔴 P0 |
| admin | Admin Dashboard | Next.js | 🔴 P0 |
| sdk-node | Node.js/TS SDK | TypeScript | 🔴 P0 |
| docs | Documentation | VitePress | 🔴 P0 |
| sdk-react | React SDK | TypeScript | 🟡 P1 |
| sdk-go | Go SDK | Go | 🟡 P1 |
| sdk-python | Python SDK | Python | 🟡 P1 |
| openfeature-provider | OF Provider | TypeScript | 🟡 P1 |
| plugin-sdk | Plugin dev kit | TypeScript | 🟡 P1 |
| create-plugin | Plugin scaffolder | JavaScript | 🟢 P2 |
| cli | CLI tool | JavaScript | 🟢 P2 |
| helm-charts | K8s Helm charts | YAML | 🟢 P2 |
| flagbridge-pro | Pro plugin (private) | Go + TS | 🟡 P1 |
| files | Internal docs (private) | Markdown | — |
| .github | Org config | — | — |

---

## Docs produzidos (referência)

Estes documentos foram gerados em conversas anteriores no Claude e estão disponíveis nos chats:

| Doc | Conversa |
|-----|----------|
| Product doc v3 (EN + PT-BR, 1.700+ linhas) | FlagBridge 1/n |
| Stitch prompts Admin UI (28 + 6) | FlagBridge 1/n |
| Stitch prompts /developers + /marketplace | FlagBridge 2/n |
| Bootstrap runbook (GitHub, npm, repos) | FlagBridge 1/n |
| Brand guide (logo, tipografia, paleta) | FlagBridge 1/n |
| Infra decisions (CI/CD, Auth, Cache, Obs) | FlagBridge 2/n |
| Testing API + Webhooks + Integrations spec | FlagBridge 2/n |
| GrowthBook competitive (12×3×10) | Docs FlagBridge |
| SDK architecture (Dual-Mode, SSE, Hybrid) | Docs FlagBridge |
| API reference (72 endpoints) | Docs FlagBridge |
| 11 Go implementation prompts (6 semanas) | Docs FlagBridge |
| Founders Circle program | Este chat |
| C-level + IC agents (19 commands) | Este chat |
| CONTROL.md (52 tasks, 6 fases) | Este chat |

---

## Plano de execução

Ver **CONTROL.md** na raiz do workspace para o plano completo com 52 tasks em 6 fases:
1. Foundation (CLAUDE.md, CI, Docker, Vercel)
2. Core API Go (CRUD, evaluation, testing, webhooks)
3. SDK Node v1 (evaluation, testing helpers, publish npm)
4. Admin UI (shell, dashboard, flags, targeting, audit)
5. Landing + Docs (hero, pricing, /developers, /founders-circle, quickstart)
6. Launch prep (README, Show HN, Product Hunt, Docker image)

Timeline: ~12 semanas side project / ~6-8 semanas full-time.

---

## Slash Commands Disponíveis

```
C-Levels:    /cto (Bridge)  /cpo (Flag)  /cmo (Growth)
ICs:         /backend (Gopher)  /frontend (Pixel)  /sdk (DX)
             /sre (Ops)  /data (Signal)  /design (Craft)
             /docs (Docs)  /qa (Guard)
Flows:       /feature  /api-review  /founders-circle-eval
             /roadmap  /competitive  /launch-check
             /incident  /security
```
