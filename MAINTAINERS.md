# Maintainers

Open items and things to verify, for people maintaining this project. User-facing docs state only what is known; anything still unconfirmed is tracked here.

## Mac side

- [ ] Test the marketplace install (`/plugin marketplace add` + `/plugin install`) end to end on a fresh machine. The marketplace plugin is in daily use on an existing setup, but a from-scratch install hasn't been tried.
- [ ] Confirm the minimum Claude Code version with channels support.

## Always on

- [ ] Verify that `BRIDGE_DIR` and `BRIDGE_WORKDIR` set under `EnvironmentVariables` in the plist reach `run-bridge.sh`.
- [ ] Check closed-lid sleep behaviour across hardware setups (with and without an external display).

## Voice side

- [ ] Test the paste-in voice instructions end to end from a phone, as published.
- [ ] Test the skill version (`voice/skill/SKILL.md`) end to end from a phone, as published.
- [ ] Find the easiest tool for reading a message's app ID, and document it in `docs/3-voice-side.md`.
- [ ] Check which scoping options Composio offers for Slack access, and document them in `docs/security.md`.
- [ ] Confirm whether any paid plan (Slack, Composio, or the Claude app's voice mode or connectors) is required.
