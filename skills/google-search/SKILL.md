---
name: google-search
description: 'Use to get live Google Search results as structured JSON: a SERP API for organic results, People Also Ask, local pack, shopping cards, sponsored ads, related searches and the knowledge graph. Use it for city-level and device-level Google results (desktop, iPhone, Android), results in one country and language, depth past page one (up to 10 pages, 100 results, after Google removed num=100), the raw HTML beside the parsed results, or a replacement for the Google Custom Search JSON API. To give an agent or a RAG pipeline live web search, use web-search. To analyze the results page for a keyword (intent, ranking page types, a content brief), use serp-analysis. For the AI Overview, use google-ai-overview. For news, use google-news. For thousands of keywords on a schedule, use serp-research. For setup and errors, use cloro-api.'
license: MIT
metadata:
  author: cloro
  version: "0.1.0"
  docs: "https://cloro.dev/docs/api-reference/endpoint/monitor-google"
---

# Google Search

`POST https://api.cloro.dev/v1/monitor/google`. MCP tool: `scrape_google`. Async `taskType`: `GOOGLE`.

Each request runs a new Google search when you send it and parses the page that Google returned.

## The call

```bash
curl -X POST "https://api.cloro.dev/v1/monitor/google" \
  -H "Authorization: Bearer $CLORO_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"query": "best crm for startups", "country": "US"}'
```

Required: `query` and `country` (or `gl`). Or send only `url`, a complete `google.com/search` URL. Then the URL sets the query, the country, the language and the depth.

## Parameters that matter

| Parameter | Use |
|---|---|
| `country` or `gl` | Result country, ISO 3166-1 alpha-2 |
| `hl` | Interface language, for example `de` or `pt-BR`. It can differ from the country |
| `location` | City or region, in Google's canonical format: `"New York,New York,United States"`. Do not send it with `uule` |
| `uule` | A pre-encoded Google location string. Do not send it with `location` |
| `device` | `desktop` (default), `ios` (Safari on iPhone), `android` or `mobile` (Chrome on Android) |
| `pages` | 1 to 10. Each page after the first costs +2 credits. All pages come back in one response |
| `include.aioverview` | Add the AI Overview. See the `google-ai-overview` skill |
| `include.paaAioverview` | Add the AI Overview inside People Also Ask answers |
| `include.html` | Also return URLs of the raw HTML pages, one per page. Free. The URLs expire after 24 hours |

Details and examples: [references/geo.md](references/geo.md).

## What comes back

`result` has these keys when Google shows the feature:

| Key | Content |
|---|---|
| `organicResults` | `position`, `title`, `link`, `displayedLink`, `snippet`, `date`, `page`, `sitelinks` |
| `peopleAlsoAsk` | `question`, `snippet`, `title`, `link`, `sources`, `page` |
| `localResults` | The local pack: `title`, `rating`, `reviews`, `address`, `phone`, `hours`, `placeId` |
| `shoppingCards` | `title`, `price`, `store`, `rating`, `reviews`, `productResultToken` |
| `ads` | Sponsored ads with `title`, `url`, `domain`, `description`, `sitelinks` |
| `relatedSearches` | `query`, `link` |
| `knowledgeGraph` | The right-hand panel |
| `aioverview` | Only with `include.aioverview` |
| `html` | An array of URLs, only with `include.html` |

A key that Google did not show is absent. Read keys with a default, for example `result.get("localResults", [])`.

Field-by-field notes: [references/features.md](references/features.md).

## Cost

3 credits for page 1, async. +2 for each extra page. +2 once for the AI Overview. +2 for a sync request. 10 pages with AI Overview cost 23 credits async.

## Red flags

- Do not send `num`. Use `pages`. Google caps `num` at 10, so cloro gets depth by pages.
- Do not send `location` and `uule` together.
- Do not send `state`. Google Search uses `location` for sub-country targeting.
- A result `link` can be empty or a `google.com/goto` URL. Then use `redirectLink` with `POST /v1/monitor/google/goto` (1 credit) to get the destination.
- cloro returns Google only. It does not return Bing, DuckDuckGo, Yandex, Baidu, Naver, YouTube or Amazon results.

## Read next

- [references/geo.md](references/geo.md): location, device, language and depth.
- [references/features.md](references/features.md): each SERP feature and its fields.
- `serp-research`: rank tracking at scale.
