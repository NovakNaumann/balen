# Balen 2.5D Style Reference

This project uses WAKFU and DOFUS as high-level references for presentation and encounter flow, not as assets, UI copies, story references, or exact mechanical clones.

## Visual Direction

- Use a fixed isometric 2.5D view built from 2D art layers that imply volume.
- Environments should appear dimensional through painted planes, tile diamonds, object bases, fake height, shadows, parallax, and depth sorting.
- Characters are 2D sprites/portraits/animation sets placed into the same isometric space.
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
- Keep combat math and combat state separate from presentation. The scene should display tactical state; it should not own the resolver rules.
- For Milestone 0, graybox geometry may use polygons and labels. Later milestones should replace these with approved painterly isometric assets.

