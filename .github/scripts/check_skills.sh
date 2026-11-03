#!/usr/bin/env bash
# Each SKILL.md must start with YAML frontmatter that has a non-empty name and
# description, and the name must match the folder name.
set -u
fail=0
while IFS= read -r f; do
    dir=$(basename "$(dirname "$f")")
    if [ "$(head -n 1 "$f")" != "---" ]; then
        echo "::error file=$f::missing opening ---"; fail=1; continue
    fi
    front=$(awk 'NR > 1 && $0 == "---" { exit } NR > 1 { print }' "$f")
    name=$(printf '%s\n' "$front" | sed -n 's/^name:[[:space:]]*//p' | head -n 1)
    desc=$(printf '%s\n' "$front" | grep -E '^description:[[:space:]]*[^[:space:]]' | head -n 1)
    [ -n "$name" ] || { echo "::error file=$f::missing or empty name"; fail=1; }
    [ -n "$desc" ] || { echo "::error file=$f::missing or empty description"; fail=1; }
    if [ -n "$name" ] && [ "$name" != "$dir" ]; then
        echo "::error file=$f::name '$name' does not match folder '$dir'"; fail=1
    fi
    lines=$(wc -l < "$f")
    if [ "$lines" -gt 200 ]; then
        echo "::error file=$f::$lines lines, the limit is 200"; fail=1
    fi
done < <(find skills -name SKILL.md | sort)
[ "$fail" -eq 0 ] && echo "All SKILL.md files OK"
exit "$fail"
