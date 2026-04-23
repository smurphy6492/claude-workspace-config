---
name: portfolio-updater
description: Structured process for adding a new project to the personal portfolio website. Gathers project details, generates case study content, updates site files, and opens a PR. Use whenever a project is ready to be showcased.
argument-hint: "project name or description"
allowed-tools: Read, Write, Edit, Glob, Bash, WebFetch
metadata:
  version: "1.0"
  tier: guided-workflow
  freedom: medium
  tags: [portfolio, website, content, github]
---

# Portfolio Updater

Adds a new project to Sean's personal portfolio website.

---

## Step 1 — Gather Project Details

Ask for (or infer from context):
- **Project name** — what is it called?
- **One-line description** — what does it do?
- **Problem it solves** — what was the real challenge?
- **Tech stack** — what tools, languages, frameworks?
- **AI tools used** — which agents, skills, or Claude workflows were involved?
- **Outcome** — what does it demonstrate or prove?
- **Links** — GitHub repo, live demo, screenshots?

---

## Step 2 — Read Existing Site Structure

Before writing anything:
- Read the current site files to understand how existing projects are displayed
- Note the component/template pattern used for project cards
- Check the existing content tone and style

---

## Step 3 — Generate Case Study Content

Using the `content-writer` agent tone and structure:

### Project Card (for grid/list on homepage)
```
Title: [project name]
Tagline: [one compelling sentence]
Tags: [tech stack, 3-5 tags]
Link: [GitHub or live demo]
```

### "How I Built This" Writeup
```markdown
## [Project Name]

**What I built:** [one sentence]

**The challenge:** [what was hard or interesting about it]

**Approach:** [tools used, agents involved, key decisions]

**What it demonstrates:** [capability shown — autonomous execution, pipeline, orchestration, etc.]
```

---

## Step 4 — Update Site Files

Identify the correct file(s) to edit and add:
1. New project card to the projects section
2. Case study content (inline or linked page)
3. Any new tags or categories needed

If the site has a data file (JSON, JS array, etc.) that drives the project grid, update that file rather than raw HTML.

---

## Step 5 — Create Branch & PR

```bash
git checkout -b feature/add-<project-name>
git add <changed files>
git commit -m "feat(portfolio): add <project-name> case study"
gh pr create --title "feat(portfolio): add <project-name>" --body "..."
```

---

## Step 6 — Output Summary

```
## Portfolio Update: [project name]

### Content Created
- [ ] Project card copy
- [ ] Case study writeup

### Files Updated
- [list of files changed]

### PR
- [PR link or number]

### Next Steps
- [ ] Review on staging (Netlify deploy preview)
- [ ] Add screenshot/demo link if missing
- [ ] Merge when approved
```
