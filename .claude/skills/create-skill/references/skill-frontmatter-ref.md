# Skill Frontmatter Reference

Complete reference for YAML frontmatter fields in `SKILL.md` files.

---

## Required Fields

| Field | Type | Description |
|---|---|---|
| `name` | string | Lowercase, hyphenated. Becomes the `/name` slash command. |
| `description` | string | When/why to trigger this skill. Used for auto-routing. |

---

## Recommended Fields

| Field | Type | Description |
|---|---|---|
| `argument-hint` | string | Example input shown as a hint when skill loads |
| `allowed-tools` | string | Comma-separated list of tools this skill may use |
| `metadata` | block | See below |

---

## Metadata Block

```yaml
metadata:
  version: "1.0"
  tier: guided-workflow   # see tiers below
  freedom: medium         # low | medium | high
  tags: [tag1, tag2]      # 2-4 lowercase tags
```

### Tiers

| Tier | Meaning |
|---|---|
| `conventions` | Enforces a standard or style rule |
| `platform-knowledge` | Reference guide, best practices, how-to |
| `guided-workflow` | Step-by-step procedure with gates |
| `business-logic` | Domain-specific, project-specific logic |

### Freedom Levels

| Level | Meaning |
|---|---|
| `low` | Strict steps, minimal deviation allowed |
| `medium` | Follow steps but apply judgment at each |
| `high` | Goal-directed, autonomous execution |

---

## Optional Fields

| Field | Type | Description |
|---|---|---|
| `model` | string | Override default model for this skill |
| `agent` | string | Route to a specific agent when invoked |
| `context` | list | Additional files to load into context |
| `hooks` | object | Pre/post hooks |
| `user-invocable` | bool | Whether users can trigger via `/name` (default: true) |

---

## Tags Vocabulary

| Category | Tags |
|---|---|
| Language | `python`, `javascript`, `typescript`, `sql`, `html`, `css` |
| Domain | `data`, `pipeline`, `api`, `web`, `portfolio` |
| Workflow | `scaffold`, `debugging`, `testing`, `review`, `quality` |
| Meta | `workspace`, `meta`, `agents`, `skills`, `automation` |

---

## Skill Loading Behavior

- Skills in `.claude/skills/<name>/SKILL.md` are auto-discovered
- Triggered by `/name` or when description matches user intent
- `allowed-tools` restricts which tools the skill can invoke
- `context` files are read into context when skill loads
