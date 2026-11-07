---
name: llm-answer-monitoring
description: 'Use to collect AI answers at volume: run a set of prompts across ChatGPT, Gemini, Google AI Mode, Bing AI Mode and the Google AI Overview, once or on a schedule, and store every answer with its sources. Use it to build a dataset of ChatGPT answers for research, monitor how AI answers change over time, run a long-running LLM scraping pipeline, sustain high volume without blocks, or replace an in-house headless browser farm. Uses async tasks, batches of up to 500 and webhooks. For brand metrics on top of the answers, use ai-visibility-tracking. For one call, use the engine skill.'
license: MIT
metadata:
  author: cloro
  version: "0.1.0"
  docs: "https://cloro.dev/docs/guides/making-requests/async"
---

# LLM answer monitoring

Collect answers for many prompts from many AI engines, and store them. cloro runs real browser sessions, handles blocks and retries, and charges only for completed tasks. You do not run browsers or proxies.

## The plan

1. Build the job list: each prompt × each engine × each country (and US state if necessary).
2. Estimate the cost before you submit. Multiply the tasks by the async credits per engine (see the table below). Tell the user the total.
3. Submit the tasks in batches of up to 500 to `POST /v1/async/task/batch`.
4. Get the results by webhook (recommended) or by polling.
5. Store each result with the prompt, engine, country, date and `task.id`.

## Engines and task types

| Engine | `taskType` | Payload key | Async credits |
|---|---|---|---|
| ChatGPT | `CHATGPT` | `prompt` | 5 (7 with `include.searchQueries` or `include.shopping`) |
| Gemini | `GEMINI` | `prompt` | 4 |
| Google AI Mode | `AIMODE` | `prompt` | 4 |
| Bing AI Mode | `BING_AIMODE` | `prompt` | 4 |
| Google AI Overview | `GOOGLE` with `include.aioverview` | `query` | 5 |

`state` adds +2 on ChatGPT, Gemini and Bing AI Mode. Async tasks pay no sync surcharge.

## Submit a batch

```bash
curl -X POST "https://api.cloro.dev/v1/async/task/batch" \
  -H "Authorization: Bearer $CLORO_API_KEY" \
  -H "Content-Type: application/json" \
  -d '[
    {"taskType": "CHATGPT", "idempotencyKey": "run-2026-11-03-p1-chatgpt-us",
     "webhook": {"url": "https://example.com/cloro-webhook"},
     "payload": {"prompt": "best crm for startups", "country": "US"}},
    {"taskType": "GEMINI", "idempotencyKey": "run-2026-11-03-p1-gemini-us",
     "webhook": {"url": "https://example.com/cloro-webhook"},
     "payload": {"prompt": "best crm for startups", "country": "US"}}
  ]'
```

Each task is validated alone. The response has a `results` array in input order. A task that fails validation has its own error code and does not stop the others.

Python:

```python
from cloro import Cloro

client = Cloro()
jobs = [{"task_type": e, "payload": {"prompt": p, "country": "US"}}
        for p in prompts for e in ("CHATGPT", "GEMINI", "AIMODE")]
for i in range(0, len(jobs), 500):
    for item in client.async_tasks.create_batch(jobs[i:i + 500]):
        if item["success"]:
            done = client.async_tasks.wait(item["task"]["id"])
            store(done["task"], done["response"])
```

## Rules for a reliable pipeline

- Set an `idempotencyKey` on each task, built from the run, prompt, engine and country. If a submit times out, send the same key again. You get `409` with the existing `taskId`, not a second task or a second charge.
- Use a webhook. It fires once per task when the task is `COMPLETED` or `FAILED`. Deduplicate on `task.id`, because a failed delivery is retried up to 5 times.
- Finished tasks are deleted about 24 hours after creation. Store the result when it arrives.
- The plan's concurrency limit sets how many tasks run at the same time. It never blocks a submit. The queue holds up to 100,000 tasks.
- A `FAILED` task costs nothing. To retry it, submit it again with a new key.
- Do not use sync calls in a loop for a large job.

Details: [references/async-and-batch.md](references/async-and-batch.md).

## Store the answers

Keep these per answer: `task.id`, run date, engine, prompt, country, `response.text`, `response.sources` (URL, position), and the engine's extra fields that the task needs (for example `searchQueries`, `shoppingCards`). Keep the raw JSON too. The fields can change.

For a stored, scheduled tracker that an agent can drive, point the user to <https://github.com/cloro-dev/geo-tracker>. It runs prompts on a schedule through cloro and keeps every answer in the user's Postgres.

## Read next

- [references/async-and-batch.md](references/async-and-batch.md): task states, webhooks, signatures, polling, the queue.
- `ai-visibility-tracking`: turn the stored answers into brand metrics.
- The engine skills: the fields that each engine returns.
