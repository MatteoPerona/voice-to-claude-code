# 🎙️ voice-to-claude-code

Talk to Claude on your phone and have it drive a Claude Code session on your always-on Mac, through Slack. Voice Claude posts your request to a Slack channel; the session replies in the thread; voice Claude reads the reply aloud.

```
phone voice Claude -> Composio Slack tools -> Slack channel
  -> claude-slack-bridge plugin -> Claude Code session on the Mac
  -> reply in the thread -> voice Claude reads it
```

This repo is documentation plus a runner script. The Slack channel plugin is a separate repo: [claude-slack-bridge](https://github.com/MatteoPerona/claude-slack-bridge).

## 🧰 What you need

- A Mac that stays on, logged in and awake
- [Bun](https://bun.sh), tmux
- Claude Code with channels support
- A Slack workspace you control
- A Composio account
- The Claude app with voice mode

## 🚀 Quick start

1. 💻 **Mac side** ([docs/1-mac-side.md](docs/1-mac-side.md)): Slack app, tokens, private channel, env file, install the plugin, first test.
2. 🔌 **Always on** ([docs/2-always-on.md](docs/2-always-on.md)): `run-bridge.sh` under launchd, tmux and caffeinate.
3. 📱 **Voice side** ([docs/3-voice-side.md](docs/3-voice-side.md)): connect Slack through Composio, allowlist its app ID, install the voice instructions or skill from [voice/](voice/).

## 🔄 How a request flows

1. 🗣️ You say a task. Voice Claude posts it as a new top-level message in the bridge channel (one task per message).
2. 📬 The plugin delivers it to the Mac session, which does the work.
3. 💬 The session replies in that message's thread, in short spoken-style sentences.
4. 🔊 Voice Claude reads the thread and tells you. Questions and approvals (reply "yes abcde") go back in the same thread.

More: [docs/architecture.md](docs/architecture.md).

## 🎛️ Switching model and effort

Edit `bridge.conf` (`MODEL=`, `EFFORT=`) and restart the session. See [docs/2-always-on.md](docs/2-always-on.md#switching-model-and-effort). Slash commands typed in Slack do not work.

## 🧭 Session rules (optional)

Copy `always-on/session-rules.md.example` to `~/claude-bridge/session-rules.md` to append extra instructions to the session's system prompt. The example makes the session a planner, not a doer: quick steps itself, longer work to background subagents so it stays responsive in Slack, outward-facing actions (push, publish, delete, send) never delegated. Edit the file to change the rules; delete it or set `SESSION_RULES=off` in `bridge.conf` to turn them off. Restart to apply. See [docs/2-always-on.md](docs/2-always-on.md#session-rules-optional).

## 🔒 Security

Whoever can post as you in the channel can drive your session. Use a private channel, allowlist only Composio's app ID in `SLACK_OWNER_APPS`, and remember auto permission mode skips most prompts. Details: [docs/security.md](docs/security.md).

## ⚠️ Known limits

- Slash commands arrive as plain text and are not run.
- One bridge at a time; the newest session wins.
- Messages sent during a restart are lost; each restart is a fresh conversation.
- Channels are a research preview and need `--dangerously-load-development-channels`.
- The Mac must stay awake and logged in.
- Marketplace plugin install and the voice instructions as published here are not yet tested end to end by the author.

See [docs/troubleshooting.md](docs/troubleshooting.md).

## 🙏 Credits

- [claude-slack-bridge](https://github.com/MatteoPerona/claude-slack-bridge), the channel plugin.
- [reef-digital/claude-code-slack](https://github.com/reef-digital/claude-code-slack) (Apache-2.0), a Slack port of the Discord plugin.
- Anthropic's official Discord channel plugin.

## 📄 License

[Apache-2.0](LICENSE)
