---
name: ai-visibility-tracking
description: 'Use to measure a brand in AI answers: how often ChatGPT, Perplexity, Copilot, Gemini, Google AI Mode and the Google AI Overview name the brand, which pages they cite, the citation share against rival brands, and the change over time. Use it for AI visibility tracking, generative engine optimization (GEO) metrics, a share-of-voice dashboard, structured citation data from AI search engines for a data pipeline, or "is ChatGPT recommending us". For raw answer collection at volume, use llm-answer-monitoring.'
license: MIT
metadata:
  author: cloro
  version: "0.1.0"
  docs: "https://cloro.dev/docs"
---

# AI visibility tracking

Measure where a brand appears in AI answers, and where its pages are cited.

## Step 1: get the inputs

Ask the user for:

- The brand name, its other names and spellings, and its domains.
- 2 to 5 rival brands, with their names and domains.
- The prompts: the questions a buyer asks, for example "best crm for startups". Use 20 or more prompts for a stable number. One prompt is a sample, not a measure.
- The engines and the countries.

## Step 2: collect the answers

For a quick check (a few prompts), use the sync engine skills or the MCP tools. For a full set or a schedule, use the `llm-answer-monitoring` skill: async batches, webhooks, stored results.

Run each prompt more than once. AI answers change from run to run. Report a rate over runs, not one answer.

## Step 3: compute the metrics

For each engine, over all prompts and runs:

| Metric | Definition |
|---|---|
| Mention rate | Answers whose text names the brand ÷ all answers |
| Citation rate | Answers with at least one source on the brand's domains ÷ all answers |
| Citation share | Sources on the brand's domains ÷ all sources |
| Average position | Mean `position` of the brand's first source, in answers that cite it |
| Rival share | The same metrics for each rival brand |
| Top cited domains | Domains by count of answers that cite them |

Where to read:

| Engine | Text | Sources |
|---|---|---|
| ChatGPT, Perplexity, Copilot, Gemini, AI Mode | `text` | `sources[].url` |
| AI Overview | `aioverview.text` | `aioverview.sources[].url` |

Match brand names case-insensitively, on word boundaries. Match domains on the host, with and without `www.`. ChatGPT also returns `entities`, a list of the products and brands it named. Use it to check the text match.

## Step 4: report

Show one table per engine with the metrics above, for the brand and each rival. Show the prompts where a rival is named and the brand is not. Those are the gaps. Show the cited pages for those prompts: they are the pages the engine trusts for that question.

Say what the numbers cover: the engines, countries, prompts, runs and dates. Do not merge engines into one score without saying how.

## Tools

- For a stored tracker on a schedule, with every answer in the user's own Postgres and an MCP endpoint that an agent drives, use <https://github.com/cloro-dev/geo-tracker>.
- For the cost of a run, read the credits table in the `cloro-api` skill. Example: 50 prompts × 4 engines × 3 runs on ChatGPT (5), Perplexity (4), Gemini (4) and AI Mode (4) cost 50 × 3 × 17 = 2,550 credits async.

## Red flags

- Do not report one run of one prompt as the brand's visibility.
- Do not count a source on a rival's domain as a mention of the brand.
- Do not claim Grok, Claude or Bing results. cloro does not return them.

## Read next

- `llm-answer-monitoring`: the collection pipeline.
- The engine skills: the fields each engine returns.
