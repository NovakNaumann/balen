# Balen Known Issues

Known issues are tracked openly so playtest work does not silently treat placeholders as finished systems.

## 2026-07-22

- The repository already contains a playable Crossroads Plaza prototype, even though the new phase plan defines Phase 0 as no gameplay beyond a minimal boot check. This is accepted as pre-existing prototype work, not permission to skip later phase gates.
- The copied Voyage JSON contains the latest attached source, but the phase plan itself names an older source snapshot and hash. The manifest documents the conflict and active resolution.
- No importer exists yet; runtime systems still only validate source presence and manifest metadata.
- Crossroads Plaza art remains placeholder/procedural, not production spritework. Ground, road, sidewalk, and map objects can be manually authored now, but the plaza does not yet use final painterly tiles or a full per-tile editor paint workflow.
- The title scene still enters the prototype directly rather than presenting all later phase destinations such as the Scale and Elevation Laboratory.
- Save/load is debug-level only and not yet the robust Phase 10 save system.
