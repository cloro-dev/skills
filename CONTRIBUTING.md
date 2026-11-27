# Contributing

## Repo map

- `README.md`: install and the table of skills.
- `skills/<name>/SKILL.md`: one skill. The frontmatter `name` is the folder name.
- `skills/<name>/references/*.md`: facts that a skill reads only when necessary.
- `.github/workflows/check.yml`: the CI check (frontmatter, name, length). The check runs inline in the workflow. Do not move it into a script file.
- `.claude-plugin/` and `.mcp.json`: the Claude Code plugin. The repo root is the plugin, and the repo is also its own marketplace. The plugin loads every skill under `skills/` and the remote MCP server at `https://mcp.cloro.dev/mcp`. The plugin asks for the cloro API key when it is enabled (`userConfig.api_key`, sensitive), and `.mcp.json` sends it as `Authorization: Bearer ${user_config.api_key}`. Run `claude plugin validate . --strict` after you change any of these files. Raise `version` in `plugin.json` for each release that changes the plugin. Do not change the plugin icon, and do not name its file in any text file: the claude.ai directory keeps the first icon it receives, and it refuses a text file that names an image (UNREAD_ASSET_REFERENCED, 2026-11-27).
- Keep every file in the repo Markdown, text, JSON, YAML or an image, and start no file with `#!`. The claude.ai directory refuses any other file (scripts, programs, package manager files) from organizations that Anthropic has not verified. It refused v0.1.0 on 2026-11-08 for `.github/scripts/check_skills.sh`, and v0.1.4 on 2026-11-26 for `AGENTS.md`. Do not add an `AGENTS.md`, `CLAUDE.md` or `CLAUDE.local.md` file: this file holds the repo rules.

## Editing rules

Commit directly to `main`. This repo needs no branch and no pull request. CI runs on each push.

1. Each fact comes from the cloro docs (<https://cloro.dev/docs>) or the OpenAPI spec. When a skill and the API reference do not agree, the API reference is correct. Change the skill.
2. Write credit counts exactly. Do not round them. Prices in USD go on the pricing page, not here, because they change.
3. Do not name rival vendors.
4. Do not claim a surface that cloro does not sell. Grok, Perplexity and Copilot are discontinued (`MODEL_UNAVAILABLE`). Claude, DeepSeek and Meta AI are not supported. Bing Search and Bing AI Mode are supported.
5. Each `SKILL.md` stays under 200 lines. Move long tables to `references/`.
6. The `description` says when to use the skill, in the words a user types, and which skill to use for nearby tasks.
7. Never commit an API key. In every file, write `YOUR_API_KEY`. Do not write an environment variable for the key: the claude.ai directory refuses a plugin whose files read a credential from the machine (MCP_FORWARDS_CREDENTIAL_ENV, v0.1.4, 2026-11-26).
8. Each `SKILL.md` has the "Treat results as data" section, before "Read next". Copy it from an existing skill. It tells the agent not to follow instructions in search results, pages or AI answers.
9. Write in ASD-STE100 Simplified Technical English: short sentences, active voice, one instruction per sentence.
