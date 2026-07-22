# Balen RPG Testbed — Codex Build Plan

**Document purpose:** implementation plan for a playable Balen vertical-slice testbed  
**Primary implementation target:** Godot 4.x, GDScript, desktop  
**Presentation:** 2.5D isometric tactical CRPG using 3D environments and characters with painterly 2D dialogue portraits  
**Combat:** turn-based, party-based, positional, contact-before-damage  
**Source snapshot:** `balen 35_ (1).json`, Voyage.IO Heroes V35, uploaded/modified 2026-07-22 04:52:46 UTC  
**Pinned source mods:** `zxKkFzisLYR-` v14 and `2LDeiL6rEHva` v2  
**Supporting art references:** `Balen Drakona Dragon Portrait Design Bible.docx` and `Narrator Instruction Hierarchy.txt`  
**Companion canon reference:** `Balen_World_Canon_Bible.md`

---

## 1. Product statement

> **Balen is a painterly isometric political-fantasy CRPG in which a culturally mixed party investigates dangerous problems, navigates rival nations, and fights tactical battles where knowledge, preparation, restraint, and identity matter as much as raw power.**

The testbed is not a miniature open-world action RPG. It is a focused proof that Balen's most distinctive systems work together:

- real-time exploration that enters turn-based combat without changing to an unrelated arena;
- party positioning, reactions, cover, weak points, and nonlethal outcomes;
- evidence-led investigation and a journal that distinguishes fact from testimony and theory;
- companion and faction reactions;
- public lore separated from private and endgame truth;
- a readable isometric presentation supported by large painterly portraits;
- data-driven content imported from the Voyage.IO world without letting the engine rewrite canon.

The testbed should be fun as a small game while remaining intentionally expandable.

---

## 2. Non-negotiable design pillars

### 2.1 A living world, not a protagonist's stage

NPCs have schedules, loyalties, beliefs, duties, prejudices, affection, fear, and limited knowledge. They do not exist only to wait for the player. A solved contract changes the people, prices, patrols, rumors, and relationships around it.

### 2.2 No nation is the default villain

Drakona, the Holy Crown, Valen, Sylvera, and Aethelgard each require defensible values, internal disagreements, ordinary citizens, noble actors, selfish actors, laws, hypocrisies, and blind spots. Conflict comes from history, resources, policy, fear, pride, and incompatible priorities.

### 2.3 Contact precedes damage

An attack is never automatic damage exchange. Resolve intent, range, line of effect, attack vector, defense vector, and contact result first. Damage or another consequence occurs only when contact or a tactical success is established.

### 2.4 Knowledge is gameplay

Tracks, residue, witness statements, damage patterns, bestiary research, faction records, and companion expertise should unlock mechanical options. Research can reveal a creature's behavior, legal status, resistances, weak points, or likely motive.

### 2.5 Restraint is a valid form of victory

Combat may end through surrender, retreat, restraint, arrest, broken morale, evacuation, negotiation, objective completion, or escape. A true dragon is a person and citizen, not a routine monster target. Even a lethal battle should have a stated intent.

### 2.6 Canon is data, not improvisation

Codex may implement systems and placeholders, but it must not silently invent gods, nations, borders, species, rulers, currencies, hidden history, or replacement versions of authored characters.

---

## 3. Testbed definition of done

The testbed is complete when a new player can launch the game and finish one 45–90 minute scenario containing all of the following:

1. Explore a compact Aethelgard hub district in real time.
2. Speak with at least six NPCs using portrait-supported dialogue.
3. Accept a contract with at least two plausible interpretations.
4. Gather physical evidence at three investigation sites.
5. Add entries to a layered evidence journal.
6. Select and equip a four-character debug party.
7. Travel to a nearby road/wilderness encounter map.
8. Enter turn-based combat without loading a disconnected battle board.
9. Use movement, cover, elevation, reactions, at least one weak point, and at least one non-damage maneuver.
10. Finish the encounter through at least three possible resolutions, one of which is nonlethal.
11. Return to Aethelgard and see faction, companion, journal, and world-state consequences.
12. Save, quit, reload, and preserve all relevant state.
13. Run automated tests that validate content references and core combat math.

The testbed does **not** need the whole continent, every profession, all 90 authored NPCs, every bestiary creature, the complete Abyssal Tower, romance, crafting depth, mounted travel, full dragon flight, or a final art pass.

---

## 4. Recommended vertical-slice scenario

### 4.1 Working title

**The Ash on the Wool**

### 4.2 Premise

Livestock and two caravan guards have been injured outside Aethelgard. Witnesses insist a dragon attacked. The evidence initially supports several explanations:

- a false-wyrm is hunting near the road;
- a smuggler is staging dragon signs to frighten patrols away;
- a wounded young true dragon is hiding nearby;
- alchemical waste or a damaged rune caused burns that witnesses misread as breath fire.

The authored testbed solution should combine two causes rather than reveal a random supernatural conspiracy. Example: smugglers disturbed a territorial Emberwing Wyvern and then planted larger claw marks to implicate a true dragon. A young Drakonan envoy becomes trapped in the resulting panic.

### 4.3 Why this scenario is useful

It tests:

- the legal and moral difference between true dragons and false-wyrms;
- evidence collection and conflicting witness testimony;
- faction pressure from Aethelgard, Drakona, the Slayers, and merchants;
- combat against an established creature rather than an invented species;
- a nonlethal objective involving a sentient person;
- reputation consequences based on method, not only success;
- the Bestiary as an active gameplay tool.

### 4.4 Resolution families

At minimum, support these endings:

1. **Clean hunt:** identify and defeat or drive off the false-wyrm, rescue the envoy, expose the smugglers.
2. **Arrest:** trap the smugglers, calm or redirect the creature, and deliver evidence to authorities.
3. **Partial success:** save civilians but lose the smugglers or kill a protected creature unnecessarily.
4. **Diplomatic failure:** attack the envoy or misidentify a true dragon, triggering a serious Drakonan incident.
5. **Retreat:** escape with evidence and return for reinforcements; the contract remains active in a changed state.

Do not use a single binary quest flag. Record independent outcomes.

