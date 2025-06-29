#!/bin/bash

# Status and health check script for daza.ar-env
# Usage: ./status.sh

set -e

# Source shared utilities
source "$(dirname "$0")/lib.sh"

echo -e "${BLUE}📊 daza.ar-env Status Check${NC}"
echo "=================================="
echo ""

# 1. Prerequisites Check
echo -e "${BLUE}🔧 Prerequisites${NC}"
echo "----------------"

if command_exists node; then
    NODE_VERSION=$(node --version)
    echo -e "${CHECK} Node.js: ${GREEN}$NODE_VERSION${NC}"
else
    echo -e "${CROSS} Node.js: ${RED}Not installed${NC}"
fi

if command_exists npm; then
    NPM_VERSION=$(npm --version)
    echo -e "${CHECK} npm: ${GREEN}$NPM_VERSION${NC}"
else
    echo -e "${CROSS} npm: ${RED}Not installed${NC}"
fi

if command_exists git; then
    GIT_VERSION=$(git --version | cut -d' ' -f3)
    echo -e "${CHECK} Git: ${GREEN}$GIT_VERSION${NC}"
else
    echo -e "${CROSS} Git: ${RED}Not installed${NC}"
fi

if command_exists gh; then
    GH_VERSION=$(gh --version | head -n1 | cut -d' ' -f3)
    echo -e "${CHECK} GitHub CLI: ${GREEN}$GH_VERSION${NC}"

    # Check authentication
    if gh auth status >/dev/null 2>&1; then
        echo -e "${CHECK} GitHub Auth: ${GREEN}Authenticated${NC}"
    else
        echo -e "${CROSS} GitHub Auth: ${RED}Not authenticated${NC}"
    fi
else
    echo -e "${CROSS} GitHub CLI: ${RED}Not installed${NC}"
fi

echo ""

# 2. Project Structure Check
echo -e "${BLUE}📁 Project Structure${NC}"
echo "-------------------"

if [ -f "package.json" ]; then
    echo -e "${CHECK} package.json: ${GREEN}Found${NC}"
else
    echo -e "${CROSS} package.json: ${RED}Missing${NC}"
fi

if [ -f "vite.config.js" ]; then
    echo -e "${CHECK} vite.config.js: ${GREEN}Found${NC}"
else
    echo -e "${CROSS} vite.config.js: ${RED}Missing${NC}"
fi

if [ -d "node_modules" ]; then
    echo -e "${CHECK} node_modules: ${GREEN}Found${NC}"
else
    echo -e "${CROSS} node_modules: ${RED}Missing (run: npm install)${NC}"
fi

