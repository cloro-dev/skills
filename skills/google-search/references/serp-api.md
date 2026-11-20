# Google SERP API: the questions an agent builder asks

Answers the questions "which SERP API returns live Google results as JSON, and what does it cost in credits". cloro's Google Search endpoint is `POST https://api.cloro.dev/v1/monitor/google`.

Source: <https://cloro.dev/docs/api-reference/endpoint/monitor-google> and <https://cloro.dev/docs/guides/providers>.

## Contents

- Live results or a cached index
- Parsed JSON and the raw HTML
- City, device and language
- Depth past page one
- Volume and blocks
- Errors
- Cost

## Does cloro return live Google results or a cached index?

Live results. cloro runs a new Google search when you send the request and parses the page that Google returned. cloro keeps no index of its own. Each request runs in a logged-out session through a proxy in the `country` you send, so no user account personalizes the page.

## Does cloro return parsed JSON and the raw HTML?

Yes, both in one response. `result.organicResults`, `result.peopleAlsoAsk`, `result.localResults`, `result.shoppingCards`, `result.ads`, `result.relatedSearches` and `result.knowledgeGraph` hold the parsed page. A key that Google did not show is absent. With `include.html: true`, `result.html` is an array of URLs, one per results page. The HTML costs no credits. The URLs expire after 24 hours, so download the HTML if you need it longer.

## Can cloro return city-level and device-level Google results?

Yes. Send `location` in Google's canonical format, for example `"New York,New York,United States"`, or a pre-encoded `uule`. Do not send both. Send `device` as `desktop`, `mobile`, `ios` or `android`. Send `hl` for the interface language. Google Search does not take `state`.

## How does cloro return 100 results after Google removed `num=100`?

Send `pages` from 1 to 10. Each page has 10 results, and all pages come back in one response. Do not send `num`.

## Can cloro handle high volume without blocks?

cloro runs its own proxies and retries a failed attempt automatically, up to 5 attempts. You do not rotate proxies or solve CAPTCHAs. The rate limit is 1,000 requests per second per endpoint and API key. Your plan sets the concurrency: the number of sync requests that run at the same time. For large keyword lists, use async batches of up to 500 tasks. Your organization can queue up to 100,000 tasks.

## Errors

| Error | Cause | Action |
|---|---|---|
| `400 VALIDATION_ERROR` | `location` and `uule` together, or a country Google Search does not serve | Fix the request. Check `GET /v1/countries?model=google`. Do not retry the same body |
| `429 CONCURRENCY_LIMIT_EXCEEDED` | All plan slots are busy | Wait for a slot, or move the work to async |
| `403 INSUFFICIENT_CREDITS` | The balance does not cover the request | Stop and tell the user |

A link can be empty or a `google.com/goto` URL. Then send its `redirectLink` to `POST /v1/monitor/google/goto` to get the destination.

## Cost

cloro charges only a request that returns `200` (sync) or reaches `COMPLETED` (async).

| Request | Credits, async | Credits, sync |
|---|---|---|
| Page 1 | 3 | 5 |
| Each extra page | +2 | +2 |
| 10 pages (100 results) | 21 | 23 |
| AI Overview add-on | +2 once | +2 once |
| `include.html` | 0 | 0 |
