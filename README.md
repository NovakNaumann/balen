# Balen RPG

Standalone Godot project workspace for the Balen RPG game.

This repository is intentionally separate from the 4872 A.D. project and should not depend on or modify any 4872 game folders or assets.

## Project Authority

Read these files before changing code or content:

1. `docs/Balen_Codex_Game_Testbed_Plan.md`
2. `docs/Balen_World_Canon_Bible.md`
3. `docs/testbed_change_log.md`

The testbed plan defines the milestone order and systems scope. The canon bible defines the lore, terminology, NPC, nation, species, secrecy, and art guardrails.

## Current Focus

Current implementation target: Milestone 0, repository and rules foundation.

Do not begin later milestones until the current milestone's exit tests pass.

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

Milestone 0 is intentionally small: boot to title screen, load a 1920x1080 2.5D graybox scene, verify service skeletons, and keep source/canon rules visible.
