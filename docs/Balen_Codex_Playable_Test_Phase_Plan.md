# Balen Playable Test — Phase-Based Codex Build Plan

**Purpose:** give Codex an ordered, test-gated plan for building a playable Balen RPG test in Godot.  
**Primary engine:** Godot 4.x with GDScript. Pin the exact installed Godot minor version in the repository before Phase 1.  
**Presentation:** stylized 3D isometric world, painterly 2D conversation portraits, strict logical combat grid.  
**Playable hub:** Crossroads Plaza, Aethelgard.  
**Developer map:** Scale and Elevation Laboratory.  
**Source snapshot:** `balen 35_ (1)(1).json`  
**Source SHA-256:** `9029c4036288223a911da6ebaae63ec76974ee6183dc28491736a400dcd68987`  
**Companion references:** `Balen_World_Canon_Bible.md`, `Balen_Codex_Game_Testbed_Plan.md`, and `Balen Drakona Dragon Portrait Design Bible.docx`.

> **Authority note:** This document is the implementation authority for the first playable test. Where it conflicts with the earlier testbed plan, this document supersedes that plan for grid scale, movement, combat action economy, Crossroads Plaza scope, and milestone order.

---

## 1. Test objective

Build a compact, stable, replayable test that proves the following systems work together:

1. A real Balen zone can be explored at isometric scale.
2. The player can use both camera-relative WASD movement and click-to-move.
3. Exploration can transition into turn-based tactical combat in the same scene.
4. A 5-foot logical tile grid can support elevation, cover, line of sight, and creatures occupying multiple tiles.
5. Humanoids, Drakken, Worcens, Beastkin, and true dragons can be represented at consistent visual and gameplay scales.
6. Crossroads Plaza can function as a civic hub with named NPCs, ambient traffic, interactions, a short quest, and visible exits to the rest of Aethelgard.
7. Combat can end through restraint, surrender, escape, or objective completion rather than mandatory killing.
8. The latest Voyage JSON can be imported through a controlled, read-only, validated content pipeline.
9. Save/load, settings, debugging, and automated tests are strong enough for repeated external playtesting.

The target is a **25–45 minute playable test**, plus a separate developer laboratory that can be entered from the title screen or a debug menu.

---

## 2. Definition of done

The playable test is complete when a fresh player can:

- launch a desktop build from a clean install;
- start in Crossroads Plaza;
- move through the zone with WASD;
- click on the ground and path to the selected point;
- rotate, zoom, and recenter the isometric camera;
- switch the directly controlled party member;
- talk to at least three named NPCs;
- inspect at least three world objects;
- receive and complete the `testbed.crossroads_diversion` scenario;
- enter turn-based combat without loading a disconnected combat board;
- use AP, MP, a Reaction, cover, elevation, and at least one forced-movement or restraint effect;
- interact with a Large 2-by-2 creature footprint during the scenario;
- finish with at least three materially different outcomes;
- see NPC dialogue and a result summary reflect what happened;
- save, quit, reload, and retain position, quest state, party state, and scenario outcome;
- enter the Scale and Elevation Laboratory;
- view humanoid and dragon size references from 1-by-1 through 4-by-4 or larger;
- toggle grid, elevation, navigation, footprints, cover, and line-of-sight debug overlays;
- complete the build without a blocker, crash, unrecoverable pathing failure, or corrupted save.

All automated tests and content validation must pass before the test is distributed.

---

## 3. Locked design decisions

### 3.1 World and combat scale

- One logical tile represents **5 feet by 5 feet**.
- Exact engine conversion:
  - `FEET_PER_CELL = 5.0`
  - `METERS_PER_FOOT = 0.3048`
  - `CELL_SIZE_METERS = 1.524`
- Horizontal positions are stored as integer grid coordinates.
- Standard combat elevation is stored in 5-foot levels.
- Half-height props, railings, crates, and low walls use cover metadata rather than half-elevation cells.
- Visual meshes may overhang the logical control footprint, but the game must distinguish:
  - logical occupied cells;
  - collision hull;
  - visual bounds;
  - selection bounds;
  - turning clearance.

### 3.2 Creature footprints

The first test uses the following D&D-style combat-space convention:

| Creature category | Logical size | Minimum controlled space | Grid footprint |
|---|---|---:|---:|
| Human | Medium | 5 ft by 5 ft | 1 by 1 |
| Elf | Medium | 5 ft by 5 ft | 1 by 1 |
| Beastkin | Medium | 5 ft by 5 ft | 1 by 1 |
| Drakken | Medium | 5 ft by 5 ft | 1 by 1 |
| Worcen | Medium for this ruleset | 5 ft by 5 ft | 1 by 1 |
| Dragon wyrmling | Medium | 5 ft by 5 ft | 1 by 1 |
| Young dragon | Large | 10 ft by 10 ft | 2 by 2 |
| Adult dragon | Huge | 15 ft by 15 ft | 3 by 3 |
| Ancient dragon | Gargantuan | 20 ft by 20 ft or larger | 4 by 4 minimum |

Rules:

- The dragon mapping is a **gameplay footprint convention**, not a rewrite of Balen dragon biology, adulthood, culture, or social age.
- Ancient dragons default to 4 by 4 for the test, but the data model must allow larger and rectangular overrides such as 4 by 6 or 5 by 6.
- True dragon meshes should follow the portrait/design bible: western dragon anatomy, four limbs, high shoulder-rooted wings, long neck, powerful forequarters, tail, and intelligent expression.
- Drakken remain humanoid and 1 by 1. They are not scaled-down true dragons.
- Beastkin and Worcens must remain visually distinct. Beastkin are animal-hybrid people; Worcens should read as broader, more bestial, civilized werebeast-like people.

### 3.3 Exploration movement

Exploration is real time.

- **WASD:** direct, camera-relative movement of the selected party leader.
- **Left click on walkable ground:** path the selected leader to that point.
- **Left click on an interactable:** select it and move into interaction range if necessary.
- **Manual input immediately cancels an active click path.**
- **A new click path replaces the old path.**
- **Shift-click:** append one waypoint, with a small maximum queue.
- Followers use formation anchors and navigation paths rather than copying the leader’s exact trail.
- Narrow passages cause followers to queue and reform on the far side.
- Party members must not visibly teleport during normal play.

Use one movement state machine rather than two unrelated controllers:

```text
Idle
ManualMove
PathMove
InteractionApproach
ScriptedMove
CombatLocked
Disabled
```

### 3.4 Combat movement

Combat is turn based and cell based.

- Movement uses the logical grid.
- Default movement is four-neighbor cardinal movement for predictable costs.
- One legal cell costs 1 MP unless terrain or an ability changes it.
- Mouse users click a destination cell.
- Keyboard users move a tactical cursor with WASD or arrow keys and confirm movement.
- Exploration WASD must never bypass combat MP rules.
- Path previews display each traversed cell, MP cost, elevation changes, threatened cells, and invalid segments.

### 3.5 Action economy

For the first playable test:

- **6 Action Points per turn**
- **4 Movement Points per turn**
- **1 Reaction Point per round**

All costs are data-driven. Initial cost examples:

