# Task Extraction Prompt

Use this prompt to extract actionable GitHub issues from governance + design documents.

## Goal

Produce a JSON array of proposed issues with:
- title
- body (problem, scope, acceptance criteria)
- labels
- priority (low/medium/high)
- suggested area/path (e.g., `design/adr/`, `policies/`, `automation/`)

## Instructions

1. Read the input document(s).
2. Extract concrete, volunteer-friendly tasks (1–3 days of work).
3. Prefer issues that improve reproducibility, governance clarity, or automation.
4. Do not invent requirements not present in the documents.
5. If a task is ambiguous, create a "clarify" issue rather than guessing.
