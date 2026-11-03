---
name: perplexity
description: 'Use to get Perplexity answers as structured JSON from the Perplexity web interface, not its model API: the answer text, markdown, every cited source, citation pills, related queries, the search-model queries behind the answer, shopping cards, images, videos, hotels and places. Use it to get the Perplexity UI answer and sources through an API, or check what Perplexity says about a brand. Supports US state targeting. For many prompts or a schedule, use llm-answer-monitoring.'
license: MIT
metadata:
  author: cloro
  version: "0.1.0"
  docs: "https://cloro.dev/docs/api-reference/endpoint/monitor-perplexity"
---

# Perplexity

`POST https://api.cloro.dev/v1/monitor/perplexity`. MCP tool: `scrape_perplexity`. Async `taskType`: `PERPLEXITY`.

cloro sends the prompt to the Perplexity web interface in a logged-out session in the country you select. The result is the answer and the sources that the interface shows. It is not a call to the Perplexity model API.

## The call

```bash
curl -X POST "https://api.cloro.dev/v1/monitor/perplexity" \
  -H "Authorization: Bearer $CLORO_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"prompt": "best accounting software for freelancers", "country": "US"}'
```

Required: `prompt` and `country`. Optional: `state` (a US state, +2 credits), `include.markdown`, `include.html`, `include.rawResponse` (all free).

## What comes back

| Field | Content |
|---|---|
| `result.text`, `result.markdown` | The answer |
| `result.sources` | `position`, `url`, `label`, `description` |
| `result.citationPills` | Bracketed inline citations, one entry per cited source |
| `result.related_queries` | Suggested follow-up queries |
| `result.search_model_queries` | The search queries behind the answer. No flag needed |
| `result.shopping_cards` | Products, when the prompt has a shopping intent |
| `result.images`, `result.videos` | Media for the query |
| `result.hotels`, `result.places` | Travel and location results |

Perplexity uses snake_case for some keys (`shopping_cards`, `related_queries`). Other surfaces use camelCase.

## Cost

4 credits async, 6 sync. +2 for `state`.

## Read next

- `llm-answer-monitoring`: Perplexity and other engines for a prompt set.
- `cloro-api`: errors, including `MODEL_UNAVAILABLE` when a surface is temporarily not available.
