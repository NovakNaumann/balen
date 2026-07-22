# Balen 2.5D Style Reference

This project uses WAKFU and DOFUS as high-level references for presentation and encounter flow, not as assets, UI copies, story references, or exact mechanical clones.

Primary Aethelgard concept reference for the current pass:

- `docs/reference/aethelgard_concept_crossroads_plaza.png`
- `docs/reference/aethelgard_concept_crossroads_plaza_circled.png`
- `docs/reference/aethelgard_plaza_ground_grandeur_reference.png`
- `docs/reference/aethelgard_plaza_scale_reference.png`

Painterly realism references for early sprite and environment direction:

- `docs/reference/painterly_reference_rookmire_curios.png`
- `docs/reference/painterly_reference_aethelgard_jeweler.png`
- `docs/reference/painterly_reference_worcen_knight.png`
- `docs/reference/painterly_reference_magi_knight_researcher.png`

## Visual Direction

- Use a fixed isometric 2.5D view built from 2D art layers that imply volume.
- Environments should appear dimensional through painted planes, tile diamonds, object bases, fake height, shadows, parallax, and depth sorting.
- Characters are 2D sprites/portraits/animation sets placed into the same isometric space.
- For Aethelgard, prioritize pale civic stone, blue-gold banners, radial roads, canals/bridges, market edges, crowd flow, and a distant Magi-Knight Citadel axis.
- Crossroads Plaza should represent the large fountain boulevard/market approach circled in the Aethelgard concept reference, not the entire city compressed into one small map.
- City rings, canals, and the Magi-Knight Citadel are scale/context/backdrop signals until their own zones are intentionally built.
- Aethelgard is a city-state and should feel grandiose: streets and plazas must leave breathing room for crowds, mounts, wagons, guards, market flow, and many Balen species.
- Because Aethelgard is the Ring City, major civic areas should favor circular plazas, ring roads, curved terraces, round fountain basins, and radial boulevards over purely rectangular town-square layouts.
- Plaza-scale buildings should frame civic space as continuous street walls, guild halls, arcade rows, tower clusters, domes, and attached market fronts. Avoid isolated prop boxes that make large roads feel empty or randomly decorated.
- Walkable space must agree with visible architecture: walls, guild fronts, arcades, towers, domes, and building foundations block movement, and non-walkable plaza edges should render as masonry/foundations rather than black void.
- In the Crossroads Plaza graybox, lighter tiles are roads and grey checker tiles are sidewalk/plaza pedestrian areas. Buildings, tents, and arcade piers belong on sidewalk/frontage parcels and must not block authored road exits.
- Crossroads Plaza map placement is manually editable in `balen/scenes/testbeds/bootstrap_graybox.tscn` under `MapAuthoring`. Use `PlazaAuthoringNode` children for buildings, tents, routes, spawns, crowds, banners, and combat areas; move or duplicate these nodes in Godot before changing runtime generation code.
- Use painterly realism for placeholder-forward assets: hand-painted material texture, readable silhouettes, warm interior craft detail, blue-gold civic cloth, brass/gold trim, pale stone, and clear species separation.
- Character sprites should remain 2.5D readable at game scale even when portraits use richer painterly detail.
- Avoid true 3D cameras, 3D mesh-first environments, free perspective orbit, or physically modeled 3D battle arenas unless a future exception is explicitly approved.
- Target a native 1920 x 1080 composition first. UI and scene framing must fit that screen cleanly.

## Environment Rules

- Exploration scenes are the primary spatial source of truth.
- A hub street, courtyard, room, road, pasture, or camp should be authored once, then reused for exploration, investigation, dialogue positioning, and tactical conflict.
- Use layers such as terrain, detail, walls, roofs, props, actors, effects, UI overlays, and combat overlays.
- Depth sorting should make actors pass behind or in front of objects without needing a 3D camera.

## Combat Flow

- Combat takes place in the actual environment where the confrontation begins.
- Do not load a separate curated battlemap for ordinary encounters.
- When combat starts, overlay tactical information on the same scene: reachable cells, movement paths, cover, objectives, reactions, and targets.
- The tactical layer may expose a readable grid or movement cells, but the world remains the same place.
- Encounter boundaries should come from local space, doors, terrain, NPC intent, morale, guards, civilians, and route exits rather than an abstract arena edge.

## Implementation Notes

- Prefer `Node2D`, `CanvasItem` layers, `TileMapLayer` or authored tile/object layers, sprite sheets, polygon placeholders, and deterministic depth ordering.
- `blocks_movement` on an authored plaza node defines its footprint as non-walkable unless the cell is an authored road exit.
- Keep combat math and combat state separate from presentation. The scene should display tactical state; it should not own the resolver rules.
- For Milestone 0, graybox geometry may use polygons and labels. Later milestones should replace these with approved painterly isometric assets.
