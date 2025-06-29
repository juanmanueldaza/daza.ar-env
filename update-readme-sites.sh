#!/bin/bash
# update-readme-sites.sh: Update README.md with current sites, ports, and URLs from sites.config.json

set -e

SITES_JSON="$(dirname "$0")/sites.config.json"
README="$(dirname "$0")/README.md"

if ! command -v jq >/dev/null 2>&1; then
  echo "jq is required. Please install jq."
  exit 1
fi

if [ ! -f "$SITES_JSON" ]; then
  echo "sites.config.json not found!"
  exit 1
fi
if [ ! -f "$README" ]; then
  echo "README.md not found!"
  exit 1
fi

# Generate markdown table
TABLE="| Site | Port | URL |\n|------|------|-----|\n"
for row in $(jq -c '.[]' "$SITES_JSON"); do
  NAME=$(echo "$row" | jq -r '.name')
  PORT=$(echo "$row" | jq -r '.port')
  URL=$(echo "$row" | jq -r '.url // ("http://" + .host + ":" + (.port|tostring))')
  TABLE+="| $NAME | $PORT | $URL |\n"
done

# Markers for auto-generated section
START_MARKER="<!-- SITES_TABLE_START -->"
END_MARKER="<!-- SITES_TABLE_END -->"

# If markers not present, add them after the first heading
if ! grep -q "$START_MARKER" "$README"; then
  sed -i "/^# /a \
$START_MARKER\n$END_MARKER" "$README"
fi

# Replace content between markers
awk -v table="$TABLE" -v start="$START_MARKER" -v end="$END_MARKER" '
  BEGIN {inblock=0}
  {if ($0 ~ start) {print; print table; inblock=1; next} else if ($0 ~ end) {inblock=0}}
  !inblock {print}
' "$README" > "$README.tmp" && mv "$README.tmp" "$README"

echo "README.md updated with current sites table."
