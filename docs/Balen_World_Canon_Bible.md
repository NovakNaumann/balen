# Balen World & Canon Bible — Codex Handoff

**Document purpose:** implementation-facing lore, character, nation, species, magic, location, and canon guide for the Balen RPG testbed  
**Primary source:** `balen 35_ (1).json`, the most recent Voyage.IO JSON found in the project File Library  
**Source timestamp:** 2026-07-22 04:52:46 UTC  
**Source format:** Voyage.IO Heroes V35  
**Pinned source mods:** `zxKkFzisLYR-` v14 and `2LDeiL6rEHva` v2  
**Art references:** `Balen Drakona Dragon Portrait Design Bible.docx` and `Narrator Instruction Hierarchy.txt`  
**Companion implementation plan:** `Balen_Codex_Game_Testbed_Plan.md`

> **Scope note:** This is a curated implementation bible, not a byte-for-byte Markdown dump of every record in the multi-megabyte Voyage world. It preserves the world rules and the characters, factions, locations, and secrets most important to an RPG implementation. Keep the original JSON beside this file as the exhaustive authority for all authored records.

---

## 1. Canon authority and conflict resolution

When two records appear to disagree, use this order:

1. **Explicit endgame truth and reveal-system content**
2. **Current system rules and hard canon guardrails in the latest JSON**
3. **Authored NPC `hiddenInfo` for that NPC's private truth**
4. **Authored public `basicInfo`, faction, nation, location, and world-lore entries**
5. **Public belief, mythologized history, rumor, and testimony**
6. **Generated or testbed-only content that does not contradict the above**

Older terminology and older source documents must yield to the latest JSON. In particular:

- use **Drakken** for the humanoid dragon-like race;
- do not reintroduce `Dragonborn` or `Dragonborne` as current race names;
- use **true dragon** for actual dragons;
- use **Draconic Bloodline** only for actual true-dragon parentage or descent;
- use **Drakken Bloodline** or **Drakken-blooded** for ancestry from Drakken humanoids;
- do not call a true dragon's child Drakken;
- use **Worcen**, never Worcester, Worchester, Worce, or similar variants.

Where the portrait notes use the older term `Dragonborne`, interpret it as **Drakken** when referring to the humanoid species. A true dragon using humanoid form is still a true dragon, not a Drakken.

---

## 2. Canon visibility levels

Every lore statement, character fact, dialogue line, journal entry, and codex record must carry a visibility level.

### 2.1 Public

Ordinary citizens, travelers, soldiers, merchants, scholars, priests, and officials may know it. Public knowledge may still be simplified, political, or incorrect.

### 2.2 Faction-private

Known to members of a faction, government, order, guild, profession, or restricted office. Access requires membership, trust, records, or investigation.

### 2.3 Character-private

Known to a specific person or small relationship circle. It may be revealed through trust, confession, coercion, discovery, or a dedicated story.

### 2.4 Secret

Hidden canon that ordinary records and NPCs must not confirm. Clues may exist, but the game presents them as observations, contradictions, or theories until a valid reveal.

### 2.5 Endgame

The Full Truth of Balen. It may be revealed only through approved endgame routes or an explicit debug trigger.

### 2.6 Developer-only

Implementation notes, negative constraints, debug content, internal IDs, and test fixtures. Never show these in player-facing text.

---

## 3. World identity

Balen is a high-fantasy world undergoing an industrial revolution. Magic, true dragons, Drakken, ancient forests, divine relics, gunpowder, railways, pressure engines, airships, ruins, and monster ecology coexist.

No nation is inherently evil. Each major power has legitimate goals, laws, values, fears, virtues, hypocrisies, and internal disagreement. The setting's conflicts emerge from:

- old wars and historical wounds;
- incompatible ideas of authority and freedom;
- dragon personhood and aerial sovereignty;
- fear of uncontrolled magic;
- industrial growth and environmental damage;
- religion and monarchy;
- isolation and cultural preservation;
- trade, resources, borders, and strategic routes;
- ordinary crime, ambition, prejudice, and survival.

### 3.1 Tone

Balen should feel:

- mature;
- cinematic;
- grounded;
- beautiful and dangerous;
- politically complex;
- capable of intimacy and domestic life;
- violent when violence occurs;
- wondrous without becoming whimsical nonsense.

Magic has texture, strain, cost, risk, and beauty. Steel has weight. Gunpowder is loud and dirty. Dragons have scale, mass, political status, and individual personalities. Cities contain workers, families, pilgrims, merchants, animals, soldiers, artists, and people who do not care about the current main quest.

### 3.2 Threat routing

Normal threats should come from established Balen material:

- named nations and factions;
- soldiers, spies, criminals, rebels, smugglers, and cultists;
- established Bestiary creatures and false-wyrms;
- dangerous terrain and weather;
- ruins, logistics, accidents, resource conflict, and politics.

Shaydes, Daemons, Obsidian Blight, Abyssal Tower forces, Celestial ruins, and world-ending revelations are special threats. They are not the default explanation for ordinary crime, war, missing livestock, diplomatic friction, or local monsters.

---

## 4. Geography and world boundaries

### 4.1 The continent

The known mortal world centers on Balen and its major nations, with neutral Aethelgard in the Aetherian Marches. Regional travel is structured through named regions, locations, areas, and route layers rather than a featureless open world.

### 4.2 The Great Blue Empty

A vast ocean surrounds the known continent before the World's Maw. It contains open water, storms, currents, fish, seabirds, kelp, sea predators, and rare uninhabitable islets. It does not contain convenient secret ports, inhabited island nations, roadside inns, or unexplained settlements unless authored explicitly.

### 4.3 The World's Maw

**Public belief:** a colossal, unbroken antimagic mountain ridge beyond the Great Blue Empty. Powerful upward winds, impossible stone, and natural antimagic make it effectively impassable. Many believe it is a divine barrier protecting the mortal realm.

**Implementation rule:** ordinary tools, spells, flight, and climbing cannot bypass it. Crossing is an endgame event, not an exploration exploit.

### 4.4 Border guardrails

- Valen and Sylvera do **not** share a direct land border.
- A Valen–Sylvera conflict must be expeditionary, proxy, diplomatic, commercial, naval, aerial, covert, or fought through neutral/third-party territory.
- **Dragonfall Pass** is Drakona's southernmost land border and primary fortified southern approach.
- **Aerial Strongholds** are northern/internal Drakonan aerial military territory, not the southern border.
- Aethelgard is neutral territory and a diplomatic power, not a fifth expansionist kingdom.

### 4.5 Travel layers

- **Roadway:** maintained ground routes.
- **Skies:** open sky above and around a region, used by airships, dragons, wyverns, weather, patrols, and aerial encounters. A skies location is not automatically a dock, inn, tower, or physical stop.
- **Wilderness:** deliberate off-route travel, hunting, stealth, shortcuts, difficult terrain, and exploration.

Elapsed time must be preserved. Airships may travel continuously when supplied and crewed. Flying mounts and dragons require rest. A true dragon carries riders only by consent.

---

## 5. National overview

