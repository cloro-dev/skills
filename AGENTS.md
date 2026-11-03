# AGENTS.md

## Repo map

- `README.md`: install and the table of skills.
- `skills/<name>/SKILL.md`: one skill. The frontmatter `name` is the folder name.
- `skills/<name>/references/*.md`: facts that a skill reads only when necessary.
- `.github/scripts/check_skills.sh`: the CI check (frontmatter, name, length).

## Editing rules

1. Each fact comes from the cloro docs (<https://cloro.dev/docs>) or the OpenAPI spec. When a skill and the API reference do not agree, the API reference is correct. Change the skill.
2. Write credit counts exactly. Do not round them. Prices in USD go on the pricing page, not here, because they change.
3. Do not name rival vendors.
4. Do not claim a surface that cloro does not sell. Grok is discontinued (`MODEL_UNAVAILABLE`). Bing, Claude, DeepSeek and Meta AI are not supported.
5. Each `SKILL.md` stays under 200 lines. Move long tables to `references/`.
6. The `description` says when to use the skill, in the words a user types, and which skill to use for nearby tasks.
7. Never commit an API key. Use `CLORO_API_KEY` or `YOUR_API_KEY`.
8. Write in ASD-STE100 Simplified Technical English: short sentences, active voice, one instruction per sentence.
