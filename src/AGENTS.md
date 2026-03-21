# SRC KNOWLEDGE BASE

## OVERVIEW
`src/server.js` is the operational core: auth gates, config migration, setup APIs, gateway process control, and reverse proxying all converge here.

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|
| Setup auth failures | `requireSetupAuth`, `requireDashboardAuth` | Basic auth guards for `/setup` and Control UI |
| Gateway startup/restarts | `ensureGatewayRunning`, `startGateway`, `restartGateway` | Managed child-process lifecycle |
| Proxy/header behavior | `attachGatewayAuthHeader`, `server.on("upgrade")` | HTTP + WebSocket path |
| Setup debug console | `ALLOWED_CONSOLE_COMMANDS`, `/setup/api/console/run` | Strict allowlist; keep tight |
| Config persistence | `resolveGatewayToken`, `migrateLegacyConfigFile`, config write endpoints | Handles migration + backups |
| Health/debug output | `/healthz`, `/setup/healthz`, `/setup/api/debug` | Public probe vs setup-only diagnostics |

## CONVENTIONS
- Preserve the wrapper-first architecture: Express owns the port and mounts Next.js plus the gateway behind it.
- Keep new route handlers narrow and explicit; this file already carries enough complexity.
- Prefer helper extraction only when it reduces real risk or duplication inside `server.js`; avoid broad refactors during bug fixes.
- Redact secrets before returning anything to the browser or logs. Follow `redactSecrets()` patterns, do not invent looser ones.
- When writing config or token files, preserve backup/permission behavior.

## ANTI-PATTERNS
- Do not execute user-provided shell commands; extend `ALLOWED_CONSOLE_COMMANDS` instead.
- Do not require Basic auth on WebSocket upgrades; browsers cannot attach those headers reliably.
- Do not bind the gateway publicly; it is expected to stay on loopback and be proxied.
- Do not remove legacy migration paths casually; existing Railway volumes may still depend on them.
- Do not change `/setup/healthz` semantics without also updating `railway.toml`.

## NOTES
- Most tests inspect this file as text. Renaming routes/helpers can require updating regex-based regression tests even when behavior is unchanged.
- `SETUP_PASSWORD`, `OPENCLAW_STATE_DIR`, and `OPENCLAW_WORKSPACE_DIR` are the key env contract surfaces.
