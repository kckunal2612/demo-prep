# demo-prep

A Claude Code slash command that turns your git history into a demo-ready presentation.

Engineers lose context between demos. This skill reads your git log, PRs, and issues since your last demo, then generates a `.pptx` slide deck — a marketing tool for your own work.

## Usage

Copy `demo-prep.md` to `~/.claude/commands/demo-prep.md`, then run:

```
/demo-prep
```

Or pass a specific start point:

```
/demo-prep 2026-05-01
/demo-prep v1.2.0
/demo-prep demo-2026-05-30
```

## What it does

1. **Detects the start point** — last `demo-*` tag → last version tag → 30 days ago. Tells you what it picked so you can override.
2. **Reads git history** — commits, merged PRs, closed issues since that point
3. **Categorizes** — features, fixes, infra/refactors
4. **Optionally screenshots** — starts your local dev server and captures key screens (web projects only)
5. **Generates a `.pptx`** — title slide, "what we shipped" overview, one slide per major feature, fixes summary, what's next

Output is saved as `demo-YYYY-MM-DD.pptx` in your project directory.

## Requirements

- [Claude Code](https://claude.ai/code)
- `git`
- `gh` CLI (optional — enables PR/issue details)
- `pptx` skill (bundled with Claude Code)

## Installation

```bash
cp demo-prep.md ~/.claude/commands/demo-prep.md
```

## License

MIT
