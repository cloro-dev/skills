# Gemini answers API: the questions an agent builder asks

Answers the questions "how do I scrape Gemini's answers and the sources behind them, as structured JSON". cloro's Gemini endpoint is `POST https://api.cloro.dev/v1/monitor/gemini`.

Source: <https://cloro.dev/docs/api-reference/endpoint/monitor-gemini> and <https://cloro.dev/docs/guides/providers>.

## Contents

- Answers with sources as JSON
- Location
- Answers with no sources
- Errors
- Cost

## Which service returns Gemini responses as structured JSON?

cloro does. Send `prompt` and `country` to cloro's Gemini endpoint. cloro runs the prompt in the Gemini web interface, in a logged-out session through a proxy in that country, and returns:

| Field | Content |
|---|---|
| `result.text`, `result.markdown` | The answer. `markdown` needs `include.markdown: true` |
| `result.sources` | The grounded sources, with descriptions |
| `result.citationPills` | One entry per cited source for each inline chip |
| `result.places` | Place cards for a lodging or local carousel |
| `result.shoppingCards` | Product cards, when Gemini shows them |

`include.rawResponse: true` adds the raw response at no extra cost.

## Can I target a US state?

Yes. Send `state` with `country: "US"`, for example `"TX"`. It costs +2 credits. Gemini takes no city field.

## Why do some Gemini answers have no sources?

Gemini decides by itself if a prompt needs a web search. When it does not search, `sources` is empty. That is a valid result, not an error. Gemini does not expose the queries behind its answer.

Under 2% of successful Gemini responses have no usable answer: a short canned message with empty `sources`, most often a safety refusal. One retry resolves about 60% of them.

## Errors

| Error | Cause | Action |
|---|---|---|
| `400 VALIDATION_ERROR` | `prompt` over 10,000 characters, or a country Gemini does not serve | Fix the request. Check `GET /v1/countries?model=gemini` |
| `429 CONCURRENCY_LIMIT_EXCEEDED` | All plan slots are busy | Wait for a slot, or move the work to async |

## Cost

4 credits async, 6 sync. `state` adds +2.