| Action | Cost |
|---|---:|
| basic weapon attack | 2 AP |
| quick utility action | 1 AP |
| standard technique | 3 AP |
| strong technique | 4 AP |
| turn-defining technique | 5–6 AP |
| reload firearm | 2 AP |
| interact with gate, lever, or restraint | 2 AP |
| enter stance | 1 AP |
| overwatch | 3 AP plus Reaction |
| protect/intercept | 2 AP plus Reaction |
| move one normal cell | 1 MP |
| enter difficult terrain | 2 MP |

### 3.6 Camera

- Fixed high isometric presentation with shallow perspective.
- Default yaw around 45 degrees.
- Default pitch around 50–60 degrees.
- Q/E rotate by 90 degrees with a short tween.
- Mouse wheel zooms within authored limits.
- Middle-mouse drag or edge pan temporarily offsets the camera.
- F recenters on the selected party leader.
- Roofs and foreground walls fade through authored occlusion volumes.
- Camera bounds must prevent the player from exposing unfinished void.

---

## 4. Canon anchors from the latest Voyage JSON

### 4.1 Aethelgard

Aethelgard is the neutral circular heart-city, organized in rings around the Magi-Knight Citadel. The implementation must keep it politically neutral, mixed in population, and visibly centered on Magi-Knight authority.

### 4.2 Crossroads Plaza

Source path:

```text
locations.Aethelgard.areas["Crossroads Plaza"]
```

Source description:

> Primary gateway plaza at the center of travel routes, markets, contracts, and public movement.

Authored connected paths:

1. Aethelgard City
2. The Ringmarket
3. Slayers Guild Headquarters
4. Citadel Training Grounds
5. Citadel Archives
6. Crossroads Stable Yard

Area level guidance is 1–5. The test must not populate the plaza with elite Citadel defenders presented as ordinary low-level street NPCs.

### 4.3 Named NPC anchors

The minimum named cast is:

| NPC | Authored area | Testbed function |
|---|---|---|
| Maelin Vossmark | Crossroads Plaza | primary quest giver, caravan permits, route contracts, result summary |
| Runa Tackwell | Crossroads Stable Yard | ordinary mounts, wagons, animal welfare, incident witness |
| Kestrel Vanehook | Crossroads Stable Yard | Desert Trotter and false-wyrm handling, nonlethal guidance |
| Tessa Bellmark | Slayers Guild Headquarters | optional contract and bestiary tutorial at the guild threshold or via dialogue transition |

Optional named cast after the minimum works:

- Rorren Ashmantle
- Orren Waymark
- Dorrik Mulebell
- Archivist Mirava Quillflame

### 4.4 Crossroads Stable Yard

The stable yard is directly connected to Crossroads Plaza. It handles horses, mules, pack animals, carts, wagons, and trained tameable mounts. Runa oversees ordinary stalls and wagon teams. Kestrel oversees reinforced wyvern runs, glide-saddle racks, and tameable false-wyrm pens.

The first test does not need to build the full stable yard. It must build:

- the stable-side plaza gate;
- a visible yard threshold;
- one reinforced pen facade;
- one water trough;
- one tack or harness rack;
- one wagon staging lane;
- enough space for the incident scenario to spill into Crossroads Plaza.

### 4.5 Desert Trotter Wyvern

Use a **Large 2-by-2** trained Desert Trotter for the scenario.

Canon behavior to preserve:

- false-wyrm, not true dragon;
- tameable working mount;
- ground-running and raptor-like;
- powerful hind legs;
- forelimbs fused with wing-limbs;
- folded wing-limbs while running;
- short glides, braking, balance, and display rather than sustained long-distance flight;
- intelligent for a mount, social, stubborn, and responsive to trust;
- dangerous when panicked or abused but not inherently malicious.

The incident must reward calming, opening space, removing threats, and safe restraint. Killing the animal is a valid player action but a poor outcome, not the expected solution.

---

## 5. Playable test flow

### 5.1 Working scenario ID

```text
testbed.crossroads_diversion
```

This scenario is testbed-authored and is not permanent canon unless separately approved.

### 5.2 Player flow

```text
Title Screen
  -> New Playable Test
  -> Crossroads Plaza arrival
  -> movement and camera tutorial
  -> speak with Maelin Vossmark
  -> inspect a questionable caravan permit
  -> question Runa or Kestrel at the stable-side gate
  -> inspect evidence around a wagon and pen latch
  -> smugglers trigger a diversion and a Desert Trotter panics
  -> same-scene tactical combat/crisis mode
  -> protect civilians, contain the Trotter, and apprehend or drive off smugglers
  -> return to real-time exploration
  -> speak with Maelin, Runa, and/or Kestrel
  -> receive result summary
  -> save and continue exploring or enter the developer laboratory
```

### 5.3 Evidence objects

At least three inspectable clues:

1. **Forged caravan seal** — inconsistent stamp depth or authority mark.
2. **Cut pen latch** — tool marks prove the opening was deliberate.
3. **Irritant scent cloth** — explains the Trotter’s panic and links the diversion to the smugglers.

The journal stores each clue as `Observed`. NPC explanations are stored as `Reported`. The final conclusion is marked `Confirmed` only after sufficient evidence or confession.

### 5.4 Crisis participants

Recommended fixture:

- four debug party members;
- two smugglers;
- one Large 2-by-2 Desert Trotter;
- Maelin, Runa, and Kestrel as protected or support NPCs;
- two ambient civilians near the incident;
- one neutral guard who enters after a delay.

Use fewer ambient crowd actors once combat begins. Nonparticipants should flee to authored safe points.

### 5.5 Crisis objectives

Primary:

- prevent civilian defeat;
- stop the Trotter from reaching an exit lane.

Secondary:

- close or secure the stable gate;
- calm, guide, or restrain the Trotter;
- apprehend both smugglers;
- preserve the wagon cargo;
- avoid lethal force.

### 5.6 Outcome families

| Outcome | Conditions | Consequences |
|---|---|---|
| Exemplary | Trotter calmed or safely restrained, both smugglers captured, no civilians defeated | strongest approval from Maelin, Runa, and Kestrel |
| Controlled | Trotter contained and civilians safe, one smuggler escapes | positive result with an unresolved lead |
| Costly | incident stopped but cargo destroyed, Trotter injured, or civilians harmed | mixed dialogue and reduced reward |
| Escape | Trotter or smugglers escape the plaza | quest completes as partial failure; world state records escape direction |
| Cruel | Trotter killed unnecessarily or civilians deliberately endangered | severe disapproval and guard intervention |
| Party defeat | party incapacitated | no permanent hard game-over; reload checkpoint or continue from a controlled failure summary |

No single `quest_complete = true` flag is sufficient. Store independent facts.

---

## 6. Repository structure

