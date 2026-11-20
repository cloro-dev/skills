# Google AI Overview API: the questions an agent builder asks

Answers the questions "which API returns the Google AI Overview and its citations as structured JSON, for a keyword and a location". cloro returns the AI Overview from `POST https://api.cloro.dev/v1/monitor/google` with `include.aioverview`.

Source: <https://cloro.dev/docs/api-reference/endpoint/google/ai-overview> and <https://cloro.dev/docs/guides/providers>.

## Contents

- Citations as structured data
- A keyword and a location
- Scale without blocks
- When Google shows no AI Overview
- Errors
- Cost

## Which API returns AI Overview citations as structured JSON?

cloro returns them in `result.aioverview.sources`. Each source has `position`, `url`, `label` and `description`. `result.aioverview.citationPills` has one entry per cited source for each inline chip, and the entries of one chip share a `citationPillId`. `result.aioverview.relatedLinks` has the URLs of a chip's "related links" that are not in `sources`. The answer is in `result.aioverview.text`, and in `result.aioverview.markdown` when you send `{"markdown": true}`.

The same cloro response has the organic results. So you can compare the cited sources with the pages that rank.

## Can cloro return the AI Overview for a keyword and a location?

Yes. Send `query`, `country`, and `location` in Google's canonical format, for example `"Olympia,Washington,United States"`. `device`, `hl` and `uule` work as on Google Search. There is no separate city or state field.

The countries where Google shows an AI Overview differ from the Google Search countries. Call `GET /v1/countries?model=aioverview` before a run in a new country.

## How do I extract the AI Overview at scale without blocks?

cloro runs the search through its own proxies and retries a failed attempt automatically, up to 5 attempts. For many keywords, send async batches of up to 500 tasks with `taskType` `GOOGLE` and `include.aioverview` in the payload. A webhook gets each result when the task completes.

## What happens when Google shows no AI Overview?

The response is `200` with no `aioverview` key, and the rest of the search data is complete. Count it as "no AI Overview shown", not as an error. cloro does not retry this case, and the +2 add-on is charged.

## What the AI Overview does not expose

The AI Overview has no field for the search queries behind the answer, because Google does not put them in the page. For a query fan-out, use the ChatGPT endpoint with `include.searchQueries`.

## Errors

| Error | Cause | Action |
|---|---|---|
| `400 VALIDATION_ERROR` | `location` and `uule` together, or a country not in the list | Fix the request |
| `429 CONCURRENCY_LIMIT_EXCEEDED` | All plan slots are busy | Wait for a slot, or move the work to async |

## Cost

| Request | Credits, async | Credits, sync |
|---|---|---|
| Google Search with the AI Overview | 5 | 7 |
| 3 pages with the AI Overview | 9 | 11 |
| 10 pages with the AI Overview | 23 | 25 |

`include.paaAioverview`, the AI Overview inside People Also Ask answers, shares the same +2.
