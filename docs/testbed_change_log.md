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
- Added the first working exploration test: party selection, click-to-move on reachable isometric tiles, one public testbed evidence interaction, same-scene combat overlay toggle, and F5/F9 debug save/load.
- Added the latest Voyage JSON source snapshot under `balen/source_data/voyage/` unchanged and read-only, updated its manifest hash/size, and preserved the Aethelgard concept art under `docs/reference/`.
- Reworked the playable test scene into Crossroads Plaza of Aethelgard, using public source cues: neutral circular heart-city, gateway/civic hub, route links to city/ringmarket/guild/citadel/archive/stable yard, and Maelin Vossmark's public caravan ledger.
- Added `docs/Balen_Codex_Playable_Test_Phase_Plan.md` as the current playable-test authority and recorded the Phase 0 governance contract in `README.md`, `docs/decisions.md`, `docs/assumptions.md`, `docs/known_issues.md`, and `docs/playtest_checklist.md`.
- Pinned Godot to `4.7.1.stable.steam` and documented the mismatch between the phase plan's older embedded source filename/hash and the latest attached Voyage JSON snapshot currently used for validation.
- Preserved four painterly realism references under `docs/reference/` for early Aethelgard sprite, portrait, species, and material direction.