---

## 5. Playable test party

Use an internal-only four-character debug party. These characters are mechanical test fixtures, not new canon protagonists. Their names and portraits must be clearly marked `DEBUG` and excluded from release builds.

| Slot | Mechanical role | Power tradition | Systems exercised |
|---|---|---|---|
| Vanguard | Knight | martial / stamina | guard zones, shield reactions, interception, challenge, restraint |
| Controller | Runescribe | mana / prepared runes | circles, brands, wards, surfaces, delayed triggers |
| Investigator | Slayer-Scout | stamina / tools | Bestiary, weak points, tracking, ranged attacks, clean harvest |
| Mobile striker | Drakken Dracomancer or Valenian Musketeer | breathing or ammunition | flight-aware positioning and breath rhythm, or reload/suppression/penetration |

The content layer must make it easy to swap the fourth slot between a Drakken and a Musketeer. This proves that power traditions are not only differently colored spells.

Later integration can replace the debug party with canonical parties such as:

- Silas Dey Corvand, Sylvareth, Kaelith, and Pyrrhos;
- Kazien Cranehollow and Commander Valyrine Dawnmere, supplemented by appropriate allies;
- a custom player character and recruited companions.

---

## 6. Core gameplay loop

```text
Receive problem
  -> question witnesses and inspect records
  -> choose party, tools, and equipment
  -> travel to the site
  -> explore and gather evidence
  -> update theories and unlock tactical information
  -> negotiate, fight, evade, arrest, rescue, or retreat
  -> return to consequences
  -> update world state, relationships, journal, and available work
```

The loop should reward preparation without making investigation mandatory for basic completion. A player may rush into danger, but the game should show the cost of acting without knowledge.

---

## 7. Presentation and camera

### 7.1 World rendering

- Fully 3D environments and characters.
- Isometric-style camera with shallow perspective rather than strict orthographic projection.
- Default yaw around 45 degrees and pitch around 50–60 degrees.
- Optional 90-degree camera rotation.
- Smooth zoom within authored limits.
- Occlusion fading for roofs, walls, and tall foreground objects.
- Interiors use cutaway walls or authored visibility volumes.

### 7.2 Dialogue presentation

- Keep the 3D scene visible behind the dialogue UI.
- Display a large painterly portrait for the active speaker.
- Support portrait variants by expression and form.
- Allow two portraits for confrontations and relationship scenes.
- True-dragon portraits use a wider crop that shows head, long neck, upper chest, wing roots, and suitable adornment.
- Portraits are character art, not monster cards.

### 7.3 Art style

Use stylized realism with painterly materials:

- clear silhouettes;
- moderately simplified geometry;
- grounded clothing and equipment;
- hand-authored texture variation;
- restrained effects;
- readable weapons, stances, and faction colors;
- atmosphere without muddy combat readability.

Do not target photorealism, anime, pixel art, glossy mobile-game rendering, or exaggerated low-poly comedy.

### 7.4 Placeholder art rule

The first functional build may use primitive geometry and labeled portrait frames. Placeholder assets must be visually obvious and must never be confused with approved canon designs.

---

## 8. Combat design specification

### 8.1 Entry and exit

Exploration runs in real time. When a hostile action, detection state, scripted confrontation, or player command begins combat:

1. freeze ordinary world simulation;
2. preserve exact positions and facing;
3. establish participants, objectives, intent, surprise, and initiative;
4. enter turn-based mode in the same scene;
5. return to real time after all hostile intents end or an objective resolves.

Do not teleport units to predefined battle slots.

### 8.2 Spatial model

Use a **soft grid** over a navigation mesh:

- movement is continuous over `NavigationRegion3D`;
- distances are measured in world meters;
- preview paths may snap to small increments for readability;
- ability areas use actual geometry;
- large creatures may occupy custom footprints;
- flying units use authored flight nodes or layered navigation in the testbed, not unrestricted six-axis movement.

For the first build, support ground units plus one creature that can hop or glide between designated elevated perches. Full aerial combat is out of scope.

### 8.3 Turn structure

Default player turn:

- **2 Action Points**;
- movement budget that may be split around actions;
- **1 Reaction** per round;
- free facing and inspect actions;
- one limited free interaction where clearly appropriate.

Common costs:

| Action | Cost |
|---|---:|
| standard attack | 1 AP |
| basic ability | 1 AP |
| major ability | 2 AP |
| reload | 1 AP unless an ability changes it |
| drink or apply item | 1 AP |
| help ally | 1 AP |
| interact with mechanism | 1 AP |
| enter or change stance | 1 AP |
| prepare overwatch | 1 AP + reaction |
| draw a simple prepared rune | 1 AP |
| extend or empower a circle | 1 AP per stage |

Do not hard-code these costs into UI logic. Read them from ability data.

### 8.4 Contact-before-damage pipeline

Every attack or hostile maneuver follows this pipeline:

```text
Intent
  -> validate source, target, range, line of effect, resources
  -> choose attack vector
  -> collect defense vectors and situational modifiers
  -> resolve contact
  -> resolve impact tier
  -> apply armor and mitigation
  -> apply consequences
  -> update morale, reactions, objectives, and combat log
```

Valid contact outcomes:

- critical failure;
- miss;
- defended miss;
- glancing hit;
- clean hit;
- critical hit;
- tactical success without damage.

Misses, dodges, clean blocks, parries, complete cover stops, and complete ward stops cause no HP loss unless an ability explicitly defines a partial effect.

### 8.5 Testbed hit model

The Voyage data defines principles rather than one mandatory numerical formula. Use the following transparent implementation for the testbed:

```text
attack_total = d20 + attacker_accuracy + ability_accuracy + situational_attack
contact_dc   = 10 + target_defense + situational_defense
margin       = attack_total - contact_dc
```

Recommended outcome mapping:

| Result | Rule |
|---|---|
| critical failure | natural 1 or margin <= -10 |
| miss | margin < 0 and no active defense presentation is appropriate |
| defended miss | margin < 0 and block/parry/dodge/ward/cover is the primary reason |
| glancing hit | margin 0–3 |
| clean hit | margin 4–8 |
| strong clean hit | margin 9–12; still a clean contact, but may use Great impact |
| critical hit | natural 20 or margin >= 13, subject to immunity rules |
| tactical success | maneuver-specific success that changes state without ordinary damage |

