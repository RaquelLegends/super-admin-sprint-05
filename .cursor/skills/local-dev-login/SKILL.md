---
name: local-dev-login
description: >-
  Choose FE→prod OAuth (Mode A) vs FE→local Phoenix (Mode B), with per-lane
  CMUX profiles and port-aware scripts. Use when opening teachers/admin,
  DevToken, Google sign-in, local Phoenix, or scaffolding a FE lane.
---

# Local dev login — two modes

Mixing modes caused DevToken / Google-against-prod confusion. Pick **one** per
session and document it in the lane `AGENTS.md`.

Port math: skill **`lane-ports`**. Browser panes + cookie jars: skill
**`cmux-layout`** (one browser per workspace; **profile = lane slug**).

## Mode A — FE against remote API (prod or staging)

**When:** UI work against real prod/staging data; no local Phoenix.

| API | Start | Sign-in |
|-----|--------|---------|
| **prod** | `bin/run-lane-teachers.sh <slug> prod` | `/dev/sign-in` → Google OAuth |
| **staging** | `bin/run-lane-teachers.sh <slug> staging` | `/dev/token` (no staging OAuth client) |

- Remembered session: CMUX profile **`<slug>`** (not `teacher`) +
  `<lane>/.cmux/browser-state` (mirror `browser-state-prod` after Google).
- Restore: `bin/open-lane-browser.sh <slug> --mode a`
- Save after rare fresh Google: `bin/save-lane-browser.sh <slug> --mode a`
- Never ask Raquel to type a password when state exists.

## Mode B — FE against local Elixir (Phoenix)

**When:** local DB / seed / flag behavior (e.g. Civics on Phoenix `:4600`).

| Piece | How |
|-------|-----|
| Ports | `bin/lane-ports.sh <slug>` — teachers + Phoenix share one base |
| Backend | `bin/run-lane-phoenix.sh <slug> --exec` — **must** set `PORT`, `OPS_PORT`, `BASE_FE_PORT`, `TEACHERS_APP_URL` |
| Frontend | `bin/run-lane-teachers.sh <slug> local` |
| Seed user | `<lane>/bin/seed-local-teacher.sh` (civics: `raquel.juarez@…` / `abc123`) |
| Sign-in | `bin/login-lane-local.sh <slug>` — GraphQL token → cookie **`lol_dev_session_token`** + localStorage → save state |

### Pitfalls that look like “not logged in”

1. **Cookie required.** Middleware reads `lol_dev_session_token` cookie.
   localStorage / `/dev/token` alone → bounce through `/api/auth/redirect`.
2. **Phoenix without `BASE_FE_PORT`.** `teachers_app_url` falls back to
   `http://localhost:3006`. You leave the lane port, land on sign-up, and the
   lane cookie never sticks. Always start API via `run-lane-phoenix.sh` /
   `<lane>/bin/phoenix.sh --exec`.
3. **Wrong CMUX profile.** Using `teacher`/`default` shares cookies across
   tasks. Always `--profile <slug>`.

Do **not** use prod Google while the FE targets localhost Phoenix.

## Defaults by lane

| Lane | Default mode | Teachers | Phoenix | CMUX profile |
|------|--------------|----------|---------|--------------|
| `civics/` | **B** | 3606 | 4600 | `civics` |
| `ab-testing/` | **A** | 3506 | 4500 | `ab-testing` |

## Remembered files (gitignored under `<lane>/.cmux/`)

| File | Meaning |
|------|---------|
| `browser-state` | Active restore target |
| `browser-state-local` | Mode B mirror |
| `browser-state-prod` | Mode A Google mirror |

Per-lane only. Never copy to another task folder.

## Agent rules

1. Read the lane’s login mode + ports before opening a browser.
2. Mode A → `open-lane-browser.sh`; Mode B → `login-lane-local.sh` if no state.
3. Profile = slug. Layout = one browser (skill `cmux-layout`).
4. Extra worktrees that run servers: another `BASE_FE_PORT` (+100).
5. CoS owns shared scripts/skills; lanes wrap them in `<lane>/bin/`.
