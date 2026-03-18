#!/bin/bash

# Ensure required environment variables are set for the GitHub API
if [[ -z "$GITHUB_PAT" || -z "$OWNER" || -z "$REPO" ]]; then
    echo "Error: Missing required environment variables."
    echo "Please export GITHUB_PAT, OWNER, and REPO before running."
    exit 1
fi

# Define the project root directory
PROJECT_ROOT=$(git rev-parse --show-toplevel)

# Ensure we are actually inside a git repository
if [[ -z "$PROJECT_ROOT" ]]; then
    echo "Error: Not inside a git repository. Cannot determine project root."
    exit 1
fi

# --- Replicate the Branching Logic ---

# Ensure we are on main
git checkout main 2>/dev/null || git checkout -b main

# Create M1
echo "Creating M1 on main..."
"$PROJECT_ROOT/scripts/commit.sh"
M1_COMMIT=$(git rev-parse HEAD)

# Create M2
echo "Creating M2 on main..."
"$PROJECT_ROOT/scripts/commit.sh"

# Branch off from M1 to create the feature branch
echo "Branching 'feature' off from M1..."
git switch feature 2>/dev/null || git switch -c feature "$M1_COMMIT"

# Create F1 (Target D2)
echo "Creating F1 on feature..."
"$PROJECT_ROOT/scripts/commit.sh"
F1_COMMIT=$(git rev-parse HEAD)
git push -u origin feature

# Create M3 (Target D1)
git checkout main
echo "Creating M3 on main..."
"$PROJECT_ROOT/scripts/commit.sh"
M3_COMMIT=$(git rev-parse HEAD)
git push


# Return to main branch to leave the repo in a clean state
echo "Workflow complete."
