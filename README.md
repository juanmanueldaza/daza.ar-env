# daza.ar Environment Setup

A simple setup script to bootstrap the development environment for daza.ar projects by creating a structured workspace and cloning all necessary repositories.

## Overview

This repository provides tools to quickly set up and develop the daza.ar ecosystem locally. It includes:
- A setup script to clone all required repositories into a `sites/` directory.
- A unified development workflow to serve all sites locally with Vite, each on its own port.

## Prerequisites

- **GitHub CLI (`gh`)** ([Installation guide](https://cli.github.com/))
- **Git** ([Installation guide](https://git-scm.com/downloads))
- **Node.js** (v18+ recommended)
- **Bash shell** (Linux, macOS, or Windows with WSL)

### Authentication

Make sure you're authenticated with GitHub CLI:

```bash
gh auth login
```

## Quick Start

1. Clone this repository:
   ```bash
   git clone <this-repository-url>
   cd daza.ar-env
   ```

2. Run the setup script to clone all project repositories:
   ```bash
   ./setup.sh
   ```

3. Install dependencies:
   ```bash
   npm install
   ```

4. Start all development servers (each site will open in your browser):
   ```bash
   ./dev.sh
   ```

   > Each site will be served on a different port (see below).

## What Gets Cloned

The setup script clones the following repositories into the `sites` directory:

| Repository              | Description                    |
|-------------------------|--------------------------------|
| `juanmanueldaza/cv`     | Personal CV/Resume website     |
| `juanmanueldaza/onepager` | One-page portfolio site      |
| `juanmanueldaza/data`   | Data and content management    |
| `juanmanueldaza/wallpapers` | Wallpaper collection       |
| `juanmanueldaza/start`  | Start page/dashboard           |
| `juanmanueldaza/navbar` | Navigation bar component       |
| `juanmanueldaza/mdsite` | Markdown-based static site     |

## Directory Structure

After running the setup script, your directory structure will look like this:

```
daza.ar-env/
├── README.md
├── setup.sh
├── dev.sh
├── package.json
├── vite.config.js
├── sites/           # (cloned repos, ignored by git)
│   ├── cv/
│   ├── onepager/
│   ├── data/
│   ├── wallpapers/
│   ├── start/
│   ├── navbar/
│   └── mdsite/
└── logs/            # (optional, for custom logging)
```

## Development Workflow

- Run `./dev.sh` to start all Vite dev servers in the background. Each site will open in your browser:
  - CV:           http://localhost:3001
  - Onepager:     http://localhost:3002
  - Start:        http://localhost:3003
  - Navbar:       http://localhost:3004
  - Mdsite:       http://localhost:3005
  - Data:         http://localhost:3006 (opens /README.md by default)
- Make changes in any site and see them live with hot reload.
- The `sites/` directory is ignored by git; you can safely re-run `setup.sh` to update or re-clone projects.

## Features

- **Idempotent setup:** Safe to run multiple times—skips existing repositories.
- **Unified dev environment:** Serve all sites with Vite, each on its own port.
- **No extra dependencies:** Only Vite is required for development.

## Troubleshooting

- **Permission denied:**
  - Make sure scripts are executable: `chmod +x setup.sh dev.sh`

---

**Author**: Juan Manuel Daza  
**Website**: [daza.ar](https://daza.ar)