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

## Usage

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
2. **Reads your history** — commits, merged PRs, closed issues since that point
3. **Categorizes** — features, fixes, infra/refactors, each in plain English
4. **Screenshots** *(optional)* — starts your local dev server and captures key screens
5. **Generates a `.pptx`** — title, "what we shipped" overview, one slide per major feature, fixes summary, what's next

Output: `demo-YYYY-MM-DD.pptx` in your project directory, ready to open in Keynote or PowerPoint.

## Requirements

- [Claude Code](https://claude.ai/code)
- `git`
- `gh` CLI *(optional — enables PR and issue details)*

## License

MIT © Kunal Chawla
