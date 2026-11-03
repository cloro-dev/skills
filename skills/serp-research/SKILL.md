---
name: serp-research
description: 'Use for Google rank tracking and SERP research at scale: track thousands of keywords a day, top 100 positions, by country, city and device, with the AI Overview, local pack and shopping results, on a schedule, and load the results into a warehouse such as BigQuery. Use it for an SEO agency rank tracker, ecommerce price and ranking monitoring, SERP feature tracking, or market research from search results. For one search, use google-search. For AI answers, use llm-answer-monitoring.'
license: MIT
metadata:
  author: cloro
  version: "0.1.0"
  docs: "https://cloro.dev/docs/api-reference/endpoint/monitor-google"
---

# SERP research and rank tracking

Run many Google searches on a schedule and keep the results. Each search is a `GOOGLE` async task with the same payload as the `google-search` skill.

## Pick the depth first

| The ask | Payload | Async credits per keyword |
|---|---|---|
| Top 10, no AI Overview | `pages: 1` | 3 |
| Top 10 with AI Overview | `pages: 1`, `include.aioverview: true` | 5 |
| Top 30 | `pages: 3` | 7 |
| Top 100 | `pages: 10` | 21 |
| Top 100 with AI Overview | `pages: 10`, `include.aioverview: true` | 23 |

Credits = 3 + 2 for each page after the first + 2 if the AI Overview is on. Multiply by keywords × locations × devices × runs. Tell the user the total before the first run.

## The job

1. Build the keyword list: keyword × `country` × (`location`) × (`device`).
2. Submit the tasks in batches of up to 500 to `POST /v1/async/task/batch`, with `taskType: "GOOGLE"`.
3. Get the results by webhook. Store each one.
4. Repeat on a schedule (a cron job). Use the same `idempotencyKey` pattern for each run, with the run date in it.

```json
[
  {
    "taskType": "GOOGLE",
    "idempotencyKey": "rank-2026-11-03-crm-software-us-desktop",
    "webhook": { "url": "https://example.com/cloro-webhook" },
    "payload": {
      "query": "crm software",
      "country": "US",
      "device": "desktop",
      "pages": 10,
      "include": { "aioverview": true }
    }
  }
]
```

For webhooks, retries and the queue, read the `llm-answer-monitoring` skill and its `references/async-and-batch.md`.

## Find a rank

For a target domain, the rank is the lowest `position` in `response.organicResults` where the host of `link` matches the domain. Each result has `page`. If no result matches, record "not in the top N", where N is 10 × `pages`. Do not record 0.

Track the SERP features too: presence of `aioverview`, `localResults`, `shoppingCards`, `peopleAlsoAsk` and `ads`, and whether the domain is in `aioverview.sources`.

## Load into a warehouse

Write one row per keyword per run, and one row per organic result:

| Table | Columns |
|---|---|
| `serp_run` | `task_id`, `run_date`, `query`, `country`, `location`, `device`, `has_aioverview`, `has_local_pack`, `has_shopping` |
| `serp_result` | `task_id`, `position`, `page`, `link`, `domain`, `title` |

For BigQuery, load newline-delimited JSON of these rows with `bq load --source_format=NEWLINE_DELIMITED_JSON`, or stream them from the webhook handler. Keep the raw JSON in object storage. The fields can grow.

## Rules

- Use `pages`, not `num`.
- Use `location` for a city. The `state` field does not work on Google.
- Use `device: "ios"` or `"android"` for mobile rankings. Mobile and desktop SERPs differ.
- A run with a large keyword list takes time. The plan's concurrency limit sets how many tasks run at the same time. Read `GET /v1/async/status` to see the queue.
- Read keys with defaults. A feature that Google did not show is absent.

## Read next

- `google-search`: parameters and fields.
- `google-ai-overview`: the AI Overview fields.
- `cloro-api`: limits and cost.
