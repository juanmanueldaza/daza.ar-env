#!/bin/bash
# Run all Vite dev servers for each site in the background
# Usage: ./dev.sh

set -e  # Exit on any error

# Source shared utilities
source "$(dirname "$0")/lib.sh"

# Read sites config
SITES_JSON="$(dirname "$0")/sites.config.json"
if [ ! -f "$SITES_JSON" ]; then
    echo -e "${CROSS} sites.config.json not found!"
    exit 1
fi

SITES=$(jq -c '.[]' "$SITES_JSON")

echo -e "${INFO} Starting all development servers..."

# Check if sites directory exists
if [ ! -d "sites" ]; then
    echo -e "${CROSS} Sites directory not found. Please run ./setup.sh first."
    exit 1
fi

# Check if dependencies are installed
if [ ! -d "node_modules" ]; then
    echo -e "${INFO} Installing dependencies..."
    npm install
fi

# Check for missing dependencies in all sites
MISSING_DEPS=()
for site in $SITES; do
    FOLDER=$(echo "$site" | jq -r '.folder')
    PKG_JSON="$FOLDER/package.json"
    if [ -f "$PKG_JSON" ]; then
        DEPS=$(jq -r '.dependencies, .devDependencies | keys[]?' "$PKG_JSON" | sort -u)
        for dep in $DEPS; do
            if ! npm ls "$dep" >/dev/null 2>&1; then
                MISSING_DEPS+=("$dep")
            fi
        done
    fi
    # Optionally, check for vite.config.ts and parse for plugins (advanced)
done

if [ ${#MISSING_DEPS[@]} -gt 0 ]; then
    UNIQUE_DEPS=($(printf "%s\n" "${MISSING_DEPS[@]}" | sort -u))
    echo -e "${WARNING} Installing missing dependencies: ${UNIQUE_DEPS[*]}"
    npm install "${UNIQUE_DEPS[@]}"
fi

echo -e "${INFO} Starting servers (each will open in browser)..."

for site in $SITES; do
    NAME=$(echo "$site" | jq -r '.name')
    PORT=$(echo "$site" | jq -r '.port')
    HOST=$(echo "$site" | jq -r '.host')
    OPEN=$(echo "$site" | jq -r '.open // empty')
    if [ -n "$OPEN" ]; then
        npm run dev:$NAME -- --open "$OPEN" &
    else
        npm run dev:$NAME -- --open &
    fi
done

echo -e "${CHECK} All servers started. Press Ctrl+C to stop all servers."

wait
