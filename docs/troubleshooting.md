# Troubleshooting

- **Slash commands do nothing.** `/model`, `/effort` typed in the channel arrive as plain text and are not run. A slash command reaches the session as a normal channel message. Change model and effort in `bridge.conf` and restart ([2-always-on](2-always-on.md#switching-model-and-effort)).
- **Two sessions, one goes silent.** Slack hands each event to one open connection, so the plugin keeps a single-instance lock: the newest session wins; the older one stays alive but silent (its `reply` errors). Kill the one you do not want, or the stale tmux session.
- **A message got no answer after a restart.** Messages sent during a restart are lost. Re-send. Each restart is also a fresh conversation.
- **Session never starts answering.** Claude Code shows a development-channels warning screen at each start. The script confirms it only when the "local development" option is highlighted. If it is stuck on another screen: `tmux attach -t claude-bridge`, handle it, detach with Ctrl-b d. Check `~/Library/Logs/claude-bridge.log`.
- **Voice posts are ignored.** The Composio app ID is probably missing from `SLACK_OWNER_APPS`; see [3-voice-side](3-voice-side.md). Restart after editing.
- **Can't launch the session from a Claude Code session.** Auto mode may block launching a development-channel session, or loading the launchd agent. Run those commands yourself in a normal terminal.
- **Mac asleep or logged out.** The bridge runs only while you are logged in and the Mac is awake.
- **Script won't run.** `zsh -n always-on/run-bridge.sh` checks syntax; make sure `tmux` and `claude` are on the script's `PATH` (it sets `/opt/homebrew/bin` and `~/.local/bin`; edit if yours differ).
