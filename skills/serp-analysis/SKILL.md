---
name: serp-analysis
description: 'Use to analyze the Google results page for a keyword before you write or change a page: "analyze the SERP for", "what ranks for this keyword", "search intent", "what content type does Google want", "who are my search competitors for", "what does the AI Overview cite", "can we rank for this", or a content brief from the SERP. It reads the live results and gives the intent, the SERP features, the ranking domains and page types, the AI Overview sources, the People Also Ask questions and a brief. For the raw results, use google-search. For thousands of keywords on a schedule, use serp-research. For AI answers from ChatGPT and other engines, use ai-seo-audit. For setup and errors, use cloro-api.'
license: MIT
metadata:
  author: cloro
  version: "0.1.0"
  docs: "https://cloro.dev/docs/api-reference/endpoint/monitor-google"
---

# SERP analysis

Read the live Google results page for a keyword, and say what it takes to rank there.

## Step 1: get the results

```bash
curl -X POST "https://api.cloro.dev/v1/monitor/google" \
  -H "Authorization: Bearer $CLORO_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"query": "best crm for startups", "country": "US", "include": {"aioverview": true}}'
```

MCP tool: `scrape_google`. Ask the user for the country and, for local intent, the city. Send the city as `location`, for example `"Austin,Texas,United States"`. Send `device: "ios"` to see the mobile page. One page has the top 10. Send `pages: 2` or `3` for more depth.

## Step 2: read the page

| Signal | Field | What it tells you |
|---|---|---|
| Ranking pages | `organicResults`: `position`, `link`, `title`, `snippet`, `date` | Who ranks and with which page type |
| AI Overview | `aioverview.text`, `aioverview.sources` | Google's answer, and the pages it cites |
| People Also Ask | `peopleAlsoAsk[].question` | The sub-questions that a page must answer |
| Related searches | `relatedSearches[].query` | Nearby keywords and the next pages to write |
| Ads | `ads` | Commercial value. Many ads means buyers search this term |
| Local pack | `localResults` | Local intent |
| Shopping | `shoppingCards`, `productResults` | Product intent |
| Knowledge graph | `knowledgeGraph` | An entity query |
| Forum posts | `peopleAreSaying` | Google wants first-hand experience |

A key that Google did not show is absent. Read keys with a default.

## Step 3: classify the intent

| The page shows | Intent |
|---|---|
| Shopping cards, product results, many ads | Transactional |
| Lists such as "best X", comparisons, reviews | Commercial investigation |
| An AI Overview, People Also Ask, guides, a knowledge graph | Informational |
| A local pack | Local |
| The brand's own site at position 1 | Navigational |

A page can have more than one intent. Name the main one, then the others.

## Step 4: classify the ranking pages

For each of the top 10 organic results, record the domain and the page type: list article, comparison, product or category page, homepage, guide, docs, forum thread, video or news. Use the title, the URL path and the snippet. If you are not sure, read the page.

The most common page type in the top 5 is the type that Google wants for this keyword. A page of another type rarely ranks there.

Also record:

- Dates. If most snippets have a date from the last few months, freshness matters.
- Domains that appear twice or more. They own this topic.
- AI Overview sources that are not in the top 10. Google trusts them for the answer, even without a top ranking.

## Step 5: check the user's position

If the user gives a domain, find its results in `organicResults` and in `aioverview.sources`. Report the position and the page. If the domain is not in the top 10, fetch 3 pages and report the first position. Compare the user's page with the top 3: the page type, the title, the questions it answers and the date.

## Step 6: write the brief

1. The keyword, country, device and date of the search.
2. The main intent and the page type to write.
3. The top 10: position, domain, page type.
4. The AI Overview: a summary, and the cited domains.
5. The questions to answer: from `peopleAlsoAsk` and the AI Overview.
6. The nearby keywords: from `relatedSearches`.
7. The user's position, if a domain was given, and the main gap to the top 3.

## Compare more than one results page

Run the same keyword with a different `device`, `location` or `country`, and compare the top 10 and the features. For a list of keywords, run them as one async batch with `taskType: "GOOGLE"`. See the `llm-answer-monitoring` skill for batches. For a daily rank tracker, use `serp-research`.

## Cost

One keyword with the AI Overview costs 5 credits async or 7 sync. Each page after the first adds 2. The MCP tool is sync. 3 pages with the AI Overview cost 11 credits sync.

## Red flags

- cloro returns the results page only. It does not return search volume, keyword difficulty or backlink data. If the user needs these, ask them to give the numbers from their SEO tool. Do not estimate them.
- Results change by country, city, device and day. Always say where and when the search ran.
- Do not send `num`. Use `pages`.
- Do not judge a keyword from one result. Read the whole top 10.

## Read next

- `google-search`: every parameter and field.
- `google-ai-overview`: the AI Overview fields.
- `serp-research`: many keywords on a schedule.
