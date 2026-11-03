# Errors, retries and limits

Source: <https://cloro.dev/docs/guides/error-handling> and <https://cloro.dev/docs/guides/concurrency>.

## Error shape

```json
{
  "success": false,
  "error": {
    "code": "CONCURRENCY_LIMIT_EXCEEDED",
    "message": "Concurrency limit exceeded",
    "details": { "limit": 10 },
    "timestamp": "2025-01-15T12:00:00.000Z"
  }
}
```

## Status codes

| Status | Meaning | Action |
|---|---|---|
| `200` | Success | Read `result` |
| `400` | Validation failed, or the surface is not available (`MODEL_UNAVAILABLE`) | Fix the request. Do not retry the same body |
| `401` | Missing, malformed or invalid API key | Fix the `Authorization` header |
| `403` | `INSUFFICIENT_CREDITS` | Stop and tell the user |
| `404` | Unknown route or task | Check the path or the `taskId`. Tasks are deleted about 24 hours after creation |
| `409` | `RESOURCE_ALREADY_EXISTS`: the async `idempotencyKey` was used before | Use `error.details.taskId`. It is the existing task |
| `429` | Rate, concurrency or queue limit | See below |
| `499` | You closed the request | The running attempt can still finish and be charged |
| `500` | Server error | Retry with exponential backoff |
| `502` | Redirect link did not resolve | Retry with backoff |
| `503` | `SERVICE_UNAVAILABLE` | Wait `Retry-After` seconds |

## Limits

| Limit | Value | Code when exceeded |
|---|---|---|
| Rate | 1,000 requests per second per endpoint, per API key | `RATE_LIMIT_EXCEEDED` |
| Concurrency | Simultaneous sync requests, set by the plan (1 on the free tier) | `CONCURRENCY_LIMIT_EXCEEDED` |
| Queue | 100,000 queued async tasks per organization | `QUEUE_LIMIT_EXCEEDED` |
| Batch size | 1 to 500 tasks per batch request | `400 VALIDATION_ERROR` |

No `429` sends `Retry-After`. Choose the backoff from the code. For sustained load, use a queue on your side or the async API. Do not retry in a tight loop.

Async tasks share the concurrency slots with sync requests. The concurrency limit never blocks an async submit. It only sets how many tasks run at the same time.

## Headers

| Header | Meaning |
|---|---|
| `X-Request-ID` | Give this to support |
| `X-Concurrency-Limit`, `X-Concurrency-Current`, `X-Concurrency-Remaining` | Plan slots, slots in use, free slots when the request arrived |
| `X-RateLimit-Limit`, `X-RateLimit-Remaining` | Per-second rate limit |
| `X-Credits-Charged`, `X-Credits-Remaining` | Credits for this request, balance |
| `X-Latency-Ms` | Time the API spent on the request |

## Retries

cloro retries each failed attempt automatically, up to 5 attempts (fewer on some surfaces). A sync request starts no new attempt after 5 minutes. Set a client timeout of at least 300 seconds.

## Country failures

A provider can ask for a login in some regions for a time. Then requests from that country fail until the provider changes it. Call `GET /v1/countries?model=<surface>` to get the current list. If more than about 30% of requests from one listed country fail, contact support with the `taskId` or `X-Request-ID`.

## Empty answers

A `COMPLETED` task or a `200` can carry the provider's own refusal or error text. cloro returns what the provider showed. Check `result.text` before you use it.
