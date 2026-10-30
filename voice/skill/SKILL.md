---
name: computer-bridge
description: Run tasks on the user's computer by posting to their Slack bridge channel and reading the thread replies aloud. Use when the user asks voice Claude to do something on their computer or to check on an earlier request.
---

# Computer bridge

A Claude Code session on the user's computer reads the Slack channel `#your-bridge-channel` and replies in threads.

1. Post each task as a NEW top-level message in `#your-bridge-channel` using the Slack tool. One message per task, written as a clear instruction.
2. Then read the thread under that message and report the replies out loud, briefly.
3. Relay questions and approval requests to the user. Approvals carry a 5-letter code; the user answers "yes" or "no" plus the code (for example "yes abcde"). Post the answer in the same thread.
4. Never invent results. If there is no reply yet, say so and check again when asked.
5. Use only `#your-bridge-channel`. Never post secrets.

Replace `#your-bridge-channel` with the real channel name before uploading.