| Polity | Direction / identity | Capital | Core peoples | Governing character |
|---|---|---|---|---|
| Empire of Drakona | northern sky-civilization, true dragons, Drakken, aerial sovereignty | Caelum Spire | roughly 70% Drakken/true dragons, 25% humans, 5% beastkin | Queen Veyra and the Draconic Council |
| Kingdom of the Holy Crown | southern agrarian, knightly, religious monarchy | Crownheart | roughly 70% humans, 15% beastkin, 15% Worcen | Emperor Aureon Dawnmere |
| Republic of Valen | western industrial republic, gunpowder, rail, invention | Ironhaven | roughly 80% humans, 15% beastkin, 5% Worcen | First Minister Gerard and the Senate |
| Sylvera | eastern jungle nation, elves, Worcen, World-Roots | Canopy's Whisper | roughly 70% elves, 30% Worcen | Queen Elowyn and the Verdant Crown |
| Aethelgard | central neutral citadel-city and diplomatic hub | Aethelgard | highly mixed | Grandmaster and High Exarch |

Demographic percentages guide crowds and generated NPCs; they do not prohibit minorities or mixed-heritage individuals.

---

## 6. Empire of Drakona

### 6.1 Identity

Drakona is the northern empire of floating cities, sky routes, dragons, Drakken, dragon riders, aerial fortresses, and ancient clan politics. Its public coexistence between true dragons and humanoids is genuine, not propaganda, but it is not effortless.

Drakona values:

- true-dragon personhood;
- bond culture;
- aerial sovereignty;
- old honor;
- clan continuity;
- draconic authority;
- protection of the northern realm;
- disciplined power.

Its flaws may include:

- hierarchy and aristocratic pride;
- old dragon arrogance;
- prejudice against half-dragons or complicated bloodlines;
- political resistance to reform;
- severe responses to crimes involving dragons or bonds;
- tension over how much power humanoid citizens should hold.

### 6.2 Government

Queen Veyra rules from Caelum Spire. The Draconic Council includes major Archons and Matriarchs representing powerful clans and traditions. The Queensguard Dragoons protect the throne, state, airspace, and important bonds. The Drakken Armada represents broader aerial military power.

Queen Veyra must balance:

- dragon tradition;
- mortal and Drakken citizenship;
- military necessity;
- reform;
- clan pride;
- the risk that an old clan fractures from the throne.

### 6.3 Capital: Caelum Spire

Caelum Spire is a single massive floating island-city built for true dragons and humanoids to coexist physically and politically.

Key environmental rules:

- streets, gates, plazas, halls, balconies, and markets are large enough for true dragons;
- humanoid galleries, side-streets, smaller doors, and interior rooms exist alongside dragon-wide routes;
- roost terraces, landing rings, aerial entrances, and open halls are normal civic infrastructure;
- the city rises through tiers connected by a broad ascending street;
- Cloud-Piercer Plaza is a major civic and arrival center;
- the Great Hall of the Draconic Council contains dragon-scale council positions rather than decorative monster pedestals.

### 6.4 Visual identity

Drakona should feel like a bright high-sky civilization, not a tyrannical monster empire.

Use:

- natural sky light and bright cloudlight;
- pale stone and high balconies;
- airy imperial arches and floating spires;
- layered silks, fitted sashes, elegant collars, and refined drapery;
- lacquer-like armor cues;
- ornate bronze, gold, or silver metalwork;
- filigree, jewelry, dragon motifs, and fantasy dragoon silhouettes;
- visible signs of dragon-and-humanoid coexistence.

Cultural influence appears through clothing, craftsmanship, architecture, and regalia, not through direct real-world ethnic coding.

### 6.5 Political gameplay themes

- dragon personhood cases;
- bond law and bond-severance trauma;
- clan petitions and vetoes;
- airspace violations;
- disputes over half-dragon status;
- reform versus traditional authority;
- dragon-scale trade and molting rights;
- Queensguard duty;
- diplomacy with nations that historically feared dragons.

---

## 7. Kingdom of the Holy Crown

### 7.1 Identity

The Holy Crown is a southern agrarian kingdom of fertile fields, livestock, sacred roads, knightly houses, chapels, pilgrimages, and hereditary authority. Its culture is warm and traditional, and its knights are often decorated with ribbons or tokens given by ordinary citizens.

The kingdom values:

- family and continuity;
- faith;
- protection;
- sacred duty;
- chivalry;
- agriculture and stewardship;
- loyalty to Crown and house;
- communal ritual.

Its flaws may include:

- monarchy and house privilege;
- political rivalry beneath sacred language;
- pressure to conform;
- conflict between Crown authority and Elyra's ideal of freedom;
- sanitized public history;
- harsh treatment of perceived heresy or disloyalty.

### 7.2 Government

- **Emperor Aureon Dawnmere** rules.
- The **High Priestess of the Lady Celestial** is the religious head and stands just below the Emperor.
- The **Crown Council** is house-based.
- Each major house has a House Lord and a House Knight.
- The **Glaive Commander** answers directly to the Emperor and stands outside ordinary house politics.
- Crown Knights and Glaives maintain distinct military traditions.

Do not reduce the government to a generic church hierarchy. The Emperor is the sovereign; the High Priestess is the highest religious authority.

### 7.3 Capital: Crownheart

Crownheart is a castle-city arranged around a sacred straight axis:

1. the Crownway Fairway enters from the outer gates;
2. the road passes through the lived city;
3. it reaches the castle walls and military courtyard;
4. it terminates at Crownheart Citadel.

The city includes markets, chapels, homes, inns, workshops, pilgrim houses, and a regulated Slayer branch. The citadel includes:

- Throne-Sanctum;
- Citadel Archives;
- Crown Council Chamber;
- Glaive barracks;
- Crown Knight barracks;
- training courtyards.

The Throne-Sanctum is both throne room and place of worship. The Crystal Crown is embedded above the Emperor's throne and is **never worn**. Morning sunlight passes through stained glass and strikes it.

### 7.4 Public Crystal Crown belief

Modern public teaching says the Crystal Crown protects the kingdom and must be empowered regularly by the ruler to maintain an ancient seal against the Shaydes.

This is public, mythologized, and incomplete. It must not override the endgame truth.

### 7.5 Visual identity

- Arthurian and high-medieval silhouettes;
- polished armor, tabards, heraldry, ribbons, and sacred emblems;
- cultivated fields, abbeys, keeps, granaries, and chapel beacons;
- warm stone, gold grass, stained glass, and ceremonial light;
- noble and disciplined rather than uniformly grim.

### 7.6 Political gameplay themes

- house rivalry;
- imperial versus priestly authority;
- knightly duty and civilian need;
- public myths surrounding the Crown;
- agricultural crisis and land stewardship;
- pilgrim-road safety;
- heresy accusations;
- family, inheritance, marriage, and oath conflicts.

---

## 8. Republic of Valen

### 8.1 Identity

Valen is the western industrial republic of gunpowder, railways, foundries, pressure engines, clockwork, patents, civic works, invention fairs, shooting competitions, and firework displays. Most Valenian humans cannot use magic because of an ancient divine punishment, so the Republic built power through discipline, industry, engineering, and law.

Valen values:

- civic merit;
- invention;
- practical education;
- nonmagical power;
- industry;
- public works;
- military discipline;
- patents and ownership;
- survival without dependence on mages.

Its flaws may include:

- pollution and worker exploitation;
- industrial surveillance;
- dangerous prototypes;
- militarized technology;
- class conflict;
- aggressive resource extraction;
- suspicion of magic and magical nations;
- bureaucracy that protects property more quickly than people.

