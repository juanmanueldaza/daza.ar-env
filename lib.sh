#!/bin/bash
# Shared utility functions and variables for daza.ar-env scripts
# Source this file in other scripts: source ./lib.sh

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Symbols
CHECK="5F8"
CROSS="5F4"
WARNING="6A7"
INFO="6C8"

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check if a port is in use
port_in_use() {
    lsof -i ":$1" >/dev/null 2>&1
}

# Function to check if a domain is in /etc/hosts
domain_resolves() {
    grep -q "$1" /etc/hosts 2>/dev/null
}
