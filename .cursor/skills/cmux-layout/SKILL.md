---
name: cmux-layout
description: >-
  One terminal left, one browser right; never split the browser. Per-lane CMUX
  profiles isolate cookies so tasks do not share logins. Use when opening
  browsers, verifying UI, scaffolding lanes, or spawning subagents that touch CMUX.
---

# CMUX layout + browser isolation

## Pane layout (every workspace)

- **Left:** a single terminal (the lane / agent terminal).
- **Right:** a single browser.

Background / headless browsers are OK for automation that does **not** add a
second visible pane. Never split the right browser into two.

## Login isolation (critical)

Each task folder is a **separate CMUX browser profile** and a **separate
saved state**. Switching lanes must not keep you logged in as the other lane’s
session.

| Lane | CMUX `--profile` | Saved state (gitignored) |
|------|------------------|--------------------------|
| `civics/` | `civics` | `civics/.cmux/browser-state*` |
| `ab-testing/` | `ab-testing` | `ab-testing/.cmux/browser-state*` |
| new FE lane `<slug>/` | `<slug>` | `<slug>/.cmux/browser-state*` |

Hard rules:

1. **Always** open that lane’s browser with `--profile <slug>` (same as the
   folder name). Scripts: `bin/open-lane-browser.sh`, `bin/login-lane-local.sh`.
2. **Never** use shared profiles `default`, `teacher`, `developer`, or
   `pacing-guides` for lane teachers/admin work — those jars are shared and
   will leak the same Google/cookie session across tasks.
3. **Never** load another lane’s `.cmux/browser-state` into this workspace.
4. **Never** open lane A’s URL inside lane B’s workspace browser “as a
   shortcut.” Work in the owning workspace + owning profile only.
5. Mode A (prod Google) and Mode B (local Phoenix) states for the **same**
   lane are separate files (`browser-state-prod` vs `browser-state-local`);
   do not cross-load them.

If a browser already exists in the lane workspace, **reuse it** (do not
split). That surface must have been created with `--profile <slug>`. If it
was opened on `default`/`teacher` by mistake: close it, open one new browser
with the correct profile, restore that lane’s state only.

## Pane hard rules

1. Before opening a browser, check the workspace for an existing browser
   surface. If one exists → `goto` / `state load`. Do **not** `browser open`,
   `open-split`, `new-split`, or `new-pane --type browser` beside it.
2. Only create a browser when the workspace has **none**.
3. Subagents and scripts inherit these rules.
4. CoS must not open extra browsers in a lane workspace “just to check.”

## Do

```bash
bin/open-lane-browser.sh civics          # profile=civics, reuse pane, restore state
bin/open-lane-browser.sh ab-testing      # profile=ab-testing — different cookie jar
```

## Do not

- Split the right browser into two panes
- Reuse profile `teacher` / `default` across lanes
- Copy or load `.cmux/browser-state` from another task folder
- Navigate civics while the browser was opened as `ab-testing` (or the reverse)