All thresholds belong in a rules resource, not scattered scripts.

### 8.6 Impact and damage

Keep contact and impact separate. Use the source JSON's impact ladder:

| Impact tier | Modifier |
|---|---:|
| Mixed | 0.20 |
| Basic / Glancing | 0.35 |
| Success | 0.50 |
| Great | 0.75 |
| Critical | 1.00 |

Suggested mapping:

- glancing contact -> Basic impact;
- ordinary clean contact -> Success impact;
- strong clean contact -> Great impact;
- critical contact -> Critical impact;
- abilities may explicitly force a lower or higher impact tier within limits.

Use only the single declared attack source. Do not add every equipped weapon, off-hand item, attribute score, skill score, success margin, level, and vocation bonus together unless a specific ability explicitly does so.

Recommended damage sequence:

```text
raw_damage = roll_or_select_declared_source_damage()
impact_damage = floor(raw_damage * impact_modifier)
impact_modifier_after_armor = max(0.10, impact_modifier - armor_impact_reduction)
armor_scaled_damage = floor(raw_damage * impact_modifier_after_armor)
final_damage = max(0, armor_scaled_damage - matching_flat_DR - matching_typed_resistance)
```

Default armor impact reductions:

- light armor: `0.05`;
- medium armor: `0.10`;
- heavy armor: `0.15`;
- active shield brace: additional `0.05`.

Physical DR applies only to physical damage after contact. Typed resistance applies only to matching damage. Energy damage bypasses physical DR unless its data says otherwise. A complete block, parry, dodge, cover stop, or ward stop bypasses this damage calculation and produces zero damage.

### 8.7 Damage types

Support these source damage types in the data model even when the testbed uses only a subset:

- piercing;
- slashing;
- bludgeoning;
- poisoning;
- fire;
- lightning;
- wind;
- water;
- arcane;
- light;
- dark;
- psychic;
- frost.

The testbed must include at least physical, fire, arcane, and one resistance interaction.

### 8.8 Reactions

Implement a generic reaction system before bespoke class reactions. A reaction contains:

- trigger event;
- eligible reactor;
- conditions;
- resource cost;
- priority;
- optional target selection;
- effect;
- AI policy;
- player prompt policy.

Initial reactions:

- shield block;
- parry;
- dodge step;
- protect ally / interception;
- overwatch shot;
- counterspell or ward flare;
- opportunity strike;
- prepared rune trigger.

Allow players to configure reaction behavior as `Always`, `Ask`, or `Never` for routine triggers.

### 8.9 Cover, concealment, and elevation

- Cover blocks line traces and grants defense based on exposed body percentage.
- Concealment affects contact but does not behave as physical armor.
- Partial concealment baseline: roughly 20% miss pressure.
- Total concealment, invisibility, phasing, or displacement baseline: roughly 50% miss pressure when fiction supports it.
- Use the highest applicable concealment tier, not additive stacking.
- Elevation changes line of sight, range, shove danger, and selected ability modifiers.
- UI must distinguish cover from concealment.

### 8.10 Weak points and called shots

A called shot normally trades accuracy for a state change. Examples:

- wing joint -> grounded or flight disabled;
- weapon hand -> disarm pressure;
- leg or tendon -> reduced movement;
- throat after breath -> delayed breath recovery;
- rune plate -> ward disruption;
- musket mechanism -> jam;
- scale seam -> temporary armor reduction;
- sensory organ -> impaired perception.

Weak points may be:

- visible by default;
- revealed by evidence;
- revealed by the Bestiary;
- revealed by a successful observe action;
- created by another ability.

Do not reduce all weak points to bonus damage.

### 8.11 Morale and intent

Every combatant has an intent:

- kill;
- incapacitate;
- arrest;
- restrain;
- drive away;
- protect;
- delay;
- capture;
- escape.

Every non-mindless combatant has morale state:

- steady;
- pressured;
- wavering;
- broken;
- surrendered or routed.

Morale changes from:

- leader defeat;
- severe injury;
- isolation;
- objective failure;
- overwhelming threat;
- successful intimidation;
- rescue or reinforcement;
- faction doctrine;
- relationship to allies.

The UI should display observable morale, not hidden exact numbers, unless an ability reveals them.

### 8.12 Defeat states

At zero HP, choose a fiction-appropriate state rather than automatically killing:

- wounded;
- stunned;
- prone;
- disarmed;
- routed;
- surrendered;
- captured;
- unconscious;
- pinned;
- restrained;
- disabled;
- dying;
- dead.

Intent, damage type, final blow, stakes, species, and authored flags determine the result. Important NPCs must not die from vague narration or an unsupported single line.

### 8.13 Boss design

No boss should be only a large HP pool. Testbed boss encounter requirements:

- at least one changing objective;
- at least one breakable defense or weak point;
- at least one terrain interaction;
- at least one nonlethal or escape resolution;
- a visible behavioral shift rather than an arbitrary immunity phase.

For a true dragon encounter, the main objective should be survival, interruption, evidence presentation, rescue, restraint, or negotiated de-escalation—not routine extermination.

---

## 9. Distinct power traditions

### 9.1 Normal magic

- Resource: Mana.
- Most casters draw from blood mana.
- Overuse creates fatigue, strain, and possible injury.
- Abilities should show texture, cost, and risk.
- Intelligence improves control and design, not automatically maximum Mana.

### 9.2 Dracomancy

- Resource: Breathing rhythm.
- Used by true dragons and Drakken.
- Breath-linked spells recover quickly when breathing is controlled.
- Winded, restrained, choking, smoke-filled, underwater, or frozen conditions interfere with recovery.
- Do not present Dracomancy as ordinary Mana spellcasting with a dragon icon.

Testbed representation:

```text
Breath state: Ready -> Exhaled -> Recovering -> Ready
```

A strong breath action may consume the current exhale and require one or more turns of recovery. Smaller dracomantic techniques may advance recovery differently.

