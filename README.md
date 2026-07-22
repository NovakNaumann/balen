# Balen RPG

Standalone Godot project workspace for the Balen RPG game.

This repository is intentionally separate from the 4872 A.D. project and should not depend on or modify any 4872 game folders or assets.

## Project Authority

Read these files before changing code or content:

1. `docs/Balen_Codex_Game_Testbed_Plan.md`
2. `docs/Balen_World_Canon_Bible.md`
3. `docs/2_5d_style_reference.md`
4. `docs/testbed_change_log.md`

The testbed plan defines the milestone order and systems scope. The canon bible defines the lore, terminology, NPC, nation, species, secrecy, and art guardrails. The 2.5D style reference defines how Balen should interpret isometric environment, character, and combat presentation.

## Current Focus

Current implementation target: Milestone 1 working exploration test.

Do not begin later systems until the current working test remains launchable and the headless checks pass.

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

The current working test is intentionally small: boot to title screen, load a 1920x1080 2.5D Aethelgard graybox, select and move DEBUG party markers, inspect one evidence marker, toggle the same-scene combat overlay, and quick save/load scene state.

Working test controls:

- Left click: select a DEBUG party member or inspect evidence.
- Right click: move the selected party member to a reachable courtyard tile.
- `Tab`: show or hide the same-environment combat overlay.
- Mouse wheel: zoom.
- `Q` / `E`: rotate the isometric view by 90 degrees.
- `F5` / `F9`: debug quick save/load.
- `Esc`: return to title.
