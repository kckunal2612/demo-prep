# demo-prep

A Claude Code plugin that turns your git history into a demo-ready slide deck.

Engineers lose context between demos. `demo-prep` reads your commits, PRs, and issues since your last demo, then generates a `.pptx` presentation — a marketing tool for your own work.

## Install

```bash
claude mcp install github:kunalchawla/demo-prep
```

Or clone and install locally:

```bash
git clone https://github.com/kunalchawla/demo-prep
cd demo-prep
claude mcp install .
```

## Commands

| Command | What it does |
|---|---|
| `/demo-prep` | Full interactive flow — asks what to focus on and who the audience is |
| `/demo-prep 2026-05-01` | Same, but starting from a specific date or git tag |
| `/demo-prep-tech high` | Skips the audience question, sets technical depth directly (`high` / `medium` / `low`) |
| `/demo-prep-pick` | Shows everything shipped as a numbered list — you choose what goes in the deck |

## What it does

1. **Detects the start point** — last `demo-*` tag → last version tag → 30 days ago. Tells you what it picked so you can override.
2. **Reads your history** — commits, merged PRs, closed issues since that point
3. **Asks what to focus on** — one feature, a selection, or everything
4. **Adapts to your audience** — high/medium/low technical depth changes the language, framing, and slide structure
5. **Screenshots** *(optional)* — starts your local dev server and captures key screens
6. **Generates a `.pptx`** — tailored to your focus and audience, saved to your project directory

Output: `demo-YYYY-MM-DD.pptx` in your project directory, ready to open in Keynote or PowerPoint.

## Requirements

- [Claude Code](https://claude.ai/code)
- `git`
- `gh` CLI *(optional — enables PR and issue details)*

## License

MIT © Kunal Chawla
