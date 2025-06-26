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

git checkout main
git fetch origin
# Robustly set BASE to develop if it exists remotely, else main
if git branch -r | grep -q 'origin/develop'; then
  BASE=develop
else
  BASE=main
fi
git checkout $BASE
git pull origin $BASE

# Use a branch name based on issue and commit message
BRANCH_NAME="feature/${ISSUE_NUMBER}-$(echo "$COMMIT_MESSAGE" | tr ' ' '-' | tr -cd '[:alnum:]-' | cut -c1-30 | tr '[:upper:]' '[:lower:]')"
git checkout -b "$BRANCH_NAME" $BASE

git add .
if ! git diff --cached --quiet || ! git diff --quiet; then
  git commit -m "$COMMIT_MESSAGE"
  git push -u origin "$BRANCH_NAME"
else
  echo "No changes to commit. Exiting."
  exit 0
fi

gh pr create --base $BASE --head "$BRANCH_NAME" --title "$PR_TITLE" --body "$PR_BODY" --label documentation --fill

gh pr merge --squash --delete-branch --admin --subject "$PR_TITLE" --body "$PR_BODY"

gh issue close "$ISSUE_NUMBER" --comment "Resolved and merged via PR."

echo "Workflow complete."