```text
/docs
  Balen_Codex_Playable_Test_Phase_Plan.md
  Balen_World_Canon_Bible.md
  Balen_Codex_Game_Testbed_Plan.md
  decisions.md
  assumptions.md
  playtest_checklist.md
  known_issues.md

/source_data
  /voyage
    balen_35_2026-07-22.json
    source_manifest.json

/tools
  import_voyage.py
  validate_content.py
  generate_test_manifest.py

/game
  project.godot
  /autoload
    DataRegistry.gd
    EventBus.gd
    GameState.gd
    SaveService.gd
    DebugService.gd
  /data
    /definitions
    /generated
    /fixtures
  /systems
    /grid
    /navigation
    /interaction
    /dialogue
    /quest
    /combat
    /ai
    /save
  /actors
    /components
    /debug_party
    /npcs
    /creatures
  /world
    /zones/crossroads_plaza
    /dev/scale_elevation_lab
  /ui
    /hud
    /dialogue
    /combat
    /journal
    /menus
    /debug
  /audio
  /art
    /placeholder

/tests
  /unit
  /integration
  /content
  /golden

/builds
```

Rules:

- The Voyage source is read-only.
- Runtime code loads compact generated data, not the full Voyage file.
- Generated data is never manually edited.
- Hand-authored testbed content uses a `testbed.` or `debug.` ID namespace.
- Named canon records retain authored names and stable IDs.

---

## 7. Core data contracts

Codex should create these contracts before large scene work.

### 7.1 `WorldScale`

```text
feet_per_cell
meters_per_foot
cell_size_meters
elevation_step_feet
elevation_step_meters
```

### 7.2 `TileCellDefinition`

```text
cell_id
grid_x
grid_z
elevation_level
walkable
surface_type
base_mp_cost
blocks_line_of_sight
blocks_projectiles
cover_north
cover_east
cover_south
cover_west
supports_footprint_sizes
area_id
```

### 7.3 `FootprintDefinition`

```text
footprint_id
width_cells
depth_cells
orientation_mode
occupied_cell_mask
turning_clearance_mask
selection_padding
visual_overhang_allowed
```

Start with rectangular masks. Keep the contract capable of irregular masks later.

### 7.4 `ActorDefinition`

```text
actor_id
display_name
species
faction
logical_size
footprint_id
reference_height_meters
visual_scale_multiplier
movement_profile
interaction_profile
combat_profile
portrait_id
```

### 7.5 `ActorRuntimeState`

```text
actor_id
scene_instance_id
world_position
grid_anchor
orientation
hp
ap
mp
reaction_available
statuses
current_intent
morale_state
quest_flags
```

### 7.6 `MovementRequest`

```text
actor_id
mode: manual | click_path | interaction | combat
start
requested_destination
resolved_destination
path_points
path_cells
mp_cost
failure_reason
```

### 7.7 `CombatActionRequest` and `CombatActionResult`

The request includes actor, ability, target, target cell, intent, cost, and selected reaction policy. The result contains validation, contact outcome, impact tier, damage, statuses, movement, morale changes, and emitted events.

UI must consume results. UI must not calculate combat outcomes.

---

## 8. Scale and Elevation Laboratory specification

Scene ID:

```text
debug.scale_elevation_lab
```

The laboratory is a developer-facing map, but it must be playable through normal controls. It exists to answer visual, grid, navigation, and animation questions before those problems are hidden inside a finished zone.

### 8.1 Required stations

#### Station A — Grid calibration floor

- 20 by 20 visible 5-foot cells.
- Meter and foot labels at 5, 10, 20, 30, and 60 feet.
- Toggle between visible checker grid and invisible gameplay grid.
- Place a 1-meter cube, 5-foot cube, and human reference silhouette.

#### Station B — Humanoid scale lineup

Spawn labeled proxy models for:

- Human
- Elf
- Beastkin
- Drakken
- Worcen

All occupy 1 by 1. The proxies are not final canon heights. They exist to establish readable differences and keep all art imports in a shared scale.

Initial proxy guidance:

| Type | Proxy purpose |
|---|---|
| Human | neutral baseline proportions |
| Elf | slightly refined, lean silhouette; not simply a resized human |
| Beastkin | humanoid frame with subtype traits such as ears, tail, feathers, horns, or fur patches |
| Drakken | humanoid draconic frame with scales, horns or ridges, and clear separation from true dragons |
| Worcen | broader werebeast-like silhouette, heavier animal anatomy, still clothed and civilized |

#### Station C — Dragon age lineup

Spawn four true-dragon proxies:

- Wyrmling: 1 by 1
- Young: 2 by 2
- Adult: 3 by 3
- Ancient: 4 by 4 minimum

For every proxy display:

- occupied cells;
- visual bounds;
- collision hull;
- selection outline;
- turning clearance;
- body anchor;
- head targeting anchor;
- wing roots;
- dialogue camera anchor.

Add a toggle for a larger ancient override to prove Gargantuan actors can exceed 4 by 4.

#### Station D — Elevation staircase

Create connected platforms at:

- 0 feet;
- +5 feet;
- +10 feet;
- +15 feet;
- +20 feet.

Include:

- standard stairs;
- broad ramp;
- narrow ramp that rejects 2-by-2 or larger footprints;
- bridge over a 10-foot drop;
- low railing;
- open ledge;
- ladder or climb marker as a future-facing interaction.

The grid overlay must show elevation numbers on each cell.

#### Station E — Door and corridor clearance

Build corridors and gates that are:

- 1 cell wide;
- 2 cells wide;
- 3 cells wide;
- 4 cells wide;
- 6 cells wide.

Test:

- whether a footprint can enter;
- whether it can turn;
- whether its visual mesh clips;
- whether followers queue correctly;
- whether path previews clearly explain rejection.

#### Station F — Cover and line of sight

Include:

- waist-high crate wall;
- full-height stone wall;
- column;
- wagon;
- smoke or concealment volume;
- destructible cover proxy;
- high-ground firing platform.

Debug display must show:

- line trace;
- body points tested;
- cover direction;
- contact modifier;
- concealment state.

#### Station G — Camera and occlusion house

Include:

- one small roofed structure;
- one tall foreground wall;
- one archway;
- one interior room;
- one balcony.

Test roof fade, wall fade, camera rotation, zoom, and target visibility.

#### Station H — Animation and equipment pads

For each actor proxy, support buttons or hotkeys for:

- idle;
- walk;
- run;
- turn 90 degrees;
- attack;
- react/block;
- hit;
- fall or defeat;
- interact;
- dragon wing fold/unfold;
- dragon breath telegraph;
- large-creature turn-in-place.

#### Station I — Combat fixture arena

Provide deterministic spawn presets:

- 1-by-1 versus 1-by-1;
- party versus 2-by-2 creature;
- party versus 3-by-3 creature;
- 4-by-4 pathing and targeting test;
- elevation and cover test;
- reaction and opportunity-control test.

#### Station J — Performance lane

Spawn adjustable counts of:

- ambient NPCs;
- combat actors;
- props;
- VFX;
- path requests.

Display frame time, draw calls, active navigation agents, and pending path jobs.

### 8.2 Laboratory acceptance tests

- Every footprint accurately occupies the expected number of cells.
- A 2-by-2 actor cannot enter a 1-cell corridor.
- A 4-by-4 actor can traverse a 6-cell route and cannot illegally rotate in insufficient clearance.
- Grid/world conversion round-trips without drift.
- WASD and click-to-move both work with the selected proxy.
- Manual input cancels click navigation without stutter.
- Elevation labels match world height.
- Line-of-sight and cover overlays update after camera rotation and actor movement.
- All test presets reset without reloading the entire application.

