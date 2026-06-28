---
name: demo-prep
description: >
  Turns git history into a demo-ready slide deck. Reads commits, PRs, and
  issues since the last demo tag, release tag, or a user-specified date/ref.
  Categorizes work into features, fixes, and infra. Optionally starts the
  local dev server and captures screenshots. Generates a .pptx presentation
  using the pptx skill. Use when the user says "prep my demo", "make a demo
  deck", "what did I ship", "generate a presentation of my work", or invokes
  /demo-prep. Also triggers when an engineer needs to summarize recent work
  for a meeting, sprint review, or engineering all-hands.
argument-hint: "[date|tag]  e.g. 2026-05-01 or v1.2.0"
license: MIT
---

# Demo Prep

You are helping an engineer turn their recent work into a polished presentation. This is a **marketing tool** for the engineer — make their work visible, compelling, and easy to understand for a mixed technical/non-technical audience.

## Step 1 — Determine the start point

Use this priority order:

1. **User-provided argument** — a date (`2026-05-01`) or git ref (`v1.2.0`, `demo-2026-05-30`)
2. **`demo-*` tag** — `git tag --sort=-creatordate | grep "^demo-" | head -1`
3. **Last version tag** — `git tag --sort=-creatordate | grep -E "^v[0-9]" | head -1`
4. **30 days ago** — final fallback

**Always tell the user what you picked and why** before doing anything else:

> "No demo tag found. Using last release tag `v2.3.1` from May 15. Pass a date like `/demo-prep 2026-06-01` to override."

## Step 2 — Gather the work

```bash
# Commits since start (--since for dates, <ref>..HEAD for tags)
git log --oneline --since="<start>" --no-merges
# OR
git log --oneline <ref>..HEAD --no-merges

# Merged PRs
gh pr list --state merged --limit 50 --json number,title,body,mergedAt,labels \
  | jq '[.[] | select(.mergedAt > "<start>")]'

# Closed issues
gh issue list --state closed --limit 50 --json number,title,closedAt,labels \
  | jq '[.[] | select(.closedAt > "<start>")]'

# Project name
basename $(git rev-parse --show-toplevel)

# Open PRs for "What's next"
gh pr list --state open --limit 20 --json number,title,labels
```

If `gh` is not available, fall back to git log only and note it.

## Step 3 — Categorize

Group everything into three buckets:

- **Features** — new capabilities visible to users or other engineers
- **Fixes** — bugs resolved, reliability improvements, performance wins
- **Infra / Refactors** — internal improvements, dependency updates, CI, cleanup

Write a one-sentence plain-English description for each item. Think: "30 seconds to explain this to a product manager." If commit messages are cryptic, infer intent from PR titles, issue descriptions, and changed file paths.

## Step 4 — Screenshots (web projects only)

Check for `package.json`, a dev server script, or a `Makefile` with a `dev`/`start` target.

If found, ask: **"Should I start the dev server and capture screenshots? (y/n)"**

If yes:
- Use the `run` skill to start the dev server
- Use `preview_start` and `preview_screenshot` to capture key screens
- Focus on the most impactful new features
- Save as `demo-screenshot-<name>.png` in the current directory

## Step 5 — Generate the deck

Use the `pptx` skill with this structure:

**Slide 1 — Title**
`[Project Name] — Demo` / today's date / clean bold style

**Slide 2 — What we shipped**
Top 5–8 most impactful items, bullets under 10 words, lead with impact not implementation

**Slides 3–N — Feature deep dives** (top 3–5 only)
Plain-English title / 2–3 sentences on what it does and why it matters / screenshot if available

**Slide N+1 — Fixes & Improvements** (if notable)
4–6 bullets, framed positively ("resolved X" not "fixed bug where...")

**Slide N+2 — What's next**
Open PRs / upcoming work, forward-looking tone

Instructions for pptx: clean modern theme, title ~36pt, body ~20pt, screenshots prominent, output as `demo-YYYY-MM-DD.pptx` in the current working directory.

## Step 6 — Finish

Report: file path, slide count, any gaps (no screenshots, no `gh` CLI, etc.).

If content looks thin: "Consider adding a metrics slide if you have usage or performance data."

## Notes

- A tight 8-slide deck beats a sprawling 20-slide one.
- If it was all infra with no visible impact, be honest but positive: "This period was about building foundations that will unlock X."
- Always generate the deck even with missing data — something the engineer can edit is more useful than nothing.
