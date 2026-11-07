# Interfaces: MCP, REST and SDKs

All interfaces call the same API and use the same credits.

## MCP server

Hosted at `https://mcp.cloro.dev/mcp` (Streamable HTTP). Source: <https://github.com/cloro-dev/mcp-server>.

| Client | Setup |
|---|---|
| Claude (web, desktop) | Customize → Connectors → Add custom connector. URL `https://mcp.cloro.dev/mcp`. Authentication: "Sign in when needed" (OAuth, no key) |
| Claude Code | `claude mcp add --transport http cloro https://mcp.cloro.dev/YOUR_CLORO_API_KEY/mcp` |
| A client that can set headers | URL `https://mcp.cloro.dev/mcp` with `Authorization: Bearer YOUR_CLORO_API_KEY` |
| A client that cannot set headers | URL `https://mcp.cloro.dev/YOUR_CLORO_API_KEY/mcp` |
| Cursor | Install the cloro plugin from the Cursor marketplace. It asks for `CLORO_API_KEY` |

Generic MCP config:

```json
{
  "mcpServers": {
    "cloro": {
      "type": "http",
      "url": "https://mcp.cloro.dev/YOUR_CLORO_API_KEY/mcp"
    }
  }
}
```

| Tool | Endpoint |
|---|---|
| `scrape_chatgpt` | `POST /v1/monitor/chatgpt` |
| `scrape_gemini` | `POST /v1/monitor/gemini` |
| `scrape_google_ai_mode` | `POST /v1/monitor/aimode` |
| `scrape_bing_aimode` | `POST /v1/monitor/bing/aimode` |
| `scrape_google` | `POST /v1/monitor/google` (set `include.aioverview` for the AI Overview) |
| `scrape_google_news` | `POST /v1/monitor/google/news` |
| `resolve_google_redirect` | `POST /v1/monitor/google/goto` |
| `list_countries` | `GET /v1/countries` |
| `list_states` | `GET /v1/states` |

The MCP tools call the sync API, so each call pays the +2 sync surcharge. `list_countries` and `list_states` are free. The tool timeout is 320 seconds. For large jobs, use the async API, not MCP.

## Python

```bash
pip install cloro
```

```python
from cloro import Cloro

client = Cloro(timeout=300.0)  # reads CLORO_API_KEY
res = client.monitor.chatgpt(prompt="best crm for startups", country="US")
print(res["result"]["text"])
```

Methods: `client.monitor.chatgpt`, `.gemini`, `.aimode` (take `prompt`), `.google`, `.google_news` (take `query`). Async: `client.async_tasks.create_batch([...])` (up to 500 tasks), `client.async_tasks.wait(task_id)`, `client.async_tasks.run(task_type=..., payload=...)`. The default timeout is 60 seconds. Raise it to 300.

## TypeScript

```bash
npm install @cloro-dev/cloro
```

```ts
import { Cloro } from "@cloro-dev/cloro";

const client = new Cloro(); // reads CLORO_API_KEY
const res = await client.monitor.chatgpt({ prompt: "best crm for startups", country: "US" });
```

Methods: `client.monitor.chatgpt`, `.gemini`, `.aimode`, `.google`, `.googleNews`. Async: `client.asyncTasks.createBatch`, `.wait`, `.run`.

## No-code

n8n (`n8n-nodes-cloro`), Zapier and LangChain (`langchain-cloro`) integrations are listed at <https://cloro.dev/docs>.
