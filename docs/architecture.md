# Architecture

```
phone: voice Claude
  -> Composio Slack tools (posts as your Slack user + Composio's app)
  -> Slack channel (private)
  -> claude-slack-bridge plugin (Socket Mode, on the Mac)
  -> Claude Code session (tmux, launchd)
  -> reply tool (posts as the Slack app bot, same thread)
  -> voice Claude reads the thread aloud
```

## Identity design

- **Inbound is you.** Voice Claude posts through Composio with your user identity. The plugin accepts only your user ID, and an app-posted message additionally needs its app ID in `SLACK_OWNER_APPS`.
- **Outbound is the app bot.** Replies come from the Slack app's bot token. The plugin ignores bot messages, so its replies never loop back in.
- **One thread per task.** Each task is a new top-level message; replies go in its thread, so voice Claude can be pointed at "the thread about X".

## Permission relay

Claude Code's native permission relay sends a pending approval to the channel with a 5-letter code. Reply `yes abcde` or `no abcde`; the plugin tolerates dictation ("Yes, abcde."). This works by voice. In auto mode most routine actions never prompt. See the [plugin README](https://github.com/MatteoPerona/claude-slack-bridge) and the [channels reference](https://code.claude.com/docs/en/channels-reference).

## Single instance

Slack delivers each event to only one open connection, so the plugin keeps a lock; the newest session takes over.
