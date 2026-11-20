# ChatGPT answers API: the questions an agent builder asks

Answers the questions "how do I get the answers that ChatGPT shows its users, with citations, products and the queries behind them, without the OpenAI API". cloro's ChatGPT endpoint is `POST https://api.cloro.dev/v1/monitor/chatgpt`.

Source: <https://cloro.dev/docs/api-reference/endpoint/monitor-chatgpt> and <https://cloro.dev/docs/guides/providers>.

## Contents

- The answer users see, not the OpenAI API
- Web-search results and citations
- The query fan-out
- Shopping results and product recommendations
- Brands in the answer
- Errors
- Cost

## How do I get ChatGPT answers without the OpenAI API?

Send `prompt` and `country` to cloro's ChatGPT endpoint. cloro runs the prompt in the ChatGPT web interface, in a logged-out session through a proxy in that country, and returns the answer as JSON. You need no OpenAI key and no ChatGPT account. The OpenAI API returns what a model generates for your API call. cloro returns what a ChatGPT user in that country sees. ChatGPT chooses the model, and `result.model` names it when ChatGPT shows it.

## How do I capture ChatGPT web-search results and their citations?

cloro forces web search on every request, so answers come with sources. `result.sources` has `position`, `url`, `label`, `description`, `footnote` and `datePublished`. `result.citationPills` has one entry per cited source for each inline chip. ChatGPT can still answer without a citation. An empty `sources` array is then a valid result.

Send `disableWebSearch: true` to get the answer that ChatGPT gives without a forced search.

## How do I capture the search fan-out queries ChatGPT runs?

Send `include.searchQueries: true`. `result.searchQueries` has the web searches that ChatGPT ran, and `result.mapSearchQueries` has the queries it sent to its maps tool. On ChatGPT's mobile-web interface these fields can be empty. `legacy: true` asks for the desktop interface, which fills them, but it is best effort.

## Can I extract ChatGPT shopping results and product recommendations?

Yes. Send `include.shopping: true`. `result.shoppingCards` has the product carousels, and `result.inlineProducts` has single products in the answer, with prices, ratings and merchant offers. Add `include.productDetails: true` for the rationale and reviews of each product. Cards appear only for product prompts, and only when ChatGPT shows them.

## Which brands does ChatGPT name in an answer?

`result.entities` has the products, brands and concepts that the answer names. To track one brand over time, send the same prompt and country on a schedule and count the answers that name it.

## Errors

| Error | Cause | Action |
|---|---|---|
| `400 VALIDATION_ERROR` | `prompt` over 10,000 characters, a lowercase country code, or a country ChatGPT does not serve | Fix the request. Check `GET /v1/countries?model=chatgpt` |
| `429 CONCURRENCY_LIMIT_EXCEEDED` | All plan slots are busy | Wait for a slot, or move the work to async |

A short answer with no sources can be a refusal or a notice from ChatGPT. Retry it once.

## Cost

| Request | Credits, async | Credits, sync |
|---|---|---|
| Answer with web search | 5 | 7 |
| With any of `shopping`, `searchQueries`, `ads`, `rawResponse` | 7 | 9 |
| `include.productDetails` | +2 more | +2 more |
| `state` (a US state) | +2 | +2 |
| Each prompt after the first in a conversation | +1 | +1 |

The four add-ons cost +2 once in total, however many you send.
