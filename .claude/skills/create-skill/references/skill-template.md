# Skill Template

Copy and fill in this skeleton when creating a new skill.

---

```markdown
---
name: <name>                         # lowercase, hyphenated → becomes /name
description: <trigger description>   # when should this be invoked?
argument-hint: "<example input>"     # shown as hint when skill is loaded
allowed-tools: Read, Write, Bash     # only tools this skill needs
metadata:
  version: "1.0"
  tier: guided-workflow              # conventions | platform-knowledge | guided-workflow | business-logic
  freedom: medium                    # low | medium | high
  tags: [tag1, tag2, tag3]           # 2-4 lowercase tags
---

# <Skill Display Name>

Brief description of what this skill does and when to use it.

---

## Instructions

### Step 1 — [Name]
[What to do. Be specific. Name files, commands, and outputs.]

### Step 2 — [Name]
[Next step.]

### Step 3 — [Name]
[And so on.]

---

## Output Format

[Describe what the skill produces. Include a template if applicable.]

\`\`\`
## [Skill Name]: [input]

[output structure]
\`\`\`
```

---

Also create `FEEDBACK.md` in the same directory:

```markdown
# Feedback: <name>

Track outcomes to improve the skill over time.

| Date | Input | Outcome | Notes |
|---|---|---|---|
|  |  |  |  |
```
