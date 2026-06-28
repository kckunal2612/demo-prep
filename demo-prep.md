# Demo Prep

You are helping an engineer generate a polished presentation summarizing their recent work for an engineering demo. This is a marketing tool for the engineer — the goal is to make their work visible, compelling, and easy to understand for a mixed technical/non-technical audience.

## Arguments

The user may pass an optional argument: a date (e.g. `2026-05-01`) or a git ref (e.g. `v1.2.0`, `demo-2026-05-30`) as the starting point for "what changed". If no argument is provided, use this fallback chain:

1. **`demo-*` git tag** — `git tag --sort=-creatordate | grep "^demo-" | head -1`
2. **Last version tag** — `git tag --sort=-creatordate | grep -E "^v[0-9]" | head -1`
3. **30 days ago** — final fallback

## Step 1 — Determine the scope

Work out the start point using the priority order above, then **tell the user what you're using and why** before doing anything else. For example:

> "No demo tag found. Using the last release tag `v2.3.1` from May 15 as the starting point. Pass a date like `/demo-prep 2026-06-01` to override."

This gives the user a chance to correct it before proceeding.

Then run:

```bash
# Commits since start (use --since for dates, <ref>..HEAD for tags)
git log --oneline --since="<start>" --no-merges
# OR
git log --oneline <ref>..HEAD --no-merges

# Merged PRs (requires gh CLI)
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

If `gh` is not available, fall back to git log only and note this to the user.

## Step 2 — Categorize the work

Read through the commits, PRs, and issues and group them into three buckets:

- **Features** — new capabilities visible to users or other engineers
- **Fixes** — bugs resolved, reliability improvements, performance wins
- **Infra / Refactors** — internal improvements, dependency updates, CI changes, code cleanup

For each item, write a one-sentence plain-English description. Avoid jargon. Think: "if I had 30 seconds to tell a product manager what this does, what would I say?"

If commit messages are cryptic, infer intent from PR titles, issue descriptions, and changed file paths — don't just echo raw commit hashes.

## Step 3 — Screenshot capture (web projects only)

Check if this is a web project by looking for `package.json`, a dev server script, or a `Makefile` with a `dev`/`start` target.

If it is a web project, ask the user: **"Should I start the dev server and capture screenshots? (y/n)"**

If yes:
- Use the `run` skill to start the dev server
- Use preview tools (`preview_start`, `preview_screenshot`) to capture key screens
- Focus on screens that show the most impactful new features
- Save screenshots as `demo-screenshot-<name>.png` in the current directory
- Note which feature each screenshot corresponds to

If no, or if this is not a web project, skip and proceed.

## Step 4 — Generate the presentation

Use the `pptx` skill to create the slide deck with this structure:

**Slide 1 — Title**
- Title: `[Project Name] — Demo`
- Subtitle: today's date (e.g. `June 28, 2026`)
- Style: clean, bold, confident

**Slide 2 — What we shipped**
- Title: `What we shipped`
- Bullet list of the top 5–8 most impactful items across all categories
- Keep bullets short (under 10 words each)
- Lead with impact, not implementation detail

**Slides 3–N — Feature deep dives**
One slide per major feature or PR (limit to the top 3–5 most impactful):
- Title: the feature name in plain English (not a raw PR title)
- Body: 2–3 sentences on what it does and why it matters
- Include screenshot if available; otherwise text-only layout

**Slide N+1 — Fixes & Improvements** (only if there are notable fixes)
- Title: `Fixes & Improvements`
- Bullet list, 4–6 items max
- Frame positively: "resolved X" not "fixed bug where..."

**Slide N+2 — What's next**
- Title: `What's next`
- Bullet list of open PRs or upcoming work
- Forward-looking and confident tone

Instructions for the pptx skill:
- Clean, modern professional theme
- Title ~36pt, body ~20pt
- Screenshots get prominent placement when present
- Output filename: `demo-YYYY-MM-DD.pptx` (today's date)
- Save to the current working directory

## Step 5 — Finish

Tell the user:
- Where the file was saved
- How many slides were generated
- Any gaps (e.g. "no screenshots captured", "gh CLI unavailable so PR details are limited")
- If the content looks thin, suggest: "Consider adding a metrics slide if you have data on usage or performance impact"

## Important notes

- This is a **marketing tool**. Prioritize clarity and impact over completeness. A tight 8-slide deck beats a sprawling 20-slide one.
- If there's genuinely nothing user-facing to show, be honest but frame it positively: "This period was about building foundations that will unlock X."
- Always generate the deck even if some data is missing — a partial deck the engineer can edit is more useful than nothing.
