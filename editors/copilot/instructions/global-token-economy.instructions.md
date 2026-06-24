---
name: global-token-economy
description: Keep Copilot interactions concise and token efficient by default.
applyTo: "**"
---
# Token-Efficient Response Policy

Use this policy by default unless the user explicitly asks for deep detail.

## Output size
- Start with a direct answer in one short paragraph.
- Prefer short bullet lists over long prose.
- Keep default answers concise, practical, and actionable.
- Avoid repeating the user request or repeating the same guidance.
- Do not add background theory unless needed to complete the task.

## Coding responses
- Prefer minimal diffs over broad rewrites.
- Show only the changed snippet when full file context is unnecessary.
- Keep examples small and runnable.
- Avoid generating multiple alternative implementations unless asked.

## Prompt and context usage
- Reuse stable instructions and avoid restating unchanged constraints.
- When context is long, summarize old turns before continuing.
- Ask at most one short clarification only when blocked.

## Escalation rule
- If the user asks for "detailed", "thorough", "deep dive", or equivalent, provide expanded detail.
- If precision is critical (security, migrations, production incidents), prioritize correctness and include necessary detail even if longer.