### 8.2 Government

The Republic is governed by the Senate.

- **First Minister Gerard** rules from Ironhaven.
- **Master Tinker Hix**, Chief Engineer, advises on engineering, blackpowder weapons, pressure engines, prototypes, and industrial risks.
- **Marshal Octavia Bronzewick** commands the Republic Musketeers.

The Six Seats of the Senate are:

| Senator | Portfolio | Seat |
|---|---|---|
| Marcelline Ironwright | civic works | Ironhaven, Valen Iron Marches |
| Garron Blackiron | heavy industry | Blackiron Foundry, Valen Iron Marches |
| Elian Powdergate | defense policy | Powdergate Arsenal, Ironforge Gate |
| Petra Gearford | trade and patents | Gearford Exchange, Gearworks District |
| Brina Coalhand | labor | Ashgate Worker Rows, Ashen Flats |
| Tomas Railwright | railways, roads, bridges, depots | Ironmile Depot, Western Foundry Road |

### 8.3 Capital: Ironhaven

Ironhaven is a red-brick and black-iron city of:

- rail lines;
- foundries;
- Senate halls;
- blimp and airship moorings;
- blackpowder workshops;
- worker districts;
- patent offices;
- cannon foundries;
- marching Musketeers.

### 8.4 Terminology

- **Valenian** is the broad cultural or national demonym.
- **Republican** is a narrower political/civic identity for people who support, serve, or represent the Republic model.
- Do not call every person from Valen a Republican automatically.

### 8.5 Visual identity

- early industrial and Renaissance-fantasy clothing;
- practical coats, vests, leather, goggles, aprons, travel gear, and uniforms;
- iron, brass, brick, coal, steam, cranes, canals, rail, and pressure mechanisms;
- restrained magic and visibly engineered solutions;
- a grittier palette than other nations without making every street filthy or hopeless.

### 8.6 Political gameplay themes

- patent theft and industrial espionage;
- worker safety and labor politics;
- arms races;
- rail and bridge control;
- anti-magic prejudice;
- pollution crossing political boundaries;
- invention used for public good or war;
- meritocracy versus wealth and ownership.

---

## 9. Sylvera

### 9.1 Identity

Sylvera is the eastern jungle nation of elves and Worcen living among immense forests, rain, sacred roots, waterways, living architecture, spirit pacts, cultivated medicinal ecosystems, and long memory.

Sylvera values:

- the World-Roots;
- living memory;
- ecological balance;
- spiritual patience;
- ancient treaties;
- craft integrated with nature;
- community continuity;
- protection of sacred territory.

Its flaws may include:

- isolation and suspicion;
- slow decision-making during urgent crises;
- hostility toward outsiders who do not understand local law;
- tradition becoming inflexibility;
- secretive governance;
- willingness to sacrifice outside interests for ecological preservation.

### 9.2 Government

Sylvera is governed by the Verdant Crown.

- **Queen Elowyn**, the Verdant Queen, rules from Canopy's Whisper.
- **Aurelian Rootwhisper**, Elder Root-Sage, preserves ancient law, World-Root memory, old treaties, and spirit pacts.
- **High Warden Thalara Moonspear** commands the Sylveran Guard.

The Verdant Six are:

| Member | Portfolio | Seat |
|---|---|---|
| Lyranthiel Canopy-Speaker | civic law | Canopy's Whisper, Sylveran Deepwood |
| Maelion Rootwarden | World-Root oaths | Rootfather Grove, Rootward Depths |
| Varessa Thornmantle | defense policy | Thornwatch Hold, Thornwall Forest |
| Serelith Moonharp | diplomacy and trade | Moonharp Court, Moonlit Groves |
| Ruhan Antlerwake | Worcen, beast pacts, wild clans | Wildcall Enclave, Ancient Canopy |
| Mirael Greenhand | agriculture, herbalism, medicine, crafting, forest resources | Greenbloom Terrace, Mistveil Canopy |

### 9.3 Capital: Canopy's Whisper

Canopy's Whisper is a hidden treetop city woven into living World-Roots. It should feel inhabited, cultivated, and sophisticated rather than like an untouched forest camp.

### 9.4 Beliefs

Trees are sacred. A common belief holds that an elf's soul becomes a tree after death. Treat this as a lived cultural and religious belief, not automatically confirmed cosmological fact.

### 9.5 Visual identity

- refined layered robes and elegant metalwork;
- Chinese-inspired fantasy craft expressed through silhouette, architecture, and ornament rather than direct replication;
- jade, silver, living wood, water, mist, moonlight, roots, leaves, and ritual motifs;
- graceful structures integrated with trees;
- cultivated gardens, apothecaries, waterways, bridges, and vertical movement.

### 9.6 Political gameplay themes

- sacred-grove access;
- World-Root damage;
- spirit pacts;
- outsiders violating ecological law;
- trade versus isolation;
- Worcen representation;
- medicinal resources;
- ancient treaties remembered differently by other nations.

---

## 10. Aethelgard and the neutral lands

### 10.1 Identity

Aethelgard is a neutral magi-knight citadel-city and diplomatic power in the Aetherian Marches. It is not a monarchy. It recruits across species and nations and expects sworn members to place neutrality before their birth nation.

Aethelgard values:

- neutrality;
- magical discipline;
- mediation;
- public order;
- protection of travelers and civilians;
- controlled knowledge;
- cross-cultural service.

Its flaws may include:

- neutrality that appears cold or self-serving;
- classified knowledge and institutional secrecy;
- political pressure from all four nations;
- overconfidence in controlled procedure;
- competing order priorities.

### 10.2 Government

- The **Grandmaster of the Magi-Knights** commands military deployments, citadel defense, inter-order discipline, and battlefield command.
- The **High Exarch** governs civil administration, diplomacy, neutral law, education, archives, trade arbitration, and city affairs.
- Knight Commanders lead individual orders and sit on the Citadel Council.

The concise rule is:

> The Grandmaster commands. The High Exarch governs. Knight Commanders advise and lead. The Orders act.

Grandmaster Elaris Vexhammer is a current named figure in the source material. The importer should use the complete latest authored command roster and report any office collisions rather than guessing replacements.

### 10.3 Magi-Knight orders

| Order | Duties and identity |
|---|---|
| Gryphon | honor, frontline warfare, battlefield command, aerial response, direct defense |
| Raven | vigilance, asymmetric warfare, intelligence, rescue, recovery, infiltration, missing persons |
| Chimera | adaptability, diplomacy, peacekeeping, mixed magic, negotiation, crisis mediation |
| Stag | civil defense, refugee protection, city wards, evacuation, disaster response |
| Manticore | monster containment, dangerous arrests, anti-Slayer crimes, quarantine, lethal threat resolution |
| Sphinx | truth, archives, magical law, investigation, trials, forbidden knowledge review, classified records |
| Phoenix | healing, purification, curse-breaking, battlefield recovery, anti-Daemon cleanup |
| Basilisk | restraint, anti-magic enforcement, mage arrests, spell suppression, dangerous caster containment |

Selected confirmed commanders include Cassian Gryphonheart for the Gryphon Order, Lira Voss for the Chimera Order, and Solenne Ashfeather for the Phoenix Order. Other authored commanders must come from the source JSON rather than generated substitutes.

