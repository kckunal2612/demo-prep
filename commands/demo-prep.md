---
description: Generate a demo slide deck from your git history since a date or tag
argument-hint: "[date|tag]  e.g. 2026-05-01 or v1.2.0"
---

# Demo Prep

Turn the engineer's recent git activity into a polished, audience-ready slide deck. Be brief at every step — one line of status, tight questions, no narration.

## 1. Start point

Priority: user arg → `demo-*` tag → last version tag → 30 days ago.

Tell the user in one line what you picked, then move on.

## 2. Gather

```bash
git log --oneline --since="<date>" --no-merges        # or <ref>..HEAD
gh pr list --state merged --limit 50 --json number,title,mergedAt,labels
gh issue list --state closed --limit 50 --json number,title,closedAt,labels
basename $(git rev-parse --show-toplevel)
```

Fall back to git log only if `gh` isn't available.

Titles and labels are enough to bucket work into features/fixes/infra and answer the questions below — don't fetch PR bodies yet.

## 3. Ask three questions

One message, all questions together:

> Found X features, Y fixes, Z infra changes since [date].
> 1. What do you want to focus on? (one thing, or everything)
> 2. How technical is the audience? (high / medium / low)
> 3. Slide theme? (default / dark / claude-code / codex)

## 4. Adapt the deck

**Focus — one thing:** build the whole deck around it; everything else gets one "also shipped" bullet at most.
**Focus — everything:** top 3–5 features get slides; fixes and infra share one summary slide.

**Depth — high:** technical details, numbers, and tradeoffs are fine.
**Depth — medium:** lead with outcomes, one sentence of how.
**Depth — low:** outcomes only, plain English, zero jargon.

## 5. Screenshots (web only)

If `package.json` or a dev script exists, ask: "Capture screenshots? (y/n)"

If yes, use `run` + `preview_screenshot`. Only capture screens relevant to the focus.

## 6. Generate

For each PR that made the final cut (the focus item, or the top 3–5 chosen features), fetch its full description now with `gh pr view <number> --json body` before writing its slide.

Use the `pptx` skill:

- Slide 1: `[Project] — Demo` / today's date
- Slide 2: The hook — why this matters, not what was built
- Slides 3–N: Feature(s), with screenshots where available
- Last slide: What's next

Apply the chosen theme. Title ~36pt, body ~20pt.

| Theme | Background | Accent | Text | Body font |
|---|---|---|---|---|
| `default` | `#FFFFFF` | `#0066CC` | `#111111` | Calibri |
| `dark` | `#0F172A` | `#6C63FF` | `#FFFFFF` | Calibri |
| `claude-code` | `#1C1C1C` | `#D4774A` | `#FFFFFF` | Courier New |
| `codex` | `#161616` | `#10A37F` | `#FFFFFF` | Calibri |

For `claude-code` and `codex`: use the accent color for slide titles and callout text; body bullets in white; a thin accent-colored rule under each slide title.

Save as `demo-YYYY-MM-DD.pptx` in the current directory.

## 7. Done

One line: file path and slide count. Note any gaps only if material.
