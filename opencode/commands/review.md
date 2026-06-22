---
description: Comprehensive multi-agent code review — architecture, code, security (Semgrep + CodeQL), and WCAG 2.2 AA accessibility — produced as a unified P0–P3 findings table
agent: review-orchestrator
---

# Action

Run a comprehensive code review using the four specialist subagents (`software-architect-reviewer`, `code-reviewer`, `security-reviewer`, `accessibility-reviewer`) and consolidate their output into a single prioritised P0–P3 findings table.

## Scope detection

User arguments (if any) determine scope:

- A file or directory path → review just that
- `--pr <num>` or `#<num>` → use `gh pr diff` for that PR
- `--branch` or no argument → diff current branch vs the repo's default branch
- `--staged` → `git diff --cached`
- `--all` → full repo (warn it's slow and token-heavy; confirm before proceeding)

If the user prompt didn't include arguments, infer scope by checking, in order:

1. Open PR for the current branch (`gh pr view --json number,baseRefName,headRefName 2>/dev/null`)
2. Branch diff against the default branch
3. Staged changes
4. Working-tree changes

If none of those produce a non-empty scope, ask the user before doing anything else.

## Dispatch

Follow the `review-orchestrator` agent's process exactly:

1. Build the scope description.
2. Issue **all four Task tool calls in a single message**, in parallel, with `subagent_type` set to each of:
   - `software-architect-reviewer`
   - `code-reviewer`
   - `security-reviewer`
   - `accessibility-reviewer`
3. Aggregate, deduplicate, and classify the responses into P0–P3.
4. Produce the unified report per the orchestrator's output format.

## Constraints

- **Read-only**. No file edits. No git mutations. No GitHub issue creation.
- If the security reviewer aborts because Semgrep or CodeQL is missing, surface its install instructions verbatim and still report the other three reviewers' output.
- Stop after the report. Suggest follow-on actions in a single closing sentence, but do not execute them.
