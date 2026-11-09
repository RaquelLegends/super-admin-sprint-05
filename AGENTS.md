# Super Admin Report — agent rules

This folder is an **isolated workspace** for the Partner Success **Super Admin Updates** board: a publishable static site that summarizes Super Admin / Admin work for skimming (with Linear links for official titles).

Do **not** edit sibling checkouts or other task folders under `Workspace 1/`. Do **not** leave board HTML or publish scripts at Workspace 1 root.

## Stay inside this folder

| Path | Role |
|------|------|
| `super-admin-report/index.html` | The published board artifact |
| `super-admin-report/handoff.md` | Current status — read first, update when you stop |
| `super-admin-report/MEMORY.md` | Durable facts (publish URL, content rules) |
| `super-admin-report/agents/` | Registry of agents / subagents / hooks |
| `super-admin-report/skills/` and `.cursor/skills/` | Lane skills (update board, publish) |
| `super-admin-report/docs/` | Notes / scratch |

This directory **is** the git repo for the site (remote: `RaquelLegends/super-admin-sprint-05`). Commits and publishes happen from here.

## Product rules (board copy)

- Plain-language titles for skimming; Linear keeps the official title on click-through.
- Exclude duplicates, won't-do, and old launch tickets unless the user says otherwise.
- Sections cover in progress, Intake/Backlog waiting, and recently finished work.

## Publish

- Live site: https://raquellegends.github.io/super-admin-sprint-05/
- Repo: https://github.com/RaquelLegends/super-admin-sprint-05
- `.nojekyll` is intentional for GitHub Pages.
- Prefer normal git commit + push to `main` (and existing Pages setup). Do not invent a second copy of the site at Workspace 1 root.

```bash
# from this folder
git status
git add index.html   # and any other intentional site files
git commit -m "…"    # only when the user asked to commit
git push origin main
```

## CMUX only

Use `cmux` for browsers. Never Cursor Simple Browser / `vscode://` / external Chrome unless `cmux` is unavailable.

**Layout + isolation (skill `cmux-layout`):** one terminal on the left, **one** browser on the right. Never split the browser pane. Reuse the existing browser. **CMUX profile: `super-admin-report`** when a browser login matters — never reuse `teacher`/`default`/another lane’s profile (cookie isolation).

When opening this lane in CMUX: workspace in the **caller's existing window**; never `cmux new-window` unless asked.

Local preview: open `index.html` via a tiny static server from **this** folder, or use the published Pages URL.

## Hooks & memory

- Project hooks: `.cursor/hooks.json`
- `agents/registry.md`: durable ownership / hooks / lasting subagents only — not CoS pings or ticket play-by-play
- Long-lived notes: `MEMORY.md`, `memory/`
- Session handoff: update `handoff.md` for material state changes only — not every micro-step
