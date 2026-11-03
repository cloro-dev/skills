---
name: chatgpt
description: 'Use to get ChatGPT answers as structured JSON from the ChatGPT web interface, not the OpenAI model API: the answer text, markdown, cited sources with dates, citation pills, shopping cards, inline products, brand and product entities, map entries, ads and the query fan-out (the web searches ChatGPT ran). Use it to get ChatGPT responses programmatically, extract ChatGPT shopping results and product recommendations, check what ChatGPT says about a brand, or replace an in-house ChatGPT scraper or a headless browser farm. Supports multi-turn conversations and US state targeting. For many prompts or a schedule, use llm-answer-monitoring.'
license: MIT
metadata:
  author: cloro
  version: "0.1.0"
  docs: "https://cloro.dev/docs/api-reference/endpoint/monitor-chatgpt"
---

# ChatGPT

`POST https://api.cloro.dev/v1/monitor/chatgpt`. MCP tool: `scrape_chatgpt`. Async `taskType`: `CHATGPT`.

cloro sends the prompt to the ChatGPT web interface in a logged-out session in the country you select. The result is what a ChatGPT user there sees, parsed into JSON. It is not a call to the OpenAI API. cloro does not choose the model: ChatGPT does.

## The call

```bash
curl -X POST "https://api.cloro.dev/v1/monitor/chatgpt" \
  -H "Authorization: Bearer $CLORO_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "best running shoes for flat feet",
    "country": "US",
    "include": { "markdown": true, "shopping": true, "searchQueries": true }
  }'
```

Required: `prompt` (1 to 10,000 characters) and `country`.

| Parameter | Use | Cost |
|---|---|---|
| `include.markdown`, `include.html` | Markdown, and a URL of the rendered page | Free |
| `include.shopping` | Shopping cards and inline products | +2 (shared, see below) |
| `include.searchQueries` | The query fan-out | +2 (shared) |
| `include.ads` | Ads. They appear only on follow-up prompts | +2 (shared) |
| `include.rawResponse` | The raw stream | +2 (shared) |
| `include.productDetails` | Rationale and reviews for each product. Needs `include.shopping` | +2 more |
| `state` | A US state, with `country: "US"` | +2 |
| `prompt` as an array | Up to 5 prompts in one conversation | +1 per prompt after the first |
| `disableWebSearch` | Do not force web search. Gets the answer ChatGPT gives on its own | Free |
| `legacy` | Ask for the legacy desktop interface | Free |

The four shared add-ons cost +2 once in total, however many you set.

## What comes back

| Field | Content |
|---|---|
| `result.text`, `result.markdown` | The answer |
| `result.sources` | `position`, `url`, `label`, `description`, `footnote`, `datePublished` |
| `result.citationPills` | Inline citations, one entry per cited source |
| `result.shoppingCards`, `result.inlineProducts` | Products with prices, ratings and merchant offers. Only with `include.shopping` |
| `result.entities` | Products, brands and concepts named in the answer |
| `result.map` | Business and place entries |
| `result.searchQueries` | Web searches that ChatGPT ran. Only with `include.searchQueries` |
| `result.mapSearchQueries` | Queries ChatGPT sent to its maps tool |
| `result.ads` | Ads. Only with `include.ads` |
| `result.followUpForm` | The questions ChatGPT asks to refine the prompt |
| `result.model` | The model that answered, when ChatGPT shows it |

With `prompt` as an array, `result` is an array with one response per prompt.

## Know these behaviors

- cloro forces web search on every request, so answers have sources. With `disableWebSearch: true`, expect empty `sources` and `searchQueries`.
- ChatGPT serves two interfaces. On the default mobile-web interface, `result.model`, `result.searchQueries` and `result.mapSearchQueries` can be empty. `legacy: true` asks for the desktop interface, which fills them, but it is best effort and can stop working.
- Shopping cards appear only for product prompts, and only when ChatGPT shows them. An empty array is a valid result.
- In a multi-turn request, web search is forced on the first prompt only.

## Cost

5 credits async, 7 sync. With any shared add-on: 7 async, 9 sync. Sync with `include.shopping` and `state`: 11.

## Read next

- `llm-answer-monitoring`: many prompts, many engines, a schedule.
- `ai-visibility-tracking`: brand mentions and citations.
- `cloro-api`: errors, countries (`GET /v1/countries?model=chatgpt`), states.
