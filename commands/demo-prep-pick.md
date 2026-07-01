---
description: Pick specific features or fixes to include in your demo deck
---

Run demo-prep in pick mode. Gather what was shipped, show a numbered list grouped by features / fixes / infra in plain English, ask which items to include (numbers or 'all'), what technical depth (high / medium / low), and how much effort to spend, then generate the deck with only the selected items.

# Demo Prep

Turn the engineer's recent git activity into a polished, audience-ready slide deck. Be brief at every step — one line of status, tight questions, no narration.

## 1. Start point

Priority: user arg → `demo-*` tag → last version tag → 30 days ago.

Tell the user in one line what you picked, then move on.

## 2. Gather

Delegate this step to a subagent on `haiku` — running commands and bucketing results by title/label is mechanical pattern-matching, not judgment work, and it keeps the raw git/gh output out of your context.

Have the subagent run:

```bash
git log --oneline --since="<date>" --no-merges        # or <ref>..HEAD
gh pr list --state merged --limit 50 --json number,title,mergedAt,labels
gh issue list --state closed --limit 50 --json number,title,closedAt,labels
basename $(git rev-parse --show-toplevel)
```

Fall back to git log only if `gh` isn't available. Have it return the project name, counts of features/fixes/infra, and a categorized list of {number, title, category, mergedAt} for each merged PR.

Titles and labels are enough to bucket work into features/fixes/infra and answer the questions below — don't fetch PR bodies yet.

## 3. Ask three questions

One message, all three together:

> Found X features, Y fixes, Z infra changes since [date].
> 1. What do you want to focus on? (one thing, or everything)
> 2. How technical is the audience? (high / medium / low)
> 3. Effort? (low / medium / high — default: medium)

## 4. Scale gather to the chosen effort

**Low:** use the step 2 data as-is. No PR bodies are fetched at any point.

**Medium (default):** use the step 2 data as-is. PR bodies are fetched later, in step 7, only for the items the user picked.

**High:** re-run the gather yourself, on the default model rather than delegating to haiku, with `gh pr list --state merged --limit 100 --json number,title,body,mergedAt,labels`. Full descriptions up front give a more reliable feature/fix/infra categorization and richer slide content.

## 5. Adapt the deck

**Focus — one thing:** build the whole deck around it; everything else gets one "also shipped" bullet at most.
**Focus — everything:** top 3–5 features get slides; fixes and infra share one summary slide.

**Depth — high:** technical details, numbers, and tradeoffs are fine.
**Depth — medium:** lead with outcomes, one sentence of how.
**Depth — low:** outcomes only, plain English, zero jargon.

## 6. Screenshots (web only)

**Low:** skip screenshots entirely — don't ask.
**Medium:** if `package.json` or a dev script exists, ask: "Capture screenshots? (y/n)"
**High:** if `package.json` or a dev script exists, capture automatically — don't ask.

When capturing, use `run` + `preview_screenshot`. Only capture screens relevant to the focus.

## 7. Generate

**Low:** titles only — no PR bodies at any point.
**Medium:** for each item the user picked, fetch its full PR description now with `gh pr view <number> --json body` before writing its slide.
**High:** bodies were already fetched in step 4 — use them directly.

Use the `pptx` skill:

- Slide 1: `[Project] — Demo` / today's date
- Slide 2: The hook — why this matters, not what was built
- Slides 3–N: Feature(s), with screenshots where available
- Last slide: What's next

Clean modern theme, title ~36pt, body ~20pt. Save as `demo-YYYY-MM-DD.pptx` in the current directory.

## 8. Done

One line: file path and slide count. Note any gaps only if material.
