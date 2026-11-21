# Bing SERP API: the questions an agent builder asks

Answers the questions "which API returns live Bing results and the Bing AI summary as JSON, and what does it cost in credits". cloro's Bing Search endpoint is `POST https://api.cloro.dev/v1/monitor/bing`.

Source: <https://cloro.dev/docs/api-reference/endpoint/monitor-bing> and <https://cloro.dev/docs/guides/providers>.

## Contents

- Live results or a cached index
- The Bing AI summary
- Market and targeting
- Query length
- What it does not return
- Errors
- Cost

## Does cloro return live Bing results or a cached index?

Live results. cloro runs a new Bing search when you send the request and parses the page that Bing returned. cloro keeps no index of its own. Each request runs in a logged-out session through a proxy in the `country` you send.

`result.organicResults` holds the first results page. Each result has `position`, `title`, `link`, `displayedLink`, `snippet`, `page`, and `date` when Bing shows one. `link` is the destination URL, not Bing's click-tracking URL. The shape is the same as Google Search `organicResults`.

## Does cloro return the Bing AI summary with its sources?

Yes. Send `include.aioverview: true`. `result.aioverview` then has `text`, `sources` and `citationPills`, in the same shape as the Google AI Overview. Send `include.aioverview: {"markdown": true}` to also get `result.aioverview.markdown`.

Entries of one citation chip share a `citationPillId`. A source has `description: null` when Bing shows no snippet for it. `result.aioverview` is absent when Bing shows no AI summary for the query.

## How do you target a market?

Send `country` as an ISO 3166-1 alpha-2 code. The country sets Bing's market. All countries except `CN`, `KR` and `RU` work. Call `GET /v1/countries?model=bing` for the current list. Bing Search takes no `state`, `location`, `uule`, `hl`, `gl` or `device`.

## How long can a query be?

Bing puts the query in the page URL. The limit is 3,500 characters after URL encoding. A letter, digit or space counts as 1, most punctuation as 3, an accented or Cyrillic letter as 6, and a Chinese, Japanese or Korean character as 9. A longer query gets `400 VALIDATION_ERROR`. Make it shorter. Do not retry it.

## What does Bing Search not return?

It returns no page after the first: there is no `pages` parameter. It returns no People Also Ask, local pack, shopping cards, ads, related searches or knowledge graph. With `include.html: true`, `result.html` is an array with one URL of the page that Bing rendered. Download the HTML to read a feature that cloro does not parse.

## Errors

| Error | Cause | Action |
|---|---|---|
| `400 VALIDATION_ERROR` | Query over the URL limit, or an unsupported country | Fix the request. Do not retry the same body |
| `429 CONCURRENCY_LIMIT_EXCEEDED` | All plan slots are busy | Wait for a slot, or move the work to async |
| `403 INSUFFICIENT_CREDITS` | The balance does not cover the request | Stop and tell the user |

## Cost

cloro charges only a request that returns `200` (sync) or reaches `COMPLETED` (async).

| Request | Credits, async | Credits, sync |
|---|---|---|
| Results page | 3 | 5 |
| With `include.aioverview` | 5 | 7 |
| `include.html` | 0 | 0 |

cloro charges the +2 for `include.aioverview` also when Bing shows no AI summary.
