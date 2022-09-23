#!/bin/bash

declare -a dirty untracked deleted newfile copied renamed
git status --porcelain | (
    # IFS needed to keep the whitespaces
    # TODO Sort out which of these statuses need to be git added
    while IFS= read line ; do
        case "${line}" in
        " M"*)          dirty+=(${line:2}) ; ;;
        "MM"*)          dirty+=(${line:2}) ; ;;
        "UU"*)         dirty+=(${line:2}) ; ;;
        "D"*)          deleted+=(${line:2}) ; ;;
        "??"*)         untracked+=(${line:2}) ; ;;
        "A"*)           newfile+=(${line:2}) ; ;;
        "C"*)          copied+=(${line:2}) ; ;;
        "R"*)          renamed+=(${line:2}) ; ;;
        esac
    done
    # TODO Check if there are no files to add and exit script
    add=$(gum choose --cursor-prefix "[ ] " --selected-prefix "[✓] " --no-limit "${dirty[@]}")
    addArr=(${add})
    git add "${addArr[@]}"
    # TODO Add a check here that everything is added before commiting
    # TODO Output result of check to confirm for user that everything is added
    git commit -m "$(gum input --width 50 --placeholder "Commit message")"
    gum confirm "Push?" && git push
)

