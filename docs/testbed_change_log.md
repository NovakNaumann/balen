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
- Reframed Crossroads Plaza around the large fountain boulevard/market approach circled in the concept art instead of compressing all of Aethelgard into a tiny map. City rings, canals, and the Citadel are now treated as backdrop/exit context for this prototype slice.
- Added grandeur and scale references for Aethelgard as a city-state/Ring City. The Crossroads prototype now uses a larger round plaza footprint, visible plaza ring bands, radial spokes, denser mixed crowd markers, and taller edge/backdrop facades.
- Rescaled Crossroads Plaza architecture so surrounding buildings read as continuous plaza-fronting civic blocks with roofs, upper masses, awnings, arcades, towers, and foreground domes instead of random small boxes beside a walkway.
- Added architectural movement blockers, invalid-save-position recovery, and masonry/foundation fills so players cannot walk through visible plaza buildings and non-walkable edges no longer expose black void.
- Clarified Crossroads Plaza tile language: light tiles are roads, grey checker tiles are sidewalk/plaza pedestrian areas. Reopened the left/right road exits by moving frontage buildings and tents onto sidewalk parcels.
- Added manual Crossroads Plaza map authoring under `MapAuthoring` in `bootstrap_graybox.tscn`. Buildings, tents, route exits, debug spawns, crowd markers, civic banners, and the same-scene combat overlay can now be moved or duplicated in Godot through `PlazaAuthoringNode` properties instead of editing hardcoded layout arrays.
- Added editable ground authoring nodes under `MapAuthoring/Ground` so roads and sidewalk regions are visible while manually arranging the plaza in Godot.
- Added `MapAssetCatalog` presets and an `asset_id` selector on `PlazaAuthoringNode` so map pieces can be chosen as categorized assets with default footprint, height, collision, color, and render-style behavior.
- Rebuilt the Crossroads Plaza authoring layout around explicit road, sidewalk, and perimeter-building assets: the fountain boulevard now uses authored ring-road segments, sidewalks are separate two-tile bands around roads, and buildings sit beyond the sidewalks as plaza-wall frontage while leaving route exits open.
- Filled early Crossroads Plaza authoring gaps with local road-cap assets on road/roundabout seams and added perimeter building infill where dark voids appeared beyond the sidewalk line.
