# demo-prep

A Claude Code and Codex plugin that turns your git history into a demo-ready slide deck.

Engineers lose context between demos. `demo-prep` reads commits, PRs, and issues since your last demo, asks what to focus on, then generates a `.pptx` presentation for the room.

## Install

### Claude Code plugin

This repository is a Claude Code marketplace and a plugin. Add the marketplace, then install the plugin from it:

```text
/plugin marketplace add kckunal2612/demo-prep
/plugin install demo-prep@demo-prep
```

When developing from a local checkout, add the local repository path instead:

```text
/plugin marketplace add /path/to/demo-prep
/plugin install demo-prep@demo-prep
```

Plugin commands are namespaced by the plugin name:

```text
/demo-prep:demo-prep
/demo-prep:demo-prep-tech high
/demo-prep:demo-prep-pick
```

You can also install standalone Claude slash commands directly into `~/.claude/commands/`:

```bash
cd /path/to/demo-prep
./install.sh
```

For the published version, the same standalone installer can be run with:

```bash
curl -fsSL https://raw.githubusercontent.com/kckunal2612/demo-prep/main/install.sh | bash
```

Standalone installs give you unnamespaced commands such as `/demo-prep`.

### Codex plugin

This repository also includes a Codex plugin manifest and repo-local marketplace catalog.

For a local checkout:

```bash
cd /path/to/demo-prep
codex plugin marketplace add .
codex plugin add demo-prep@demo-prep
```

For the published GitHub marketplace:

```bash
codex plugin marketplace add kckunal2612/demo-prep
codex plugin add demo-prep@demo-prep
```

You can also open `/plugins` in Codex, select the Demo Prep marketplace, install `demo-prep`, and start a new thread. Use it by asking Codex to prep a demo, or explicitly invoke `@demo-prep` / the bundled `demo-prep` skill when available.

## Commands

| Command | What it does |
|---|---|
| `/demo-prep:demo-prep` | Full interactive flow - asks what to focus on and who the audience is |
| `/demo-prep:demo-prep 2026-05-01` | Same, but starting from a specific date or git tag |
| `/demo-prep:demo-prep-tech high` | Skips the audience question, sets technical depth directly (`high` / `medium` / `low`) |
| `/demo-prep:demo-prep-pick` | Shows everything shipped as a numbered list - you choose what goes in the deck |

If you used the standalone curl installer instead of the plugin, drop the `demo-prep:` namespace.

## What it does

1. **Detects the start point** - last `demo-*` tag -> last version tag -> 30 days ago. Tells you what it picked so you can override.
2. **Reads your history** - commits, merged PRs, closed issues since that point.
3. **Asks what to focus on** - one feature, a selection, or everything.
4. **Adapts to your audience** - high/medium/low technical depth changes the language, framing, and slide structure.
5. **Screenshots** *(optional)* - starts your local dev server and captures key screens when the host agent supports that workflow.
6. **Generates a `.pptx`** - tailored to your focus and audience, saved to your project directory.

Output: `demo-YYYY-MM-DD.pptx` in your project directory, ready to open in Keynote or PowerPoint.

## Requirements

- [Claude Code](https://claude.ai/code) and/or [Codex CLI](https://github.com/openai/codex)
- `git`
- `gh` CLI *(optional - enables PR and issue details)*

## Release notes for plugin authors

Claude Code uses the plugin manifest version when deciding whether an installed plugin needs an update. If you keep `version` in `.claude-plugin/plugin.json`, bump it for each release.

## License

MIT (c) Kunal Chawla
