extends SceneTree


func _initialize() -> void:
	var failures: Array[String] = []

	_expect_file("res://scenes/ui/title_screen.tscn", failures)
	_expect_file("res://scenes/testbeds/bootstrap_graybox.tscn", failures)
	_expect_file("res://scripts/autoload/DataRegistry.gd", failures)
	_expect_file("res://scripts/autoload/EventBus.gd", failures)
	_expect_file("res://scripts/autoload/GameState.gd", failures)
	_expect_file("res://scripts/autoload/SaveService.gd", failures)
	_expect_file("res://scripts/autoload/DebugService.gd", failures)
	_expect_file("res://scripts/world/map_asset_catalog.gd", failures)
	_expect_file("res://scripts/world/plaza_authoring_node.gd", failures)
	_expect_file("res://source_data/voyage/source_manifest.json", failures)
	_expect_file("res://source_data/voyage/balen_35_low_hp_d20_known_patch.json", failures)
	_expect_external_file(ProjectSettings.globalize_path("res://../docs/Balen_Codex_Playable_Test_Phase_Plan.md"), failures)
	_expect_external_file(ProjectSettings.globalize_path("res://../docs/2_5d_style_reference.md"), failures)
	_expect_external_file(ProjectSettings.globalize_path("res://../docs/decisions.md"), failures)
	_expect_external_file(ProjectSettings.globalize_path("res://../docs/assumptions.md"), failures)
	_expect_external_file(ProjectSettings.globalize_path("res://../docs/known_issues.md"), failures)
	_expect_external_file(ProjectSettings.globalize_path("res://../docs/playtest_checklist.md"), failures)
	_expect_external_file(ProjectSettings.globalize_path("res://../docs/reference/aethelgard_concept_crossroads_plaza.png"), failures)
	_expect_external_file(ProjectSettings.globalize_path("res://../docs/reference/aethelgard_concept_crossroads_plaza_circled.png"), failures)
	_expect_external_file(ProjectSettings.globalize_path("res://../docs/reference/aethelgard_plaza_ground_grandeur_reference.png"), failures)
	_expect_external_file(ProjectSettings.globalize_path("res://../docs/reference/aethelgard_plaza_scale_reference.png"), failures)
	_expect_external_file(ProjectSettings.globalize_path("res://../docs/reference/painterly_reference_rookmire_curios.png"), failures)
	_expect_external_file(ProjectSettings.globalize_path("res://../docs/reference/painterly_reference_aethelgard_jeweler.png"), failures)
	_expect_external_file(ProjectSettings.globalize_path("res://../docs/reference/painterly_reference_worcen_knight.png"), failures)
	_expect_external_file(ProjectSettings.globalize_path("res://../docs/reference/painterly_reference_magi_knight_researcher.png"), failures)

	var registry_script: Variant = load("res://scripts/autoload/DataRegistry.gd")
	if registry_script == null:
		failures.append("DataRegistry script failed to load.")
	else:
		var registry: Node = registry_script.new()
		root.add_child(registry)
		var manifest := registry.load_source_manifest()
		if manifest.get("heroes_version", "") != "Voyage.IO Heroes V35":
			failures.append("Source manifest does not record Voyage.IO Heroes V35.")
		if manifest.get("source_filename", "") != "balen_35_low_hp_d20_known_patch.json":
			failures.append("Source manifest does not reference the latest copied Voyage JSON.")
		if manifest.get("source_hash_sha256", "") != "E7C75DFA082DE61FD0AFD1CBE242179764BE5533EEF27B10E29E55E17344606B":
			failures.append("Source manifest hash does not match the copied Voyage JSON.")
		var authority_documents: Array = manifest.get("authority_documents", [])
		if not authority_documents.has("docs/Balen_Codex_Playable_Test_Phase_Plan.md"):
			failures.append("Source manifest does not list the playable test phase plan as authority.")
		registry.queue_free()

	var game_state_script: Variant = load("res://scripts/autoload/GameState.gd")
	if game_state_script == null:
		failures.append("GameState script failed to load.")
	else:
		var game_state: Node = game_state_script.new()
		var save_data: Dictionary = game_state.to_save_data()
		if save_data.get("debug_seed", 0) != 1517:
			failures.append("GameState default debug seed must be 1517.")
		if save_data.get("content_build_version", "") != "milestone_1_working_test":
			failures.append("GameState content build version should identify the working test.")

	var debug_service_script: Variant = load("res://scripts/autoload/DebugService.gd")
	if debug_service_script == null:
		failures.append("DebugService script failed to load.")
	else:
		var debug_service: Node = debug_service_script.new()
		root.add_child(debug_service)
		debug_service._ready()
		for action_name in ["select", "move_command", "toggle_combat_overlay", "quick_save", "quick_load", "pause"]:
			if not InputMap.has_action(action_name):
				failures.append("Missing working-test input action: %s" % action_name)
		debug_service.queue_free()

	var graybox_scene: Variant = load("res://scenes/testbeds/bootstrap_graybox.tscn")
	if graybox_scene == null:
		failures.append("Bootstrap graybox scene failed to load.")
	else:
		var graybox_instance: Node = graybox_scene.instantiate()
		if not FileAccess.file_exists("res://maps/crossroads_plaza.json"):
			failures.append("Crossroads Plaza should be driven by a painted map JSON file.")
		else:
			var parsed_map: Variant = JSON.parse_string(FileAccess.get_file_as_string("res://maps/crossroads_plaza.json"))
			if typeof(parsed_map) != TYPE_DICTIONARY:
				failures.append("Crossroads Plaza map JSON should parse as a dictionary.")
			else:
				var terrain: Array = parsed_map.get("terrain", [])
				var placements: Array = parsed_map.get("placements", [])
				var road_count := 0
				var sidewalk_count := 0
				var building_count := 0
				var has_ringmarket := false
				var has_combat_area := false
				for terrain_entry in terrain:
					if typeof(terrain_entry) != TYPE_DICTIONARY:
						continue
					if str(terrain_entry.get("kind", "")) == "road":
						road_count += 1
					elif str(terrain_entry.get("kind", "")) == "sidewalk":
						sidewalk_count += 1
				for placement in placements:
					if typeof(placement) != TYPE_DICTIONARY:
						continue
					if int(placement.get("kind", -1)) == 3:
						building_count += 1
					if str(placement.get("name", "")) == "The Ringmarket":
						has_ringmarket = true
					if str(placement.get("name", "")) == "Same Scene Combat Test Area":
						has_combat_area = true
				if road_count < 100:
					failures.append("Crossroads Plaza should contain painted road tiles.")
				if sidewalk_count < 100:
					failures.append("Crossroads Plaza should contain painted sidewalk tiles.")
				if building_count < 10:
					failures.append("Crossroads Plaza should contain placed building assets.")
				if not has_ringmarket:
					failures.append("Crossroads Plaza map JSON should keep the Ringmarket route placement.")
				if not has_combat_area:
					failures.append("Crossroads Plaza map JSON should keep the same-scene combat placement.")
		if graybox_instance.has_method("_is_grid_walkable"):
			graybox_instance.call("_load_map_data")
			if not bool(graybox_instance.call("_is_grid_walkable", Vector2i(0, 0))):
				failures.append("Authored Crossroads Plaza should keep the central fountain road walkable.")
			if not bool(graybox_instance.call("_is_grid_walkable", Vector2i(-12, 7))):
				failures.append("Authored Crossroads Plaza should keep the Slayers Guild road exit walkable.")
			if not bool(graybox_instance.call("_is_grid_walkable", Vector2i(12, 7))):
				failures.append("Authored Crossroads Plaza should keep the Ringmarket road exit walkable.")
			if not bool(graybox_instance.call("_is_grid_walkable", Vector2i(-7, -6))):
				failures.append("Painted Crossroads Plaza fountain ring road should be walkable.")
			if not bool(graybox_instance.call("_is_grid_walkable", Vector2i(14, 5))):
				failures.append("Authored Crossroads Plaza road exit caps should be walkable.")
			if bool(graybox_instance.call("_is_grid_walkable", Vector2i(-14, 2))):
				failures.append("Authored Crossroads Plaza building walls should block movement.")
			if bool(graybox_instance.call("_is_grid_walkable", Vector2i(-14, -3))):
				failures.append("Authored Crossroads Plaza perimeter wall infill should block movement.")
		graybox_instance.queue_free()

	var map_builder_scene: Variant = load("res://scenes/tools/map_builder.tscn")
	if map_builder_scene == null:
		failures.append("Map builder scene should load.")

	var graybox_script: Variant = load("res://scripts/testbeds/bootstrap_graybox.gd")
	if graybox_script == null:
		failures.append("Bootstrap graybox script failed to load.")
	else:
		var graybox: Node = graybox_script.new()
		var authored_node := Node2D.new()
		authored_node.set_script(load("res://scripts/world/plaza_authoring_node.gd"))
		authored_node.grid_position = Vector2i.ZERO
		authored_node.position = Vector2(560.0, 168.0)
		if graybox._authored_grid_position(authored_node) != Vector2i(8, -2):
			failures.append("Runtime placement should follow the visible editor position when it diverges from grid_position.")
		authored_node.queue_free()
		var back_anchor: Vector2 = graybox._authoring_position_from_grid(Vector2i(0, 0))
		var front_anchor: Vector2 = graybox._authoring_position_from_grid(Vector2i(0, 1))
		if graybox._depth_z(front_anchor, 0) <= graybox._depth_z(back_anchor, 4):
			failures.append("Foreground objects should sort above the highest local layer of background objects.")
		if graybox.LAYER_ROAD >= graybox._depth_z(graybox._authoring_position_from_grid(Vector2i(0, -24)), 0):
			failures.append("Road and sidewalk layers should remain below authored objects.")
		if not graybox._is_grid_walkable(Vector2i(0, 0)):
			failures.append("Central plaza tile should remain walkable.")
		if not graybox._is_grid_walkable(Vector2i(-12, 7)):
			failures.append("Left road exit to Slayers Guild HQ should remain walkable.")
		if not graybox._is_grid_walkable(Vector2i(12, 7)):
			failures.append("Right road exit to The Ringmarket should remain walkable.")
		if graybox._is_grid_walkable(Vector2i(-14, 2)):
			failures.append("Slayers Guild Plaza Front footprint must block movement.")
		graybox.queue_free()

	var authoring_script: Variant = load("res://scripts/world/plaza_authoring_node.gd")
	if authoring_script == null:
		failures.append("Plaza authoring node script failed to load.")
	else:
		var grid := Vector2i(8, -3)
		var world_position: Vector2 = authoring_script.grid_to_iso(grid)
		if authoring_script.world_to_grid(world_position) != grid:
			failures.append("Plaza authoring grid/world conversion should round-trip for editor movement.")
		var placement: Node = authoring_script.new()
		placement.asset_id = "market.stall.row"
		if int(placement.kind) != 4:
			failures.append("Market row asset should apply the tent authoring kind.")
		if int(placement.render_style) != 3:
			failures.append("Market row asset should use modular block rendering.")
		if placement.footprint != Vector2i(1, 3):
			failures.append("Market row asset should apply its catalog footprint.")
		placement.queue_free()

	var asset_catalog: Variant = load("res://scripts/world/map_asset_catalog.gd")
	if asset_catalog == null:
		failures.append("Map asset catalog failed to load.")
	elif not asset_catalog.has_asset("building.guild_front"):
		failures.append("Map asset catalog should expose a guild-front building preset.")

	if failures.is_empty():
		print("BALEN_TESTS_OK")
		quit(0)
		return

	for failure in failures:
		push_error(failure)
	print("BALEN_TESTS_FAILED %d" % failures.size())
	quit(1)


func _expect_file(path: String, failures: Array[String]) -> void:
	if not FileAccess.file_exists(path):
		failures.append("Missing expected file: %s" % path)


func _expect_external_file(path: String, failures: Array[String]) -> void:
	if not FileAccess.file_exists(path):
		failures.append("Missing expected file: %s" % path)
