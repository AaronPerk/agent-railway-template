# TEST KNOWLEDGE BASE

## OVERVIEW
Tests are lightweight regression guards built on Node's native test runner. The suite favors direct source inspection and tiny local helpers over booting the full wrapper.

## STRUCTURE
- Flat `test/` directory; files are grouped by behavior, not mirrored source paths.
- Most cases protect `src/server.js` contracts directly because importing the runtime cleanly is awkward in this repo.

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|
| Route presence regressions | `test/healthz.test.js`, `test/setup-ui-routing.test.js` | Read `src/server.js` and assert route patterns |
| Security/auth regressions | `test/websocket-upgrade-auth.test.js`, `test/trusted-proxies-config.test.js` | Protects subtle wrapper behavior |
| Input validation examples | `test/server.devices-approve.validation.test.js` | Shows the expected validation strictness |
| Output sanitization | `test/redact-secrets.test.js` | Good reference when touching logging/output |

## CONVENTIONS
- Use `node:test` and `node:assert/strict`; keep dependencies at zero unless the repo changes its test strategy.
- Prefer small, focused tests with one behavior per file or per case block.
- It is acceptable here to read `src/server.js` as text when importing the full app would start servers or processes.
- When behavior is easier to isolate as a pure helper, mirror the production logic locally in the test instead of spinning up the whole wrapper.

## ANTI-PATTERNS
- Do not introduce brittle end-to-end setup for changes that can be protected with a source-level regression guard.
- Do not rewrite the suite around Vitest/Jest without a repo-wide decision; current commands and dependencies assume native Node tests.
- Do not silently change route strings, auth wording, or proxy hooks without updating the matching regression tests.

## NOTES
- `npm test` runs the full suite.
- `npm run smoke` is separate and checks CLI availability, not wrapper behavior.
- When adding a new regression guard, choose the smallest assertion style that locks the behavior in place.
