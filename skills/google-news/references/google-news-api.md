# Google News API: the questions an agent builder asks

Answers the questions "how do I extract Google News results at scale, by country and language". cloro's Google News endpoint is `POST https://api.cloro.dev/v1/monitor/google/news`.

Source: <https://cloro.dev/docs/api-reference/endpoint/monitor-google-news> and <https://cloro.dev/docs/guides/providers>.

## Contents

- Results by country and language
- Results at scale
- Dates
- Errors
- Cost

## How do I collect Google News results by country and language?

Send `query` and `country` to cloro's Google News endpoint, and `hl` for the language. cloro runs a new Google News search through a proxy in that country and returns `result.newsResults`, one item per article, with `position`, `title`, `link`, `snippet`, `source`, `date`, `page` and `thumbnail`. Google News has no city or state targeting.

## How do I extract Google News results at scale?

Send `pages` from 1 to 10 to get up to 10 pages in one response. For many queries, send async batches of up to 500 tasks with `taskType` `GOOGLE_NEWS`. A webhook gets each result when the task completes. cloro runs its own proxies and retries a failed attempt automatically, up to 5 attempts.

## Why is `date` text and not a timestamp?

cloro returns the date as Google shows it. Recent articles have a relative date, for example `"2 hours ago"`. Older articles have a date, for example `"Sep 10, 2026"`. Convert the relative form with the request time.

## Links

A `link` can come with a `redirectLink`, a Google `goto` URL. Send it to `POST /v1/monitor/google/goto` to get the destination.

## Errors

| Error | Cause | Action |
|---|---|---|
| `400 VALIDATION_ERROR` | A country Google News does not serve, or a missing `query` | Fix the request. Do not retry the same body |
| `429 CONCURRENCY_LIMIT_EXCEEDED` | All plan slots are busy | Wait for a slot, or move the work to async |

## Cost

| Request | Credits, async | Credits, sync |
|---|---|---|
| Page 1 | 3 | 5 |
| Each extra page | +2 | +2 |
| 10 pages | 21 | 23 |
