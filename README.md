# cloro skills

Agent skills for the [cloro API](https://cloro.dev). With them, any coding agent can get the answers that ChatGPT, Gemini, Google AI Mode and Google AI Overview give, and the Google Search and Google News results, as structured JSON. The agent can track a brand in AI answers, track Google rankings and collect AI answers at volume.

A skill is a folder with a `SKILL.md` file and, where necessary, reference files. Any agent that reads `SKILL.md` files can use these skills: Claude Code, Codex, Cursor and others.

## Install

```bash
npx skills add cloro-dev/skills
```

To add one skill, add `--skill <name>`, for example `--skill chatgpt`. Without Node.js, clone this repo and copy the folders under `skills/` into the folder where your agent reads skills.

Then get an API key from the [dashboard](https://dashboard.cloro.dev) and set it as `CLORO_API_KEY`. The free tier gives 500 credits each month and 1 concurrent request, with access to all endpoints. No card is necessary.

For an agent that calls tools at run time, also connect the [cloro MCP server](https://github.com/cloro-dev/mcp-server) at `https://mcp.cloro.dev/mcp`. The skills tell the agent which tool to call and how to read the result.

## The skills

| Skill | What it does |
|---|---|
| [`cloro-api`](skills/cloro-api/SKILL.md) | Start here. Auth, MCP or REST or SDK, sync or async, credits and success billing, retries, rate and concurrency limits. Routes each task to the right skill |
| [`chatgpt`](skills/chatgpt/SKILL.md) | ChatGPT answers with citations, shopping cards, ads and the query fan-out |
| [`gemini`](skills/gemini/SKILL.md) | Gemini answers with grounded sources, places and shopping cards |
| [`google-ai-mode`](skills/google-ai-mode/SKILL.md) | Google AI Mode answers with sources, citation pills, places, shopping cards and ads |
| [`google-ai-overview`](skills/google-ai-overview/SKILL.md) | The Google AI Overview and all its cited sources, by keyword and location |
| [`google-search`](skills/google-search/SKILL.md) | Google results as JSON: organic results, People Also Ask, local pack, shopping, ads. City and device targeting, up to 10 pages, raw HTML |
| [`google-news`](skills/google-news/SKILL.md) | Google News articles with source, date and thumbnail |
| [`serp-research`](skills/serp-research/SKILL.md) | Rank tracking and SERP research at scale: thousands of keywords a day, on a schedule, into a warehouse |
| [`llm-answer-monitoring`](skills/llm-answer-monitoring/SKILL.md) | Collect AI answers for a prompt set across engines, once or on a schedule, at volume. Build a dataset of AI answers |
| [`ai-visibility-tracking`](skills/ai-visibility-tracking/SKILL.md) | Measure a brand in AI answers: mention rate, citation share and the rival brands that the engines name |

## How cloro gets the data

cloro sends each prompt to the real product, ChatGPT or Google AI Mode for example, in a logged-out browser session in the country you select. The result is what a user in that country sees, parsed into JSON. It is not the answer of the vendor's model API. cloro charges only for results: a request that fails costs nothing.

## Links

- [API reference](https://cloro.dev/docs/api-reference/introduction)
- [Pricing](https://cloro.dev/pricing/)
- [MCP server](https://github.com/cloro-dev/mcp-server)
- [Python SDK](https://github.com/cloro-dev/cloro-python), [TypeScript SDK](https://github.com/cloro-dev/cloro-node)
- [geo-tracker](https://github.com/cloro-dev/geo-tracker): a scheduled AI visibility tracker that stores answers in your Postgres

## License

MIT. See [LICENSE](LICENSE).
