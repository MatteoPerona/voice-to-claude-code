# 1. Mac side: the Slack channel plugin

Goal: a Claude Code session on your Mac that receives messages from one Slack channel and replies in the thread. The plugin lives in its own repo: [claude-slack-bridge](https://github.com/MatteoPerona/claude-slack-bridge). Its README is the reference for setup details; this page is the short path and does not duplicate it.

## Requirements

macOS (for part 2), Bun, tmux (for part 2), Claude Code with channels support logged in with a claude.ai account, a Slack workspace where you can create and install apps. Install commands and details: [README, What you need](../README.md#-what-you-need).

## Steps

1. **Create the Slack app** from the manifest in the plugin repo (`slack-app-manifest.yml`): in Slack's app console choose to create an app from a manifest and paste it. Install it to your workspace.
2. **Collect two tokens:** the bot token (`xoxb-...`) and an app-level token with `connections:write` (`xapp-...`).
3. **Create a private channel** for the bridge and invite the bot. Note two IDs:
   - **Channel ID** (`C...`): open the channel, click its name, and the ID is at the bottom of the About tab. Or right-click the channel, choose Copy link, and take the last path segment.
   - **Your member ID** (`U...`): open your profile, then the ⋯ menu, then Copy member ID.
4. **Write the env file** `~/.claude/channels/slack/.env` from the plugin's `examples/env.example`, then `chmod 600` it. Never commit it. Variables are listed in the plugin README. Leave `SLACK_OWNER_APPS` empty for now; part 3 fills it in.
5. **Install the plugin** from inside Claude Code:

   ```
   /plugin marketplace add MatteoPerona/claude-slack-bridge
   /plugin install slack-bridge@matteoperona-plugins
   ```

   Or from a terminal:

   ```
   claude plugin marketplace add MatteoPerona/claude-slack-bridge
   claude plugin install slack-bridge@matteoperona-plugins
   ```

   The author's always-on bridge runs the plugin installed from this marketplace daily, but a from-scratch install on a fresh machine has not been tested yet. If it fails, use the plugin README's "Without the plugin system" route and open an issue.
6. **Start a session with the channel enabled.** Channels are a research preview and custom plugins are not on the approved list, so the development flag is required:

   ```
   claude --dangerously-load-development-channels plugin:slack-bridge@matteoperona-plugins
   ```

   Claude Code shows a warning screen at each start; confirm the "local development" option.
7. **First test:** post `hello` in the channel as yourself. The session should show it as a channel message and reply in the thread.

Next: [2. Always on](2-always-on.md).
