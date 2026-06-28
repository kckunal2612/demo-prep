---
description: Pick specific features or fixes to include in your demo deck
---

Run demo-prep in pick mode. Gather what was shipped, show a numbered list grouped by features / fixes / infra in plain English, ask which items to include (numbers or 'all') and what technical depth (high / medium / low), then generate the deck with only the selected items.

# Demo Prep

Turn the engineer's recent git activity into a polished, audience-ready slide deck. Be brief at every step — one line of status, tight questions, no narration.

## 1. Start point

Priority: user arg → `demo-*` tag → last version tag → 30 days ago.

Tell the user in one line what you picked, then move on.

## 2. Gather

```bash
git log --oneline --since="<date>" --no-merges        # or <ref>..HEAD
gh pr list --state merged --limit 50 --json number,title,body,mergedAt,labels
gh issue list --state closed --limit 50 --json number,title,closedAt,labels
gh pr list --state open --limit 20 --json number,title,labels
basename $(git rev-parse --show-toplevel)
```

Fall back to git log only if `gh` isn't available.

## 3. Ask two questions

One message, both questions together:

> Found X features, Y fixes, Z infra changes since [date].
> 1. What do you want to focus on? (one thing, or everything)
> 2. How technical is the audience? (high / medium / low)

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

Use the `pptx` skill:

- Slide 1: `[Project] — Demo` / today's date
- Slide 2: The hook — why this matters, not what was built
- Slides 3–N: Feature(s), with screenshots where available
- Last slide: What's next

Clean modern theme, title ~36pt, body ~20pt. Save as `demo-YYYY-MM-DD.pptx` in the current directory.

## 7. Done

One line: file path and slide count. Note any gaps only if material.
