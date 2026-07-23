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

Crossroads Plaza is now driven by `balen/maps/crossroads_plaza.json`.

Use the side builder scene for map edits:

Fast launch:

```powershell
.\Open_Map_Builder.bat
```

Editor launch:

1. Open `balen/scenes/tools/map_builder.tscn`.
2. Use **Run Current Scene** / `F6`. The normal Play Project button runs the title/testbed main scene.
3. Paint roads, sidewalks, paths, and water as individual isometric terrain cells.
4. Use ellipse and ring shapes for round plazas, true circular roads, and fountain paths.
5. Place buildings, tents, route exits, spawns, banners, and combat areas as objects.
6. Press `S` in the builder to save back to `balen/maps/crossroads_plaza.json`.

The runtime scene `balen/scenes/testbeds/bootstrap_graybox.tscn` loads this JSON directly. Roads, sidewalks, and paths define walkable cells; buildings and wall-like structures block movement through their placed footprints.

Map builder controls:

- `1` / `2` / `3` / `4`: road, sidewalk, path, water.
- `B` / `L` / `E` / `R`: brush, line, ellipse, ring.
- `G`: regenerate two-tile sidewalk outlines around painted roads.
- `O`: toggle object placement.
- `Tab`: cycle object preset.
- Left mouse: paint terrain or place selected object.
- Right mouse: erase terrain or remove object.
- Middle mouse drag: pan.
- Mouse wheel: zoom.
- `S`: save.
- `F5`: reload.

Legacy `PlazaAuthoringNode` and `MapAssetCatalog` code remains available as a fallback/reference, but new map work should use the JSON builder path.

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