### 10.4 Important locations

- Magi-Knight Citadel;
- Wayfarer's Accord Inn;
- Ringmarket and trade districts;
- embassies and diplomatic halls;
- Slayer headquarters and contract services;
- civic courts and archive spaces;
- roads into the Aetherian Marches;
- Cranemere Estate outside the city.

### 10.5 Demonyms

- **Aetherian:** a person of the neutral lands around Aethelgard.
- **Aethelgardian:** a person who claims Aethelgard city or its capital region as home.

---

## 11. Peoples and species

### 11.1 Humans

Humans are fully human unless a bloodline or explicit trait says otherwise. Do not add horns, scales, animal ears, tails, or pointed ears as random decoration.

### 11.2 Elves

Elves are graceful, long-lived, and strongly associated with Sylvera, though individuals may live elsewhere. Visual design should use clearly elven ears, refined facial structure, and an age-appropriate presence.

### 11.3 Beastkin

Beastkin are civilized humanoid people with visible animal traits determined by subtype. They are not humans wearing animal accessories. They may belong to any appropriate profession or social class.

### 11.4 Worcen

Worcen are a distinct civilized werebeast-like people with stronger and more pronounced bestial anatomy than ordinary Beastkin. They remain intelligent persons with culture, professions, family, law, and individual personality.

Do not reduce Worcen to:

- humans with ears and a tail;
- mindless werewolves;
- automatic barbarians;
- pets or monsters.

### 11.5 Drakken

Drakken are a distinct humanoid dragon-like race. Common features include scales, horns or horn ridges, draconic eyes, claws, and breath magic.

Hard distinctions:

- Drakken are not true dragons.
- Drakken are not descended from true dragons as a species.
- A Drakken person does not become a true dragon through age.
- Drakken-blooded ancestry is ancestry from Drakken humanoids.
- A true dragon's child is a dragon, young dragon, dragon heir, or dragon child—not Drakken.

### 11.6 True dragons

True dragons are actual dragons and recognized people. They possess intelligence, culture, citizenship, family lines, political status, individual morality, and legal personhood.

They are not:

- routine monsters;
- pets;
- mounts by default;
- harvestable carcasses in ordinary law;
- color-coded copies of one personality.

True dragons may use:

- true dragon form;
- humanoid form;
- hybrid form.

Their chosen form does not change their species or personhood.

### 11.7 False-wyrms

False-wyrms are dragon-like beasts or monsters, not true dragons. Examples include:

- Pseudo-Drakes;
- Wyverns and wyvern subspecies;
- Basilisks;
- Sand-Wyrms.

False-wyrms do not receive:

- true-dragon citizenship;
- humanoid forms;
- dragon bond culture;
- Draconic Council status;
- automatic sentience.

Some false-wyrm species may be tameable when raised young. Pseudo-Drakes are specifically not tameable.

### 11.8 Daemons and Shaydes

Daemons are secret Hells/shadow entities, not normal beasts. They do not provide ordinary harvestable parts. They can cause Obsidian Blight and require specialized reporting, purification, secrecy, and compensation.

Modern Balen believes Shaydes are extinct. Ordinary NPCs do not actively search for Shaydes as a routine explanation. Claims of living Shaydes are dismissed, mythologized, or misidentified until evidence becomes overwhelming.

---

## 12. Magic and power traditions

### 12.1 Fundamental mana rule

Magic is the art of willing mana into controlled form through imagination, knowledge, discipline, ritual, or embodied technique.

The deeper Cardinalis truth is:

> Mana has no inherent element. Mana is mana. Element is shaped expression.

Do not make every caster's power a rigid birth element unless the character's discipline says so.

### 12.2 Blood Mana and normal spellcasting

Most ordinary casters draw from internal blood mana. Overuse causes fatigue, blood-cell rupture, pain, collapse, or worse. Normal spells consume Mana unless explicitly exempted.

### 12.3 Light and Dark

- Light is associated with the presence and expression of mana.
- Dark is associated with absence and devouring of mana.

Do not use Light as automatic moral goodness or Dark as automatic moral evil.

### 12.4 Dracomancy

Dracomancy belongs to true dragons and Drakken. It is tied to breathing and recovers rapidly through controlled respiration. Common expressions include fire, lightning, wind, and healing.

Rules:

- Dracomancy is not normal Mana spellcasting unless an ability explicitly spends Mana.
- Breathing, exhaustion, restraint, air quality, and injury matter.
- A breath weapon should have rhythm and vulnerability, not be an unlimited cone every turn.

### 12.5 Cardinalis and Magi-Knights

Magi-Knights use the Cardinal Crux—Fire, Water, Earth, Wind, and Light/Dark—engraved into weapons to shape new spells through combat understanding. Their training is secretive, difficult, and lifelong.

Cardinalis supports flexible spell creation, but not consequence-free reality editing.

### 12.6 Bladesinging

Bladesingers guide ambient mana through blade path, breath, rhythm, and footwork. They dedicate themselves to a chosen element and use Stamina rather than normal Mana for significant Bladesinging actions.

They are in decline and generally transmit knowledge master-to-student.

### 12.7 Ninefold Path and Sublime Arts

Ninefold practitioners believe disciplined and merciful violence can create peace. The nine major paths are:

- Desert Winds;
- Iron Heart;
- Shadow Hand;
- Devoted Spirit;
- Tiger Claw;
- Stone Dragon;
- Diamond Mind;
- White Raven;
- Setting Sun.

These techniques use Stamina, focus, timing, stance, and martial perfection. They should look like physical mastery, not generic spellcasting.

### 12.8 Runescribes

Runescribes write magic into flesh, air, stone, parchment, weapons, and prepared surfaces.

Common techniques:

- body-rune protection;
- Runic Branding;
- air-cut circles;
- wards and thresholds;
- Mana-drain traps;
- chained circles;
- inscription-breaking;
- circle extension and empowerment;
- enchantment and rune repair.

Simple, properly drawn runes may cost little Mana because the structure performs much of the shaping. Major circles still require time, materials, geometry, power, and protection.

### 12.9 Valenian technology

Valenian systems rely on engineering rather than personal magic:

- firearms;
- blackpowder;
- repeating mechanisms;
- cannon;
- pressure engines;
- rail;
- clockwork;
- deployables;
- airships;
- industrial alchemy.

Technology should have maintenance, ammunition, heat, reload, supply, and failure constraints.

---

## 13. Religion

Balen's four major deities are Dominus, Elyra, Liriel, and Drakath. Lesser, forgotten, obscure, or local gods may exist but should not replace the major pantheon without explicit canon.

### 13.1 Dominus — God of Dominion

**Public, mythologized domains:** War, Peace, Dominance, Balance.

Dominus represents mastered power: the force that ends a war, the treaty backed by strength, command used decisively, and restraint preventing dominion from becoming tyranny. He is patron of Drakona.

Modern public stories about his mortal and draconic origins are incomplete and partly wrong.

### 13.2 Elyra — Goddess of Will / Lady Celestial

**Public, mythologized domains:** Compassion, Vigilance, Freedom, Willpower.

Elyra represents resistance to domination, protection of the weak, moral courage, vigilance against tyranny, and the ability to choose one's path. She is the primary deity of the Holy Crown and is revered there as the Lady Celestial.

