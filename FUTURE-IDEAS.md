# Future Ideas & Iteration Backlog

Ideas for extending this workspace and the projects built with it. These are not immediate tasks — they're bigger-picture features to explore as the system matures.

---

## Demonstrating Agentic Work Visibly

The portfolio should show *how* it was built, not just what it does:

- **Agent-generated case studies** — for each project, a writeup describing the build process, tools used, and decisions made
- **Claude Code session embeds** — visual proof of agentic development in action
- **GitHub Activity feed** — live display of commit history and repo stats
- **Build log / changelog** — auto-generated from commit history, showing the site's evolution

---

## Live Data Pipeline Demo

A page that fetches real data, processes it, and displays it — proving "data pipeline" is not just a claim.

Data source ideas:
- GitHub API — repo stats, commit activity, language breakdown
- Public financial data (stock prices, economic indicators)
- Weather or geolocation data
- Custom API endpoint running a mini ETL on demand

Stack considerations:
- Python backend (FastAPI) deployed on Railway or similar
- GitHub Actions for scheduled data refresh
- Frontend visualization (Chart.js, Observable Plot, or Plotly)

---

## Multi-Agent Orchestration Demo

A visible demonstration of agents working together autonomously:

- Pipeline where one agent plans, another builds, another reviews, another documents
- "Live build" feature — trigger a task and watch agents collaborate
- Case study with agent logs and decision traces

---

## GitHub Actions as Proof of Automation

Even simple workflows demonstrate the capability:

- Auto-deploy on push to `main`
- Scheduled data refresh job
- Lint + type-check + test on every PR
- Auto-generate changelog entries from commit messages

---

## Content Ideas

- **"AI Tools I Actually Use"** — honest breakdown of Claude Code, Netlify, GitHub, etc. with real opinions
- **Case study: This Workspace** — how the Claude Code workspace was built and iterated on
- **Decision-making / reasoning loops** — demo of how plan mode + multi-agent works in practice

---

## Workspace Improvements

- Add a `data-pipeline` skill (complement to the agent) for common ETL patterns
- Build out shared references as the project portfolio grows (tech stack conventions, style guides)
- Explore additional MCP servers for expanded tool access
