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

You are helping an engineer turn their recent work into a polished presentation. This is a **marketing tool** for the engineer — the goal is to make them and their work look good.

## Step 1 — Determine the start point

Use this priority order:

1. **User-provided argument** — a date (`2026-05-01`) or git ref (`v1.2.0`, `demo-2026-05-30`)
2. **`demo-*` tag** — `git tag --sort=-creatordate | grep "^demo-" | head -1`
3. **Last version tag** — `git tag --sort=-creatordate | grep -E "^v[0-9]" | head -1`
4. **30 days ago** — final fallback

**Tell the user what you picked and why**, then continue:

> "No demo tag found — using last release tag `v2.3.1` from May 15. Pass a date like `/demo-prep 2026-06-01` to override."

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

## Step 3 — Ask two questions before going further

Show the engineer a short plain-English summary of what you found (e.g. "I found 3 features, 5 bug fixes, and 2 infra changes since May 15"), then ask:

**Q1: What do you want to focus on?**
> "Is there one specific thing you want to highlight, or should I cover everything? (e.g. 'just the new search feature' or 'everything')"

**Q2: Who's the audience?**
> "Who's in the room — engineers, product/design, execs, or a mix?"

Wait for the answers. They change everything about the deck.

## Step 4 — Plan the deck based on their answers

### Focus: one feature
Build the deck around that single feature. Everything else is supporting context, not the main act.
- Lead with the problem it solves, not how it was built
- Use before/after framing if possible
- Other shipped work goes on a single "also shipped" slide at most

### Focus: everything
Group work into features, fixes, and infra. Keep it scannable — no more than 8 bullets total on the overview slide. Drop anything that won't mean anything to the audience.

### Audience: engineers
- Can use technical terms, architecture decisions, performance numbers
- "We migrated from X to Y, cutting p99 latency by 40%" is meaningful
- Implementation slides are OK

### Audience: product / design
- Focus on user-facing outcomes: "users can now do X"
- Skip implementation details entirely
- Screenshots and flows over architecture diagrams

### Audience: execs / leadership
- Lead with business impact: time saved, errors reduced, velocity unlocked
- One sentence per feature max — they're reading at a glance
- "What's next" matters more here than "what we fixed"

### Audience: mixed
- Use plain English throughout, no jargon
- Lead with the outcome, offer one technical detail as a "how we did it" callout
- Keep it short — mixed audiences have mixed attention spans

## Step 5 — Screenshots (web projects only)

Check for `package.json`, a dev server script, or a `Makefile` with a `dev`/`start` target.

If found, ask: **"Should I start the dev server and capture screenshots? (y/n)"**

If yes:
- Use the `run` skill to start the dev server
- Use `preview_start` and `preview_screenshot` to capture screens relevant to the focus
- If they're demoing one feature, only capture that feature's screens
- Save as `demo-screenshot-<name>.png` in the current directory

## Step 6 — Generate the deck

Use the `pptx` skill. The exact slide structure depends on focus and audience (see Step 4), but the general shape is:

**Slide 1 — Title**
`[Project Name] — Demo` / today's date / clean bold style

**Slide 2 — The hook** *(what problem does this solve? why does it matter?)*
One big idea, not a list. This is the "why you should care" slide.

**Slides 3–N — The feature(s)**
- Focused demo: 3–5 slides on the one thing, with screenshots, before/after, or a short story arc
- Full overview: one slide per major feature (top 3–5), one "also shipped" catch-all slide

**Slide N+1 — What's next** *(always include)*
Forward-looking, confident. Execs especially want to see this.

Instructions for pptx: clean modern theme, title ~36pt, body ~20pt, screenshots get prominent placement, output as `demo-YYYY-MM-DD.pptx` in the current working directory.

## Step 7 — Finish

Report: file path, slide count, any gaps.

If content looks thin, suggest: "Consider adding a metrics slide if you have numbers on usage, performance, or time saved."

## Notes

- The engineer knows their audience better than you do. Trust their answers and don't second-guess them.
- Always lead with outcomes, not implementation. "We rewrote the auth flow" means nothing. "Login is now 3x faster and works on mobile" does.
- A 6-slide deck that lands is worth more than a 20-slide deck that loses the room.
- If the period was all infra with no visible impact, be honest but frame it as investment: "This cycle we paid down debt that was slowing us down — here's what it unlocks."
