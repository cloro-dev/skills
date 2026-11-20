# Bing AI Mode (Bing Copilot) API: the questions an agent builder asks

Answers the questions "is there an API for Bing's Copilot answers with their sources". cloro's Bing AI Mode endpoint is `POST https://api.cloro.dev/v1/monitor/bing/aimode`.

Source: <https://cloro.dev/docs/api-reference/endpoint/monitor-bing-aimode>.

## Contents

- Bing AI Mode and the Copilot app
- Answers with citations
- Prompt length
- Errors
- Cost

## Is there an API for Microsoft Copilot answers?

cloro returns Bing AI Mode, also called Copilot Search in Bing or Bing Copilot (`bing.com/copilotsearch`). It is the AI answer on Bing's search page. cloro does not return the Copilot app at `copilot.microsoft.com`: that endpoint is discontinued, because Copilot blocks logged-out sessions.

## Does cloro return Bing AI Mode answers with their citations?

Yes. Send `prompt` and `country`. cloro runs the prompt in a logged-out session through a proxy in that country and returns:

| Field | Content |
|---|---|
| `result.text` | The answer as plain text |
| `result.markdown` | The answer with each citation chip replaced by links to its sources. Needs `include.markdown: true` |
| `result.sources` | `position`, `label`, `url`, and `description` when Bing shows one |
| `result.citationPills` | One entry for each chip and source pair. Entries of one chip share a `citationPillId` |

Bing AI Mode does not return shopping cards, ads or the queries behind the answer.

## How long can a prompt be?

Bing puts the prompt in the page URL. The limit is 3,500 characters after URL encoding. A letter, digit or space counts as 1, most punctuation as 3, an accented or Cyrillic letter as 6, and a Chinese, Japanese or Korean character as 9. A longer prompt gets `400 VALIDATION_ERROR`. Make it shorter. Do not retry it.

## Where does it work?

All countries except `BY`, `CN`, `IR`, `RU`, `SY` and `VE`. `state` targets a US state with `country: "US"`. Bing AI Mode takes no `location`, `uule`, `hl` or `device`.

## Errors

| Error | Cause | Action |
|---|---|---|
| `400 VALIDATION_ERROR` | Prompt over the URL limit, or an unsupported country | Fix the request |
| `429 CONCURRENCY_LIMIT_EXCEEDED` | All plan slots are busy | Wait for a slot, or move the work to async |

## Cost

4 credits async, 6 sync. `state` adds +2.