---

## 9. Crossroads Plaza zone specification

Scene ID:

```text
zone.aethelgard.crossroads_plaza
```

### 9.1 Zone dimensions

Recommended logical bounds:

- overall authored grid: approximately 64 by 64 cells;
- approximately 320 feet by 320 feet of logical area;
- playable core: approximately 48 by 48 cells;
- outer cells reserved for facades, camera framing, and blocked destinations.

This is a starting target, not a requirement to fill every cell with detail.

### 9.2 Layout principles

- Circular civic plaza with a readable central ring.
- Six radial routes correspond to the six authored paths.
- Main routes are at least 6 cells wide so crowds, wagons, and debug large-footprint actors can pass.
- Side routes can narrow to 2–3 cells.
- The central open space must allow a 4-by-4 footprint to stand and turn in debug mode.
- The plaza should visually point toward the Magi-Knight Citadel without making the Citadel itself fully explorable.
- Aethelgard should feel mixed, organized, neutral, and busy—not culturally generic or controlled by one nation.

### 9.3 Required landmarks

1. **Central route marker or civic dais**
   - 5-foot raised elevation;
   - broad stairs and one accessible ramp;
   - neutral heraldry;
   - usable as a combat high-ground feature.

2. **Maelin’s caravan ledger station**
   - desk, route board, permit seals, waiting bench;
   - clear interaction area;
   - sheltered but open to traffic.

3. **Stable-side gate**
   - broad gate and wagon lane;
   - visible pen threshold;
   - water trough and tack fixtures;
   - scenario breach point.

4. **Slayers Guild approach**
   - guild facade and contract board;
   - transition marker;
   - optional small foyer only after core scope is complete.

5. **Ringmarket approach**
   - market awnings, supply carts, food stalls, foot traffic;
   - blocked transition at the test boundary.

6. **Citadel Training Grounds approach**
   - wider disciplined avenue;
   - banners and guard post;
   - higher elevation transition.

7. **Citadel Archives approach**
   - raised quieter terrace;
   - controlled doorway and archive guard;
   - blocked transition.

8. **Aethelgard City approach**
   - residential and embassy-facing street facade;
   - mixed traffic and civic signage;
   - blocked transition.

### 9.4 Elevation in the playable zone

The zone must use elevation meaningfully:

- plaza ground at level 0;
- central dais at +5 feet;
- archive approach at +10 feet;
- training avenue at +5 feet;
- one ramp and one stair path between relevant levels;
- one ledge or terrace that affects cover and ranged targeting;
- one route too narrow for the 2-by-2 Trotter, creating a readable tactical constraint.

### 9.5 Modular asset list

Minimum environment modules:

- 5-foot stone floor tile;
- plaza border/curb;
- straight road tile;
- curved ring-road segment;
- 5-foot stair rise over 1–2 cells;
- broad ramp;
- low wall;
- full wall;
- arch;
- column;
- market awning;
- banner mount;
- stall counter;
- cart and wagon;
- crate and barrel set;
- bench;
- water trough;
- stable gate;
- pen fence;
- signpost;
- doorway/transition frame;
- roof and wall occlusion modules.

All modules must use consistent world scale and pivots.

### 9.6 Population

Exploration target:

- 3–4 named NPCs active;
- 10–16 ambient civilians or travelers;
- 2–4 guards or Magi-Knight-associated peacekeepers;
- 1–2 pack animals or mount proxies;
- 1 Desert Trotter in the stable threshold before the scenario.

Crowd composition must visibly reflect Aethelgard’s mixed population. Do not make every background character human.

### 9.7 Ambient behaviors

At minimum:

- walk between authored points;
- pause at stalls;
- sit on benches;
- carry a crate or ledger;
- lead a pack animal;
- queue at Maelin’s desk;
- react to the incident;
- flee to safe points when crisis mode begins;
- resume or change behavior after the outcome.

Crowd actors do not need full dialogue trees.

### 9.8 Exits

Each authored exit must have:

- visible destination name;
- transition volume;
- path-valid approach;
- a test-build response when unavailable;
- no invisible wall without explanation.

Recommended unavailable response:

> This route exists in Aethelgard, but it is outside the current playable test.

The stable-side route remains partly functional for the incident threshold.

---

## 10. Minimum playable party

Use four clearly labeled testbed characters. They are fixtures, not new canon protagonists.

| Slot | Role | Core tests |
|---|---|---|
| Vanguard | Knight | block, intercept, shield bash, control zone, restraint |
| Controller | Runescribe | rune snare, ward line, delayed trigger, area preview |
| Investigator | Slayer-Scout | inspect, observe, bow, called shot, Bestiary reveal |
| Ranged specialist | Musketeer or Drakken | reload/overwatch or breath cone/breath recovery |

For the first implementation, select **Musketeer** as the fourth fixture because it tests line of sight, cover, reload, and overwatch with less animation complexity than full Dracomancy. Keep the data contract ready for a Drakken fixture later.

Exploration behavior:

- one selected leader receives direct movement input;
- other members follow formation anchors;
- clicking a portrait or pressing 1–4 changes the leader;
- dialogue begins with the whole active party present;
- combat gives individual turns to all four.

---

## 11. Combat rules required for the test

### 11.1 Contact before damage

Every hostile action follows:

```text
validate action
  -> resolve range, line of sight, cover, elevation, and facing
  -> identify eligible reactions
  -> resolve contact
  -> resolve impact tier
  -> apply armor and resistance
  -> apply damage or tactical consequence
  -> update morale, objectives, and quest facts
```

Minimum contact outcomes:

- miss;
- defended miss;
- glancing hit;
- clean hit;
- critical hit;
- tactical success without damage.

A miss, dodge, complete block, parry, cover stop, or ward stop causes zero HP loss unless an ability explicitly defines a partial effect.

### 11.2 Facing

Actors have front, side, and rear arcs.

Required uses:

- shield block requires a protected arc;
- rear attacks may improve contact but do not automatically multiply damage;
- the Trotter’s kick threatens rear cells;
- a charge or pounce has a facing line;
- turning large creatures must validate clearance.

### 11.3 Cover and elevation

- Cover is directional.
- Low cover and full cover are distinct.
- High ground may improve line of sight and selected contact checks.
- Elevation must not grant a universal damage multiplier.
- Shoves toward a ledge display the fall risk before confirmation.

### 11.4 Reactions

Minimum reactions:

- Shield Block
- Intercept Ally
- Opportunity Strike
- Overwatch Shot
- Dodge Step or defensive reposition
- Rune Trigger

Reaction policies:

- Always
- Ask
- Never

### 11.5 Nonlethal and intent

Every attack or maneuver carries an intent:

- lethal;
- incapacitate;
- restrain;
- drive away;
- protect;
- escape.

The incident scenario must support:

