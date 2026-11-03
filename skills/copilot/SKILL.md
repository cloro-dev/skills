---
name: copilot
description: 'Use to get Microsoft Copilot answers as structured JSON from the Copilot web interface: the answer text, markdown, cited sources, citation pills, shopping cards, map entries and the web searches Copilot ran. Use it for an API for Microsoft Copilot answers, to scrape Copilot programmatically, or to check what Copilot says about a brand. Supports US state targeting. For many prompts or a schedule, use llm-answer-monitoring.'
license: MIT
metadata:
  author: cloro
  version: "0.1.0"
  docs: "https://cloro.dev/docs/api-reference/endpoint/monitor-copilot"
---

# Microsoft Copilot

`POST https://api.cloro.dev/v1/monitor/copilot`. MCP tool: `scrape_copilot`. Async `taskType`: `COPILOT`.

cloro sends the prompt to the Copilot web interface in a logged-out session in the country you select. Copilot searches the web on every request, so answers have sources.

## The call

```bash
curl -X POST "https://api.cloro.dev/v1/monitor/copilot" \
  -H "Authorization: Bearer $CLORO_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"prompt": "best noise cancelling headphones", "country": "US"}'
```

Required: `prompt` and `country`. Optional: `state` (a US state, +2 credits), `include.markdown`, `include.html`, `include.rawResponse` (all free).

## What comes back

| Field | Content |
|---|---|
| `result.text`, `result.markdown` | The answer |
| `result.sources` | Cited sources |
| `result.citationPills` | Inline citations, one entry per cited source |
| `result.searchQueries` | The web searches Copilot ran. No flag needed |
| `result.shoppingCards` | Products with prices, ratings and seller, when Copilot shows them |
| `result.map` | Business and place entries with reviews and photos |

## Cost

5 credits async, 7 sync. +2 for `state`.

## Read next

- `llm-answer-monitoring`: Copilot and other engines for a prompt set.
- `cloro-api`: errors and countries (`GET /v1/countries?model=copilot`).
