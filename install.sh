#!/usr/bin/env bash
set -euo pipefail

COMMANDS_DIR="$HOME/.claude/commands"
mkdir -p "$COMMANDS_DIR"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL="$SCRIPT_DIR/skills/demo-prep/SKILL.md"

# Extract skill body (everything after the frontmatter)
skill_body() {
  awk '/^---/{n++; if(n==2){found=1; next}} found{print}' "$SKILL"
}

# demo-prep (main command)
cat > "$COMMANDS_DIR/demo-prep.md" <<EOF
---
description: Generate a demo slide deck from your git history since a date or tag
argument-hint: "[date|tag]  e.g. 2026-05-01 or v1.2.0"
---

$(skill_body)
EOF

# demo-prep-tech
cat > "$COMMANDS_DIR/demo-prep-tech.md" <<EOF
---
description: Generate a demo deck at a set technical depth: high, medium, or low
argument-hint: "[high|medium|low]"
---

Run demo-prep with technical depth set to \$ARGUMENTS (default: medium). Skip the audience question. Still ask what to focus on, then generate the deck.

$(skill_body)
EOF

# demo-prep-pick
cat > "$COMMANDS_DIR/demo-prep-pick.md" <<EOF
---
description: Pick specific features or fixes to include in your demo deck
---

Run demo-prep in pick mode. Gather what was shipped, show a numbered list grouped by features / fixes / infra in plain English, ask which items to include (numbers or 'all') and what technical depth (high / medium / low), then generate the deck with only the selected items.

$(skill_body)
EOF

echo "✓ Claude Code: /demo-prep, /demo-prep-tech, /demo-prep-pick installed."
echo ""
echo "To install via Codex, run:"
echo "  codex plugin marketplace add kckunal2612/demo-prep"
echo "  codex plugin add demo-prep@demo-prep"
echo ""
echo "For local Codex development from this checkout, run:"
echo "  codex plugin marketplace add ."
echo "  codex plugin add demo-prep@demo-prep"
