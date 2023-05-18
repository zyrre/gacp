#!/bin/bash

# Check if 'gum' command is available
if ! command -v gum &> /dev/null
then
    echo "'gum' command could not be found. Please install it and try again."
    echo "https://github.com/charmbracelet/gum"
    exit
fi

# Check what changes have happened in the current git directory
CHANGES=$(git status --porcelain)

# Present a list of the potential files to be added
FILES_TO_ADD=$(echo "$CHANGES" | awk '{print $2}')

# Check if there are any files to add
if [ -z "$FILES_TO_ADD" ]
then
    echo "No changes detected. Exiting."
    exit
fi

CHOSEN_FILES=$(gum choose --header "Which files do you want to add?" --cursor-prefix "[ ] " --unselected-prefix "[ ] " --selected-prefix "[✓] " --no-limit $FILES_TO_ADD)

# Git add the files selected by the user
git add $CHOSEN_FILES

# Ask user for commit message§-
COMMIT_MSG=$(gum input --placeholder "Enter commit message")

# Commit the changes
git commit -m "$COMMIT_MSG"

# Ask the user if they want to push the changes, and if confirmed, push the changes
gum confirm "Push changes?" && git push
