---
name: token-efficiency
description: Optimize prompts, context size, and response length to reduce token usage and cost while preserving answer quality.
user-invocable: false
---

# Token Efficiency Skill

Use this skill when users ask to reduce token usage, reduce API cost, improve caching efficiency, or optimize prompt/context size.

## Objectives
- Reduce input tokens by trimming duplicated and low-value context.
- Reduce output tokens by enforcing compact response contracts.
- Improve cache hit rate by stabilizing prompt prefixes.
- Preserve quality by keeping critical constraints and facts.

## Workflow
1. Identify verbosity sources:
- Long repeated instructions
- Full chat history replay
- Oversized tool schemas or examples
- Unbounded response format

2. Apply compact prompt structure:
- Static instructions first
- Dynamic request last
- Strict output contract: max bullets, max words, expected format

3. Compact conversation state:
- Keep latest request and latest result
- Replace old turns with a short rolling summary containing:
  - Decisions
  - Constraints
  - Open questions

4. Enforce output budget:
- Set explicit max output tokens
- Prefer one-pass concise answer, expand only on request

5. Verify impact with measurements:
- Track input tokens, output tokens, and cached/read tokens when available
- Compare before and after values

## Deliverable format
When using this skill, produce:
- A short optimization plan
- A concrete patch/config change list
- A measurement checklist with token fields to monitor
