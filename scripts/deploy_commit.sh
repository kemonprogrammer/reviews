#!/bin/bash

TARGET_COMMIT=$1

if [[ -z "$TARGET_COMMIT" ]]; then
    echo "Error: Please provide a commit SHA or branch name as the first argument."
    echo "Usage: ./deploy_commit.sh <commit-sha-or-branch>"
    exit 1
fi

if [[ -z "$GITHUB_PAT" || -z "$OWNER" || -z "$REPO" ]]; then
    echo "Error: Missing required environment variables."
    echo "Please export GITHUB_PAT, OWNER, and REPO before running."
    exit 1
fi

echo "Preparing to deploy target: $TARGET_COMMIT"

# 1. Add temporary tag 'd1' and push it (force to overwrite if it exists)
git tag -f d1 "$TARGET_COMMIT"
git push -f origin d1

# 2. Trigger the GitHub Action workflow
echo "Triggering GitHub Action dispatch..."
curl -s -L -X POST \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $GITHUB_PAT" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    "https://api.github.com/repos/$OWNER/$REPO/actions/workflows/go.yml/dispatches" \
    -d '{ "ref": "d1" }'

# Give GitHub Actions a few seconds to register the dispatch event
sleep 5

# 3. Clean up the temporary tag locally and remotely
git tag -d d1
git push origin --delete d1

echo "Deployment triggered and temporary tag cleaned up for $TARGET_COMMIT."
echo "---------------------------------------------------"
