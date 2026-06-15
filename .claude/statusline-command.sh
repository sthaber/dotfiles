#!/bin/bash
input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
five_h=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_h_resets=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
week=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
version=$(echo "$input" | jq -r '.version // empty')
model=$(echo "$input" | jq -r '.model.display_name // empty')

version_str=""
if [ -n "$version" ]; then
    version_str=" (v${version})"
fi

bits=""
if [ -n "$model" ]; then
    bits="${bits} [${model}]"
fi
if [ -n "$used" ]; then
    bits="${bits} [ctx: ${used}%]"
fi
if [ -n "$five_h" ]; then
    five_h_int=$(printf '%.0f' "$five_h")
    five_h_str="5h: ${five_h_int}%"
    if [ -n "$five_h_resets" ]; then
        now=$(date +%s)
        secs_left=$(( five_h_resets - now ))
        if [ "$secs_left" -gt 0 ]; then
            mins_left=$(( secs_left / 60 ))
            if [ "$mins_left" -ge 60 ]; then
                hrs=$(( mins_left / 60 ))
                mins=$(( mins_left % 60 ))
                five_h_str="${five_h_str} resets ${hrs}h${mins}m"
            else
                five_h_str="${five_h_str} resets ${mins_left}m"
            fi
        fi
    fi
    bits="${bits} [${five_h_str}]"
fi
if [ -n "$week" ]; then
    week_int=$(printf '%.0f' "$week")
    bits="${bits} [wk: ${week_int}%]"
fi

printf '\033[01;32m%s@%s\033[00m:\033[01;34m%s\033[00m%s%s' "$(whoami)" "$(hostname -s)" "$cwd" "$bits" "$version_str"
