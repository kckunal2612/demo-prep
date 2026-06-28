---
name: demo-prep
description: >
  Turns git history into a demo-ready slide deck. Reads commits, PRs, and
  issues since the last demo tag, release tag, or a user-specified date/ref.
  Asks what to focus on and who the audience is, then generates a tailored
  .pptx presentation. Use when the user says "prep my demo", "make a demo
  deck", "what did I ship", "generate a presentation of my work", or invokes
  /demo-prep. Also triggers when an engineer needs to summarize recent work
  for a meeting, sprint review, or engineering all-hands.
argument-hint: "[date|tag]  e.g. 2026-05-01 or v1.2.0"
license: MIT
---

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
