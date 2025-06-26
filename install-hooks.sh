#!/bin/bash
# Simple pre-commit hook installer - no extra dependencies needed
# Usage: ./install-hooks.sh

HOOK_FILE=".git/hooks/pre-commit"

if [ ! -d ".git" ]; then
    echo "❌ Not a git repository"
    exit 1
fi

echo "🪝 Installing pre-commit hook..."

cat > "$HOOK_FILE" << 'EOF'
#!/bin/bash
# Pre-commit hook for daza.ar-env
echo "🔍 Running linting and formatting checks..."

# Run linting on root files
echo "📋 Checking root JavaScript files..."
if ! npm run lint:root --silent; then
    echo "❌ ESLint failed on root files. Please fix the issues or run 'npm run lint:fix'"
    exit 1
fi

# Check formatting on root files
echo "🎨 Checking code formatting..."
if ! npm run format:check --silent 2>/dev/null; then
    echo "❌ Code formatting check failed. Please run 'npm run format'"
    exit 1
fi

echo "✅ All pre-commit checks passed!"
EOF

chmod +x "$HOOK_FILE"
echo "✅ Pre-commit hook installed successfully!"
echo ""
echo "💡 Quick commands to fix issues:"
echo "   - Fix linting: npm run lint:fix"
echo "   - Fix formatting: npm run format"
echo ""
echo "🔧 The hook will now run automatically before each commit."