- smugglers surrendering;
- smugglers fleeing;
- the Trotter calming;
- the Trotter being restrained;
- the Trotter escaping;
- civilian rescue;
- gate closure as an objective action.

### 11.6 Required abilities

Minimum party ability set:

**Knight**

- Basic Sword Strike
- Shield Bash
- Guard Stance
- Intercept
- Restraining Hold

**Runescribe**

- Arcane Bolt
- Rune Snare
- Ward Line
- Triggered Seal
- Dispel or release own rune

**Slayer-Scout**

- Bow Shot
- Observe Creature
- Called Shot: Leg
- Mark Escape Route
- Field Aid

**Musketeer**

- Musket Shot
- Reload
- Overwatch
- Suppressing Lane
- Smoke Bomb

**Scenario actions**

- Calm Trotter
- Offer Scent Cloth or Feed
- Close Stable Gate
- Cut Harness or Free Obstruction
- Protect Civilian
- Accept Surrender

### 11.7 AI

**Smugglers**

- prioritize escape;
- use cover;
- avoid fighting to death;
- surrender when cornered, wounded, or abandoned;
- one may threaten cargo or create smoke to split attention.

**Desert Trotter**

- uses a Panic meter rather than ordinary enemy malice;
- seeks open lanes away from threat;
- avoids fire, loud attacks, and crowding;
- may charge if cornered;
- calms when threats are removed, Kestrel is nearby, or trust actions succeed;
- never plans like a human opponent.

**Civilians**

- flee toward safe points;
- avoid occupied and threatened cells;
- may freeze briefly if panic is high;
- do not take full combat turns after reaching safety.

**Guard**

- protects civilians;
- attempts arrest;
- responds negatively to unjustified lethal force.

---

## 12. Phase plan

Every phase is a separate Codex work package. Codex must not begin the next phase until the current phase’s acceptance gate passes.

---

## Phase 0 — Authority, scope, and repository contract

### Goal

Eliminate ambiguity before code is generated.

### Codex work package

- Read this document, the canon bible, the prior testbed plan, and the source manifest.
- Pin the Godot version in `README.md` and `project.godot`.
- Copy the latest Voyage JSON into `source_data/voyage/` without editing its contents.
- Record source filename, timestamp, SHA-256, and import policy.
- Create `docs/decisions.md`, `docs/assumptions.md`, and `docs/known_issues.md`.
- Record this document as the current authority for the playable test.
- Define the testbed namespace rule.
- Write explicit non-goals into the repository.

### Deliverables

- repository skeleton;
- authoritative source manifest;
- documented run, test, and validation commands;
- no gameplay code beyond a minimal boot check.

### Acceptance gate

- source hash matches this document;
- source file remains byte-for-byte unchanged;
- authority order is documented;
- a reviewer can identify what the first playable test includes and excludes.

### Suggested commit

```text
chore: establish Balen playable-test authority and source manifest
```

---

## Phase 1 — Godot bootstrap and automated test harness

### Goal

Create a project Codex can safely evolve and verify.

### Codex work package

- Create Godot project.
- Add title screen with disabled placeholders for:
  - New Playable Test;
  - Scale and Elevation Laboratory;
  - Load;
  - Settings;
  - Quit.
- Add autoload skeletons:
  - `DataRegistry`;
  - `EventBus`;
  - `GameState`;
  - `SaveService`;
  - `DebugService`.
- Configure input actions for movement, interaction, camera, party selection, combat cursor, confirm, cancel, overlays, pause, quicksave, and quickload.
- Add a headless test command.
- Add formatting and static-analysis commands where supported.
- Add deterministic random seed support.

### Deliverables

- project boots to title screen;
- headless boot succeeds;
- sample unit test passes;
- input map is documented.

### Acceptance gate

- no parse errors or missing autoloads;
- project can launch from command line;
- headless test exits successfully;
- title-screen buttons are wired to placeholder scenes or clear messages.

### Suggested commit

```text
feat: bootstrap Godot project and test harness
```

---

## Phase 2 — Data definitions and Voyage import allowlist

### Goal

Create a narrow, validated data layer before scenes depend on it.

### Codex work package

- Create typed definitions for:
  - locations;
  - areas;
  - paths;
  - actors;
  - species;
  - factions;
  - footprints;
  - abilities;
  - statuses;
  - dialogue;
  - evidence;
  - quests;
  - scenario facts.
- Implement an offline importer.
- Import only the playable-test allowlist.
- Separate public fields from `hiddenInfo` and secret lore.
- Generate stable IDs.
- Create a validation report.

### Initial allowlist

**Location and areas**

- Aethelgard
- Crossroads Plaza
- Crossroads Stable Yard
- Aethelgard City
- The Ringmarket
- Slayers Guild Headquarters
- Citadel Training Grounds
- Citadel Archives

**NPCs**

- Maelin Vossmark
- Runa Tackwell
- Kestrel Vanehook
- Tessa Bellmark

**Lore**

- Population Diversity
- Worcen and Beastkin Visual Distinction
- Dragon and Drakken Distinction
- False-Wyrms
- Desert Trotter Wyverns
- Bestiary: Desert Trotter Wyvern

**Items and equipment fixtures**

- longsword or steel blade
- Knight’s Shield
- shortbow or longbow
- musket
- Smoke Bomb
- Field Dressing Kit
- Balen Slayer’s Bestiary

### Deliverables

- importer tool;
- generated compact data;
- source manifest and import report;
- content validator;
- hand-written debug-party fixtures.

### Acceptance gate

- repeated import produces identical output;
- all imported references resolve;
- hidden information is absent from player-facing generated data;
- no source record is renamed;
- invalid fixture causes validation to fail with an actionable message.

### Suggested commit

```text
feat: add validated Voyage import pipeline for playable-test content
```

---

## Phase 3 — Logical grid, elevation, and footprint engine

### Goal

Build the deterministic spatial foundation for both the laboratory and combat.

### Codex work package

- Implement world/grid conversion using 1.524 meters per cell.
- Implement tile coordinates with integer elevation levels.
- Implement footprint occupancy and placement validation.
- Implement orientation and turning-clearance checks.
- Implement A* or equivalent combat-grid pathfinding.
- Implement directional cover metadata.
- Implement debug drawing for:
  - cell borders;
  - cell coordinates;
  - elevation;
  - occupied cells;
  - blocked cells;
  - footprint bounds;
  - path previews.
- Add unit tests for all conversions and footprints.

### Deliverables

- logical grid service;
- footprint resources for 1-by-1, 2-by-2, 3-by-3, 4-by-4, and one larger override;
- path and placement preview API;
- debug overlay.

### Acceptance gate

- world-to-grid-to-world round-trip stays within tolerance;
- footprint cannot overlap blocked cells or another actor;
- 2-by-2, 3-by-3, and 4-by-4 path validation works;
- turning is rejected when clearance is insufficient;
- path cost reflects terrain and elevation rules;
- deterministic unit tests pass.

### Suggested commit

```text
feat: implement five-foot tactical grid and multi-cell footprints
```

---

## Phase 4 — Isometric camera and hybrid navigation

### Goal

Make movement feel responsive before content is built on top of it.

### Codex work package