if [ -d "sites" ]; then
    echo -e "${CHECK} sites directory: ${GREEN}Found${NC}"

    # Check individual repositories
    EXPECTED_REPOS=("cv" "onepager" "start" "navbar" "mdsite" "data" "wallpapers")
    MISSING_REPOS=()

    for repo in "${EXPECTED_REPOS[@]}"; do
        if [ -d "sites/$repo" ]; then
            echo -e "  ${CHECK} sites/$repo: ${GREEN}Found${NC}"
        else
            echo -e "  ${CROSS} sites/$repo: ${RED}Missing${NC}"
            MISSING_REPOS+=("$repo")
        fi
    done

    if [ ${#MISSING_REPOS[@]} -gt 0 ]; then
        echo -e "${WARNING} Missing repositories: ${YELLOW}${MISSING_REPOS[*]}${NC}"
        echo -e "${INFO} Run: ./setup.sh to clone missing repositories"
    fi
else
    echo -e "${CROSS} sites directory: ${RED}Missing (run: ./setup.sh)${NC}"
fi

echo ""

# 3. Dependencies Check
echo -e "${BLUE}📦 Dependencies${NC}"
echo "---------------"

if [ -f "package.json" ] && [ -d "node_modules" ]; then
    if npm ls >/dev/null 2>&1; then
        echo -e "${CHECK} Dependencies: ${GREEN}All installed${NC}"
    else
        echo -e "${WARNING} Dependencies: ${YELLOW}Some issues found${NC}"
        echo -e "${INFO} Run: npm install"
    fi
else
    echo -e "${CROSS} Dependencies: ${RED}Cannot check (missing package.json or node_modules)${NC}"
fi

# Check Vite specifically
if [ -d "node_modules/vite" ]; then
    VITE_VERSION=$(npm ls vite --depth=0 2>/dev/null | grep vite | cut -d'@' -f2 || echo "unknown")
    echo -e "${CHECK} Vite: ${GREEN}$VITE_VERSION${NC}"
else
    echo -e "${CROSS} Vite: ${RED}Not installed${NC}"
fi

echo ""

# 4. Development Servers Check
echo -e "${BLUE}🌐 Development Servers${NC}"
echo "---------------------"

PORTS=(3001 3002 3003 3004 3005 3006 3007)
PORT_NAMES=("cv" "onepager" "start" "navbar" "mdsite" "data" "wallpapers")
RUNNING_SERVERS=0

for i in "${!PORTS[@]}"; do
    port=${PORTS[$i]}
    name=${PORT_NAMES[$i]}

    if port_in_use "$port"; then
        echo -e "${CHECK} $name (port $port): ${GREEN}Running${NC}"
        ((RUNNING_SERVERS++))
    else
        echo -e "${CROSS} $name (port $port): ${RED}Not running${NC}"
    fi
done

echo -e "${INFO} Servers running: ${RUNNING_SERVERS}/7"

if [ $RUNNING_SERVERS -eq 0 ]; then
    echo -e "${INFO} Run: ./dev.sh or npm run dev to start all servers"
fi

echo ""

# 5. Domain Configuration Check
echo -e "${BLUE}🔗 Local Domain Configuration${NC}"
echo "-----------------------------"

DOMAINS=("cv.local" "onepager.local" "start.local" "navbar.local" "mdsite.local" "data.local" "wallpapers.local")
MISSING_DOMAINS=()

for domain in "${DOMAINS[@]}"; do
    if domain_resolves "$domain"; then
        echo -e "${CHECK} $domain: ${GREEN}Configured${NC}"
    else
        echo -e "${CROSS} $domain: ${RED}Missing from /etc/hosts${NC}"
        MISSING_DOMAINS+=("$domain")
    fi
done

if [ ${#MISSING_DOMAINS[@]} -gt 0 ]; then
    echo -e "${WARNING} Missing domains: ${YELLOW}${MISSING_DOMAINS[*]}${NC}"
    echo -e "${INFO} Run: ./setup.sh --hosts-only to configure domains"
fi

echo ""

# 6. System Resources Check
echo -e "${BLUE}💻 System Resources${NC}"
echo "------------------"

# Check available memory (Linux/macOS)
if command_exists free; then
    MEMORY=$(free -h | awk '/^Mem:/ {print $7}')
    echo -e "${INFO} Available Memory: ${MEMORY}"
elif command_exists vm_stat; then
    # macOS version - simplified
    echo -e "${INFO} Memory: ${GREEN}Available${NC} (macOS)"
fi

# Check disk space
if command_exists df; then
    DISK_USAGE=$(df -h . | awk 'NR==2 {print $5}')
    DISK_AVAIL=$(df -h . | awk 'NR==2 {print $4}')
    echo -e "${INFO} Disk Usage: ${DISK_USAGE} used, ${DISK_AVAIL} available"
fi

# Check CPU load (Linux)
if [ -f "/proc/loadavg" ]; then
    LOAD=$(cut -d' ' -f1 /proc/loadavg)
    echo -e "${INFO} CPU Load: ${LOAD}"
fi

echo ""

# 7. Quick Health Summary
echo -e "${BLUE}📋 Health Summary${NC}"
echo "----------------"

ISSUES=0

# Count issues
if ! command_exists node || ! command_exists npm || ! command_exists git || ! command_exists gh; then
    ((ISSUES++))
fi

if ! gh auth status >/dev/null 2>&1; then
    ((ISSUES++))
fi

if [ ! -d "sites" ] || [ ${#MISSING_REPOS[@]} -gt 0 ]; then
    ((ISSUES++))
fi

if [ ! -d "node_modules" ]; then
    ((ISSUES++))
fi

if [ ${#MISSING_DOMAINS[@]} -gt 0 ]; then
    ((ISSUES++))
fi

if [ $ISSUES -eq 0 ]; then
    echo -e "${CHECK} Overall Status: ${GREEN}HEALTHY${NC}"
    echo -e "${INFO} All systems operational!"

    if [ $RUNNING_SERVERS -gt 0 ]; then
        echo -e "${INFO} Development servers are running. Access your sites:"
        for i in "${!PORTS[@]}"; do
            port=${PORTS[$i]}
            name=${PORT_NAMES[$i]}
            if port_in_use "$port"; then
                echo -e "  • ${name}: ${BLUE}http://${name}.local:${port}${NC}"
            fi
        done
    else
        echo -e "${INFO} Run ${YELLOW}./dev.sh${NC} to start development servers"
    fi
else
    echo -e "${WARNING} Overall Status: ${YELLOW}NEEDS ATTENTION${NC}"
    echo -e "${INFO} Found $ISSUES issue(s) that need to be resolved"
    echo ""
    echo -e "${INFO} Quick fixes:"
    echo -e "  • Missing prerequisites: Install Node.js, npm, git, GitHub CLI"
    echo -e "  • Authentication: Run ${YELLOW}gh auth login${NC}"
    echo -e "  • Missing repositories: Run ${YELLOW}./setup.sh${NC}"
    echo -e "  • Missing dependencies: Run ${YELLOW}npm install${NC}"
    echo -e "  • Missing domains: Run ${YELLOW}./setup.sh --hosts-only${NC}"
fi

echo ""
echo -e "${BLUE}📚 More Help${NC}"
echo "----------"
echo -e "• Documentation: ${BLUE}README.md${NC}"
echo -e "• Troubleshooting: ${BLUE}TROUBLESHOOTING.md${NC}"
echo -e "• Issues: ${BLUE}https://github.com/juanmanueldaza/daza.ar-env/issues${NC}"

echo ""
echo "Status check completed at $(date)"
