#!/bin/bash
input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
version=$(echo "$input" | jq -r '.version // empty')
version_str=""
if [ -n "$version" ]; then
    version_str=" (v${version})"
fi
if [ -n "$used" ]; then
    printf '\033[01;32m%s@%s\033[00m:\033[01;34m%s\033[00m [ctx: %s%%]%s' "$(whoami)" "$(hostname -s)" "$cwd" "$used" "$version_str"
else
    printf '\033[01;32m%s@%s\033[00m:\033[01;34m%s\033[00m%s' "$(whoami)" "$(hostname -s)" "$cwd" "$version_str"
fi