Her complete origin is endgame truth.

### 13.3 Liriel — Goddess of Fertility and Lust

Domains:

- Love;
- Lust;
- Childbearing;
- Growth;
- Family.

Liriel is associated with harvests, passion, pleasure, parenthood, romance, art, and the cycle of life. Farmers, couples, midwives, parents, artists, and those seeking love or children honor her. Her worship treats passion and growth as holy when joined with care, consent, and devotion.

She is important in the Holy Crown but is not its chief national deity.

### 13.4 Drakath — God of Magic

Domains:

- Arcane;
- Humility;
- Restraint;
- Efficiency.

Drakath represents disciplined magic, clean shaping, minimal waste, humility before power, and precise application of knowledge. Public belief says he stripped Valenian humans of magic after the Old Valen queen attempted to trap Dominus through sacrifice and dark ritual.

### 13.5 Religious distribution

- Drakona strongly honors Dominus.
- The Holy Crown centers Elyra/Lady Celestial and also deeply honors Liriel.
- The Republic is officially secular, though private worship persists.
- Mages, scholars, ritualists, artificers, and healers often honor Drakath.
- Personal faith does not always match national identity.

---

## 14. Economy and trade

### 14.1 Currency

All active game systems use universal Marks:

- Copper Mark = 1 value;
- Silver Mark = 10 value;
- Gold Mark = 100 value.

Convert prices, rewards, bribes, wages, and loot into clear Mark denominations. Do not revive older national coin systems in active content.

### 14.2 Trade identities

- Drakona exports Dracosilk, legally traded molted dragon scales, and northern spices.
- The Holy Crown exports livestock, crops, precious metals, and fine arts.
- Valen exports fireworks, metals, firearms-related goods, and clockwork machinery.
- Sylvera exports artisan metalwork, stonework, medicines, and exotic fruits.
- Aethelgard brokers neutral trade and contracts.

### 14.3 Transaction rule

An appraisal, price quote, offer, contract promise, or reward notice is not an inventory change. Currency moves only when a transaction is confirmed or payment is delivered.

---

## 15. Major neutral and professional factions

### 15.1 The Slayers

The Slayers are a neutral guild of monster hunters, trackers, researchers, and legal harvesters. After dragons were recognized as sentient people, the guild reformed its practices and reputation.

Modern Slayer functions include:

- civilian protection;
- monster identification;
- ecological research;
- legal contracts;
- safe harvesting;
- endangered-creature stewardship;
- expedition support;
- reporting illegal hunts and protected-species crimes.

The canonical normal reference item is the **Balen Slayer's Bestiary**.

### 15.2 Red-Guard

The Red-Guard functions as conservation, legal oversight, and enforcement around hunting, protected species, poaching, and crimes involving true dragons. It should not become a generic tax office or omnipresent secret police.

### 15.3 Daemon Slayers

A secret or highly restricted branch/protocol dealing with Daemons, Obsidian Blight, and specialized purification. Ordinary citizens and routine guild members do not know the full truth.

### 15.4 Neutral Trade Guilds

Neutral trade organizations support Aethelgard's markets, contracts, arbitration, caravans, and cross-national commerce. They are useful for economic quests, smuggling, embargoes, labor disputes, and diplomatic pressure.

---

## 16. Political pressure modes

Balen supports five broad world modes.

### 16.1 Peace

Nations retain old grudges, spies, trade friction, crime, monsters, patrols, politics, and local danger, but no active national crisis exists. Military forces appear as patrols, exercises, escorts, and political pressure rather than invasion armies.

### 16.2 Tension

Cold-war pressure without open war. Expect:

- propaganda;
- patrol buildup;
- inspections;
- espionage;
- sabotage;
- suspicious shipments;
- border alerts;
- military drills;
- diplomatic incidents;
- trade restrictions.

Incidents remain limited or deniable unless deliberately escalated.

### 16.3 Border Skirmishes

Localized military clashes and contested routes. Use valid geography. Valen and Sylvera cannot conduct ordinary direct land-border skirmishes.

### 16.4 Inter-Nation War

Two or more powers fight openly. Markets, travel, diplomacy, refugees, recruitment, and companion loyalties change substantially.

### 16.5 World War

A continent-wide crisis involving multiple nations and systemic consequences. This is a campaign structure, not a random escalation from one local encounter.

---

## 17. Major locations

### 17.1 Aethelgard

Neutral citadel-city, diplomatic hub, Magi-Knight center, and ideal recurring player base. Use it for faction meetings, companion scenes, contracts, markets, legal disputes, archives, training, and cross-cultural life.

### 17.2 Caelum Spire

Floating capital of Drakona, built at true-dragon scale and humanoid scale simultaneously. Key for aerial politics, the Draconic Council, Queensguard stories, and dragon personhood.

### 17.3 Crownheart

Sacred castle-city of the Holy Crown, organized along the Crownway Fairway and centered on the Throne-Sanctum and embedded Crystal Crown.

### 17.4 Ironhaven

Industrial capital of Valen, containing Senate politics, rail, foundries, worker districts, patents, Musketeers, airship infrastructure, and engineering conflict.

### 17.5 Canopy's Whisper

Hidden living capital of Sylvera, woven into World-Roots and governed through the Verdant Crown.

### 17.6 Cranemere Estate

Private cottage home of Kazien Cranehollow and Commander Valyrine Dawnmere in the Aetherian Marches near Aethelgard. It contains:

- a garden;
- warm hearth;
- reinforced rune workshop;
- training yard large enough for Valyrine's greatsword and Worcen stride.

It is a personal earned home, not a public inn or generic quest hub.

### 17.7 The Abyssal Tower

A pre-Lost Age inverted tower in the Northwest Neutral Foothills. It descends into the earth and becomes larger and more warped with depth.

Publicly known:

- only the first ten floors are documented;
- upper floors resemble ancient halls, stores, armories, cellars, and civic spaces;
- teleportation between floors fails;
- the Tower reacts to intent, especially intent to descend;
- no expedition has officially cleared the tenth floor.

Developer/endgame structure:

- every tenth floor is a boss threshold;
- deeper floors become district-, town-, castle-, and realm-like;
- creatures can regenerate until a threshold boss is defeated;
- the hundredth floor culminates in a mockery throne room and the Shayde Matriarch route.

### 17.8 The Vaulted City

A collapsed Celestial pocket-dimension reached only through endgame breach seals in dangerous surface ruins. It is a separate realm-space, not a normal region on the surface map.

Surface breach sites include:

- Saintless Abbey Breach;
- Ashen Skycourt Forge;
- Reliquary Archive Breach;
- Broken Halo Bastion;
- Glasswound Boundary Breach.

The Vaulted City contains no ordinary living population, bodies, bones, or normal decay beyond explicit exceptions. Fine obsidian-black dust is a mystery in ordinary narration and must not be casually identified.

---

## 18. Selected key character roster

This is an implementation-critical subset. The complete authored roster remains in the source JSON. Never generate a replacement for an existing ruler, commander, spouse, companion, council member, or faction leader merely because this summary omits them.

### 18.1 National rulers

