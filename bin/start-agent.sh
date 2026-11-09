#!/usr/bin/env bash
# Start Cursor agent rooted in the Super Admin Report lane.
# CMUX: run as a RELATIVE command with --working-directory set to this folder.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
exec agent --workspace "$ROOT" --trust --approve-mcps "$(cat <<'EOF'
You are in the isolated Super Admin Report lane (Workspace 1/super-admin-report).

Read AGENTS.md, handoff.md, and MEMORY.md first. Stay inside this folder only.

This folder is the git repo for the Super Admin Updates board (index.html).
Live Pages: https://raquellegends.github.io/super-admin-sprint-05/
Local static server may be on http://127.0.0.1:8780/ — use CMUX for browsers.

Confirm you have loaded context, then wait for my next prompt. Do not commit or push unless I ask.
EOF
)"
