# FlagBridge — Sprint Replan (v2-ia Pivot)

> **Data:** 2026-04-14
> **Autores:** Bridge (CTO), Flag (CPO), Growth (CMO)
> **Contexto:** O FlagBridge pivotou de "feature flags with product intelligence"
> para "feature flags for the whole team — AI-powered". Este documento
> reclassifica as tasks existentes e define a nova estrutura de sprints.
> **Status:** Proposta — pendente confirmação do Gabriel.

---

## 0. Estado atual do que existe

Antes de replanejar, o inventário do que já foi construído:

### Go API (v0.1.0 — publicada)
- **6.5k LOC**, 16 packages, 45 routes, 5 migrations
- Implementado: projects CRUD, flags CRUD, flag states per env, targeting rules,
  evaluation engine (MurmurHash3), testing sessions/overrides, webhooks (CRUD + delivery + test),
  API keys (4 scopes), audit log, SSE streaming, auth (login + API key middleware), environments
- Docker image: `ghcr.io/flagbridge/flagbridge:v0.1.0`
- CI/CD: GitHub Actions (lint + test + build + Docker + deploy Fly.io)
- **NAO existe:** product cards, roles/RBAC, AI endpoints, user management

### Admin Dashboard (~85%)
- **34 TSX files**, 8 pages, next-intl (EN + PT-BR), TanStack Query, Radix UI, Tailwind
- Implementado: dashboard, project detail, flags list (env bubbles + toggle), flag detail,
  project settings, webhooks (CRUD + logs + test + secret reveal), audit log viewer, API keys, login
- **NAO existe:** Product View, Cmd+K, product cards UI, role switcher, targeting rules UI visual,
  onboarding wizard, dark/light theme com nova paleta

### SDKs
- **sdk-node v0.1.0:** evaluate, batch, SSE, cache, 85 unit + 8 integration tests
- **sdk-react v0.1.0:** Provider, hooks, client, 19 tests, docs completas
- Outros SDKs: scaffold only (Go, Python, OpenFeature)

### Docs (VitePress)
- Quickstart, self-hosted guide, React SDK page, vs-LaunchDarkly comparison (EN + PT-BR)
- **NAO existe:** PM getting started, AI guide, product cards docs, Go/Python SDK docs

### Landing (Next.js)
- Hero, features, pricing, comparison table. Messaging antigo ("product intelligence")
- **Precisa:** rewrite completo com nova identidade visual + novo messaging

### Examples
- Next.js app + Node.js script (docker compose ready)

---

## 1. Reclassificacao das tasks existentes

Tasks das Sprints 3-6 originais que estavam em "to do" (pre-pivot).
Classificacao: **KEEP** (MVP) / **DEFER** (post-launch) / **CHANGE** (ajustar escopo) / **DROP** (eliminar).