| Character | Role | Public implementation notes |
|---|---|---|
| Queen Veyra | Queen of Drakona | elegant Drakken-presenting ruler balancing dragons, Drakken, humanoids, reform, military needs, and clan politics |
| Emperor Aureon Dawnmere | Emperor of the Holy Crown | sovereign above the house-based Crown Council; works alongside but outranks the High Priestess |
| First Minister Gerard | First Minister of Valen | political head of the industrial Republic and Senate government |
| Queen Elowyn | Verdant Queen of Sylvera | ruler from Canopy's Whisper, supported by Root-Sage, High Warden, and Verdant Six |
| Grandmaster Elaris Vexhammer | Grandmaster of Aethelgard | military head of the Magi-Knights; civil authority belongs to the High Exarch |

### 18.2 Drakona council figures

#### Queen Veyra

Publicly, Veyra is an elegant, beautiful Drakken ruler associated with high Drakonan nobility, layered silks, dragoon regalia, and controlled draconic traits. She is not a generic dragon empress or tyrant.

Developer warning: her deepest identity is secret and appears later in this document.

#### Archon Emberon — Emberfall Clan

- preferred form: humanoid;
- red-gold dragon lord;
- passionate, hot-tempered, loyal, poetic, emotionally honest;
- proven veteran of the War of the Scales;
- signature themes: stone-melting fire, heat, durability, morale-shattering roar;
- secretly appreciates and writes mortal poetry.

#### Archon Kaelthrax — Wyrm Spine Clan

- preferred form: listed hybrid, though formal true-dragon presentation is strongly established;
- obsidian-black, scarred, severe, stoic, protective;
- ancient military authority and battle veteran;
- favors restraint, endurance, and decisive protection;
- true-dragon portrait baseline.

#### Archon Sylvarion — Skyward Clan

- preferred form: humanoid;
- elegant, diplomatic, wise, mischievous, dryly humorous;
- silver-white hair, blue eyes, liquid-silver scale traits;
- must read as a true dragon choosing humanoid form, not merely an elven noble.

#### Archon Thalor — Stormscale Clan

- preferred form: hybrid;
- storm-gray, controlled lightning, strategic calm;
- hybrid form must remain humanoid-dominant and clothed/armored;
- true-dragon seated version may be used for formal council scenes when specifically authored.

#### Archon Valthor — Copper Peaks Clan

- preferred form: humanoid;
- calm, strategic, deeply honorable, patient;
- ancient treaty-broker and council founder;
- copper hair streaked with silver and molten-gold eyes;
- mourns a lost mate and has not taken another.

#### Archon Veylithar — Frostveil Clan

- preferred form: true dragon;
- oldest living council member;
- ice-white crystalline scales and frost-blue eyes;
- ancient, wise, patient, melancholy, powerful rather than frail;
- presentation should convey earned majesty.

### 18.3 Vaas Veyrix

Public profile:

- human with Drakken-blooded lineage;
- Hand of the Queen;
- Queensguard Lieutenant;
- court gatekeeper;
- bond-severance mediator;
- memory-jewel artisan;
- elite, controlled, formal, snarky, observant, and patient with genuine grief.

Vaas creates enchanted memory-jewels that replay one chosen vivid memory of a lost bondmate when their name is spoken. Three dragons he helped through severance have sworn rare story-significant aid to him; they are not pets, mounts, servants, or a casual summon ability.

He must not be portrayed as disgraced, retired, ceremonial, or powerless. Queen Veyra personally vetoed an effort to force his retirement and installed him as Hand of the Queen.

Developer warning: Vaas carries major character-private and secret information described later.

### 18.4 Aethelgard figures

#### Commander Cassian Gryphonheart

Knight Commander of the Gryphon Order. Use for frontline command, direct defense, honorable military response, and aerial emergencies.

#### Commander Lira Voss

Knight Commander of the Chimera Order. Use for negotiation, mixed-method problem-solving, diplomacy, peacekeeping, and crisis mediation.

#### Commander Solenne Ashfeather

Knight Commander associated with the Phoenix Order. Use for healing, purification, curse-breaking, battlefield recovery, and restricted anti-Daemon cleanup.

#### Commander Seraphina

An authored legendary Magi-Knight associated with neutrality and protective command. Preserve the source record and do not use her to replace a formally assigned order commander. Let the importer report overlapping legacy offices for human review.

### 18.5 Kazien Cranehollow and Commander Valyrine Dawnmere

#### Kazien Cranehollow

- human;
- master runesmith and circle enchanter;
- former Holy Crown Mage-Korps Spellsword;
- trusted civilian Magi-Knight contractor, not a Knight Commander;
- husband of Commander Valyrine Dawnmere;
- associated with dangerous compound runic branding and advanced circle theory;
- connected to the Thirty Sylven Massacre / Elven Slaughter and the Five-Month War;
- balances quiet domestic life, commissions, Citadel duty, and old trauma.

#### Commander Valyrine Dawnmere

- towering direwolf-Worcen woman;
- Magi-Knight commander and formidable greatsword fighter;
- Kazien's wife and active authored companion in their dedicated story start;
- physically and emotionally protective without becoming a generic bodyguard;
- must not be duplicated, renamed, replaced, or regenerated as a separate spouse.

Their relationship is affectionate, teasing, battle-scarred, and mutual. Their size difference should feel natural, not cartoonish.

### 18.6 Silas, Sylvareth, Kaelith, and Pyrrhos

The Continuation story start uses an active party of:

- **Silas Dey Corvand**;
- **Sylvareth**;
- **Kaelith**;
- **Pyrrhos**.

They have been staying at the Wayfarer's Accord Inn in Aethelgard for about a week. All four remain physically present unless explicitly separated by action, danger, injury, command, or travel logistics.

Kaelith and Pyrrhos are young Skysunderer wyverns and should be treated as living companions, not inventory items.

---

## 19. Bestiary and creature rules

### 19.1 Balen Slayer's Bestiary

The Bestiary contains:

- public creature lore;
- Slayer annotations;
- tracks and sign sketches;
- weak-point diagrams;
- harvest notes;
- regional warnings;
- blank space for new observations.

It is used to identify unknown threats, compare evidence, learn weaknesses, review materials, check tameability, and add field notes.

### 19.2 Pseudo-Drake

A small-to-medium false-wyrm predator often mistaken for a young dragon by frightened witnesses. It is aggressive, territorial, reckless, and **not tameable**.

### 19.3 Wyverns

Wyverns are false-wyrms with multiple regional subspecies. Existing examples include:

- Skysunderer;
- Thorn-Tail;
- Riverjaw;
- Frostwing;
- Emberwing;
- other authored regional variants.

Some may be tameable if raised young, but they remain dangerous animals with habitat, diet, handling, and housing needs.

### 19.4 Sand-Wyrm

A massive burrowing false-wyrm of Valen's western sands. It senses vibration, collapses routes, and threatens caravans. It is not tameable.

### 19.5 Crownfield Hart

A white-gold sacred beast associated with Holy Crown fields, protected groves, omens, and Elyra/Lady Celestial traditions. It is usually non-hostile and should not be treated as ordinary loot wildlife.

### 19.6 Pet and companion guardrails

- pets are not inventory;
- a successfully tamed creature has a clear state: in party, nearby/waiting, stabled/housed, or unavailable;
- call items do not teleport creatures;
- true dragons, Drakken, Worcen, Beastkin, elves, humans, Daemons, Shaydes, and other sentient people cannot be pets;
- tameability is species-specific, not a universal charisma check.

