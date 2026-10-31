# 3. Voice side: Claude app + Composio + Slack

Goal: voice-mode Claude in the Claude app can post to and read your bridge channel.

## Connect Slack through Composio

1. Create a Composio account and connect your Slack workspace in Composio. Follow Composio's current prompts; the screens change and are not reproduced here.
2. Make Composio available to the Claude app as a connector, following the Claude app's and Composio's current instructions.
3. Check that Claude, in voice mode, can read and post in your bridge channel. (The author verified read and post in voice mode on 2026-10-29.)

## Why the posts arrive as you

Composio posts to Slack with your own Slack user, not a bot. A message therefore carries your user ID, plus Composio's own app identity. The plugin only accepts your user ID, and for messages from an app it additionally requires that app to be allowlisted in `SLACK_OWNER_APPS`. This keeps a random app posting as "you" from being accepted.

## Find the app ID and allowlist it

1. Post a test message from voice Claude in the bridge channel.
2. On the Mac, list the channel's recent messages with the bridge's bot token (uses the env file from part 1):

   ```
   bun --env-file ~/.claude/channels/slack/.env -e 'const r = await fetch(`https://slack.com/api/conversations.history?channel=${process.env.SLACK_CHANNELS}&limit=10`, { headers: { Authorization: `Bearer ${process.env.SLACK_BOT_TOKEN}` } }).then((r) => r.json()); if (!r.ok) console.log(r.error); for (const m of r.messages ?? []) console.log(m.user, m.bot_id ?? "-", m.app_id ?? "-", (m.text ?? "").slice(0, 40))'
   ```

   Each line is user, bot ID, app ID, start of text. Find your test message: your member ID, a bot ID (`B...`), and an app ID (`A...`). The plugin checks the app ID, not the bot ID. Lines from the bridge's own replies show the bridge bot's user ID; don't allowlist that app.
3. Put the value in `~/.claude/channels/slack/.env`:

   ```
   SLACK_OWNER_APPS=<composio-app-id>
   ```

   Comma-separated if there are several. Restart the bridge ([restart notes](2-always-on.md#what-a-restart-means)).
4. Post again; the session should now answer.

## Install the voice instructions

Two options; both say the same thing.

- **Paste-in:** copy the block in [`voice/voice-claude-instructions.md`](../voice/voice-claude-instructions.md) into the Claude app where it applies to your voice chats (profile preferences or project instructions; check the app's current settings for where). Replace `#your-bridge-channel`.
- **Skill:** [`voice/skill/SKILL.md`](../voice/skill/SKILL.md) packages the same text as a skill. The Claude app supports uploaded skills, but the upload steps and menu names change; check the app's current UI and help pages rather than relying on this repo. Replace the channel name before uploading.

Neither has been tested by the author from a phone as published here (unverified); test once and adjust the wording.

## How to talk to it

- One task per message: say "tell my computer to ...". Voice Claude posts it as a new top-level message, which starts a new thread.
- Wait for the thread reply, then ask "any reply yet?" if it has not read it out.
- Questions and approvals come back through voice Claude. Answer in plain words; approvals are "yes" or "no" plus a 5-letter code ("yes abcde").