### 9.3 Bladesinging and Sublime Arts

- Resource: Stamina, rhythm, stance, and momentum.
- Bladesinging guides ambient mana through movement and a chosen element rather than spending normal internal Mana.
- Ninefold and related Sublime techniques should look like perfected martial acts, not generic spells.
- Use counters, footwork, binds, throws, disarms, redirection, and controlled bursts.

### 9.4 Runes and circles

- Resources: Mana, preparation time, charges, ink/chalk/materials, geometry, and position.
- Simple prepared runes may be cheap because the written structure performs the shaping.
- Major circles require time, materials, space, and protection.
- A Runescribe can brand, ward, link triggers, create thresholds, drain Mana, disrupt inscriptions, and extend a circle over multiple turns.

The testbed must include:

- one touch or weapon-delivered brand;
- one placed trap circle;
- one defensive threshold;
- one multi-turn empowered circle.

### 9.5 Valenian technology

- Resources: ammunition, reload actions, mechanisms, heat, deployables, powder charges, and maintenance.
- Firearms can suppress movement, penetrate armor, damage cover, create smoke, or force morale checks.
- A jam is a tactical state, not a random annoyance with no counterplay.

---

## 10. Exploration and interaction

### 10.1 Player controls

Initial desktop controls:

- left-click: move, interact, select;
- right-click: context cancel or rotate camera when held;
- middle mouse or keyboard: rotate camera;
- mouse wheel: zoom;
- `Tab`: highlight interactables;
- `Space`: pause or advance in turn mode as context requires;
- number keys: select party members or abilities;
- `J`: journal;
- `M`: local/world map;
- `I`: inventory;
- `C`: character sheet;
- `F5/F9`: quick save/load in debug builds.

Keep input actions abstracted in Godot's Input Map.

### 10.2 Interaction model

Every interactable exposes verbs rather than a single generic click when relevant:

- inspect;
- speak;
- use;
- take;
- open;
- disable;
- study;
- harvest;
- mark for party;
- use ability.

Availability is based on visible facts, skills, tools, party members, and current state. Never display a false verb that silently performs an unrelated action.

### 10.3 Party control

- Select one or multiple party members.
- Formation movement outside combat.
- Individual positioning mode for stealth and setup.
- Party members remain present unless explicitly separated.
- Conversation may draw comments or interventions from companions based on proximity and relationship.

---

## 11. Investigation and journal system

### 11.1 Knowledge states

Each journal proposition uses one of these states:

- **Observed:** directly seen, heard, measured, or recovered.
- **Reported:** claimed by a named source.
- **Inferred:** current theory derived from evidence.
- **Confirmed:** supported strongly enough to be treated as established for gameplay.
- **Disputed:** contradicted by another credible source or observation.
- **Hidden:** developer/endgame truth unavailable to the party.

Do not make the codex automatically omniscient.

### 11.2 Evidence object

Every evidence item contains:

```json
{
  "id": "evidence.scorched_wool",
  "display_name": "Scorched Wool",
  "description_public": "Wool burned in narrow branching lines.",
  "source_type": "physical",
  "location_id": "location.roadside_pasture",
  "reliability": 1.0,
  "tags": ["fire", "pattern", "livestock"],
  "reveals": ["theory.fire_not_broad_breath"],
  "requires": [],
  "developer_notes": "Do not expose the smuggler solution directly."
}
```

### 11.3 Theory resolution

Theories are not simple quest checkboxes. A theory defines:

- supporting evidence;
- contradicting evidence;
- minimum confidence;
- required expertise or tools;
- dialogue options unlocked;
- tactical information unlocked;
- whether it can be proven, disproven, or remain uncertain.

### 11.4 Bestiary integration

The Balen Slayer's Bestiary is an in-world tool and journal interface. It should:

- show known public creature lore;
- compare evidence to known signs;
- reveal weaknesses and harvestable materials when learned;
- distinguish tameable creatures from untameable creatures;
- preserve player annotations;
- avoid revealing endgame lore or secret species knowledge without a valid source.

---

## 12. Dialogue and narrative state

### 12.1 Dialogue data

Use a graph format with nodes, conditions, effects, and speaker metadata. Dialogue must support:

- portraits and expression variants;
- companion interjections;
- skill- or evidence-gated lines;
- relationship and reputation conditions;
- public versus private knowledge;
- refusal, silence, deception, and partial truth;
- consequences without forcing one "correct" line.

### 12.2 Knowledge boundaries

Each dialogue fact should declare a scope:

```text
public
faction_private
character_private
secret
endgame
```

An NPC can speak a fact only when:

- the NPC knows it;
- the current relationship or circumstance permits disclosure;
- the fact's reveal gate is satisfied;
- the line is not contradicted by a stronger canon source.

### 12.3 Player agency

The engine must never auto-select player dialogue, movement, attacks, consent, or voluntary reactions. Cutscenes may move the camera and NPCs, but player-character actions require authored explicit control transfer and must remain minimal.

### 12.4 Narrative tone

Use grounded mature fantasy. Violence may be severe, but combat feedback must remain readable and not become repetitive gore. Intimacy and romance are outside the testbed scope; the architecture should not block later relationship content.

---

## 13. Quest and consequence model

### 13.1 Quest state

Avoid a single enum such as `not_started / active / complete`. Store independent facts:

```json
{
  "quest_id": "quest.ash_on_the_wool",
  "accepted": true,
  "civilians_saved": 3,
  "envoy_status": "rescued",
  "smuggler_leader_status": "arrested",
  "false_wyrm_status": "driven_off",
  "evidence_quality": 0.86,
  "method_flags": ["nonlethal", "used_bestiary"],
  "reported_to": ["faction.aethelgard_watch", "faction.slayer_guild"],
  "unresolved_threads": []
}
```

### 13.2 Consequence channels

A resolution may affect:

- local reputation;
- national reputation;
- faction trust;
- companion approval or concern;
- legal exposure;
- prices and services;
- patrol presence;
- rumors;
- future quest availability;
- world tension;
- journal certainty;
- creature ecology.

### 13.3 World pressure modes

Represent the source's five modes as data-driven world pressure states:

