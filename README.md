# daza.ar Environment Setup
<!-- SITES_TABLE_START -->
| Site | Port | URL |
|------|------|-----|
| cv | 3001 | http://cv.local:3001 |
| onepager | 3002 | http://onepager.local:3002 |
| start | 3003 | http://start.local:3003 |
| navbar | 3004 | http://navbar.local:3004 |
| mdsite | 3005 | http://mdsite.local:3005 |
| data | 3006 | http://data.local:3006 |
| wallpapers | 3007 | http://wallpapers.local:3007 |

<!-- SITES_TABLE_END -->

A simple setup script to bootstrap the development environment for daza.ar projects by creating a structured workspace and cloning all necessary repositories.

## Overview

This repository provides tools to quickly set up and develop the daza.ar ecosystem locally. It includes:

- A setup script to clone all required repositories into a `sites/` directory.
- A unified development workflow to serve all sites locally with Vite, each on its own port.

## Quick Start

To check prerequisites and set up your environment, simply run:

```bash
./setup.sh
```

This script will guide you through all required steps and report any missing tools. For troubleshooting, see [TROUBLESHOOTING.md](./TROUBLESHOOTING.md).

## Workflow and Usage

- For development server status and health checks, run:
  ```bash
  ./status.sh
  ```
- For starting all dev servers:
  ```bash
  ./dev.sh
  ```
- For more details on workflow, branching, and PRs, see the sections below.

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

# Git, GitHub CLI, and Workflow Documentation
<!-- SITES_TABLE_START -->
| Site | Port | URL |
|------|------|-----|
| cv | 3001 | http://cv.local:3001 |
| onepager | 3002 | http://onepager.local:3002 |
| start | 3003 | http://start.local:3003 |
| navbar | 3004 | http://navbar.local:3004 |
| mdsite | 3005 | http://mdsite.local:3005 |
| data | 3006 | http://data.local:3006 |
| wallpapers | 3007 | http://wallpapers.local:3007 |

<!-- SITES_TABLE_END -->

## Branching Strategy

- **main**: Stable, production-ready code.
- **develop**: Integration branch for tested features.
- **feature/\***: Short-lived branches for new features or fixes, branched from `develop`.

## Typical Workflow

1. **Sync your local repo**

   ```bash
   git checkout main
   git pull origin main
   git checkout develop
   git pull origin develop
   ```

2. **Create a feature branch**

   ```bash
   git checkout -b feature/issue-XX-short-description develop
   ```

3. **Work and commit**
   - Make atomic commits with clear messages referencing the issue:
     ```bash
     git add .
     git commit -m "feat: add X (closes #XX)"
     ```

4. **Push and open a PR**

   ```bash
   git push -u origin feature/issue-XX-short-description
   gh pr create --base develop --head feature/issue-XX-short-description --title "Short summary (fixes #XX)" --body "Details and closes #XX"
   ```

5. **Review and merge**
   - Review PRs using GitHub or `gh pr review`.
   - Merge with squash and delete the branch:
     ```bash
     gh pr merge <PR_NUMBER> --squash --delete-branch
     ```

6. **Release to main**
   - After testing, open a PR from `develop` to `main`:
     ```bash
     gh pr create --base main --head develop --title "Release: Merge develop into main"
     ```
   - Merge as above.

## Issue Management

- Use rich issue templates for features and workflow.
- Assign, label, and close issues using the GitHub CLI:
  ```bash
  gh issue edit <number> --add-label documentation,workflow
  gh issue close <number> --comment "Released in main via PR #XX"
  ```

## Branch Protection

- `main` is protected: direct pushes are disabled, PRs required (can be relaxed for solo dev).
- Adjust protection as needed for solo or team development.

## Principles

- **KISS**: Keep scripts and workflow simple.
- **Minimal dependencies**: Use only Vite as an npm dependency. Prefer built-in tools and avoid extra packages.
- **GitHub CLI first**: Use the GitHub CLI (`gh`) for all repo, issue, and PR management tasks whenever possible. Use plain git only for low-level or unsupported operations.
- **SOLID/CLEAN**: Structure scripts and documentation for clarity and maintainability.

---

_For more detail, see `.github/ISSUE_TEMPLATE/branch_workflow.md` and `.github/ISSUE_TEMPLATE/feature_improvement.md`._

## What Gets Cloned

The setup script clones the following repositories into the `sites` directory:

| Repository                  | Description                 |
| --------------------------- | --------------------------- |
| `juanmanueldaza/cv`         | Personal CV/Resume website  |
| `juanmanueldaza/onepager`   | One-page portfolio site     |
| `juanmanueldaza/data`       | Data and content management |
| `juanmanueldaza/wallpapers` | Wallpaper collection        |
| `juanmanueldaza/start`      | Start page/dashboard        |
| `juanmanueldaza/navbar`     | Navigation bar component    |
| `juanmanueldaza/mdsite`     | Markdown-based static site  |

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

- Run `./dev.sh` to start all Vite dev servers in the background. Each site will open in your browser with its custom .local domain:
  - CV: http://cv.localhost:3001
  - Onepager: http://onepager.localhost:3002
  - Start: http://start.localhost:3003
  - Navbar: http://navbar.localhost:3004
  - Mdsite: http://mdsite.localhost:3005
  - Data: http://data.localhost:3006 (opens /README.md by default)
