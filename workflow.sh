#!/bin/bash
# Automated workflow script for standards-aligned feature/branch/PR/merge in daza.ar-env
# Usage: ./workflow.sh <issue_number> <branch_name> <commit_message> <pr_title> <pr_body>

set -e

ISSUE_NUMBER="$1"
BRANCH_NAME="$2"
COMMIT_MESSAGE="$3"
PR_TITLE="$4"
PR_BODY="$5"

if [ -z "$ISSUE_NUMBER" ] || [ -z "$BRANCH_NAME" ] || [ -z "$COMMIT_MESSAGE" ] || [ -z "$PR_TITLE" ] || [ -z "$PR_BODY" ]; then
  echo "Usage: $0 <issue_number> <branch_name> <commit_message> <pr_title> <pr_body>"
  exit 1
fi

git checkout main
# If develop exists, use it as base, else use main
git fetch origin
git branch -r | grep develop && BASE=develop || BASE=main
git checkout $BASE
git pull origin $BASE
git checkout -b "$BRANCH_NAME" $BASE

git add .
git commit -m "$COMMIT_MESSAGE"
git push -u origin "$BRANCH_NAME"

gh pr create --base $BASE --head "$BRANCH_NAME" --title "$PR_TITLE" --body "$PR_BODY" --label documentation --fill

gh pr merge --squash --delete-branch --admin --subject "$PR_TITLE" --body "$PR_BODY"

gh issue close "$ISSUE_NUMBER" --comment "Resolved and merged via PR."

echo "Workflow complete."
