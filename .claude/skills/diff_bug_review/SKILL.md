---
name: diff_bug_review
description: Run multi-agent bug review using Claude and Copilot
invocation: user
allowed-tools:
  - Read
  - Grep
  - Glob
  - Git
  - Bash
  - Agent
---

# Diff bug review

1.  Launch a Claude sub agent.
2.  Launch, in parallel to the previous one, a separate Copilot-backed reviewer
    using the model gpt-5.3-codex with extended reasoning enabled, to do that
    you can use the copilot cli from bash (copilot is the name of the
    application) giving it full access for reading this, but not for editing.
    Run copilot with output redirected to a temp file specifying that the output
    must be entirely placed in a related section at the end in order to be
    analyzed by the orchestrator.
    Read back only the output section, not the full output.
3.  Make them analyze the differences in the current repository from the last
    commit and classify all the bugs and rank them by severity.
4.  Analyze their outputs and exclude false positives.

## Project convention discovery

Before reviewing code changes:

1. Search for AI/project guidance folders including:
    - .ai/
    - docs/

2. Look for files related to:
    - architecture
    - known pitfalls
    - review guidance

3. Prioritize files with names such as:
    - architecture.md
    - known-regressions.md
    - code-review-focus.md

4. If multiple convention sources exist:
    - prefer repository-local guidance
    - prefer explicitly named architecture documents
    - prefer recently updated documents

5. If project-specific guidance is unavailable:
    - infer conventions from code structure
    - fall back to language best practices

Load only documents relevant to the modified subsystem.

## Token efficiency constraints

-   When launching agents pass only the task it has to work out.
    Do NOT embed source code, diffs, or file contents in the prompt.
    Each agent has filesystem access and will read what it needs itself.
-   Each agent should return:
    -   A brief description of each finding (2-3 sentences max, no file excerpts)
    -   File and function name, not full source quotes
    -   Severity rating with a one-line justification

