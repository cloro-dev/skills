# Async tasks, batches and webhooks

Source: <https://cloro.dev/docs/guides/making-requests/async>, <https://cloro.dev/docs/api-reference/endpoint/create-batch-tasks>, <https://cloro.dev/docs/guides/webhooks>.

## Endpoints

| Endpoint | Use |
|---|---|
| `POST /v1/async/task` | Submit one task |
| `POST /v1/async/task/batch` | Submit 1 to 500 tasks |
| `GET /v1/async/task/{taskId}` | Get the status and, when finished, the result |
| `GET /v1/async/status` | Queue and concurrency stats for the account |
| `DELETE /v1/async/queue` | Remove all `QUEUED` tasks. `PROCESSING` tasks continue |

## Task fields

| Field | Required | Use |
|---|---|---|
| `taskType` | Yes | `CHATGPT`, `GEMINI`, `AIMODE`, `BING_AIMODE`, `GOOGLE`, `GOOGLE_NEWS`, `GOOGLE_PRODUCT` |
| `payload` | Yes | The same body as the sync request for that surface |
| `priority` | No | 1 to 10. Higher runs first. Default 1 |
| `idempotencyKey` | No | A unique string across the account. A key used before returns `409` with `error.details.taskId` |
| `webhook.url` | No | cloro sends the result here when the task finishes |

## Task states

| State | Meaning |
|---|---|
| `QUEUED` | Waiting, in priority order. A task that waits for a retry is also `QUEUED` |
| `PROCESSING` | A worker runs it |
| `COMPLETED` | A result is in `response`. It is charged. The result can be the provider's own refusal text |
| `FAILED` | No attempt returned a result, or the payload or credits failed the check. Not charged |

You cannot cancel one queued task by ID. `DELETE /v1/async/queue` clears all queued tasks.

## Batch errors

The batch response is `200` with one result per task. A task can fail with:

| Code | Meaning |
|---|---|
| `VALIDATION_ERROR` | The task failed the schema. `details` names the fields |
| `RESOURCE_ALREADY_EXISTS` | The `idempotencyKey` was used before, or earlier in the same batch |
| `INSUFFICIENT_CREDITS` | Not enough credits for this task |
| `MODEL_UNAVAILABLE` | The `taskType` is not available. The task was not created |

The queue check is all or nothing. A batch that would take the queue past 100,000 tasks fails whole with `429 QUEUE_LIMIT_EXCEEDED`.

## Webhook payload

The body is the same as `GET /v1/async/task/{taskId}` for the finished task:

```json
{
  "task": {
    "id": "b27a21e1-7c39-4aa2-a347-23e828c426f9",
    "taskType": "CHATGPT",
    "status": "COMPLETED",
    "priority": 5,
    "createdAt": "2025-11-10T15:00:00.000Z",
    "latencyMs": 3420,
    "idempotencyKey": "your-custom-identifier-123"
  },
  "credits": { "creditsToCharge": 5, "creditsCharged": 5 },
  "response": { "text": "...", "sources": [] }
}
```

The result fields are directly under `response`, not under `response.result`.

Reply with any `2xx`. Anything else is a failed delivery. cloro retries up to 5 attempts, at about 2, 4, 8 and 16 minutes. Deduplicate on `task.id`.

## Webhook signatures

Signing is opt-in. Turn it on at <https://dashboard.cloro.dev/webhooks>. The secret starts with `whsec_` and is shown once.

Each signed delivery has `X-Cloro-Timestamp`, `X-Cloro-Signature` (`v1=<hex>`) and `X-Cloro-Webhook-Id`. To verify:

1. Read the raw request body before you parse the JSON.
2. Compute `HMAC-SHA256(secret, "<X-Cloro-Timestamp>.<raw body>")` and hex-encode it.
3. Compare it with the value after `v1=`, with a constant-time compare.

## Polling

Without a webhook, poll `GET /v1/async/task/{taskId}` with a backoff. The SDKs do this: `client.async_tasks.wait(id)` (Python), `client.asyncTasks.wait(id)` (TypeScript).

## Retention

Finished tasks are deleted about 24 hours after creation. HTML URLs in a result expire after 24 hours.