- Implement isometric camera rig.
- Implement camera-relative WASD movement.
- Implement click-to-move using navigation paths.
- Implement movement state machine.
- Implement input arbitration.
- Implement click-to-interact approach behavior.
- Implement leader switching.
- Implement basic follower formations.
- Add camera bounds, zoom, rotation, recenter, and occlusion hooks.
- Add movement debug display.

### Deliverables

- one graybox navigation scene;
- selected leader can move with either input method;
- three followers navigate behind leader;
- camera controls work.

### Acceptance gate

- WASD begins movement within one rendered frame of input;
- WASD cancels click path cleanly;
- click destination is clamped to reachable navigation;
- clicking an interactable stops at valid range;
- followers do not deadlock in a 2-cell corridor;
- camera never exposes unbuilt void within bounds;
- rotation does not change the meaning of camera-relative WASD.

### Suggested commit

```text
feat: add isometric camera and WASD plus click navigation
```

---

## Phase 5 — Scale and Elevation Laboratory

### Goal

Prove scale, elevation, camera, pathing, and multi-cell movement in a controlled map.

### Codex work package

- Build all required laboratory stations.
- Add proxy models and labels.
- Add actor possession/selection controls.
- Add footprint, collision, visual-bound, and turning-clearance overlays.
- Add deterministic combat fixture presets.
- Add reset controls.
- Add performance counters.

### Deliverables

- laboratory accessible from title screen;
- all humanoid and dragon scale proxies present;
- elevation staircase and corridor tests present;
- cover and camera tests present;
- debug fixture menu functional.

### Acceptance gate

- all laboratory acceptance tests in Section 8.2 pass;
- large actors cannot clip through invalid routes;
- all scale labels and footprint displays agree with data;
- a reviewer can visually compare 1-by-1, 2-by-2, 3-by-3, and 4-by-4 actors;
- lab resets without restarting the application.

### Suggested commit

```text
feat: build developer scale and elevation laboratory
```

---

## Phase 6 — Crossroads Plaza graybox

### Goal

Create the full playable topology of Crossroads Plaza before art polish.

### Codex work package

- Build the 64-by-64 logical zone shell.
- Lay out central ring and six authored exits.
- Add central dais, archive terrace, training approach, stable-side gate, and market approach.
- Add navigation mesh and logical grid metadata.
- Add camera bounds and occlusion volumes.
- Add placeholder signs and exit responses.
- Add spawn points, safe points, scenario positions, and crowd paths.
- Add one clear 4-by-4 debug route through the central plaza.

### Deliverables

- complete graybox zone;
- all authored exits visible and reachable;
- stable-side incident space exists;
- elevation and cover are present;
- no final art required.

### Acceptance gate

- player can walk a full circuit with WASD and click-to-move;
- every exit has a valid path and destination label;
- 2-by-2 Trotter can move from stable gate into the plaza;
- 4-by-4 debug actor can traverse the designated main route;
- follower formation does not deadlock on stairs or ramps;
- camera and occlusion pass a full 360-degree rotation test.

### Suggested commit

```text
feat: graybox Aethelgard Crossroads Plaza and authored exits
```

---

## Phase 7 — Interaction, dialogue, named NPCs, and crowd

### Goal

Turn the graybox into a functioning civic hub.

### Codex work package

- Implement interaction detection and interaction approach.
- Implement portrait-supported dialogue UI.
- Add Maelin, Runa, Kestrel, and Tessa data and proxy actors.
- Add short introductory dialogue trees.
- Add generic ambient NPC archetypes.
- Add crowd schedules and safe-point reactions.
- Add interactable contract board, permit desk, stable gate, cart, trough, and clues.
- Add area and destination labels.
- Add minimal journal with Observed, Reported, and Confirmed categories.

### Deliverables

- named NPC conversations;
- ambient crowd;
- inspection interactions;
- basic journal;
- no combat yet.

### Acceptance gate

- player can talk to all minimum named NPCs;
- dialogue starts only after reaching interaction range;
- portraits and names match data;
- ambient NPCs do not block critical paths indefinitely;
- crowd visibly includes more than one species;
- journal records evidence provenance correctly;
- hidden source text never appears.

### Suggested commit

```text
feat: populate Crossroads Plaza with interactions and named NPCs
```

---

## Phase 8 — Turn-based combat core

### Goal

Implement the smallest complete tactical loop in the existing scene.

### Codex work package

- Implement combat entry/exit preserving exact positions.
- Implement initiative.
- Implement 6 AP, 4 MP, and 1 Reaction.
- Implement cell movement previews.
- Implement facing.
- Implement contact-before-damage resolver.
- Implement cover, elevation, line of sight, and basic mitigation.
- Implement statuses and forced movement.
- Implement reaction system and policies.
- Implement combat HUD and structured log.
- Add debug party abilities.
- Add deterministic training enemies in the laboratory.

### Deliverables

- laboratory combat fixtures are playable;
- same-scene combat transition works;
- party and enemy turns work;
- basic abilities and reactions work.

### Acceptance gate

- misses do not deal HP damage;
- AP, MP, and Reaction cannot be overspent;
- cover and elevation previews match resolution;
- large actors occupy and move through all footprint cells;
- reactions trigger once and consume Reaction;
- deterministic seed reproduces a known encounter;
- combat exit restores real-time exploration without position snapping.

### Suggested commit

```text
feat: implement grid-based tactical combat core
```

---

## Phase 9 — Crossroads Diversion scenario

### Goal

Connect exploration, evidence, dialogue, AI, combat, nonlethal outcomes, and consequence state.

### Codex work package

- Implement scenario state graph.
- Add forged seal, cut latch, and irritant cloth clues.
- Add smugglers and Desert Trotter data fixtures.
- Add crisis trigger and civilian evacuation.
- Add Trotter Panic meter and instinct AI.
- Add smuggler escape and surrender AI.
- Add scenario actions: calm, gate, restraint, protection, surrender.
- Add independent result facts.
- Add post-crisis dialogue variants and summary screen.
- Add checkpoint before crisis.

### Deliverables

- complete 25–45 minute playable loop;
- at least three outcome families reachable;
- no required lethal solution.

### Acceptance gate

- scenario can be completed without killing anyone;
- scenario can continue after partial failure;
- killing the Trotter creates a distinct negative outcome;
- both smugglers can surrender or escape;
- civilians react and can reach safety;
- Maelin, Runa, and Kestrel respond to recorded facts;
- quest journal never promotes testimony to Confirmed without evidence;
- all results survive save/load.

### Suggested commit

```text
feat: add Crossroads Diversion playable scenario
```

---

## Phase 10 — Save/load, settings, accessibility, and recovery

### Goal

Make repeated playtests reliable and recoverable.

### Codex work package

- Implement manual save, quicksave, quickload, and autosave checkpoint.
- Save:
  - zone and position;
  - selected leader;
  - party state;
  - evidence;
  - quest facts;
  - scenario phase;
  - actor defeat and escape states;
  - settings.
- Add save-version field and migration stub.
- Add settings for:
  - key rebinding;
  - text scale;
  - camera rotation speed;
  - zoom speed;
  - screen shake;
  - motion reduction;
  - grid opacity;
  - outline strength;
  - reaction prompts;
  - combat speed;
  - master/music/effects volume.
