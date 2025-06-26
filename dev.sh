#!/bin/bash
# Run all Vite dev servers for each site in the background
# Usage: ./dev.sh

set -e  # Exit on any error

echo "🚀 Starting all development servers..."

# Check if sites directory exists
if [ ! -d "sites" ]; then
    echo "❌ Sites directory not found. Please run ./setup.sh first."
    exit 1
fi

# Check if dependencies are installed
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
fi

echo "🌐 Starting servers (each will open in browser)..."

npm run dev:cv -- --open &
npm run dev:onepager -- --open &
npm run dev:start -- --open &
npm run dev:navbar -- --open &
npm run dev:mdsite -- --open &
npm run dev:data -- --open &
npm run dev:wallpapers -- --open &

echo "✅ All servers started. Press Ctrl+C to stop all servers."

wait
