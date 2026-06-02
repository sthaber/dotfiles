#!/bin/bash
timestamp=$(date +"%Y%m%d_%H%M%S")
for src in ~/src ~/src[0-9]*; do
    [ -d "$src/.hg/patches" ] || continue
    name=$(basename "$src")
    dest=~/patches_backup/$name/$timestamp
    mkdir -p "$dest"
    cp -r "$src"/.hg/patches/* "$dest"/
done