- Add stuck recovery and return-to-checkpoint options.

### Deliverables

- stable saves;
- settings menu;
- recovery tools;
- accessibility pass.

### Acceptance gate

- save/load works before and after the crisis;
- save corruption is handled with an actionable message;
- rebinding persists;
- text remains readable at supported scales;
- statuses and movement do not rely only on color;
- stuck recovery does not duplicate actors or reset quest facts.

### Suggested commit

```text
feat: add save system, settings, accessibility, and recovery
```

---

## Phase 11 — Visual, animation, audio, and readability pass

### Goal

Replace the most disruptive placeholders while preserving tactical clarity.

### Codex work package

- Apply modular Aethelgard environment kit.
- Establish painterly stylized materials.
- Add approved or clearly labeled temporary portraits.
- Improve humanoid proxy silhouettes.
- Improve Desert Trotter proxy.
- Add basic locomotion, attack, reaction, panic, and defeat animations.
- Add effects for selection, path, cover, elevation, AP, reaction, and status.
- Add ambient plaza audio and combat transition audio.
- Add distinct musket, rune, shield, and animal-panic sounds.
- Add crowd level-of-detail or culling behavior.

### Deliverables

- coherent playable presentation;
- readable combat at normal zoom;
- no need for final production-quality art.

### Acceptance gate

- the player can identify named NPCs and party roles;
- the Trotter reads as a false-wyrm mount, not a true dragon;
- Drakken and true dragon debug models remain visibly distinct;
- effects do not obscure cells or targets;
- audio communicates combat state and reactions;
- camera rotation does not reveal missing facade backs in the playable bounds.

### Suggested commit

```text
feat: improve Crossroads presentation and tactical readability
```

---

## Phase 12 — QA, performance, packaging, and external playtest

### Goal

Produce a distributable build and evidence that the test is usable.

### Codex work package

- Run full unit, integration, content, and golden tests.
- Run a scripted full-playthrough smoke test.
- Fix blockers, crashes, pathing deadlocks, save loss, and unreadable UI.
- Profile Crossroads Plaza and the laboratory.
- Add local playtest event logging with no personal data.
- Package desktop build.
- Write playtest instructions and questionnaire.
- Create known-issues list and version notes.

### Performance targets

- 60 FPS at 1080p on the agreed reference desktop at test settings;
- no synchronous parsing of full Voyage JSON at runtime;
- no per-frame full crowd path recalculation;
- fewer than 16 combat-active actors in the main crisis;
- 10–16 ambient NPCs in ordinary exploration, adjustable by quality setting;
- no multi-frame input hitch when switching from click path to WASD.

### Acceptance gate

- clean build launches outside the editor;
- all automated tests pass;
- one complete run has no blocker;
- save/load survives application restart;
- three external testers can complete the movement tutorial;
- at least two testers discover a nonlethal resolution without being told the exact sequence;
- testers can correctly explain the difference between a true dragon, Drakken, and false-wyrm after viewing the laboratory and scenario;
- known issues are documented rather than hidden.

### Suggested commit

```text
release: package Balen Crossroads playable test
```

---

## 13. Automated test matrix

### 13.1 Unit tests

- feet/cell/meter conversion;
- world-to-grid conversion;
- grid-to-world conversion;
- elevation conversion;
- footprint occupied-cell generation;
- footprint rotation and turning clearance;
- path cost;
- invalid corridor rejection;
- movement-state transitions;
- WASD cancellation of click path;
- AP/MP spending;
- Reaction refresh and consumption;
- line-of-sight and directional cover;
- contact outcome bands;
- damage and mitigation order;
- status duration;
- Panic meter thresholds;
- morale and surrender thresholds;
- quest fact aggregation;
- evidence provenance;
- save serialization and versioning;
- stable ID generation.

### 13.2 Integration tests

- selected leader moves with WASD;
- selected leader follows click path;
- party follows through stairs and corridors;
- click interactable approaches and opens dialogue;
- combat entry preserves exact positions;
- combat exit preserves positions and defeat states;
- 2-by-2 Trotter pathing through stable gate;
- gate closure changes path graph;
- civilian evacuation reaches safe points;
- Trotter can calm without reaching 0 HP;
- smugglers can surrender;
- scenario partial failure still reaches result dialogue;
- save/load before trigger;
- save/load after trigger;
- save/load after outcome;
- laboratory reset restores fixtures.

### 13.3 Content tests

- all imported IDs unique;
- all references resolve;
- Crossroads Plaza has exactly the six authored path labels;
- minimum named NPCs exist in authored areas;
- no hiddenInfo in player localization;
- Drakken are not tagged true dragon;
- true dragons are not tagged pet or false-wyrm;
- Desert Trotter is tagged false-wyrm and tameable;
- Worcens and Beastkin use distinct visual archetype tags;
- all abilities declare AP cost, targeting, range, and outcome;
- all actors declare footprint;
- all combat maps declare cell size and elevation step.

### 13.4 Golden scenario tests

Create fixed seeds for:

1. Exemplary nonlethal resolution.
2. One smuggler escapes.
3. Trotter escapes.
4. Trotter is killed.
5. Party is defeated.

For each, assert:

- final scenario facts;
- NPC reaction keys;
- reward tier;
- journal conclusion;
- actor locations or escape state;
- save/load equivalence.

---

## 14. Debug tools required for a productive test

### 14.1 Debug overlay

Toggle with F1. Show:

- FPS and frame time;
- selected actor ID;
- movement state;
- world position;
- grid anchor and elevation;
- footprint size and occupied cells;
- navigation path;
- combat path and MP cost;
- line of sight;
- cover values;
- AP, MP, Reaction;
- current quest phase;
- active scenario facts;
- current random seed.

### 14.2 Debug menu

- load Crossroads Plaza;
- load laboratory;
- reset current scene;
- start crisis;
- skip to each scenario phase;
- spawn each footprint size;
- possess selected actor;
- toggle invulnerability;
- refill AP/MP;
- force surrender;
- set Trotter Panic;
- teleport to named marker;
- show navigation mesh;
- show occlusion volumes;
- dump state to JSON;
- validate save;
- run golden fixture.

Debug commands must be unavailable or clearly separated in non-test builds.

---

## 15. Playtest checklist

Each tester should be asked to attempt these without developer intervention:

1. Start a new playable test.
2. Move with WASD.
3. Click across the plaza to move.
4. Interrupt click movement with WASD.
5. Rotate and zoom the camera.
6. Switch party leader.
7. Speak with Maelin.
8. Identify all six plaza exits.
9. Inspect the forged permit and other clues.
10. Begin the crisis.
11. Move onto and off elevated tiles.
12. Use cover.
13. Trigger one Reaction.
14. Close or interact with the stable gate.
15. Attempt to calm or restrain the Trotter.
16. Attempt to capture or drive off the smugglers.
17. Complete the scenario.
18. Save, quit, and reload.
19. Enter the developer laboratory.
20. Compare humanoid and dragon footprints.

