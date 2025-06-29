#!/bin/bash

# Setup script for daza.ar environment
# Creates sites folder and clones required repositories
# Usage: ./setup.sh [--hosts-only]

set -e  # Exit on any error

# Source shared utilities
source "$(dirname "$0")/lib.sh"

# Parse command line arguments
HOSTS_ONLY=false
if [[ "$1" == "--hosts-only" ]]; then
    HOSTS_ONLY=true
fi

# Function to check prerequisites
check_prerequisites() {
    local missing_tools=()

    if ! command_exists gh; then
        missing_tools+=("GitHub CLI (gh)")
    fi

    if ! command_exists git; then
        missing_tools+=("Git")
    fi

    if ! command_exists node; then
        missing_tools+=("Node.js")
    fi

    if [ ${#missing_tools[@]} -gt 0 ]; then
        echo -e "${CROSS} Missing required tools:"
        for tool in "${missing_tools[@]}"; do
            echo "   - $tool"
        done
        echo ""
        echo "Please install the missing tools and try again."
        echo "See README.md for installation instructions."
        exit 1
    fi

    # Check GitHub CLI authentication
    if ! gh auth status &> /dev/null; then
        echo -e "${CROSS} GitHub CLI not authenticated."
        echo "Please run: gh auth login"
        exit 1
    fi
}

# Function to setup /etc/hosts domains
setup_hosts() {
    echo "🔗 Checking /etc/hosts for custom .local domains..."
    local SITES=(cv onepager data wallpapers start navbar mdsite)
    local MISSING=()

    for SITE in "${SITES[@]}"; do
        local DOMAIN="$SITE.local"
        if ! grep -q "$DOMAIN" /etc/hosts 2>/dev/null; then
            MISSING+=("$DOMAIN")
        fi
    done

    if [ ${#MISSING[@]} -gt 0 ]; then
        echo "The following domains are missing from /etc/hosts:"
        for DOMAIN in "${MISSING[@]}"; do
            echo "  127.0.0.1   $DOMAIN"
        done
        echo "Add them now? (requires sudo) [y/N]"
        read -r REPLY
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            for DOMAIN in "${MISSING[@]}"; do
                if echo "127.0.0.1   $DOMAIN" | sudo tee -a /etc/hosts > /dev/null; then
                    echo "✅ Added $DOMAIN"
                else
                    echo "❌ Failed to add $DOMAIN"
                    exit 1
                fi
            done
            echo "✅ Domains added. You may need to restart your browser."
        else
            echo "⚠️  Skipping domain setup. Add them manually to /etc/hosts if needed."
        fi
    else
        echo "✅ All custom .local domains are already present in /etc/hosts."
    fi
}

if [[ "$HOSTS_ONLY" == true ]]; then
    echo "🔗 Setting up /etc/hosts domains only..."
    setup_hosts
    exit 0
fi

echo "🚀 Starting daza.ar environment setup..."

# Check prerequisites first
check_prerequisites

# Create sites directory if it doesn't exist
if [ ! -d "sites" ]; then
    echo "📁 Creating sites directory..."
    if ! mkdir sites; then
        echo "❌ Failed to create sites directory"
        exit 1
    fi
else
    echo "📁 Sites directory already exists"
fi

# Change to sites directory
if ! cd sites; then
    echo "❌ Failed to change to sites directory"
    exit 1
fi

# List of repositories to clone
repos=(
    "juanmanueldaza/cv"
    "juanmanueldaza/onepager"
    "juanmanueldaza/data"
    "juanmanueldaza/wallpapers"
    "juanmanueldaza/start"
    "juanmanueldaza/navbar"
    "juanmanueldaza/mdsite"
)

echo "📦 Cloning repositories..."
failed_repos=()

# Clone each repository
for repo in "${repos[@]}"; do
    repo_name=$(basename "$repo")

    if [ -d "$repo_name" ]; then
        echo "⏭️  Repository $repo_name already exists, skipping..."
    else
        echo "📦 Cloning $repo..."
        if gh repo clone "$repo" 2>/dev/null; then
            echo "✅ Successfully cloned $repo"
        else
            echo "❌ Failed to clone $repo"
            failed_repos+=("$repo")
        fi
    fi
done

# Report any failures
if [ ${#failed_repos[@]} -gt 0 ]; then
    echo ""
    echo "⚠️  Some repositories failed to clone:"
    for repo in "${failed_repos[@]}"; do
        echo "   - $repo"
    done
    echo ""
    echo "This might be due to:"
    echo "   - Network connectivity issues"
    echo "   - Repository access permissions"
    echo "   - GitHub CLI authentication problems"
    echo ""
    echo "Please check your connection and authentication, then re-run this script."
fi

echo ""
setup_hosts

echo ""
if [ ${#failed_repos[@]} -eq 0 ]; then
    echo "🎉 Setup completed successfully!"
else
    echo "⚠️  Setup completed with some issues (see above)"
fi

echo "📍 Available repositories in the 'sites' directory:"
ls -la 2>/dev/null || echo "No repositories found"

echo ""
echo "💡 Next steps:"
echo "   - npm install (to install Vite)"
echo "   - npm run dev (to start all development servers)"
echo "   - Or run: ./dev.sh"
echo ""
echo "📖 For more information, see README.md"
