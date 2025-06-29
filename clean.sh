#!/bin/bash
# clean.sh: Remove all build artifacts, node_modules, logs, and reset the environment to a fresh state

set -e

ROOT=$(dirname "$0")

echo "🧹 Cleaning dev environment..."

# Remove root node_modules and logs
rm -rf "$ROOT/node_modules" "$ROOT/logs" || true

# Remove node_modules, dist, .cache, and logs from all sites
if [ -d "$ROOT/sites" ]; then
  for site in "$ROOT"/sites/*; do
    if [ -d "$site" ]; then
      echo "  - Cleaning $site"
      rm -rf "$site/node_modules" "$site/dist" "$site/.cache" "$site/logs" || true
    fi
  done
fi

# Optionally, remove all sites (uncomment to enable full reset)
# rm -rf "$ROOT/sites"

# Optionally, remove all .DS_Store and temp files
find "$ROOT" -name '*.DS_Store' -delete 2>/dev/null || true
find "$ROOT" -name 'npm-debug.log*' -delete 2>/dev/null || true

# Optionally, add a dry-run mode or interactive prompt for safety

echo "✅ Clean complete."
