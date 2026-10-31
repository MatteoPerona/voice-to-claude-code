# 2. Always on: launchd, tmux, caffeinate

Goal: the bridge session starts at login, restarts if it exits, and the Mac stays awake while it runs.

## Pieces

- [`always-on/run-bridge.sh`](../always-on/run-bridge.sh) starts Claude Code in a detached tmux session named `claude-bridge` (auto permission mode, Remote Control on, the plugin loaded with `--dangerously-load-development-channels plugin:slack-bridge@matteoperona-plugins`). It confirms the development-channels warning screen only when the "local development" option is highlighted, then holds `caffeinate -i -s` until the session ends.
- [`always-on/com.example.bridge.plist.example`](../always-on/com.example.bridge.plist.example) is a launchd agent (label `com.example.bridge`) that runs the script at login and restarts it at most once a minute.
- [`always-on/bridge.conf.example`](../always-on/bridge.conf.example) sets `MODEL`, `EFFORT` and `SESSION_RULES`.
- [`always-on/session-rules.md.example`](../always-on/session-rules.md.example) is optional extra instructions for the bridge session (see [Session rules](#session-rules-optional)).
- Log: `~/Library/Logs/claude-bridge.log`.

## Install

Defaults: the bridge folder is `~/claude-bridge` (override with the `BRIDGE_DIR` environment variable), the session works in `$HOME` (override with `BRIDGE_WORKDIR`; prefer a narrow directory).

```
mkdir -p ~/claude-bridge
cp always-on/run-bridge.sh ~/claude-bridge/
cp always-on/bridge.conf.example ~/claude-bridge/bridge.conf
cp always-on/com.example.bridge.plist.example ~/Library/LaunchAgents/com.example.bridge.plist
cp always-on/session-rules.md.example ~/claude-bridge/session-rules.md   # optional
```

Edit the plist: replace every `YOUR_USERNAME`. If you set `BRIDGE_DIR` or `BRIDGE_WORKDIR`, add them under an `EnvironmentVariables` key in the plist; launchd does not inherit your shell environment.

## Load, unload, stop

```
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.example.bridge.plist   # load
launchctl bootout gui/$(id -u)/com.example.bridge                                  # unload
tmux kill-session -t claude-bridge                                                 # stop the session
```

To stop fully, run bootout first (otherwise launchd restarts it), then kill the tmux session.

Watch it: `tmux attach -t claude-bridge` (detach with Ctrl-b d). Logs: `tail -f ~/Library/Logs/claude-bridge.log`.

## Switching model and effort

Edit `bridge.conf` (`MODEL=...`, `EFFORT=low|medium|high|xhigh|max`), then restart: `tmux kill-session -t claude-bridge`; launchd starts a new one (within the throttle interval). The script validates both values and falls back to the defaults (`claude-opus-5-5`, `medium`) with a log line if one is invalid. The script also clears `ANTHROPIC_MODEL` and `CLAUDE_CODE_EFFORT_LEVEL`, since they would override the flags.

## Session rules (optional)

If `session-rules.md` exists in the bridge folder, the script appends its text to the session's system prompt at launch (`--append-system-prompt`). The example sets a "planner, not doer" rule: the session does quick steps itself, hands longer work (builds, research, GitHub work, multi-file changes) to background subagents so it keeps answering in Slack, posts one line when it hands off and a short update when the work finishes, and does anything outward-facing (push, publish, delete, send) itself, never through a subagent.

- Enable: copy `always-on/session-rules.md.example` to `~/claude-bridge/session-rules.md`.
- Edit: change the file freely; it is plain text passed as-is (quotes and `$` are safe).
- Disable: delete or rename the file, or set `SESSION_RULES=off` in `bridge.conf`.

Changes apply on the next restart. The log's "starting" line ends with `session rules on` when the file was loaded.

## What a restart means

- Restart is the only way model, effort and session-rules changes apply.
- Each restart is a fresh conversation. No memory of the earlier one.
- Messages sent while it restarts are lost; Slack does not replay them. Re-send after the session is back.

## Limits

- The Mac must stay logged in and awake. A launchd user agent runs only while you are logged in; a closed lid without an external display may still sleep, depending on the hardware.
- Starting a development-channel session and loading the agent are steps you do yourself; an auto-mode Claude Code session may refuse to launch them.

Next: [3. Voice side](3-voice-side.md).
