#!/bin/bash

# Define the array of mock commit messages
MESSAGES=(
    "Update db"
    "Add feature x"
    "Fix feature y"
    "Refactor service x"
    "Clean up config files"
)

# Select a random message from the array
RANDOM_INDEX=$((RANDOM % ${#MESSAGES[@]}))
SELECTED_MESSAGE=${MESSAGES[$RANDOM_INDEX]}

# Get current timestamp for unique file content
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

# Map the selected message to a specific file and content
case "$SELECTED_MESSAGE" in
    "Update db")
        FILE="db.txt"
        CONTENT="Some db logic added at $TIMESTAMP"
        ;;
    "Add feature x")
        FILE="feature-x.txt"
        CONTENT="New functionality for feature x at $TIMESTAMP"
        ;;
    "Fix feature y")
        FILE="feature-y.txt"
        CONTENT="Patched edge case in feature y at $TIMESTAMP"
        ;;
    "Refactor service x")
        FILE="service-x.txt"
        CONTENT="Optimized service x architecture at $TIMESTAMP"
        ;;
    *)
        FILE="config.txt"
        CONTENT="Standardized config formatting at $TIMESTAMP"
        ;;
esac

# Append the content to the designated file
echo "$CONTENT" >> "$FILE"

# Stage and commit the file
git add "$FILE"
git commit -m "$SELECTED_MESSAGE"

# Output a confirmation to the terminal
echo "Successfully mocked commit: '$SELECTED_MESSAGE' (modified $FILE)"
