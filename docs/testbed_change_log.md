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