1. Peace;
2. Tension;
3. Border Skirmishes;
4. Inter-Nation War;
5. World War.

For the testbed, implement Peace and Tension fully. The remaining modes may exist as data stubs and automated tests.

Modes alter authored tables for:

- patrol composition;
- inspections;
- market modifiers;
- travel events;
- diplomatic dialogue;
- refugee presence;
- military access;
- rumor pools;
- route closures.

Do not let one minor local quest automatically trigger world war.

---

## 14. Travel model

### 14.1 Travel layers

- **Roadway:** maintained ground routes.
- **Skies:** open air above and around a region; not automatically a dock, inn, tower, or physical stop.
- **Wilderness:** intentional off-route travel, hunting, stealth, rough shortcuts, and severe terrain.

### 14.2 Testbed travel

Use a short route from Aethelgard to one roadside region. The player chooses:

- normal road;
- cautious road travel;
- wilderness shortcut.

Travel should consume elapsed time and supplies, run event checks, and stop before resolving an encounter so the player can act.

### 14.3 Consent and transport

True dragons are people. Riding or being carried by one is a personal or political choice, never a default vehicle command. Pets and companions are not inventory.

---

## 15. Economy, inventory, and equipment

### 15.1 Currency

Use only:

- Copper Marks = 1 value;
- Silver Marks = 10 value;
- Gold Marks = 100 value.

Convert payments into the fewest clear coins unless an authored scene requires a particular form.

A quote, offer, appraisal, reward promise, or negotiated price does not change inventory until the transaction or delivery occurs.

### 15.2 Inventory events

Add an item only when it physically enters possession. Remove it only when consumed, transferred, destroyed, stolen, or lost. Seeing, discussing, inspecting, or being offered an item does not alter inventory.

### 15.3 Equipment

Initial slots:

- primary;
- secondary;
- armor;
- head;
- hands;
- feet;
- cloak;
- trinket 1;
- trinket 2;
- quick item slots.

Equipment grants bounded modifiers and tags. Avoid large universal percentage bonuses.

---

## 16. Technical architecture

### 16.1 Repository layout

```text
balen-rpg/
  README.md
  project.godot
  icon.svg

  docs/
    Balen_Codex_Game_Testbed_Plan.md
    Balen_World_Canon_Bible.md
    architecture.md
    content_pipeline.md
    testbed_change_log.md

  source_data/
    voyage/
      balen_v35_source.json
      source_manifest.json
    curated/
      vertical_slice_manifest.json

  tools/
    import_voyage.py
    validate_content.py
    build_content_report.py

  data/
    generated/
      actors/
      abilities/
      items/
      factions/
      lore/
      locations/
      regions/
      quests/
    authored/
      testbed/
    schemas/

  scenes/
    bootstrap/
    exploration/
    combat/
    ui/
    actors/
    locations/
    effects/
    debug/

  scripts/
    core/
    data/
    actors/
    abilities/
    combat/
    exploration/
    dialogue/
    journal/
    quests/
    factions/
    travel/
    inventory/
    save/
    ui/
    debug/

  assets/
    models/
    textures/
    portraits/
    icons/
    audio/
    fonts/
    placeholders/

  tests/
    unit/
    integration/
    content/
    fixtures/
```

### 16.2 Autoload services

Use small, single-purpose autoloads:

- `GameState`: run state and current mode;
- `DataRegistry`: immutable content lookup;
- `EventBus`: typed high-level signals;
- `SceneRouter`: scene transitions and loading;
- `SaveService`: serialize runtime state;
- `WorldStateService`: flags, pressure mode, time, consequences;
- `AudioService`: buses and snapshot transitions;
- `SettingsService`: controls, accessibility, graphics;
- `DebugService`: deterministic seed, cheats, inspectors; excluded or disabled in release.

Do not put combat logic, quest logic, and UI logic into one global manager.

### 16.3 Core domain classes

Recommended Godot resources or typed classes:

```text
ActorDefinition
ActorRuntime
AbilityDefinition
AbilityExecution
StatusDefinition
StatusRuntime
ItemDefinition
EquipmentDefinition
FactionDefinition
RelationshipState
LoreEntryDefinition
EvidenceDefinition
TheoryDefinition
QuestDefinition
QuestRuntime
LocationDefinition
RegionDefinition
CombatEncounterDefinition
CombatObjectiveDefinition
WorldModeDefinition
DialogueGraphDefinition
```

Definitions are immutable content. Runtime classes hold saveable state.

### 16.4 Combat services

```text
CombatController
TurnManager
InitiativeService
PathPreviewService
TargetingService
LineOfSightService
ContactResolver
ImpactResolver
MitigationResolver
ConsequenceResolver
ReactionService
StatusService
MoraleService
CombatAIPlanner
CombatLogService
```

Each resolver returns a structured result. Do not make the UI parse narration strings to learn what happened.

Example result:

```json
{
  "source_id": "actor.debug_runescribe",
  "target_id": "actor.emberwing_01",
  "ability_id": "ability.runic_brand",
  "contact_outcome": "glancing_hit",
  "impact_tier": "basic",
  "raw_damage": 8,
  "final_damage": 2,
  "statuses_applied": ["status.branded"],
  "forced_movement": 0,
  "reaction_events": [],
  "log_tokens": ["contact.graze", "status.branded"]
}
```

### 16.5 Event bus examples

```text
actor_selected(actor_id)
combat_started(encounter_id)
turn_started(actor_id)
action_committed(action_request)
action_resolved(action_result)
reaction_requested(reaction_context)
evidence_discovered(evidence_id)
theory_updated(theory_id)
quest_fact_changed(quest_id, fact_key, value)
relationship_changed(actor_id, delta, reason_id)
world_mode_changed(old_mode, new_mode)
save_completed(slot_id)
```

Use typed signals or strongly validated payloads.

---

## 17. Voyage.IO data ingestion

### 17.1 Source policy

Keep the latest Voyage JSON unchanged in `source_data/voyage/`. Treat it as an input snapshot, not a runtime save file and not a file Codex may casually reformat.

The importer must:

