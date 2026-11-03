# SERP features

Source: <https://cloro.dev/docs/api-reference/endpoint/monitor-google> and its sub-pages. The OpenAPI schema lists every field.

All features below are in the base price. A feature that Google did not show is absent from `result`.

| Feature | Key | Main fields |
|---|---|---|
| Organic results | `organicResults` | `position`, `title`, `link`, `displayedLink`, `snippet`, `date`, `page`, `sitelinks`, `redirectLink` |
| People Also Ask | `peopleAlsoAsk` | `question`, `type`, `snippet`, `title`, `link`, `markdown`, `sources`, `page` |
| People Are Saying | `peopleAreSaying` | Forum and social posts that Google shows |
| Local pack | `localResults` | `position`, `title`, `placeId`, `cid`, `rating`, `reviews`, `price`, `type`, `address`, `phone`, `hours`, `links` |
| Shopping cards | `shoppingCards` | `title`, `position`, `price`, `oldPrice`, `store`, `rating`, `reviews`, `thumbnail`, `productResultToken` |
| Product results | `productResults` | The right-rail product panel with merchant offers |
| Sponsored ads | `ads` | `position`, `blockPosition`, `type`, `title`, `url`, `displayedUrl`, `domain`, `description`, `sitelinks` |
| Related searches | `relatedSearches` | `query`, `link` |
| Knowledge graph | `knowledgeGraph` | `title`, `type`, `description`, `website`, `attributes`, `profiles`, `ratings` |
| Recipes | `recipes` | Recipe cards |
| AI Overview | `aioverview` | Only with `include.aioverview`. See the `google-ai-overview` skill |

## Product panel

A shopping card has a `productResultToken`. Send it to `POST /v1/monitor/google/product` to get the product panel: merchant offers and description. It costs 1 credit (plus the sync surcharge) and is charged only on success. The token expires after five minutes (`410`).

## Redirect links

Google can serve a result as a `google.com/goto` URL. Then `link` can be empty and `redirectLink` holds the `goto` URL. Send it to `POST /v1/monitor/google/goto` to get the destination. It costs 1 credit, with no sync surcharge. A link that does not resolve returns `502 EXTERNAL_SERVICE_ERROR`.

## Raw HTML

`include.html: true` returns `result.html`, an array of URLs, one per scraped page. It is free. Each URL expires after 24 hours, so download the HTML at once if you keep it.
