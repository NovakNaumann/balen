# Balen Testbed Change Log

This file records implementation assumptions, source decisions, and notable changes made while building the Godot testbed.

## 2026-07-22

- Initialized this standalone repository separately from the 4872 A.D. game.
- Added the implementation plan and canon bible as project authority documents under `docs/`.
- Current target is Milestone 0 only: Godot bootstrap, repository structure, service skeletons, documented run/test commands, and initial validation support.
- Source Voyage JSON has not been added yet. Treat the Markdown handoff docs as the available authority until the original source JSON and manifest are placed under `source_data/voyage/`.
- Added the Godot project under `balen/` using Godot 4.7 project settings already created by the editor.
- Added Milestone 0 autoload skeletons: `DataRegistry`, `EventBus`, `GameState`, `SaveService`, and `DebugService`.
- Added a title screen and a generated graybox Aethelgard placeholder scene. These are debug/testbed placeholders, not approved art.
- Added headless smoke and content validation scripts. The content validator warns, but does not fail, while the original Voyage JSON is not yet present.
- Corrected the bootstrap target to native 1920x1080 and changed the graybox from true 3D to a 2.5D/isometric 2D scene with fake depth.
- Added WAKFU/DOFUS as presentation references for 2.5D isometric art and same-environment tactical combat. This is a directional reference only, not a request to copy assets or UI.