---

## 20. Combat worldview

Balen combat is dynamic rather than automatic exchange.

### 20.1 Resolution order

1. establish intent, target, source, range, and approach;
2. choose attack and defense vectors;
3. resolve contact;
4. determine impact;
5. apply armor, physical DR, and typed resistance;
6. apply damage or tactical consequences;
7. update position, morale, reactions, objectives, and state.

### 20.2 Valid contact outcomes

- critical failure;
- miss;
- defended miss;
- glancing hit;
- clean hit;
- critical hit;
- tactical success without damage.

### 20.3 Defeat and death

Valid defeat states include:

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

Intent and fiction matter. Important NPCs and true dragons should not die from vague narration or one unsupported line. True-dragon leaders often restrain, pin, intimidate, wound, or end a fight nonlethally when attacked by someone far weaker and not posing a genuine lethal threat.

### 20.4 Weak points

Weak points should create tactical changes, not only damage multipliers. Research and evidence may reveal them.

### 20.5 Damage types

Canonical system types include:

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

---

## 21. Art direction

### 21.1 Overall portrait style

- painterly, high-detail fantasy illustration;
- expressive faces and eyes;
- rich but grounded texture;
- dramatic, readable lighting;
- age-, species-, gender-, role-, and nation-appropriate design;
- strong silhouette;
- atmospheric background that supports rather than overwhelms the speaker.

Avoid:

- photorealistic generic faces;
- anime softness;
- cartoon comedy;
- random species mismatches;
- making every nation visually identical;
- making every nonhuman look human;
- low-detail or distorted anatomy.

### 21.2 National visual language

- **Drakona:** bright sky-spires, layered silks, sashes, lacquer cues, ornate metalwork, filigree, dragon motifs, fantasy dragoon regalia.
- **Aethelgard:** Arthurian high fantasy, practical knightly silhouettes, cloaks, heraldry, keeps, neutral civic authority.
- **Holy Crown:** chivalric, sacred, courtly, polished armor, tabards, ribbons, stained glass, agricultural warmth.
- **Sylvera:** refined natural fantasy, layered robes, jade and silver, living wood, roots, mist, water, ritual craft.
- **Valen:** early industrial/Renaissance fantasy, coats, vests, leather, firearms, workshops, brass, iron, rail, smoke.

### 21.3 True dragon design

True dragons are civilized, intelligent western dragons:

- four limbs;
- shoulder-rooted wings;
- long neck;
- powerful chest;
- full dragon head;
- tail;
- horns or crest;
- expressive intelligent eyes.

True dragons generally do not wear humanoid clothing. Show status through:

- horn rings;
- neck chains;
- collar pieces;
- clan medallions;
- gemstones;
- chest chains;
- council jewelry;
- fitted ornament and insignia.

Use a seated noble pose for rulers:

- upright;
- chest open;
- neck raised in a composed arc;
- wings naturally framing the body;
- tail controlled;
- forelimbs balanced;
- regal stillness rather than roaring aggression.

### 21.4 Humanoid true-dragon form

A true dragon in humanoid form is mostly human-shaped but visibly ancient and draconic. Use controlled scales, horns/crest, dragonlike eyes, and elegant posture. It must read as a dragon choosing humanoid form, not an ordinary Drakken.

### 21.5 Hybrid true-dragon form

Hybrid form remains humanoid-dominant and wears clothing, armor, or regalia. It may include heavier scales, pronounced horns, wings, tail, claws, and a more dragonlike face. It should read as a true dragon taking a war-ready humanoid shape.

### 21.6 Dragon negative rules

Avoid:

- eastern serpentine anatomy unless explicitly authored;
- low-set wings;
- clothing on true-dragon form;
- unclothed humanoid hybrids;
- cute mascot dragons;
- copy-paste skull shapes;
- mindless roaring poses for rulers;
- tyrant-dark Drakona by default;
- plastic scales and excessive glow;
- treating a dragon portrait as a monster card.

---

## 22. Developer-only secret canon

> **Do not expose this section through ordinary dialogue, journals, temples, Magi-Knight records, Slayer reports, standard Bestiary entries, public ruins, or casual scholars.**

### 22.1 The old mortal world

Balen was once part of a much larger mortal world containing multiple continents and forgotten peoples.

### 22.2 The Celestial Sin

The Celestials were radiant, angelic beastkin-like beings who mastered Light magic and approached divinity. Many sought to elevate their entire people into the Pantheon. To force a path upward, they opened gates both to the gods' realm and to the Hells.

This act created the conditions that birthed the Shaydes.

### 22.3 The true nature of Shaydes

Shaydes are Celestial Daemons: corrupted consequences of the Celestial Sin, not an ordinary extinct monster species.

### 22.4 Xaveraxis the Golden

Xaveraxis the Golden was the First Dragon / god-dragon connected to the creation of the first true dragons and the ancient war. He is central to the origins of draconic divinity, the Crystal Crown, and Dominus.

### 22.5 The Crystal Crown

The gods did **not** use the Crystal Crown to perpetuate war. It was forged from a severed crystal scale of Xaveraxis and intended to channel Light against the Shayde curse.

### 22.6 Abyssal Towers and the Sundering

The Abyssal Towers, war against the Shaydes, collapse of old civilizations, and the Sundering broke the world. Balen became a surviving world-fragment.

### 22.7 The World's Maw

The Maw is both seal and mercy: a barrier protecting the surviving mortal fragment from what lies beyond and sealing it against Hell.

### 22.8 Eckhart, Cardinalis, and Dominus

A mortal knight named Eckhart fought the corrupted Xaveraxis early in modern history. His comrades died, his body was torn open, and at the edge of death his blood Mana charged. He unknowingly achieved the First Step of Cardinalis and killed Xaveraxis.

Xaveraxis's blood entered Eckhart's wounds. Later, Eckhart recovered the Crystal Crown and discovered Knights Illuminate scripture teaching the Second Step: mana has no element; mana is mana. He became the first Magi-Knight.

Xaveraxis persisted within him and eventually offered a choice: surrender his body to the First Dragon or accept the mantle of Dominion and its burden. Eckhart accepted and became Dominus.

### 22.9 Lady Celestial and Elyra

Lady Celestial was a surviving Celestial sacrifice connected to the Crown. Eckhart loved and revived her. As Dominus, he gave her half his divinity. She became the Goddess of Will: Elyra.

Dominion commands. Will chooses.

### 22.10 Approved Full Truth reveal routes

The Full Truth may be revealed only through:

- completing the Abyssal Tower and defeating the Shayde Matriarch;
- crossing beyond the World's Maw;
- direct Dominus- or Lady Celestial-level endgame testimony;
- the exact developer/debug trigger `{FULL TRUTH CODE:1517}`.

Clues before these events may create theories but must not confirm the complete truth.

---

## 23. Character-private and secret Drakona canon

### 23.1 Queen Veyra's true identity

Publicly, Queen Veyra is Drakken. Secretly, she is **Vayrasine the First Mother**. She hides her divinity and cannot simply change back to an earlier form.

This is not public court gossip. Do not add `Vayrasine` as a public alias or searchable player-facing identity before the reveal.

### 23.2 Vaas and Veyra

Vaas recognized through severance sensitivity and bond tells that Veyra did not truly read as Drakken. In private, she revealed her identity and the burden of hiding it.