- Make changes in any site and see them live with hot reload.
- The `sites/` directory is ignored by git; you can safely re-run `setup.sh` to update or re-clone projects.

## Features

- **Idempotent setup:** Safe to run multiple times—skips existing repositories.
- **Unified dev environment:** Serve all sites with Vite, each on its own port and custom .local domain.
- **No extra dependencies:** Only Vite is required for development.

## Troubleshooting

- **Permission denied:**
  - Make sure scripts are executable: `chmod +x setup.sh dev.sh`

---

## Using the GitHub CLI (`gh`) Effectively

The GitHub CLI (`gh`) is a powerful tool for automating and streamlining your workflow. Here are some advanced and recommended usages for this project:

### Authentication & Setup

- Authenticate once: `gh auth login`
- Check your status: `gh auth status`

### Issues

- List issues: `gh issue list`
- View an issue: `gh issue view <number>`
- Create an issue: `gh issue create --title "Title" --body "Description" --label enhancement`
- Edit/label/assign: `gh issue edit <number> --add-label documentation --add-assignee <user>`
- Close with comment: `gh issue close <number> --comment "Fixed in PR #XX"`

### Pull Requests

- List PRs: `gh pr list`
- View PR: `gh pr view <number> --web`
- Create PR: `gh pr create --base develop --head feature/issue-XX-description --title "Title" --body "Details"`
- Add reviewer/assignee: `gh pr edit <number> --add-reviewer <user> --add-assignee <user>`
- Approve/review: `gh pr review <number> --approve --body "LGTM"`
- Merge (squash & delete): `gh pr merge <number> --squash --delete-branch`

### Branch Protection (Admin)

- Protect main: `gh api --method PUT repos/<owner>/<repo>/branches/main/protection --input protection.json`
- Unprotect (solo dev): set `required_pull_request_reviews` to `null` as shown above.

### Automation & Scripting

- Combine with bash for automation:
  ```bash
  for i in {1..5}; do gh issue close $i --comment "Batch closed"; done
  ```
- Use in CI/CD scripts for releases, tagging, or status checks.

### Tips

- Use `gh` with `jq` for JSON output and scripting.
- Use `gh` to manage releases, gists, and more: see `gh help`.
- All actions are logged in GitHub for traceability.

---

_For more CLI usage examples, see the [GitHub CLI docs](https://cli.github.com/manual/)._

## Code Quality & Formatting

### Linting and Formatting

- **Lint all code**: `npm run lint`
- **Fix linting issues**: `npm run lint:fix`
- **Format all code**: `npm run format`
- **Check formatting**: `npm run format:check`

The project uses ESLint for JavaScript linting and Prettier for consistent code formatting. Both tools are configured to work on root files and all subprojects in the `sites/` directory.

### Pre-commit Hooks

Install git hooks to automatically check code before commits:

```bash
./install-hooks.sh
```

This ensures all committed code passes linting and formatting checks, preventing style-related issues from entering the repository.

### CI Integration

The GitHub Actions workflow automatically:

- Runs ESLint on all JavaScript files
- Checks code formatting with Prettier
- Validates shell scripts with ShellCheck

All checks must pass before merging pull requests.

### Configuration Files

- **ESLint**: `eslint.config.js` (modern flat config format)
- **Prettier**: `.prettierrc` (JSON configuration)

Both configurations follow the project's KISS principle with sensible defaults that work across all subprojects.

## Scripts

- `npm run dev`: Starts all development servers using `./dev.sh`.
- `npm run build`: (Placeholder) Use site-specific build scripts or Vite as needed.
- `npm run clean`: Removes `sites/` and `node_modules/` for a fresh start.
- `npm run lint`: Lints all JavaScript files in root and sites directories.
- `npm run lint:fix`: Automatically fixes linting issues where possible.
- `npm run format`: Formats all code files using Prettier.
- `npm run format:check`: Checks if all files are properly formatted.

> This project follows KISS and minimal dependencies. Only essential scripts, Vite, ESLint, and Prettier are included. For advanced builds, use site-specific configs.

## Scripts

- `npm run dev`: Starts all development servers using `./dev.sh`.
- `npm run build`: (Placeholder) Use site-specific build scripts or Vite as needed.
- `npm run clean`: Removes `sites/` and `node_modules/` for a fresh start.

> This project follows KISS and minimal dependencies. Only essential scripts and Vite are included. For advanced builds, use site-specific configs.

## Automated Workflow (workflow.sh)

This project provides an automated workflow script (`workflow.sh`) that uses the GitHub CLI (`gh`) for all repository, PR, and issue management tasks. Only Vite is used as an npm dependency.

### Usage

```bash
./workflow.sh <issue_number> <commit_message> <pr_title> <pr_body>
```
- Detects the default branch (develop or main) using `gh`.
- Creates a feature branch, commits only if there are changes, and pushes to origin.
- Uses `gh` to create and merge PRs, and close issues.
- Exits gracefully if there are no changes to commit.

### Principles
- **KISS**: Simple, robust, and minimal logic.
- **Minimal dependencies**: Only Vite as an npm dependency; all repo management via GitHub CLI.
- **gh-first**: Prefer `gh` for all automation; use git only for local diff/staging.

**Author**: Juan Manuel Daza  
**Website**: [daza.ar](https://daza.ar)
