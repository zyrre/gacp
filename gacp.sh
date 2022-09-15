#!/bin/bash

declare -a dirty untracked deleted newfile copied renamed
git status --porcelain | (
    while read line ; do
        case "${line//[[:space:]]/}" in
        'M'*)          dirty+=(${line:2}) ; ;;
        'UU'*)         dirty+=(${line:2}) ; ;;
        'D'*)          deleted+=(${line:2}) ; ;;
        '??'*)         untracked+=(${line:2}) ; ;;
        'A'*)          newfile+=(${line:2}) ; ;;
        'C'*)          copied+=(${line:2}) ; ;;
        'R'*)          renamed+=(${line:2}) ; ;;
        esac
    done
    gum choose --no-limit "${dirty[@]}"
)
