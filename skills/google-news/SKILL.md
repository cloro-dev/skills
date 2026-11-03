---
name: google-news
description: 'Use to get Google News results as structured JSON: article titles, links, snippets, publishers, publication dates and thumbnails, for a query in one country and language, up to 10 pages. Use it for a Google News API, news monitoring at scale, or brand and competitor news tracking. For the normal Google results page, use google-search.'
license: MIT
metadata:
  author: cloro
  version: "0.1.0"
  docs: "https://cloro.dev/docs/api-reference/endpoint/monitor-google-news"
---

# Google News

`POST https://api.cloro.dev/v1/monitor/google/news`. MCP tool: `scrape_google_news`. Async `taskType`: `GOOGLE_NEWS`.

## The call

```bash
curl -X POST "https://api.cloro.dev/v1/monitor/google/news" \
  -H "Authorization: Bearer $CLORO_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"query": "electric vehicles", "country": "US", "pages": 3}'
```

Required: `query` and `country` (or `gl`).

| Parameter | Use |
|---|---|
| `hl` | Interface language |
| `device` | `desktop`, `ios`, `android` or `mobile` |
| `pages` | 1 to 10. Articles from all pages come back in one response |
| `include.html` | URLs of the raw HTML pages. Free. Expire after 24 hours |

Google News has no sub-country targeting: no `location`, `uule` or `state`.

## What comes back

`result.newsResults`, one item per article:

| Field | Content |
|---|---|
| `position` | Position in the results, from 1 |
| `title`, `link`, `snippet` | The article |
| `source` | Publisher name |
| `date` | As Google shows it, for example `"2 hours ago"` |
| `page` | The results page, from 1 |
| `thumbnail` | Image URL, when present |
| `redirectLink` | A Google `goto` URL, when Google served one. Resolve it with `POST /v1/monitor/google/goto` |

`date` is relative text, not a timestamp. Convert it with the request time if you need a date.

## Cost

3 credits async for page 1, +2 for each extra page. +2 for a sync request.

## Read next

- `google-search`: the main results page.
- `cloro-api`: async batches for many queries.
