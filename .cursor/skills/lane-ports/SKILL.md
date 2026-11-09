---
name: lane-ports
description: >-
  Port formula for concurrent FE/BE lanes and worktrees (BASE_FE_PORT +100).
  Use when starting teachers/admin/Phoenix, scaffolding a task folder, or when
  two checkouts would collide on 3006/4000.
---

# Lane ports — one slot owns FE + BE

Every running teachers/admin stack and every local Phoenix that serves it must
use a **distinct `BASE_FE_PORT`**. Defaults (`3006` / `4000`) collide the moment
two lanes or two worktrees run at once.

## Formula (from one base)

| Service | Port | Example (`3601`) |
|---------|------|------------------|
| `BASE_FE_PORT` | base | 3601 |
| admin | base + 1 | 3602 |
| teachers | base + 5 | 3606 |
| Phoenix | base + 999 | 4600 |
| ops | base + 4000 | 7601 |

```bash
source bin/lane-ports.sh
lane_ports_for_slug civics          # reserved lane base
lane_ports_from_base 3701           # ad-hoc / extra worktree
lane_ports_print
bin/lane-ports.sh next-free         # next unused 3x01 / 4x01 …
```

## Who owns which base

| Owner | `BASE_FE_PORT` | Teachers | Phoenix |
|-------|----------------|----------|---------|
| legacy / default | 3001 | 3006 | 4000 |
| `ab-testing/` | 3501 | 3506 | 4500 |
| `civics/` | 3601 | 3606 | 4600 |
| next FE lane | 3701 | 3706 | 4700 |
| … | +100 | +100 | +100 |

Document the reserved base in the lane’s `AGENTS.md`. Never bind another lane’s
teachers/admin/Phoenix ports. Never kill another session’s listener.

## Worktrees inside a lane

A lane may have several checkouts (`lol-fe/`, `lol-fe-leg-XXXX/`, …). **Only
one stack may use the lane’s reserved base at a time.**

If a second worktree must run FE or BE concurrently:

1. Take the next free slot: `bin/lane-ports.sh next-free` (or lane_base + 100·N).
2. Write that base into the worktree’s `handoff.md` / shell env for the session.
3. Start with the same formula — FE and Phoenix for that worktree share **that**
   base (so teachers still talk to the matching Phoenix).

```bash
# primary civics stack
BASE_FE_PORT=3601 …   # teachers 3606, Phoenix 4600

# second civics worktree at the same time
BASE_FE_PORT=3701 …   # teachers 3706, Phoenix 4700
```

Do not run two Next processes on 3606. Do not point 3706 at Phoenix 4600 unless
you intentionally share one API (rare — document it).

## Starting services

```bash
# Mode A — FE → prod (no local Phoenix required)
bin/run-lane-teachers.sh <slug> prod

# Mode B — FE → this slot’s Phoenix
PORT=$LANE_PHOENIX_PORT OPS_PORT=$LANE_OPS_PORT BASE_FE_PORT=$LANE_BASE_FE_PORT \
  # start Phoenix from learning-machine/lol (nix-shell / mix phx.server)
bin/run-lane-teachers.sh <slug> local
```

`BASE_FE_PORT` on Phoenix matters: dev config sets `teachers_app_url` to
`localhost:(BASE+5)`. Without it, redirects fall back to `:3006`.

## Scripts (Workspace 1 `bin/`)

| Script | Role |
|--------|------|
| `lane-ports.sh` | sourceable map + `next-free` / print |
| `run-lane-teachers.sh` | FE prod \| staging \| local \| stop \| status |
| `open-lane-browser.sh` | restore remembered login for the slot |
| `save-lane-browser.sh` | persist CMUX browser state |
| `login-lane-local.sh` | Mode B: seed token → cookie → save state |

Login modes: shared skill `local-dev-login`.
