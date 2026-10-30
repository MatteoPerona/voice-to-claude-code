#!/bin/zsh
# Always-on bridge runner. launchd runs this (see com.example.bridge.plist.example) and restarts it when it exits.
# It starts an interactive Claude Code session with the Slack channel plugin inside a detached tmux session,
# then stays in the foreground, holding a no-sleep assertion, until that session ends.
set -u

PATH="/opt/homebrew/bin:$HOME/.local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
# Folder holding this script's bridge.conf. Override with the BRIDGE_DIR environment variable.
BRIDGE="${BRIDGE_DIR:-$HOME/claude-bridge}"
# Directory the Claude Code session works in. Override with BRIDGE_WORKDIR.
WORKDIR="${BRIDGE_WORKDIR:-$HOME}"
SESSION="claude-bridge"
LOG="$HOME/Library/Logs/claude-bridge.log"

log() { print -r -- "$(date '+%Y-%m-%d %H:%M:%S') $*" >> "$LOG"; }

# Model and effort come from bridge.conf (KEY=value lines), so they change without editing this script.
# Values are validated; anything missing or invalid falls back to the defaults below.
MODEL="claude-opus-5-5"
EFFORT="medium"
CONF="$BRIDGE/bridge.conf"
if [[ -r "$CONF" ]]; then
  conf_model="$(sed -n 's/^MODEL=//p' "$CONF" | tail -1 | tr -d '[:space:]')"
  conf_effort="$(sed -n 's/^EFFORT=//p' "$CONF" | tail -1 | tr -d '[:space:]')"
  [[ "$conf_model" =~ '^[A-Za-z0-9._-]+$' ]] && MODEL="$conf_model" || log "ignoring invalid MODEL in $CONF"
  [[ "$conf_effort" =~ '^(low|medium|high|xhigh|max)$' ]] && EFFORT="$conf_effort" || log "ignoring invalid EFFORT in $CONF"
fi
# These env vars would override the flags; the bridge's model and effort come from bridge.conf only.
unset ANTHROPIC_MODEL CLAUDE_CODE_EFFORT_LEVEL

if ! tmux has-session -t "$SESSION" 2>/dev/null; then
  log "starting $SESSION (model $MODEL, effort $EFFORT)"
  tmux new-session -d -s "$SESSION" -x 200 -y 50 -c "$WORKDIR" \
    "claude --name claude-bridge --model $MODEL --effort $EFFORT --permission-mode auto --remote-control claude-bridge \
      --dangerously-load-development-channels plugin:slack-bridge@matteoperona-plugins"

  # Claude Code shows a warning screen for development channels at every start. Confirm it only when the
  # highlighted option is the "local development" one; otherwise leave it for you (tmux attach -t claude-bridge).
  for i in {1..30}; do
    sleep 1
    pane="$(tmux capture-pane -p -t "$SESSION" 2>/dev/null)" || break
    if print -r -- "$pane" | grep -Eq '(❯|>) *([0-9]+\. *)?I am using this for local development'; then
      tmux send-keys -t "$SESSION" Enter
      log "confirmed the development-channels screen"
      break
    fi
    if print -r -- "$pane" | grep -q 'inject directly in this session'; then
      log "channel registered without a warning screen"
      break
    fi
  done
  print -r -- "$(tmux capture-pane -p -t "$SESSION" 2>/dev/null | tail -15)" >> "$LOG"
fi

# Keep the Mac awake (system sleep on power, idle sleep always) while the session lives; exit when it ends.
exec caffeinate -i -s /bin/sh -c "while tmux has-session -t $SESSION 2>/dev/null; do sleep 15; done"
