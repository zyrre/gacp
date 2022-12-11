#!/bin/bash

declare -a addable untracked deleted newfile copied renamed
git status --porcelain | (
    # IFS needed to keep the whitespaces for some reason(<3 shell scripts)
    # TODO Sort out which of these statuses need to be git added
    while IFS= read line ; do
        case "${line}" in
        " M"*)          addable+=(${line:2}) ; ;;
        "MM"*)          addable+=(${line:2}) ; ;;
        "UU"*)         addable+=(${line:2}) ; ;;
        "D"*)          addable+=(${line:2}) ; ;;
        " D"*)          addable+=(${line:2}) ; ;;
        "??"*)         addable+=(${line:2}) ; ;;
        "A"*)           addable+=(${line:2}) ; ;;
        "C"*)          addable+=(${line:2}) ; ;;
        "R"*)          addable+=(${line:2}) ; ;;
        esac
    done

    # Check if there are no files to add
    if [ ${#addable[@]} -eq 0 ]; then
        echo "There are no new or modified files. Exiting."
        exit 1
    fi

    add=$(gum choose --cursor-prefix "[ ] " --selected-prefix "[✓] " --no-limit "${addable[@]}")
    addArr=(${add})

    git add "${addArr[@]}"

    git commit -m "$(gum input --width 50 --placeholder "Commit message")"


    gum confirm "Push?" && git push
)

