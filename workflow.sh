#!/bin/bash
# Automated workflow script for standards-aligned feature/branch/PR/merge in daza.ar-env
# Usage: ./workflow.sh <issue_number> <commit_message> <pr_title> <pr_body>

set -e

ISSUE_NUMBER="$1"
COMMIT_MESSAGE="$2"
PR_TITLE="$3"
PR_BODY="$4"

if [ -z "$ISSUE_NUMBER" ] || [ -z "$COMMIT_MESSAGE" ] || [ -z "$PR_TITLE" ] || [ -z "$PR_BODY" ]; then
  echo "Usage: $0 <issue_number> <commit_message> <pr_title> <pr_body>"
  exit 1
fi

# Use GitHub CLI to detect default branch (develop or main)
BASE=$(gh repo view --json defaultBranchRef -q .defaultBranchRef.name 2>/dev/null || echo "main")
git fetch origin

# Check for unstaged or staged changes
if ! git diff --quiet || ! git diff --cached --quiet; then
  # Save WIP changes to a temp branch
  WIP_BRANCH="wip/$(date +%s)"
  git checkout -b "$WIP_BRANCH"
  git add .
  git commit -m "wip: save local changes before workflow automation"
  WIP_COMMIT=$(git rev-parse HEAD)
  # Switch to base and update
  git checkout $BASE
  git pull origin $BASE
  # Create feature branch from base
  BRANCH_NAME="feature/${ISSUE_NUMBER}-$(echo $COMMIT_MESSAGE | tr ' ' '-' | tr -cd '[:alnum:]-' | cut -c1-30 | tr '[:upper:]' '[:lower:]')"
  git checkout -b "$BRANCH_NAME" $BASE
  # Cherry-pick WIP commit
  git cherry-pick $WIP_COMMIT
  # Delete WIP branch
  git branch -D "$WIP_BRANCH"
else
  # No local changes, just create feature branch from base
  git checkout $BASE
  git pull origin $BASE
  BRANCH_NAME="feature/${ISSUE_NUMBER}-$(echo $COMMIT_MESSAGE | tr ' ' '-' | tr -cd '[:alnum:]-' | cut -c1-30 | tr '[:upper:]' '[:lower:]')"
  git checkout -b "$BRANCH_NAME" $BASE
fi

# Only commit if there are changes (should always be true here, but double-check)
git add .
if git diff --cached --quiet; then
  echo "No changes to commit. Exiting."
  exit 0
fi

git commit -m "$COMMIT_MESSAGE" || echo "Nothing to commit, continuing."
git push -u origin "$BRANCH_NAME"

gh pr create --base $BASE --head "$BRANCH_NAME" --title "$PR_TITLE" --body "$PR_BODY" --label documentation --fill

gh pr merge --squash --delete-branch --admin --subject "$PR_TITLE" --body "$PR_BODY"

gh issue close "$ISSUE_NUMBER" --comment "Resolved and merged via PR."

echo "Workflow complete."
