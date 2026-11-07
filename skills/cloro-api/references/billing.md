# Billing and credits

Source: <https://cloro.dev/docs/guides/providers> and <https://cloro.dev/docs/guides/billing>. If a number here does not agree with the docs, the docs are correct.

## When cloro charges

- A sync request: only when it returns `200` with `success: true`.
- An async task: only when it reaches `COMPLETED`.
- No charge for error responses, `FAILED` tasks (`creditsCharged: 0`), or the retries that cloro runs inside one request.
- A request that you send again is a new request. It is charged if it succeeds.
- A `200` with an empty optional field (`shoppingCards: []`, no `ads`) is a result. It is charged.

## Base cost and add-ons (async)

| Surface | Base | Add-ons |
|---|---|---|
| ChatGPT | 5 | +2 once for any of `include.rawResponse`, `include.searchQueries`, `include.ads`, `include.shopping`. +2 more for `include.productDetails`. +1 for each prompt after the first in a multi-turn request. +2 for `state` |
| Gemini | 4 | +2 for `state` |
| Google AI Mode | 4 | None |
| Bing AI Mode | 4 | +2 for `state` |
| Google Search | 3 | +2 once for `include.aioverview` and/or `include.paaAioverview`. +2 for each page after the first (up to 10 pages) |
| Google News | 3 | +2 for each page after the first (up to 10 pages) |
| Google product panel | 1 | None |
| Google redirect link (`/v1/monitor/google/goto`) | 1 | None. No sync surcharge |

**Sync surcharge:** each sync request to `/v1/monitor/*` adds +2 credits. Async and batch requests do not.

Examples:

- Google Search, 3 pages with AI Overview: 3 + 2 + 2 + 2 = 9 credits async.
- Google Search, 10 pages with AI Overview: 23 credits async.
- Sync ChatGPT with `include.shopping` and `state`: 5 + 2 + 2 + 2 = 11 credits.

`include.html` and `include.markdown` are free on all surfaces. Read `X-Credits-Charged` (sync) or `creditsCharged` (async) for the exact charge.

## Plans

- Free tier: 500 credits each month, 1 concurrent request, all endpoints. No card.
- Paid plans are monthly subscriptions with more credits and more concurrency. There is no pay-as-you-go.
- Credits expire at the end of each billing cycle. They do not roll over.
- Prices: <https://cloro.dev/pricing/>.

## Balance

- `X-Credits-Remaining` on each charged sync response.
- `GET /v1/credits` at any time, also for async-only workloads.
- A request or task with not enough credits gets `403 INSUFFICIENT_CREDITS`.