1. parse the source as UTF-8 JSON;
2. record the source filename, byte size, hash, Heroes version, and mods;
3. validate expected root sections;
4. normalize keys to stable IDs without renaming display names;
5. separate public fields from hidden fields;
6. convert only allowlisted vertical-slice records initially;
7. emit a machine-readable report;
8. fail on unresolved references instead of silently inventing replacements.

### 17.2 Expected source categories

The importer should recognize, when present:

- `itemTypes`;
- `abilities`;
- `traits` and vocations;
- `skills` and attributes;
- `factions`;
- `regions`;
- `locations` and areas;
- `npcs`;
- `worldLore`;
- `storyStarts`;
- `premadeCharacters`;
- combat, travel, economy, relationship, crafting, pet, and world-mode settings.

### 17.3 Vertical-slice manifest

Do not import the entire world into the first executable build. Create an allowlist:

```json
{
  "source": "balen_v35_source.json",
  "regions": ["Aetherian Marches"],
  "locations": [
    "Aethelgard",
    "Aetherian Marches Roadways",
    "testbed.roadside_pasture",
    "testbed.smuggler_camp"
  ],
  "factions": [
    "Aethelgard",
    "The Slayers",
    "Empire of Drakona",
    "Neutral Trade Guilds"
  ],
  "npcs": [],
  "items": [
    "Balen Slayer's Bestiary",
    "Clean Bandages",
    "Copper Marks",
    "Silver Marks",
    "Gold Marks"
  ],
  "include_testbed_debug_content": true
}
```

Use exact source keys where available. Testbed-only IDs must live under a `testbed.` or `debug.` namespace.

### 17.4 Secret handling

Never place `hiddenInfo`, secret lore, or endgame truth into player-facing localization files. Normalize lore to:

```json
{
  "id": "lore.example",
  "title": "Example",
  "visibility": "public",
  "public_text": "...",
  "developer_text": "...",
  "unlock_condition": null,
  "source_reliability": "authoritative"
}
```

Valid visibility values:

- `public`;
- `faction_private`;
- `character_private`;
- `secret`;
- `endgame`;
- `debug_only`.

### 17.5 Import validation

Fail the content build when:

- an actor references an unknown faction, location, or area;
- an ability references an unknown damage type or resource;
- a path references a nonexistent destination;
- a quest references an unknown NPC or evidence item;
- a public dialogue line contains an endgame-only lore ID;
- a true dragon is tagged as pet, mount, beast, or ordinary monster;
- a false-wyrm receives true-dragon citizenship, humanoid forms, or bond culture;
- `Dragonborn` or `Dragonborne` reappears instead of current `Drakken` terminology;
- Valen and Sylvera are assigned a direct land border;
- Aerial Strongholds is labeled Drakona's southern border;
- any currency other than Copper, Silver, or Gold Marks is used in active testbed content.

---

## 18. Data schema examples

### 18.1 Ability

```json
{
  "id": "ability.shield_brace",
  "display_name": "Shield Brace",
  "tags": ["martial", "defense", "reaction_enabler"],
  "action_cost": 1,
  "movement_cost": 0,
  "resource_costs": {},
  "targeting": {
    "mode": "self",
    "range_m": 0,
    "requires_line_of_sight": false
  },
  "contact": null,
  "effects": [
    {
      "type": "apply_status",
      "status_id": "status.braced",
      "duration_rounds": 1
    }
  ],
  "ai_hints": ["use_when_threatened", "protect_chokepoint"]
}
```

### 18.2 Actor

```json
{
  "id": "actor.debug_knight",
  "display_name": "DEBUG Knight",
  "species_id": "species.human",
  "faction_id": "faction.aethelgard",
  "level": 3,
  "tier": "average",
  "attributes": {
    "strength": 12,
    "dexterity": 9,
    "constitution": 12,
    "intelligence": 8,
    "wisdom": 10,
    "charisma": 11
  },
  "resources": {
    "health": 28,
    "stamina": 30,
    "reaction": 1
  },
  "abilities": [
    "ability.basic_sword_strike",
    "ability.shield_brace",
    "ability.intercept",
    "ability.nonlethal_takedown"
  ],
  "release_excluded": true
}
```

### 18.3 Lore entry

```json
{
  "id": "lore.dragon_personhood",
  "title": "True Dragon Personhood",
  "visibility": "public",
  "public_text": "True dragons are recognized people and citizens, not ordinary monsters.",
  "developer_text": "Do not conflate true dragons with false-wyrms or Drakken.",
  "tags": ["law", "dragons", "drakona"],
  "unlock_condition": null
}
```

---

## 19. UI screens required for the testbed

### 19.1 Exploration HUD

- selected party portraits and resources;
- interactable highlight mode;
- current objective summary;
- minimap or local map button;
- world pressure indicator displayed subtly;
- pause and speed state.

### 19.2 Combat HUD

- initiative ribbon;
- selected actor resources;
- action bar;
- movement and targeting preview;
- hit/contact forecast;
- expected impact range;
- target armor, resistance, cover, and visible reactions;
- objectives;
- morale read;
- expandable combat log.

Do not show a single misleading "hit chance" when several defense vectors matter. The preview may summarize probability but must also explain the main reasons.

### 19.3 Journal

Tabs:

- quests;
- evidence;
- theories;
- people;
- factions;
- locations;
- Bestiary.

Evidence and theory pages must display provenance.

### 19.4 Dialogue UI

- portrait;
- speaker name and title;
- dialogue text;
- player responses;
- evidence/skill icons where relevant;
- optional companion interjection area;
- history log;
- text-size control.

### 19.5 Inventory and character sheet

The first build needs functional equipment and tool selection, not full crafting.

---

## 20. Accessibility and usability

Implement from the first milestone:

- remappable controls;
- UI scale and text size;
- subtitle and combat-log persistence;
- color-independent status icons;
- reduced camera motion;
- animation speed options in combat;
- hold/toggle options for highlights;
- confirmation for actions that break stealth, consume rare items, or attack neutral people;
- readable focus order for keyboard navigation;
- deterministic tooltip terminology.

Do not communicate damage type, faction hostility, or evidence reliability by color alone.

