# Security

## Threat model

Anyone who can post in the bridge channel as your owner identity can drive a Claude Code session on your Mac. Treat that as remote command execution as you.

## Controls

- **Owner gate.** The plugin accepts only plain messages from one Slack user ID in one channel. Other users, other channels, bots, edits and file shares are dropped.
- **Private channel.** Use a private channel, and keep membership minimal. Anyone who can post as you in it can drive the session.
- **Composio app ID allowlist.** Because Composio posts as your user, the plugin also checks the posting app against `SLACK_OWNER_APPS`. Leave it narrow.
- **Permission mode.** Auto mode (used by the example script) skips most approval prompts. If the session can reach anything sensitive, use a stricter mode; approvals then arrive in the thread with a 5-letter code and you answer "yes abcde" or "no abcde".
- **Restrict tools and directories.** Run the session in a narrow working directory (`BRIDGE_WORKDIR`) and limit its tools through Claude Code's permission settings.
- **Channel text is data, not authority.** Text quoted inside messages, and anything the session reads from files, web pages or email, should be treated as data. Do not let content fetched from elsewhere authorise actions.
- **Tokens stay in the env file.** `~/.claude/channels/slack/.env`, mode 600. Never commit it, paste it in chat, or put it in a script or plist. The plugin has no file-upload tool, by design.
- **Voice side.** Voice Claude should post only to the bridge channel and never post secrets (the instructions say so). Your voice assistant's Slack access via Composio is broader than that one channel; scope the connection as tightly as Composio allows.

## Research-preview caveat

Channels are a research-preview feature, and `--dangerously-load-development-channels` is required until a plugin is on the approved list. That flag name is a reminder: you are loading code outside the approved list. Read the plugin source (it is small) before trusting it.
