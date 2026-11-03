# Location, device, language and depth

Source: <https://cloro.dev/docs/api-reference/endpoint/monitor-google>.

## City or region

```json
{
  "query": "emergency plumber",
  "country": "US",
  "location": "New York,New York,United States"
}
```

`location` takes any Google canonical location name: a city, a state or a region (`"California,United States"`). Google lists about 100,000 locations at <https://developers.google.com/google-ads/api/reference/data/geotargets>.

If you have your own UULE strings, send `uule` instead of `location`. Do not send both.

## Device

```json
{ "query": "running shoes", "country": "GB", "device": "ios" }
```

| Value | SERP |
|---|---|
| `desktop` | Desktop (default) |
| `ios` | Mobile, Safari on iPhone |
| `android`, `mobile` | Mobile, Chrome on Android |

## Language

`hl` sets the interface language and can differ from the country. Example: a Portuguese-language SERP in the US is `"country": "US", "hl": "pt-BR"`.

## Depth

```json
{ "query": "project management software", "country": "US", "pages": 3 }
```

`pages` takes 1 to 10. Organic results, People Also Ask and related searches from all pages come back in one response. Each item has a `page` field. 10 pages give up to 100 organic results.

To drive pagination yourself, send a `url` with `start`. `start=20` with `num=30` returns ranks 21 to 50.

## Search by URL

```json
{ "url": "https://www.google.com/search?q=canon+ij+scanner+software&hl=en&gl=us&num=30" }
```

cloro reads `q` (required), `gl`, `hl`, `uule`, `num` and `start` from the URL. `num=30` becomes 3 pages and costs the same as `pages: 3`. Do not send `location`, `uule`, `pages`, `gl` or `hl` with a value that differs from the URL: the request fails with `400`. `device` and `include` stay at the top level.

## Country coverage

`GET /v1/countries?model=google` lists the countries for Google Search. The AI Overview has its own list: `model=aioverview`.
