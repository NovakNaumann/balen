# Balen RPG

Standalone Godot project workspace for the Balen RPG game.

This repository is intentionally separate from the 4872 A.D. project and should not depend on or modify any 4872 game folders or assets.

## Project Authority

Read these files before changing code or content:

1. `docs/Balen_Codex_Playable_Test_Phase_Plan.md`
2. `docs/Balen_World_Canon_Bible.md`
3. `docs/Balen_Codex_Game_Testbed_Plan.md`
4. `docs/2_5d_style_reference.md`
5. `docs/decisions.md`
6. `docs/assumptions.md`
7. `docs/known_issues.md`
8. `docs/testbed_change_log.md`

The playable test phase plan is the current implementation authority for the first playable Crossroads Plaza test. The canon bible defines lore, terminology, NPC, nation, species, secrecy, and art guardrails. The earlier testbed plan remains useful background when it does not conflict with the phase plan. The 2.5D style reference defines how Balen should interpret isometric environment, character, art, and same-environment combat presentation.

## Version Pin

Godot executable: `godot.windows.opt.tools.64.exe`

Pinned engine version for this repository: `4.7.1.stable.steam`

`balen/project.godot` also records the Godot feature tag `4.7` and the Balen version pin.

## Current Focus

Current implementation target: playable test Phase 0 governance over the existing Crossroads Plaza prototype.

Do not begin a later phase until the current acceptance gate is documented and the headless checks pass.

## Godot Project

Godot project root: `balen/`

Local Godot tools executable expected at the repository root:

```powershell
.\godot.windows.opt.tools.64.exe
```

Launch the editor:

```powershell
.\godot.windows.opt.tools.64.exe --path .\balen
```

Run the current headless checks:

```powershell
cd .\balen
..\godot.windows.opt.tools.64.exe --headless --check-only --path .
..\godot.windows.opt.tools.64.exe --headless --path . --script res://scripts/tests/test_runner.gd
..\godot.windows.opt.tools.64.exe --headless --path . --script res://scripts/tools/content_validator.gd
```

The current working test is intentionally small: boot to title screen, load a 1920x1080 2.5D Crossroads Plaza scene in Aethelgard, select and move DEBUG party markers, inspect Maelin Vossmark's public caravan ledger, toggle the same-scene combat overlay, and quick save/load scene state.

## Manual Map Editing

Crossroads Plaza can be manually shaped in Godot:

1. Open `balen/scenes/testbeds/bootstrap_graybox.tscn`.
2. Expand `MapAuthoring`.
3. Move, duplicate, rename, or resize `PlazaAuthoringNode` children under `Buildings`, `Tents`, `Routes`, `Spawns`, `Crowd`, `Banners`, and `CombatAreas`.
4. Use `grid_position` and `footprint` for tile placement. For buildings and walls, enable `blocks_movement` so click-to-move respects the visible footprint.

The light road and grey sidewalk base is still procedurally generated for this pass. The manually authored nodes control the physical plaza pieces layered over it.

Working test controls:

- Left click: select a DEBUG party member or inspect evidence.
- Right click: move the selected party member to a reachable plaza tile.
- `Tab`: show or hide the same-environment combat overlay.
- Mouse wheel: zoom.
- `Q` / `E`: rotate the isometric view by 90 degrees.
- `F5` / `F9`: debug quick save/load.
- `Esc`: return to title.

## Testbed Namespace Rule

Use `testbed.*` for authored playable-test content that is not approved permanent canon. Use `debug.*` for developer-only fixtures, laboratories, overlays, and test controls. Runtime code must not load the full Voyage source JSON directly; it should use compact imported/generated data once the importer phase exists.

## Explicit Non-Goals For The First Playable Test

Do not build continent-scale travel, all of Aethelgard, full character creation, final class progression, a full economy, mounted travel, free-flight, romance, multiplayer, procedural world simulation, final cinematics, final voice acting, live Voyage synchronization, or runtime generative narration before the Crossroads playable test passes.