---

## 21. Save-game model

Save runtime state, never duplicate immutable definitions.

Required save data:

- source/content build version;
- player settings reference;
- current scene and position;
- party composition and actor runtime state;
- inventory and equipment;
- quest facts;
- evidence and theory states;
- faction reputation;
- companion relationships;
- world mode and local pressure;
- elapsed time;
- NPC state changes;
- defeated, arrested, rescued, or displaced entities;
- random seed where needed.

Use a versioned migration layer. The game should refuse unsafe loads with a clear report rather than corrupt state silently.

---

## 22. AI behavior

### 22.1 Combat AI goals

Use utility scoring rather than a long scripted if/else chain. Inputs include:

- intent;
- role;
- current objective;
- threat and vulnerability;
- reachable positions;
- allies in danger;
- morale;
- resources;
- known weak points;
- legal or personality constraints.

### 22.2 AI personality examples

- trained guards protect civilians and attempt arrest;
- smugglers delay, flee, destroy evidence, or bargain;
- a territorial false-wyrm protects its den and may retreat when injured;
- a true dragon may pin, disarm, threaten, or withdraw rather than kill weaker attackers;
- a fanatic may ignore morale but should still obey physical limits.

### 22.3 Information fairness

AI may use only information its actor could know. It should not target an invisible character without a detection event, avoid an unknown trap automatically, or know the player's unrevealed resistances.

---

## 23. Audio direction

The testbed needs functional audio states:

- exploration ambience;
- city ambience;
- tension layer;
- combat layer;
- dialogue ducking;
- low-health feedback;
- turn and reaction cues;
- distinct magic, breath, firearm, rune, and armor sounds.

Do not make every magical action a generic sparkle sound. Power traditions should be recognizable by audio texture.

---

## 24. Milestone plan

### Milestone 0 — Repository and rules foundation

Deliverables:

- Godot project boots to a title screen.
- Repository structure exists.
- Formatting, linting, and test commands are documented.
- Core definitions and runtime-state separation are established.
- Source manifest records the latest Voyage JSON snapshot.
- A deterministic debug seed is available.

Exit tests:

- headless project boot succeeds;
- unit-test runner succeeds with one sample test;
- content validator reports no errors on fixtures;
- source file is never modified by import.

### Milestone 1 — Isometric exploration sandbox

Deliverables:

- one graybox Aethelgard courtyard;
- camera pan/rotate/zoom;
- click-to-move party navigation;
- interactables;
- basic dialogue window with placeholder portrait;
- save/load position and party selection.

Exit tests:

- four actors can traverse the map without collision deadlocks;
- camera never exposes unrendered void within authored limits;
- roof/foreground occlusion works in one interior;
- save/load restores exact actor positions.

### Milestone 2 — Data pipeline

Deliverables:

- `import_voyage.py`;
- stable ID generation;
- vertical-slice manifest;
- generated data report;
- public/hidden lore separation;
- initial item, faction, lore, damage-type, and ability imports.

Exit tests:

- importer is deterministic;
- unresolved references fail the build;
- source hash is recorded;
- prohibited terminology and geography tests pass;
- player-facing output contains no hidden/endgame text.

### Milestone 3 — Turn-based combat core

Deliverables:

- combat entry in the exploration scene;
- initiative and turns;
- movement budgets;
- 2 AP and 1 reaction;
- contact resolver;
- impact and mitigation resolver;
- four basic attacks;
- cover and elevation;
- combat log;
- enemy utility AI.

Exit tests:

- misses never reduce HP;
- declared source is the only damage source;
- armor and typed resistance apply in correct order;
- reactions spend their resource once per round;
- deterministic seed reproduces a full encounter.

### Milestone 4 — Vocation identity and tactical consequences

Deliverables:

- Knight protection kit;
- Runescribe circles and brand;
- Slayer Bestiary and called shot;
- Drakken breath rhythm or Musketeer reload kit;
- status effects, forced movement, disarm, grounded, and jam;
- morale and surrender;
- combat objectives and nonlethal defeat.

Exit tests:

- each party member has a distinct resource loop;
- at least one battle can be won without killing any opponent;
- weak-point research changes available actions;
- a true-dragon-tagged actor cannot be selected by pet or harvest systems.

### Milestone 5 — Investigation, dialogue, and quest state

Deliverables:

- evidence pickups;
- witness testimony;
- theory state;
- journal tabs;
- evidence-gated dialogue;
- companion interjections;
- multi-fact quest resolution;
- return-to-hub consequences.

Exit tests:

- contradicted testimony remains reported rather than becoming fact;
- hidden lore is not exposed by ordinary investigation;
- all five scenario resolution families produce distinct state;
- save/load preserves evidence provenance and theory confidence.

### Milestone 6 — World mode and travel

Deliverables:

- Peace and Tension modes;
- road and wilderness route choices;
- elapsed-time updates;
- one interruptible travel event;
- mode-dependent hub changes.

Exit tests:

- travel time is preserved;
- route choice changes risk and arrival state;
- Tension changes authored tables without creating war automatically;
- Skies is never presented as a physical dock without a named dock location.

### Milestone 7 — Art, UI, and audio pass

Deliverables:

- approved UI layout;
- painterly portrait integration;
- one representative model per playable species used in the slice;
- material and lighting pass;
- combat readability effects;
- audio state transitions;
- accessibility settings.

Exit tests:

- statuses are readable without color;
- portraits preserve species, age, role, and national identity;
- true dragon imagery follows the design bible;
- effects do not obscure targeting or movement previews.

### Milestone 8 — Packaging and playtest

Deliverables:

- desktop build;
- clean new-game path;
- crash and telemetry-free local logging;
- playtest questionnaire;
- known-issues list;
- performance report;
- content validation report.

Exit targets:

- stable 60 FPS on agreed reference hardware at testbed settings;
- no blocker defects in a complete run;
- all automated tests pass;
- three external playtesters can explain the difference between a true dragon and a false-wyrm after play;
- at least two players discover a nonlethal resolution without being explicitly told the answer.

---

## 25. Automated test matrix

### 25.1 Unit tests

