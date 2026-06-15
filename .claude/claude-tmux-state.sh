#!/usr/bin/env bash
# Reflect Claude Code session state into the tmux window-status flag.
#
# Called by Claude Code hooks (see ~/.claude/settings.json) with one argument:
#   waiting  blocked on you           (Notification hook: permission/elicitation)
#   busy     working                  (UserPromptSubmit hook)
#   idle     turn finished            (Stop hook)
#
# State is stored per pane in @claude_pane. The window flag @claude, read by
# window-status-format in ~/.tmux.conf, shows the most urgent state across all
# panes in the window: waiting > busy > idle. So two Claude panes in one window
# no longer stomp each other, and a closed pane stops contributing on its own.

set -u

state=${1:-}
[ -n "${TMUX_PANE:-}" ] || exit 0
[ -n "$state" ] || exit 0

# A finished turn is still busy while background tasks (bash, subagents, ...)
# are in flight; the Stop hook delivers them on stdin.
if [ "$state" = idle ]; then
    pending=$(jq -r '(.background_tasks | length) // 0' 2>/dev/null)
    case "$pending" in
        '' | *[!0-9]*) pending=0 ;;
    esac
    if [ "$pending" -gt 0 ]; then
        state=busy
    fi
fi

tmux set -p -t "$TMUX_PANE" @claude_pane "$state" 2>/dev/null || exit 0

panes=$(tmux list-panes -t "$TMUX_PANE" -F '#{@claude_pane}' 2>/dev/null)
if echo "$panes" | grep -qx waiting; then
    window_state=waiting
elif echo "$panes" | grep -qx busy; then
    window_state=busy
elif echo "$panes" | grep -qx idle; then
    window_state=idle
else
    window_state=
fi

if [ -n "$window_state" ]; then
    tmux set -w -t "$TMUX_PANE" @claude "$window_state" 2>/dev/null || true
else
    tmux set -wu -t "$TMUX_PANE" @claude 2>/dev/null || true
fi
