# Balen Playable Test Decisions

This file records architecture and authority decisions for the first playable test.

## 2026-07-22

- The current implementation authority is `docs/Balen_Codex_Playable_Test_Phase_Plan.md`.
- Authority order is: playable phase plan, world canon bible, earlier testbed plan, style reference, decisions, assumptions, known issues, and change log.
- Godot is pinned to `4.7.1.stable.steam`; `project.godot` also retains the `4.7` feature tag.
- Native presentation target remains 1920 x 1080.
- The first playable hub is Crossroads Plaza, Aethelgard.
- The game uses 2.5D isometric presentation with painterly realism, not a true 3D free-camera environment.
- Combat for the playable test must occur in the same authored environment as exploration.
- `testbed.*` IDs are reserved for authored playable-test content that is not permanent canon.
- `debug.*` IDs are reserved for developer laboratories, overlays, fixtures, and test controls.
- The full Voyage JSON is preserved as read-only source material and must not be loaded as runtime gameplay code.
