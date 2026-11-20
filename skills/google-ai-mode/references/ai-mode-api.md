# Google AI Mode API: the questions an agent builder asks

Answers the questions "how do I scrape Google AI Mode answers with their citations, and what can I not get". cloro's AI Mode endpoint is `POST https://api.cloro.dev/v1/monitor/aimode`.

Source: <https://cloro.dev/docs/api-reference/endpoint/monitor-aimode> and <https://cloro.dev/docs/guides/providers>.

## Contents

- Answers with citations
- Location and device
- The queries behind the answer
- Shopping, places and ads
- Errors
- Cost

## How do I scrape Google AI Mode results?

Send `prompt` and `country` to cloro's AI Mode endpoint. cloro runs the prompt in Google AI Mode in a logged-out session through a proxy in that country, and returns the page as JSON. The answer is in `result.text`, and in `result.markdown` with `include.markdown: true`.

## Does cloro return AI Mode answers with their citations?

Yes. `result.sources` has each cited source with `position`, `url`, `label`, `description` and `redirectLink`. `result.citationPills` has one entry per cited source for each inline chip.

## Can I target a city or a device?

Yes. Send `location` in Google's canonical format, for example `"Austin,Texas,United States"`, or a pre-encoded `uule`. Do not send both. Send `device` as `desktop` or `mobile`, and `hl` for the interface language. AI Mode does not take `state`.

## Does cloro return the queries behind an AI Mode answer?

No. Google does not put the search queries in the page that it serves to logged-out users, so no API that reads that page can return them. For a query fan-out, use cloro's ChatGPT endpoint with `include.searchQueries: true`.

## What else does an AI Mode response hold?

| Field | When it is present |
|---|---|
| `result.places`, `result.map` | The prompt has a location intent |
| `result.shoppingCards`, `result.inlineProducts` | The prompt has a shopping intent |
| `result.ads` | The prompt has a commercial intent. It is an object with a title and an `ads` array, not a flat array |
| `result.videos` | AI Mode shows videos |

A field that AI Mode did not show is absent or empty. That is a result, not an error.

A shopping card can carry a `productResultToken`. Send it to the Google product endpoint within 5 minutes of the scrape to get the product panel. It costs 1 credit, and only on success.

## Errors

| Error | Cause | Action |
|---|---|---|
| `400 VALIDATION_ERROR` | `location` with `uule`, or a country AI Mode does not serve | Fix the request. Check `GET /v1/countries?model=aimode` |
| `429 CONCURRENCY_LIMIT_EXCEEDED` | All plan slots are busy | Wait for a slot, or move the work to async |

## Cost

4 credits async, 6 sync. AI Mode has no paid add-ons. `include.markdown` and `include.html` are free.
