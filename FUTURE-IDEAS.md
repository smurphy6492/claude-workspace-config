# Future Ideas & Iteration Backlog

Ideas captured during workspace setup on 2026-03-17. These are not immediate tasks — they are bigger-picture features to build out as the personal website and portfolio mature.

---

## Website: Demonstrating Agentic Work Visibly

The site should show *how* it was built, not just what it does. Ideas:

- **"How I Built This" sections** — for each project, an agent-generated case study describing the build process, tools used, decisions made, and what was learned
- **Claude Code session screenshots / embeds** — visual proof of agentic development in action
- **GitHub Activity feed** — live display of commit history and repo stats to show real cadence of work
- **Build log or changelog page** — auto-generated from commit history, showing the evolution of the site itself

---

## Live Data Pipeline Demo

A page that fetches real data, processes it, and displays it — proving "real-world data pipeline" is not just a claim.

Ideas for data sources:
- GitHub API — repo stats, commit activity, language breakdown
- Public financial data (stock prices, economic indicators)
- Weather or geolocation data
- A custom-built API endpoint that runs a mini ETL on demand

Stack considerations:
- Python backend (FastAPI) deployed on Railway or similar
- GitHub Actions for scheduled data refresh
- Lightweight frontend visualization (Chart.js, Observable Plot, or Plotly)

---

## Multi-Agent Orchestration Demo

A visible demonstration of agents working together autonomously:

- Show a pipeline where one agent plans, another builds, another reviews, and another documents
- Could be a "live build" feature — trigger a task and watch the agents collaborate
- Document this in a case study with agent logs and decision traces

---

## GitHub Actions as Proof of Automation

Even simple workflows demonstrate the capability:

- Auto-deploy on push to `main`
- Scheduled data refresh job
- Lint + type-check + test on every PR
- Auto-generate a changelog entry from commit messages

---

## Content Ideas

- **"Analytics + AI Tools I Use"** — honest breakdown of Claude Code, Netlify, GitHub Copilot, etc. with real opinions
- **Case study: This Workspace** — document how the Claude Code workspace was built, what the old work config looked like, and how it was adapted for personal use
- **Decision-making / reasoning loops** — a demo or walkthrough of how plan mode + multi-agent works in practice

---

## Deferred Portfolio Projects

These were on the website but removed 2026-03-21 to focus on shipping the Analytics Agent first. Revisit after the Analytics Agent is complete.

- **AI Customer Insights Engine** — CLV predictions, customer segmentation, marketing strategy from raw transaction data. Needs public dataset (Olist could work). Stack: Python, Postgres, CrewAI, scikit-learn.
- **Automated BI Migration Agent** — Tableau workbook → dbt model conversion. **Work was actually completed at previous job** — real workbooks were migrated session by session (not yet a true agent, more a structured workflow). Next step: locate the files, scrub passwords and connection strings, and refactor into a proper agentic loop (LangGraph orchestration, not manual session-by-session). Stack: Python, dbt, LangGraph, SQLGlot. Priority: high — real work exists, just needs cleanup and reframing.
- **Self-Healing Data Pipeline** — Airflow failure diagnosis + GitHub PR auto-fix. Requires real pipeline infrastructure to be credible. Defer until infrastructure is available.
- **Autonomous Data Team** — Multi-agent simulation of a full analytics team. Too early to build — concept is strong but execution requires completing the above projects first.

---

## Workspace Improvements

- Add a `data-pipeline` skill (complement to the agent) for common ETL patterns
- Add a `weekly-review` skill for personal project tracking (adapted from old weekly-report)
- Consider adding MCP servers: GitHub MCP for repo management, browser MCP for web research
- Build out `_shared/references/` as the portfolio grows (tech stack conventions, personal style guide)