| # | Task original | Sprint | Classificacao | Justificativa |
|---|---|---|---|---|
| 1 | [api] Audit Log v2 — filtros avancados, paginacao | S4 | **CHANGE** | Manter mas escopo reduzido: paginacao + filtro por user/action. Sem diffs por enquanto |
| 2 | [admin] Targeting Rules UI visual | S4 | **KEEP** | Core da Engineering View. Ja estava planejado |
| 3 | [admin] Flag Scheduling UI | S4 | **DEFER** | Pivot prioriza Product View e AI. Scheduling e nice-to-have |
| 4 | [admin] User Analytics dashboard | S4 | **DROP** | Sem base de usuarios. Substituido pelo Product View + AI insights (Pro) |
| 5 | [docs] SDK pages Go | S4 | **DEFER** | MVP lanca com 1 SDK (Node). Go docs vao pro post-launch |
| 6 | [docs] SDK pages Python | S4 | **DEFER** | Mesma razao |
| 7 | [admin] ProGate component | S4 | **CHANGE** | Mantem conceito mas implementacao muda: agora AI features sao o gate, nao analytics |
| 8 | [landing] Social proof section | S4 | **CHANGE** | Merge na nova landing. Badges + stars como secao dentro do novo design |
| 9 | [docs] Comparison vs-Unleash | S4 | **CHANGE** | Reescrever com novos diferenciadores (AI, whole team, Product role) |
| 10 | [docs] Comparison vs-GrowthBook | S4 | **CHANGE** | Mesma razao |
| 11 | [sdk-go] Publicar SDK Go | S5 | **DEFER** | Post-launch. 1 SDK no MVP |
| 12 | [sdk-python] Publicar SDK Python | S5 | **DEFER** | Post-launch |
| 13 | [admin] Plugin Marketplace UI | S5 | **DEFER** | Post-launch. Plugin system existe na arquitetura, marketplace UI pode esperar |
| 14 | [api] Pro integrations — Slack notifications | S5 | **DEFER** | Webhooks CE resolve. Integracoes Pro sao post-launch |
| 15 | [api] Pro integrations — Mixpanel | S5 | **DEFER** | Post-launch |
| 16 | [api] Pro integrations — Amplitude | S5 | **DEFER** | Post-launch |
| 17 | [api] Pro integrations — Datadog | S5 | **DEFER** | Post-launch |
| 18 | [landing] Founders Circle page | S5 | **DEFER** | Programa desenhado, pagina publica pos-launch |
| 19 | [landing] /developers page | S5 | **CHANGE** | Simplifica: SDK showcase + API overview. Merge parcial na nova landing |
| 20 | [admin] Dark Mode toggle | S5 | **CHANGE** | Absorvido na nova identidade visual (purple + warm white). Ambos os temas sao parte do redesign |
| 21 | [admin] Cmd+K search/command palette | S5 | **CHANGE** | Evolui de "search palette" pra "AI prompt bar" — escopo MUITO maior. Task central do pivot |
| 22 | [docs] Blog post "Why we built FlagBridge" | S6 | **CHANGE** | Reescrever angulo: "the feature flag tool your PM can actually use" |
| 23 | [docs] Blog post dogfooding story | S6 | **DEFER** | So faz sentido quando tiver AI rodando pra dogfooding real |
| 24 | [landing] GA4 + GTM setup | S6 | **KEEP** | Tracking e tracking. Nao muda com pivot |
| 25 | [api] Docker image GHCR optimized | S6 | **KEEP** | Ja feito na v0.1.0. Manter atualizado |
| 26 | [docs] Self-hosted Helm guide | S6 | **DEFER** | Docker Compose resolve. Helm e post-launch |
| 27 | [sre] Monitoring + alerting setup | S6 | **KEEP** | Necessario pra launch independente de pivot |
| 28 | [docs] API reference completa | S6 | **CHANGE** | Escopo muda: ~30 endpoints (nao 72). Incluir AI endpoints e product cards |
| 29 | [admin] Flag comparison side-by-side (envs) | S5 | **DEFER** | Nice-to-have. AI responde "compare staging vs prod" melhor que uma UI dedicada |
| 30 | [docs] Testing E2E guide (differentiator) | S6 | **KEEP** | Testing API continua diferenciador #3. Guide e importante |
| 31 | [landing] Show HN post | S6 | **KEEP** | Launch. Angulo muda mas a task existe |
| 32 | [landing] Product Hunt assets | S6 | **KEEP** | Launch |
| 33 | [api] SSE improvements (reconnect, heartbeat) | S5 | **DEFER** | SSE ja funciona. Melhorias pos-launch |
| 34 | [cli] CLI scaffold | S6 | **DEFER** | Admin UI + AI cobrem todos os use cases do MVP |

### Resumo da reclassificacao

| Classificacao | Qtd | % |
|---|---|---|
| **KEEP** (como esta) | 7 | 21% |
| **CHANGE** (ajustar escopo) | 10 | 29% |
| **DEFER** (post-launch) | 15 | 44% |
| **DROP** (eliminar) | 2 | 6% |

**15 tasks adiadas = MVP mais enxuto e focado no diferenciador real.**

---

## 2. Novas tasks — o que o pivot exige

### CTO (Bridge) — Tasks tecnicas