- contact outcome thresholds;
- impact mapping;
- armor reduction order;
- physical DR versus energy damage;
- typed resistance matching;
- action-point spending;
- reaction refresh;
- status duration;
- morale thresholds;
- currency conversion;
- theory confidence calculation;
- stable ID generation.

### 25.2 Integration tests

- exploration-to-combat transition preserves positions;
- combat-to-exploration transition preserves defeated states;
- evidence unlocks a called shot;
- dialogue effect updates quest state;
- save/load during exploration;
- save/load between combat rounds if allowed;
- world mode changes patrol table;
- travel interruption returns control before encounter resolution.

### 25.3 Content tests

- all IDs unique;
- all references resolve;
- all actor factions exist;
- all NPC locations and areas exist;
- all abilities declare cost, targeting, and outcomes;
- all damaging abilities use a valid damage type;
- all lore entries declare visibility;
- no forbidden terminology;
- no secret lore in public localization;
- no true dragon tagged pet, harvestable, or ordinary monster;
- no false-wyrm tagged citizen or humanoid-form character;
- universal Marks only;
- border rules valid.

### 25.4 Golden encounter test

Create a deterministic fixture for the testbed final encounter and record:

- starting positions;
- actor definitions;
- random seed;
- expected legal actions;
- expected first-round AI choices;
- expected damage and status results for a known command sequence;
- expected quest-state output for lethal and nonlethal resolutions.

---

## 26. Performance budgets

Initial targets:

- 60 FPS at 1080p on agreed mid-range desktop hardware;
- no more than 40 active combat-capable actors in a test scene, with the vertical slice authored for fewer than 16;
- portrait textures streamed or loaded per conversation group;
- pooled projectiles and common VFX;
- navigation updates limited to changed obstacles;
- no per-frame full-party path recalculation;
- no synchronous parsing of the full Voyage source at runtime.

Generated runtime data should be compact, validated, and loadable by category.

---

## 27. Explicit non-goals for the testbed

Do not build these before the vertical slice passes playtesting:

- seamless continent-scale open world;
- third-person action combat;
- full free-flight dragon controls;
- all 100 Abyssal Tower floors;
- procedural nation simulation;
- every authored location or NPC;
- romance and explicit intimacy systems;
- multiplayer;
- player housing construction;
- full crafting economy;
- mounted combat;
- cinematic facial motion capture;
- generative AI narration inside the shipped testbed;
- live synchronization back to Voyage.IO.

---

## 28. Codex working rules

1. Read this plan and `Balen_World_Canon_Bible.md` before changing code.
2. Treat the source Voyage JSON as read-only.
3. Make small, reviewable commits organized by one system or milestone.
4. Add or update tests with every mechanical change.
5. Run headless tests and content validation before considering a task complete.
6. Do not invent canon to make a placeholder convenient. Use a `debug.` or `testbed.` namespace instead.
7. Do not rename authored NPCs, factions, species, locations, or abilities.
8. Do not expose `hiddenInfo` or endgame lore in ordinary UI.
9. Keep data definitions separate from runtime state.
10. Keep UI separate from combat resolution.
11. Return structured results from systems; narration is a presentation layer.
12. Log assumptions in `docs/testbed_change_log.md`.
13. Prefer the smallest implementation that satisfies the current milestone.
14. Do not start a later milestone while the current milestone's exit tests fail.
15. When a source rule is ambiguous, implement a configurable rule resource and document the chosen default.

---

## 29. First Codex task sequence

Give Codex work in this order:

### Task 1 — Bootstrap

- create the Godot project and directory structure;
- add a title screen and graybox test scene;
- configure input actions;
- add headless test support;
- create `DataRegistry`, `EventBus`, `GameState`, and `SaveService` skeletons;
- document run/test commands.

### Task 2 — Content definitions

- create typed definitions for actors, abilities, items, statuses, damage types, lore, evidence, and quests;
- add JSON schema or equivalent validation;
- create small hand-written fixtures;
- do not import the full Voyage file yet.

### Task 3 — Exploration

- implement isometric camera;
- click-to-move;
- party selection;
- one interactable and one dialogue;
- save/load position.

### Task 4 — Importer

- implement source manifest and hash;
- parse the latest Voyage file;
- export only vertical-slice allowlisted records;
- write validation report;
- add canon guard tests.

### Task 5 — Combat skeleton

- preserve positions entering combat;
- initiative, turns, movement, AP, reactions;
- structured action requests/results;
- contact resolver tests;
- combat log.

Continue milestone by milestone only after the exit tests pass.

---

## 30. Starter prompt for Codex

```text
You are implementing the Balen RPG testbed in Godot 4.x using GDScript.

Read these files first and treat them as authority:
1. docs/Balen_Codex_Game_Testbed_Plan.md
2. docs/Balen_World_Canon_Bible.md
3. source_data/voyage/source_manifest.json

Begin with Milestone 0 only. Do not build later systems yet.

Requirements:
- Preserve the source Voyage JSON unchanged and read-only.
- Separate immutable content definitions from runtime state.
- Use typed GDScript wherever practical.
- Add a headless automated test command.
- Add DataRegistry, EventBus, GameState, SaveService, and DebugService skeletons with narrow responsibilities.
- Create a title screen and a graybox bootstrap scene.
- Configure abstract input actions for selection, movement, camera rotation, zoom, journal, inventory, and pause.
- Add README instructions for launching, testing, and validating content.
- Record assumptions in docs/testbed_change_log.md.
- Do not invent or rename Balen canon.
- Do not expose hidden or endgame lore.

Before editing, summarize the files you will create or change. After implementation, run all available tests and report exact results, remaining failures, and the next smallest task.
```

---

## 31. Final identity check

Before approving any feature, ask:

- Does it make knowledge, preparation, position, identity, or consequence matter?
- Does it preserve the difference between true dragons, Drakken, and false-wyrms?
- Does it allow outcomes other than extermination?
- Does it show nations as cultures rather than color-coded enemy teams?
- Does it protect hidden canon from casual discovery?
- Does it remain feasible for a small team and Codex-assisted development?

A feature that fails most of these checks is probably not part of the first Balen game.
