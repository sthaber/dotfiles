#!/bin/bash
input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
five_h=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_h_resets=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
week=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
week_resets=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')
version=$(echo "$input" | jq -r '.version // empty')
model=$(echo "$input" | jq -r '.model.display_name // empty')

# Currently logged-in tenant. Not in the statusline JSON; lives in .claude.json
# oauthAccount, which /login rewrites on every account switch.
config_json="${CLAUDE_CONFIG_DIR:-$HOME}/.claude.json"
org=$(jq -r '.oauthAccount.organizationName // empty' "$config_json" 2>/dev/null)
case "$org" in
    "Qumulo Engineering")   tenant="QE"  ;;
    "Qumulo Engineering 2") tenant="QE2" ;;
    *)                      tenant="$org" ;;
esac

version_str=""
if [ -n "$version" ]; then
    version_str=" (v${version})"
fi

# Render " resets XhYm" / " resets Ym" for a resets_at epoch, empty if past/unset.
resets_str() {
    local resets_at="$1"
    if [ -z "$resets_at" ]; then
        return
    fi
    local secs_left=$(( resets_at - $(date +%s) ))
    if [ "$secs_left" -le 0 ]; then
        return
    fi
    local mins_left=$(( secs_left / 60 ))
    if [ "$mins_left" -ge 1440 ]; then
        printf ' resets %dd%dh' "$(( mins_left / 1440 ))" "$(( mins_left % 1440 / 60 ))"
    elif [ "$mins_left" -ge 60 ]; then
        printf ' resets %dh%dm' "$(( mins_left / 60 ))" "$(( mins_left % 60 ))"
    else
        printf ' resets %dm' "$mins_left"
    fi
}

bits=""
if [ -n "$tenant" ]; then
    bits="${bits} [${tenant}]"
fi
if [ -n "$model" ]; then
    bits="${bits} [${model}]"
fi
if [ -n "$used" ]; then
    bits="${bits} [ctx: ${used}%]"
fi
if [ -n "$five_h" ]; then
    five_h_int=$(printf '%.0f' "$five_h")
    bits="${bits} [5h: ${five_h_int}%$(resets_str "$five_h_resets")]"
fi
if [ -n "$week" ]; then
    week_int=$(printf '%.0f' "$week")
    bits="${bits} [wk: ${week_int}%$(resets_str "$week_resets")]"
fi

dir="${cwd/#$HOME/\~}"
printf '\033[01;34m%s\033[00m%s%s' "$dir" "$bits" "$version_str"
