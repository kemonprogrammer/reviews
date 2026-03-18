#!/bin/bash

# Array of base commit messages
BASE_MESSAGES=(
    "Update db"
    "Add feature"
    "Fix feature"
    "Refactor service"
    "Standardize config"
)

# Pick a random base message and a random uppercase letter
RANDOM_INDEX=$((RANDOM % ${#BASE_MESSAGES[@]}))
RANDOM_LETTER=$(printf "\\$(printf '%03o' $((65 + RANDOM % 26)))")
SELECTED_MESSAGE="${BASE_MESSAGES[$RANDOM_INDEX]} $RANDOM_LETTER"

TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

# Route messages to specific files
if [[ "$SELECTED_MESSAGE" == *"db"* ]]; then
    FILE="db.txt"
    CONTENT="Database logic update ($RANDOM_LETTER) at $TIMESTAMP"
elif [[ "$SELECTED_MESSAGE" == *"service"* || "$SELECTED_MESSAGE" == *"feature"* ]]; then
    FILE="service.txt"
    CONTENT="Update service ($RANDOM_LETTER) at $TIMESTAMP"
else
    FILE="config.txt"
    CONTENT="Configuration tweak ($RANDOM_LETTER) at $TIMESTAMP"
fi

# Append, stage, and commit
echo "$CONTENT" >> "$FILE"
git add "$FILE"
git commit -m "$SELECTED_MESSAGE" -q

echo "Committed '$SELECTED_MESSAGE' to $FILE"
