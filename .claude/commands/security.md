Security review de um componente ou feature do FlagBridge. Assuma os papéis de SRE, Backend e QA.

## 1. SRE (Ops) — Infra & Config
- Secrets expostos? (API keys, DB credentials, license keys)
- TLS configurado corretamente?
- CORS policies adequadas?
- Rate limiting em vigor?
- Headers de segurança (CSP, HSTS, X-Frame-Options)?
- Docker image: base image segura? Sem tools desnecessárias?

## 2. Backend (Gopher) — Application Security
- Input validation em todos os endpoints?
- SQL injection: sqlc protege, mas e queries dinâmicas?
- Auth bypass: todos os endpoints verificam API key scope?
- HMAC validation nos webhooks?
- Timing attacks em comparação de API keys/tokens?
- Error messages: não vazam stack traces ou internal state?
- File upload (plugins): sanitização, size limits, type validation?

## 3. QA (Guard) — Security Test Cases
- Test cases pra cada vetor de ataque identificado
- Fuzzing suggestions pra inputs críticos
- Auth bypass test: cada combinação scope × endpoint
- Injection test: cada campo que aceita user input

## Formato final:
Tabela: Finding | Severity (Critical/High/Medium/Low) | Status (Open/Fixed) | Action
Ordenada por severity. Critical = fix before launch.

COMPONENTE A REVISAR:

$ARGUMENTS