| # | Task | Repo | Esforco | Descricao |
|---|---|---|---|---|
| N1 | Product Cards — API CRUD | api | **M** | `GET/PUT /projects/:slug/flags/:key/product-card`. Campos: hypothesis, success_metrics, go_no_go, owner_id, status (planning/active/rolled-out/archived). Migration nova + handler + repository. Promovido de Pro pra CE |
| N2 | Roles/RBAC — API middleware | api | **L** | 4 roles: Admin, Engineer, Product, Viewer. Middleware que checa role por rota. Migration: users table + roles + project_members. JWT inclui role. Admin route groups com permission check |
| N3 | User management — API CRUD | api | **M** | `GET/POST/PATCH/DELETE /projects/:slug/members`. Invite flow (email), role assignment, list members. Necessario pro role system funcionar |
| N4 | AI proxy — context builder + provider router | api | **XL** | `POST /ai/prompt`, `GET /ai/suggestions`, `GET/PUT /ai/config`, `POST /ai/test-connection`. Context builder monta prompt com flags+rules+cards+audit. Provider router despacha pra Anthropic/OpenAI/Ollama. Streaming response. Rate limiter CE (100/mes) |
| N5 | AI config — encrypted key storage | api | **S** | Armazenar API key do provider (AES-256-GCM encrypted no DB). Migration: ai_config table. Endpoint ja coberto no N4 |
| N6 | Product View — admin UI | admin | **XL** | Layout simplificado: sidebar reduzida, flag cards com hypothesis/owner/status, toggle com context modal, flag creation wizard (5 steps). Determinado pelo role do user. Reusa componentes existentes com conditional rendering |
| N7 | Role switcher — admin UI | admin | **S** | Bottom-left: mostra role atual + botao "Switch to full/simple view". Persiste preference no localStorage. PMs veem Engineering View read-only |
| N8 | Onboarding wizard — admin UI | admin | **M** | Primeiro login: "What best describes your role?" (PM/Designer/Engineer/Lead). Define role default + view padrao. Pode mudar em settings depois |
| N9 | Cmd+K AI prompt bar — admin UI | admin | **XL** | Overlay modal global (Cmd+K). Input + response area + suggested prompts. Streaming response. Action buttons com confirmation modals. Context-aware (pagina/flag/projeto atual). Historico por sessao |
| N10 | Product Cards UI — admin | admin | **M** | Tab "Product Card" na flag detail (Engineering View). Card section na flag card (Product View). Edit form: hypothesis, success metrics, go/no-go, owner, status. Inline edit pra Product role |
| N11 | Nova identidade visual — admin | admin | **L** | Paleta purple (#9B7AFF accent) + warm off-white (#F5F0E8). Dark theme (#1A1625 bg) + Light theme (#FAF6F0 cream). Tailwind config update, component tokens, sidebar, buttons, badges CE/Pro, code blocks. Ambos os temas |
| N12 | Nova landing — redesign completo | landing | **XL** | 6 secoes: Hero ("Feature flags for the whole team"), The Problem/The Bridge, Built for Every Role (4 cards), AI-Powered (3 interactions), Pricing (CE $0 / Pro $29), Footer CTA. Nova paleta. Responsive. Performance |
| N13 | Docs — PM getting started | docs | **M** | `getting-started/for-product-managers.md` (EN + PT-BR). Zero code. Screenshots do Product View. Como criar flag, preencher product card, toggle, usar Cmd+K. Copy-paste do fluxo UUID |
| N14 | Docs — AI guide | docs | **M** | `ai/` section: overview, prompts-reference (por role), configuration (providers), examples (UUID use case, evaluation debug, code gen). EN + PT-BR |
| N15 | Docs — Product Cards reference | docs | **S** | `api-reference/product-cards.md`. CRUD endpoints, fields, examples. CE badge |
| N16 | OpenAPI spec update | api | **S** | Atualizar openapi.yaml: product cards sai de "Pro only" pra CE. Adicionar AI endpoints. Remover endpoints que nao estao no MVP |

### Estimativa de esforco total

| Tamanho | Qtd | Dias estimados por task | Total |
|---|---|---|---|
| S (small) | 4 | 0.5-1 dia | ~3 dias |
| M (medium) | 5 | 1-2 dias | ~8 dias |
| L (large) | 2 | 2-3 dias | ~5 dias |
| XL (extra-large) | 4 | 3-5 dias | ~16 dias |
| **Total** | **16** | | **~32 dias uteis (~6.5 semanas)** |

---

## 3. CPO (Flag) — Decisoes de produto

### Product Cards no CE — validacao do funnel

**Decisao: SIM, product cards no CE.**

O funnel e claro:
```
PM descobre FlagBridge → usa product cards CE (gratis)
→ time adota → PM quer insights AI avancados
→ upgrade Pro ($29/mo)
```

Product cards sao o hook que atrai product teams. Se fossem Pro, PMs
nunca experimentariam o diferenciador. A monetizacao esta nos AI insights
(hypothesis suggestions, stale analysis, weekly reports, risk assessment)
— coisas que so fazem sentido com volume e historico.

### Role "Product" — acoes exatas

| Acao | Product pode? | Nota |
|---|---|---|
| Ver flags (list, detail, status) | SIM | Product View |
| Criar flag (wizard guiado) | SIM | Gera key automaticamente |
| Toggle on/off em qualquer env | SIM | Com confirmation modal + context |
| Editar product card | SIM | Hypothesis, metrics, owner, status |
| Usar Cmd+K AI (queries) | SIM | Perguntas sobre flags, status, audit |
| Usar Cmd+K AI (actions) | SIM | Toggle, create, edit card — via AI com confirmacao |
| Editar targeting rules via UI | NAO | Precisa pedir ao Engineer |
| Editar targeting rules via AI | **SIM com guardrails** | AI mostra impacto, PM confirma. Audit log registra "via AI" |
| Gerenciar rollout % | NAO | Engineering View only |
| Gerenciar webhooks | NAO | Engineering View only |
| Gerenciar API keys | NAO | Engineering View only |
| Ver audit log | SIM | Read-only |
| Ver Engineering View | SIM | Switch temporario, read-only |

**Decisao-chave:** Product role PODE editar targeting rules via AI (nao via UI direta).
A AI funciona como guardrail — mostra impacto, pede confirmacao, registra tudo.
Isso e o que torna o use case dos UUIDs possivel e e o diferenciador #1.

### 100 prompts/mes no CE

**Decisao: 100 e o sweet spot.**

Racional:
- Time de 5 pessoas usando 1x/dia = ~100 prompts/mes
- Suficiente pra experimentar e adotar. Insuficiente pra uso intensivo
- Pro desbloqueia ilimitado — conversao natural quando o time cresce
- Competidores nao tem AI, entao qualquer numero > 0 e diferenciador
- Se precisar ajustar pos-launch, e uma config no server — trivial

### Prioridade: AI prompt bar vs Product View vs Roles

```
1. Product Cards API (N1)     — prerequisite pra tudo
2. Roles/RBAC (N2 + N3)       — prerequisite pra Product View
3. Product View (N6)          — o "aha moment" do PM
4. AI prompt bar (N4 + N9)    — o killer feature
5. Nova identidade visual (N11) — pode rodar em paralelo
```

A Product View sem AI ja e valiosa (PM vê flags com context, faz toggle).
A AI sem Product View perde metade do impacto (quem vai usar o Cmd+K?).
Logo: Product View primeiro, AI segundo.

### Criterios de "Launchable" (MVP checklist)

O MVP esta pronto quando TODOS estes criterios forem atendidos:

**Must-have (hard blockers):**
- [ ] PM consegue criar flag, preencher product card, e toggle — sem tocar JSON
- [ ] Engineer mantém controle total (targeting rules, rollouts, webhooks)
- [ ] Cmd+K AI responde queries sobre flags e executa acoes com confirmacao
- [ ] 4 roles funcionam (Admin, Engineer, Product, Viewer)
- [ ] Self-hosted funciona com `docker compose up` em < 5 minutos
- [ ] SDK Node avalia flags corretamente (evaluate + batch)
- [ ] Testing API cria sessoes e overrides
- [ ] Docs tem: quickstart, PM guide, engineer guide, AI guide, API reference
- [ ] Landing page comunica "flags for the whole team" + mostra AI demo
- [ ] Audit log registra todas as acoes (incluindo "via AI")

**Should-have (qualidade, nao blocker):**
- [ ] Nova identidade visual (purple + warm white) aplicada
- [ ] Comparison pages atualizadas (vs-LD, vs-Unleash, vs-GB)
- [ ] Blog post de launch publicado
- [ ] GA4 tracking configurado
- [ ] README atualizado com novo positioning

**Nice-to-have (pos-launch imediato):**
- [ ] SDK React atualizado pra v2
- [ ] CLI basico
- [ ] Helm chart

### "Flags for the whole team" cria categoria?

**Sim, mas com nuance.** Nao e uma categoria nova no sentido de "feature flags".
E uma subcategoria: **"collaborative feature flags"** ou **"team-first feature flags"**.
O framing correto e: "todo feature flag tool e pra engenheiros. FlagBridge e pra o time inteiro."
Isso nao cria uma categoria — redefine quem e o usuario de uma categoria existente.
E mais poderoso que criar categoria, porque nao precisa educar o mercado sobre o que e.

---

## 4. CMO (Growth) — Landing, messaging, e go-to-market

### Prioridade da landing page

**Landing DEPOIS da API + Admin. Mas nao no final.**

Racional: a landing antiga funciona (esta no ar, tem trafego). O novo positioning
so faz sentido quando o produto atras da promessa existir. Se a landing diz
"your PM can actually use" mas o admin so tem Engineering View, e mentira.

**Ordem:** API (product cards, roles, AI) → Admin (Product View, Cmd+K) → Landing → Docs → Launch

A landing entra na semana 8, quando ja tem Product View + AI rodando
pra gerar screenshots e GIFs reais.

### Novo messaging

**Headline:** "Feature flags for the whole team."

**Subheadline:** "The first feature flag platform your PM, designer, and
engineer all actually want to use. AI-powered. Open-source. Self-hosted. Free."

**3 bullets do hero:**
1. **PMs create flags and toggle features** — no JSON, no code, full product context
2. **Engineers keep full control** — targeting rules, rollouts, Testing API, webhooks
3. **AI connects everyone** — hit Cmd+K, describe what you need, done in 60 seconds

**CTA:** "Get Started Free" (primary) + "Star on GitHub" (secondary)

**Below hero:** Cmd+K demo mockup (PM removing UUIDs — o killer use case)

### Conteudo existente — o que reescrever?

| Conteudo | Acao | Urgencia |
|---|---|---|
| Hero + features section | **Rewrite completo** | Launch blocker |
| Pricing section | **Update** — CE agora inclui product cards + AI (100/mo) | Launch blocker |
| vs-LaunchDarkly comparison | **Update** — adicionar colunas "Whole team admin" + "AI ops" + "Product cards" | Antes do launch |
| vs-Unleash comparison | **Write new** com novos diferenciadores | Antes do launch |
| vs-GrowthBook comparison | **Write new** com novos diferenciadores | Antes do launch |
| Blog "Why we built FlagBridge" | **Rewrite** angulo — "flags for the whole team" | Launch day |
| README do repo principal | **Rewrite** — novo tagline, novo quick start | Launch blocker |
| SDK Node README | **Keep** — tecnico, nao muda com pivot | Manter |

### Como comunicar "AI-powered" sem hype

**Regra: mostrar, nao falar.**

NAO fazer:
- "AI-powered feature flag management" (vazio)
- "Leverage AI to..." (buzzword)
- "Intelligent feature flags" (o que isso significa?)

FAZER:
- Mostrar o Cmd+K prompt com uma interacao real (UUIDs use case)
- "Hit Cmd+K, describe what you need, done in 60 seconds"
- "Your PM removes 4 UUIDs from a targeting rule. No JSON. No dev needed."
- A AI e a evidencia, nao o claim. O claim e "your PM can actually use this."

Na landing, a secao AI mostra 3 interacoes REAIS:
1. PM remove UUIDs via prompt → screenshot do flow
2. Engineer debugs evaluation via prompt → screenshot do trace
3. Team lead gets weekly summary → screenshot do report

### Nova identidade visual na landing

A nova paleta (purple #9B7AFF + warm white #F5F0E8) deve ser aplicada
na landing no mesmo sprint do redesign. Nao faz sentido lanca com a
paleta antiga e trocar depois — seria retrabalho.

**Dark theme como default na landing** (como Linear, Vercel). Light theme
disponivel mas dark e o hero. Razao: o purple brilha no dark, e dev tools
vendem melhor em dark.

### Plano de lancamento atualizado

| Semana | Marco | Growth action |
|---|---|---|
| S3 (W1-2) | Product cards API + Roles | — (backend, nada publico) |
| S4 (W3-4) | Product View + AI API | Preview screenshots em Twitter/X |
| S5 (W5-6) | Cmd+K AI + Engineering View polish | GIF do UUID use case — "60 seconds, zero devs" |
| S6 (W7) | Nova identidade visual | Teaser: "something's changing" |
| S7 (W8) | Landing redesign + Docs | Soft launch pra early access list |
| S8 (W9) | Polish + comparisons + blog | Show HN draft, Product Hunt assets |
| S9 (W10) | Launch | Show HN + Product Hunt + Twitter thread |

---

## 5. Nova estrutura de sprints

### Sprint 3 — Product Foundation (semana 1-2)

> **Objetivo:** Backend do pivot — product cards, roles, user management.
> **Entregavel:** API suporta product cards CE + 4 roles + members CRUD.

| # | Task | Repo | Esforco | Depende de |
|---|---|---|---|---|
| 3.1 | Product Cards — migration + repository + handler | api | M | — |
| 3.2 | Roles/RBAC — users table, roles, project_members migration | api | L | — |
| 3.3 | Roles/RBAC — middleware (permission check por rota) | api | M | 3.2 |
| 3.4 | User management — CRUD members + invite flow | api | M | 3.2 |
| 3.5 | OpenAPI spec update — product cards CE + roles | api | S | 3.1, 3.2 |
| 3.6 | Audit log — registrar product card changes + role changes | api | S | 3.1, 3.2 |

**KR:** `curl POST /product-card` retorna 200. Middleware bloqueia Product role em rotas de targeting rules.

---

### Sprint 4 — Product View + Admin Pivot (semana 3-4)

> **Objetivo:** O PM consegue usar o admin. Product View funcional.
> **Entregavel:** PM cria flag, preenche product card, faz toggle.

| # | Task | Repo | Esforco | Depende de |
|---|---|---|---|---|
| 4.1 | Product View — layout, sidebar simplificada, flag cards com context | admin | XL | 3.1, 3.3 |
| 4.2 | Product Cards UI — tab na flag detail + inline edit | admin | M | 3.1 |
| 4.3 | Flag creation wizard (5 steps pra Product role) | admin | M | 4.1 |
| 4.4 | Toggle com context modal (hypothesis, metrics, impacto) | admin | M | 4.1, 4.2 |
| 4.5 | Onboarding wizard ("What's your role?") | admin | M | 3.3 |
| 4.6 | Role switcher (bottom-left, switch view) | admin | S | 3.3 |

**KR:** PM faz login → escolhe role → ve Product View → cria flag → preenche card → toggle em staging. Sem JSON.

---

### Sprint 5 — AI Layer (semana 5-6)

> **Objetivo:** Cmd+K funciona. AI responde queries e executa acoes.
> **Entregavel:** PM digita prompt, AI encontra flag, PM confirma acao.

| # | Task | Repo | Esforco | Depende de |
|---|---|---|---|---|
| 5.1 | AI proxy — context builder (flags, rules, cards, audit, role) | api | L | 3.1, 3.3 |
| 5.2 | AI proxy — provider router (Anthropic, OpenAI, Ollama) | api | L | — |
| 5.3 | AI proxy — streaming response + rate limiter CE (100/mo) | api | M | 5.1, 5.2 |
| 5.4 | AI config — encrypted API key storage + endpoints | api | S | — |
| 5.5 | AI suggestions — context-aware prompt templates | api | S | 5.1 |
| 5.6 | Cmd+K prompt bar UI — overlay, input, streaming response | admin | XL | 5.3 |
| 5.7 | Cmd+K actions — confirmation modals (toggle, create, edit card) | admin | L | 5.6, 4.4 |
| 5.8 | AI config UI — provider/key/model settings page | admin | M | 5.4 |

**KR:** PM abre Cmd+K → cola 4 UUIDs → AI encontra flag e rule → PM confirma → done em 60s. O use case dos UUIDs funciona end-to-end.

---

### Sprint 6 — Visual Identity + Engineering Polish (semana 7)

> **Objetivo:** Nova paleta aplicada. Engineering View polida.
> **Entregavel:** Admin com cara nova. Targeting rules UI funcional.

| # | Task | Repo | Esforco | Depende de |
|---|---|---|---|---|
| 6.1 | Nova identidade visual — Tailwind tokens, paleta completa | admin | L | — |
| 6.2 | Dark + Light theme (purple + warm white) | admin | M | 6.1 |
| 6.3 | Targeting Rules UI visual (Engineering View) | admin | L | existente |
| 6.4 | Audit Log v2 — paginacao + filtro user/action | admin + api | M | existente |
| 6.5 | ProGate component — AI features gating (CE/Pro badges) | admin | S | 5.6 |

**KR:** Admin com nova paleta. Engineer edita targeting rules visualmente. Audit log paginado.

---

### Sprint 7 — Landing + Docs (semana 8)

> **Objetivo:** O mundo ve o novo FlagBridge.
> **Entregavel:** Landing no ar com novo messaging. Docs cobrem PM + AI + API.

| # | Task | Repo | Esforco | Depende de |
|---|---|---|---|---|
| 7.1 | Landing redesign — 6 secoes, nova paleta, responsive | landing | XL | 6.1 (tokens) |
| 7.2 | Landing — Cmd+K demo mockup (UUID use case) | landing | M | 5.6 (screenshots) |
| 7.3 | Landing — pricing section (CE $0 / Pro $29 com AI) | landing | S | — |
| 7.4 | Docs — PM getting started (zero code, screenshots) | docs | M | 4.1 (screenshots) |
| 7.5 | Docs — AI guide (overview, prompts, config, examples) | docs | M | 5.6 |
| 7.6 | Docs — Product Cards API reference | docs | S | 3.1 |
| 7.7 | Docs — API reference atualizada (~30 endpoints) | docs | M | all API |

**KR:** Landing no ar com novo positioning. Docs tem PM guide + AI guide. "Get Started" funciona end-to-end.

---

### Sprint 8 — Launch Prep (semana 9)

> **Objetivo:** Tudo pronto pra launch.
> **Entregavel:** Blog, comparisons, tracking, polish final.

| # | Task | Repo | Esforco | Depende de |
|---|---|---|---|---|
| 8.1 | Blog post — "The feature flag tool your PM can actually use" | docs/blog | M | — |
| 8.2 | Comparison pages — vs-LD, vs-Unleash, vs-GB (rewrite) | docs | L | — |
| 8.3 | GA4 + GTM setup | landing | S | — |
| 8.4 | README rewrite — repo principal | api | S | — |
| 8.5 | Show HN post draft | — | S | — |
| 8.6 | Product Hunt assets (tagline, screenshots, GIFs) | — | M | 7.1 |
| 8.7 | Monitoring + alerting pre-launch | sre | M | — |
| 8.8 | Testing E2E guide (differentiator doc) | docs | M | — |

**KR:** Launch checklist 100% verde. Show HN pronto. Product Hunt assets prontos.

---

### Sprint 9 — Launch (semana 10)

> **Objetivo:** FlagBridge no mundo.
> **Entregavel:** Show HN + Product Hunt + Twitter thread.

| # | Task | Repo | Esforco | Depende de |
|---|---|---|---|---|
| 9.1 | Show HN — publish + monitor + respond | — | M | 8.5 |
| 9.2 | Product Hunt launch | — | M | 8.6 |
| 9.3 | Twitter/X thread — "We built..." + GIFs | — | S | — |
| 9.4 | Fix launch day bugs + feedback | all | ? | — |

---

## 6. Timeline revisada

```
              Abr                       Mai                        Jun
    14  21  28 | 05  12  19  26 | 02  09  16  23
    ─────────────────────────────────────────────────
S3  [========]                                        Product Foundation
S4          [========]                                Product View
S5                   [============]                   AI Layer
S6                               [======]             Visual + Polish
S7                                      [======]      Landing + Docs
S8                                             [====] Launch Prep
S9                                                [=] LAUNCH
```

**Total: 10 semanas (14 Abr — 23 Jun)**
**Launch target: semana de 23 de Junho de 2026**

### Riscos no timeline

| Risco | Impacto | Mitigacao |
|---|---|---|
| AI proxy mais complexo que estimado | Sprint 5 estoura | Comecar com 1 provider (Anthropic). Multi-provider vira Sprint 6 |
| Roles/RBAC adiciona complexidade ao auth | Sprint 3 estoura | Comecar com middleware simples (role check no JWT). ABAC granular pos-launch |
| Landing redesign demora | Sprint 7 atrasa | Manter landing atual como fallback. Novo design em branch separada |
| Cmd+K UX precisa de iteracao | Sprint 5-6 | MVP do Cmd+K: queries + toggle. Code gen e intelligence sao Pro pos-launch |

---

## 7. O que do codigo existente precisa mudar

### Go API
- [ ] `openapi.yaml` — Product Cards sai de "Pro only". Adicionar AI endpoints
- [ ] Migration nova: `product_cards`, `users`, `roles`, `project_members`, `ai_config`
- [ ] Auth middleware: adicionar role check alem de scope check
- [ ] Novo package: `internal/productcard/` (handler, repository, model)
- [ ] Novo package: `internal/ai/` (handler, context builder, provider router)
- [ ] Novo package: `internal/user/` (handler, repository, invite)
- [ ] Flag handler: enriquecer response com product card data
- [ ] SSE handler: nenhuma mudanca necessaria

### Admin Dashboard
- [ ] Tailwind config: nova paleta (purple + warm white)
- [ ] Layout: sidebar condicional por role
- [ ] Flag list: conditional rendering (Product View vs Engineering View)
- [ ] Flag detail: nova tab "Product Card"
- [ ] Novo componente: `CmdKDialog` (overlay global)
- [ ] Novo componente: `OnboardingWizard`
- [ ] Novo componente: `RoleSwitcher`
- [ ] Novo componente: `ProductCardForm`
- [ ] Novo componente: `FlagCreationWizard`
- [ ] Novo componente: `ConfirmationModal` (context-aware)

### O que NAO muda
- Evaluation engine (internal/evaluation/) — intacto
- Testing API (internal/testing/) — intacto
- Webhook system (internal/webhook/) — intacto
- SDK Node — intacto (product cards sao server-side)
- SDK React — intacto
- Docker/CI/CD pipeline — intacto
- Database schema existente — apenas ADDs, sem ALTERs destrutivos

---

## 8. Assinaturas

### Bridge (CTO)
O plano e tecnicamente viavel. As maiores incognitas sao o AI proxy
(nunca fizemos isso no Go API) e o RBAC (adiciona complexidade ao auth
que hoje e simples). Recomendo comecar Sprint 3 com o AI proxy em spike
paralelo pra antecipar riscos. A boa noticia: 80% do codigo existente
nao precisa mudar — so adicionar.

**Risco tecnico #1:** AI streaming response no Go com proxy pra multiplos
providers. Sugiro usar a SDK do Anthropic em Go (`github.com/anthropics/anthropic-sdk-go`)
como referencia e abstrair a interface pra multi-provider.

**Risco tecnico #2:** Role system pode virar overengineering se nao
tomarmos cuidado. MVP: 4 roles fixos, check no middleware, sem ABAC
granular. Evoluir depois.

### Flag (CPO)
O produto que sai desse replan e fundamentalmente diferente de tudo no
mercado. O aha moment e claro: PM cria flag → preenche hypothesis →
toggle → usa Cmd+K pra operar. Nenhum concorrente oferece isso.

A decisao mais importante: **Product role editar targeting rules via AI**
(nao via UI). Isso e arriscado mas e o diferenciador. Se funcionar, e
game over pro mercado. Se nao funcionar, degradamos gracefully pra
"Product role pede ao Engineer".

### Growth (CMO)
O novo positioning e 10x mais forte que o anterior. "Feature flags with
product intelligence" era vago — inteligencia de quem? "Feature flags for
the whole team" e concreto — qualquer PM entende.

A landing so faz sentido com o produto atras. Screenshots e GIFs reais
de um PM usando o Cmd+K valem mais que qualquer copy. Por isso landing
na semana 8, nao na semana 1.

O launch target de Junho da tempo pra gerar conteudo organico antes
(tweets com GIFs, preview pra early access list).

---

## Proximo passo

Gabriel confirma este replan → atualizamos ClickUp com a nova estrutura
de sprints → comecamos Sprint 3 (Product Foundation).

O Sprint 3 pode comecar imediatamente — as tasks 3.1 e 3.2 sao independentes
e podem rodar em paralelo.