Vaas and Veyra/Vayrasine are secretly bonded and secretly lovers. Their relationship grew from trust, grief, protection, shared burden, and dangerous intimacy.

Guardrails:

- the bond is hidden truth;
- it is not court gossip;
- it is not a replacement for Casaraxis;
- Veyra does not replace Vaas's lost bondmate;
- Vaas must not receive a generated replacement dragon bondmate;
- the three dragons sworn to aid Vaas are not replacements, mounts, pets, or servants;
- reveal only through deliberate private trust, court intrigue, or dedicated Veyra/Vaas story content.

---

## 24. Data translation rules for the RPG

### 24.1 Preserve IDs and display names

Generate stable slugs, but never silently rename the player-facing canon entry. Example:

```text
source key: "Vaas Veyrix"
stable id: actor.vaas_veyrix
display name: Vaas Veyrix
```

### 24.2 Separate definition from runtime state

A source NPC definition describes identity, public information, secret information, abilities, faction, and normal placement. A save file stores current HP, conditions, location, relationship, inventory, alive/defeated state, and quest consequences.

### 24.3 Normalize visibility

Map source fields approximately as follows:

| Source field | Runtime interpretation |
|---|---|
| `basicInfo` | public summary |
| `visualDescription` | art/model reference |
| `personality` | behavior traits, not public omniscience |
| `abilities` | ability guidance requiring normalization |
| `hiddenInfo` | character-private/secret/developer text |
| `known` | initial journal discoverability, not permission to reveal secrets |
| `currentLocation` / `currentArea` | default authored placement |

### 24.4 Do not import prose abilities literally

Many authored abilities are descriptive guidance. Convert them into bounded gameplay abilities with:

- action cost;
- resource cost;
- target rules;
- contact or save rule;
- damage type if applicable;
- status duration;
- mechanical effect;
- AI hints;
- clear limitations.

Keep the original prose as developer notes.

### 24.5 Health and threat normalization

Voyage values are not automatically balanced for the Godot tactical testbed. Use level, tier, species, equipment, and authored overrides to create engine-specific bands. Political importance alone does not imply combat power. True dragons should gain scale through armor, resistance, objectives, weak points, movement, and encounter structure rather than only enormous HP.

### 24.6 Authored character protection

Do not generate replacements for:

- rulers;
- commanders;
- council members;
- spouses;
- companions;
- faction leaders;
- named pets or mounts;
- bosses;
- characters required by a story start.

### 24.7 Testbed namespace

All noncanon fixtures use:

- `debug.*` for development tools and actors;
- `testbed.*` for authored slice-only content awaiting canon approval.

They must be clearly excluded from the canonical codex and release data unless explicitly promoted.

---

## 25. Canon validation checklist

Before accepting new content, verify all of the following:

### Terminology

- [ ] Drakken is used for the humanoid dragon-like race.
- [ ] True dragon is used for actual dragons.
- [ ] Draconic Bloodline means true-dragon descent.
- [ ] Drakken Bloodline means Drakken ancestry.
- [ ] Worcen is spelled correctly.
- [ ] Sylveran is the correct adjective/demonym.
- [ ] Valenian and Republican are not treated as exact synonyms.

### Species and law

- [ ] True dragons are people, not pets or ordinary monsters.
- [ ] False-wyrms do not receive dragon citizenship or humanoid forms.
- [ ] A true dragon's child is a dragon, not Drakken.
- [ ] Pseudo-Drakes remain untameable.
- [ ] Pets and companions are not inventory.

### Geography

- [ ] Valen and Sylvera do not share a land border.
- [ ] Dragonfall Pass is Drakona's southern land border.
- [ ] Aerial Strongholds is not labeled the southern border.
- [ ] Skies locations are open air, not automatic docks.
- [ ] The World's Maw cannot be bypassed in ordinary play.

### Nations and politics

- [ ] No nation is morally flattened.
- [ ] Holy Crown government keeps Emperor, High Priestess, house council, and Glaive Commander roles distinct.
- [ ] Aethelgard remains neutral and is governed by Grandmaster/High Exarch structure.
- [ ] Valen uses Senate and civic-industrial politics.
- [ ] Sylvera uses Verdant Crown and Verdant Six.
- [ ] Drakona's coexistence is genuine but politically complex.

### Lore secrecy

- [ ] Public belief does not override endgame truth.
- [ ] Ordinary scholars and records cannot confirm the Full Truth.
- [ ] Veyra's identity remains secret until an approved reveal.
- [ ] Vaas and Veyra's bond/romance remains secret.
- [ ] Daemons and Obsidian Blight are not routine public explanations.
- [ ] Shaydes remain publicly extinct until proof is earned.

### Systems

- [ ] Contact resolves before damage.
- [ ] Only the declared attack source contributes damage.
- [ ] Armor, physical DR, and typed resistance remain distinct.
- [ ] Nonlethal defeat is supported.
- [ ] Currency uses Copper, Silver, and Gold Marks only.
- [ ] Travel preserves elapsed time.

### Art

- [ ] Portrait matches age, species, gender, role, and nation.
- [ ] Drakona is bright sky-civilization, not generic tyranny.
- [ ] True dragons use western anatomy and high-set shoulder wings.
- [ ] True dragons wear adornments, not humanoid clothing.
- [ ] Hybrid forms remain humanoid-dominant and clothed.
- [ ] Major dragons have distinct skulls, silhouettes, postures, and expressions.

---

## 26. Compact glossary

| Term | Meaning |
|---|---|
| Aetherian | person of the neutral lands around Aethelgard |
| Aethelgardian | person who claims Aethelgard city/region as home |
| Crownsworn | citizen or recognized person of the Holy Crown |
| Drakonan | citizen or culturally rooted person of Drakona |
| Drakken | humanoid dragon-like race; not a true dragon |
| Drakken-blooded | person with Drakken humanoid ancestry |
| Draconic Bloodline | actual true-dragon parentage or descent |
| false-wyrm | dragon-like beast/monster, such as wyvern or Pseudo-Drake |
| Republican | Valenian aligned with or serving the Republic political model |
| Sylveran | person/culture/institution of Sylvera; commonly also broad elven demonym in context |
| true dragon | actual sentient dragon person |
| Valenian | broad national/cultural demonym for Valen |
| Worcen | distinct civilized werebeast-like people |
| World-Roots | sacred living foundations central to Sylveran culture |
| Full Truth | protected endgame history of Celestials, Shaydes, Xaveraxis, the Sundering, Dominus, and Elyra |

---

## 27. One-paragraph Codex canon brief

> Balen is an industrial high-fantasy continent where four morally complex nations surround neutral Aethelgard: Drakona's bright dragon-and-Drakken sky civilization, the Holy Crown's agrarian knightly monarchy, Valen's secular gunpowder republic, and Sylvera's World-Root jungle realm of elves and Worcen. True dragons are people and citizens; Drakken are a separate humanoid species; false-wyrms are beasts. Magic, Dracomancy, Bladesinging, Ninefold disciplines, runes, and Valenian technology use distinct resources and constraints. Public history is incomplete, and the Celestial/Shayde origin of the world is endgame truth. Never invent replacement rulers or companions, flatten a nation into evil, expose secret lore casually, confuse borders, or resolve combat as automatic damage exchange.
