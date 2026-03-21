# PROJECT KNOWLEDGE BASE

**Generated:** 2026-03-21 16:29:26 CDT
**Commit:** ffde4dc
**Branch:** main

## OVERVIEW
Railway deployment template for OpenClaw. The repo combines a Node/Express wrapper in `src/server.js` with a small Next.js setup surface mounted at `/setup`.

## STRUCTURE
```text
./
|- src/                  # Wrapper server: auth, health, proxy, gateway lifecycle
|- app/                  # Next.js App Router shell for /setup
|- components/           # Setup dashboard + UI primitives
|- lib/                  # Shared UI/store helpers
|- test/                 # Source-oriented regression tests
|- scripts/              # Container/bootstrap/smoke/maintenance scripts
|- .github/workflows/    # Docker CI + upstream ref bump automation
|- Dockerfile            # OpenClaw build + runtime image contract
|- railway.toml          # Railway healthcheck, volume, env defaults
`- package.json          # Runtime/test/build commands
```

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|
| Wrapper behavior | `src/server.js` | Primary runtime entry; most operational logic lives here |
| Setup UI route | `app/page.jsx` | Thin page that renders the dashboard |
| Setup dashboard logic | `components/setup/setup-dashboard.jsx` | Main client-side setup surface |
| Shared setup persistence | `lib/setup-store.js` | SQLite-backed event log under state dir |
| UI tokens and look | `app/globals.css`, `tailwind.config.js` | Dark ops-style theme via CSS vars |
| Deployment contract | `Dockerfile`, `railway.toml`, `README.md` | Source build, `/data` mount, `/setup/healthz` |
| Verification style | `test/*.test.js` | Mostly source-level regression guards |

## CODE MAP
| Symbol | Type | Location | Role |
|--------|------|----------|------|
| `app` | Express app | `src/server.js` | Registers setup APIs, auth gates, proxy routes |
| `ensureGatewayRunning` | function | `src/server.js` | Idempotent gateway start/probe path |
| `startGateway` | function | `src/server.js` | Spawns managed OpenClaw child process |
| `requireSetupAuth` | function | `src/server.js` | Basic auth guard for `/setup` and related endpoints |
| `attachGatewayAuthHeader` | function | `src/server.js` | Injects bearer token into proxied traffic |
| `SetupDashboard` | React component | `components/setup/setup-dashboard.jsx` | Main `/setup` control surface |
| `listSetupEvents` | function | `lib/setup-store.js` | Reads recent setup event history |
| `appendSetupEvent` | function | `lib/setup-store.js` | Persists setup/debug event output |

## CONVENTIONS
- JavaScript/ESM only. Use `.js` and `.jsx`, not TypeScript.
- In React code, prefer the `@/` alias from `jsconfig.json` over long relative imports.
- Keep changes pragmatic and deployment-focused; this repo optimizes for Railway behavior, not abstract purity.
- Comments exist to explain non-obvious runtime constraints; preserve that style when changing Docker, auth, or startup logic.
- `package.json` is the command source of truth. `CONTRIBUTING.md` still mentions `pnpm`, but the repo scripts are `npm`/`node` based.

## ANTI-PATTERNS (THIS PROJECT)
- Do not hardcode `PORT`; Railway injects it and routing breaks if the image forces a default.
- Do not bypass `/data`; state, workspace, tokens, and setup DB are expected to live on the mounted volume.
- Do not introduce arbitrary shell execution into setup APIs; the debug console is intentionally allowlisted.
- Do not treat `/setup` as the app root; the gateway owns `/` and the Next.js app lives behind `basePath: "/setup"`.
- Do not reintroduce legacy `CLAWDBOT_*` naming in new code; use `OPENCLAW_*` only.

## UNIQUE STYLES
- The UI theme is intentionally "ops console" rather than generic SaaS: dark palette, IBM Plex fonts, terminal-height tokens, subtle grid overlay.
- Tests lean on static source assertions for server regressions because importing the app cleanly is harder than reading `src/server.js`.
- The Docker image builds OpenClaw from source, then copies the wrapper app into the runtime stage.

## COMMANDS
```bash
npm run dev          # wrapper server locally
npm run setup:dev    # Next.js setup UI in dev mode
npm run setup:build  # build the /setup app
npm test             # node --test
npm run lint         # syntax-check src/server.js
npm run smoke        # verify openclaw CLI exists
docker build -t agent-railway-template .
```

## NOTES
- Health checks are split: `/healthz` is the public wrapper probe, `/setup/healthz` is the Railway deploy healthcheck.
- `src/server.js` is the only large hotspot in the repo; prefer surgical edits there.
- Existing Serena memories under `.serena/memories/` mirror some of this guidance; keep them conceptually aligned.
