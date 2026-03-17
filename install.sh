#!/bin/bash
set -ex

CWD=$(pwd)

find "$CWD" -maxdepth 1 -type f ! -name install.sh -exec ln -sf {} ~/ \;

# Symlink files from each subdirectory into the matching ~/.<dir>
for dir in "$CWD"/.*; do
    [ -d "$dir" ] || continue
    name=$(basename "$dir")
    [[ "$name" == "." || "$name" == ".." || "$name" == ".git" ]] && continue
    mkdir -p ~/"$name"
    find "$dir" -maxdepth 1 -type f -exec ln -sf {} ~/"$name"/ \;
done

crontab ~/.crontab

sudo apt -y install emacs zile mosh