Questionnaire topics:

- Did WASD feel immediate and predictable?
- Did click-to-move choose sensible routes?
- Was it clear which input method had control?
- Did camera rotation or occlusion hide important information?
- Did Crossroads Plaza feel like a real civic hub?
- Were the six exits readable?
- Could the player understand tile elevation?
- Could the player understand the 2-by-2 creature footprint?
- Were AP, MP, and Reaction distinct?
- Did nonlethal options feel mechanically valid rather than cosmetic?
- Did the Desert Trotter read as an animal/mount rather than a true dragon person?
- Did any pathing, collision, or save issue block progress?

---

## 16. Explicit non-goals

Do not build these before this playable test passes:

- seamless continent-scale world;
- all of Aethelgard;
- enterable Ringmarket, Citadel, Archives, or full Stable Yard;
- final character creation;
- final class/vocation progression;
- all Voyage NPCs or abilities;
- full economy or crafting;
- mounted travel;
- full free-flight controls;
- full true-dragon combat animation set;
- romance;
- multiplayer;
- procedural world simulation;
- every world political mode;
- full Abyssal Tower;
- production cinematics;
- final voice acting;
- live Voyage synchronization;
- runtime generative narration.

---

## 17. Codex execution rules

1. Implement one phase at a time.
2. Before editing, summarize the files Codex will create or change.
3. Do not begin a later phase while the current acceptance gate fails.
4. Keep commits small and phase-scoped.
5. Add or update tests with every mechanical change.
6. Run tests before reporting completion.
7. Report exact command results, not “tests should pass.”
8. Keep source JSON read-only.
9. Never expose `hiddenInfo` through UI, logs intended for players, or localization.
10. Do not invent canon to solve a technical problem. Use `testbed.` or `debug.` records.
11. Keep definitions separate from runtime state.
12. Keep UI separate from mechanical resolution.
13. Return structured action results from gameplay systems.
14. Record ambiguous decisions in `docs/assumptions.md`.
15. Record architecture changes in `docs/decisions.md`.
16. Avoid adding third-party dependencies unless the phase cannot reasonably be completed without them.
17. Preserve deterministic fixtures.
18. Do not replace working systems with large rewrites without a failing test or documented reason.
19. Do not optimize by removing error checks, validation, or recovery paths.
20. Treat a visual placeholder as a placeholder; do not silently approve it as canon art.

---

## 18. Master starter prompt for Codex

```text
You are building the first playable Balen RPG test in Godot 4.x with GDScript.

Read these files before editing:
1. docs/Balen_Codex_Playable_Test_Phase_Plan.md
2. docs/Balen_World_Canon_Bible.md
3. docs/Balen_Codex_Game_Testbed_Plan.md
4. source_data/voyage/source_manifest.json

Authority:
- The phase plan is authoritative for the first playable test.
- The Voyage JSON is read-only source material.
- The canon bible governs lore and terminology.
- Use testbed.* or debug.* IDs for authored test content that is not approved canon.

Work on Phase 0 only.
Do not implement later phases.

Before editing:
- inspect the repository;
- list the files you intend to create or change;
- identify any conflict between the documents;
- state the smallest implementation that satisfies Phase 0.

During implementation:
- keep changes reviewable;
- add validation where required;
- never modify the source JSON;
- record assumptions and decisions.

After implementation:
- run all available tests and validation commands;
- report exact results;
- list changed files;
- list remaining Phase 0 failures;
- stop without beginning Phase 1.
```

---

## 19. Reusable phase prompt template

```text
Continue the Balen playable test by implementing Phase [NUMBER — NAME] from docs/Balen_Codex_Playable_Test_Phase_Plan.md.

Do not begin any later phase.

First:
1. Re-read the phase goal, work package, deliverables, and acceptance gate.
2. Inspect the current repository and prior phase results.
3. List the exact files you will create or change.
4. State any assumptions that must be recorded.

Implementation rules:
- Preserve the Voyage source unchanged.
- Use typed GDScript where practical.
- Keep data definitions separate from runtime state.
- Add unit or integration tests for new behavior.
- Do not expose hidden lore.
- Do not invent permanent Balen canon.
- Use deterministic fixtures for tests.
- Prefer the smallest complete implementation that passes the phase gate.

When finished:
1. Run the documented headless tests.
2. Run content validation.
3. Run any phase-specific smoke test.
4. Report exact command output and failures.
5. Map each acceptance criterion to evidence.
6. Stop at the end of this phase.
```

---

## 20. Final approval checklist

A build is ready for external testing only when every item below is true:

### Project

- [ ] pinned Godot version documented;
- [ ] source manifest and hash valid;
- [ ] clean project boot;
- [ ] headless tests pass;
- [ ] content validator passes.

### Movement and camera

- [ ] WASD movement works;
- [ ] click-to-move works;
- [ ] manual input cancels paths cleanly;
- [ ] interaction approach works;
- [ ] followers navigate reliably;
- [ ] camera rotate/zoom/recenter works;
- [ ] occlusion works.

### Scale and grid

- [ ] 5-foot cell conversion is exact;
- [ ] elevations are labeled and valid;
- [ ] 1-by-1 through 4-by-4 footprints work;
- [ ] larger ancient override works;
- [ ] corridors reject invalid sizes;
- [ ] turning clearance works;
- [ ] laboratory reset works.

### Crossroads Plaza

- [ ] zone is fully traversable;
- [ ] all six authored exits exist;
- [ ] Maelin, Runa, Kestrel, and Tessa are represented;
- [ ] crowd is mixed and functional;
- [ ] stable-side incident space works;
- [ ] elevation and cover matter;
- [ ] unavailable routes explain their test-build boundary.

### Combat and scenario

- [ ] same-scene combat transition works;
- [ ] 6 AP, 4 MP, and 1 Reaction work;
- [ ] contact precedes damage;
- [ ] cover, elevation, and facing work;
- [ ] Trotter occupies 2 by 2;
- [ ] Trotter Panic AI works;
- [ ] smugglers flee and surrender;
- [ ] civilians evacuate;
- [ ] nonlethal completion works;
- [ ] at least three outcome families work;
- [ ] result dialogue reflects facts.

### Reliability

- [ ] save/load before scenario works;
- [ ] save/load after scenario works;
- [ ] checkpoint recovery works;
- [ ] no blocker or crash in full run;
- [ ] performance target met or documented;
- [ ] known issues written;
- [ ] packaged build launches outside editor.

---

## 21. Product identity check

Before approving the playable test, ask:

- Does Crossroads Plaza feel like Aethelgard rather than a generic medieval square?
- Are movement controls responsive under both WASD and click-to-move?
- Does the 5-foot grid remain readable without making exploration look like a permanent board game?
- Do large creatures occupy space believably?
- Are true dragons, Drakken, and false-wyrms mechanically and visually distinct?
- Does elevation change decisions rather than merely decorate the map?
- Can combat end without extermination?
- Do evidence and NPC knowledge affect the player’s options?
- Does the build protect Balen canon while remaining easy to expand?

If the answer to several of these is no, the test is not ready to become the foundation of the full RPG.
