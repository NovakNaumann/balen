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
		if graybox_instance.get_node_or_null("MapAuthoring/Ground/Roads/North South Fountain Boulevard") == null:
			failures.append("Bootstrap graybox scene is missing editable road ground authoring nodes.")
		if graybox_instance.get_node_or_null("MapAuthoring/Ground/Sidewalks/Fountain Pedestrian Apron") == null:
			failures.append("Bootstrap graybox scene is missing editable sidewalk ground authoring nodes.")
		if graybox_instance.get_node_or_null("MapAuthoring/Buildings") == null:
			failures.append("Bootstrap graybox scene is missing editable building authoring nodes.")
		if graybox_instance.get_node_or_null("MapAuthoring/Routes/The Ringmarket") == null:
			failures.append("Bootstrap graybox scene is missing the Ringmarket route authoring node.")
		if graybox_instance.get_node_or_null("MapAuthoring/CombatAreas/Same Scene Combat Test Area") == null:
			failures.append("Bootstrap graybox scene is missing the editable combat area authoring node.")
		if graybox_instance.has_method("_authoring_nodes") and graybox_instance.call("_authoring_nodes", 3).size() < 10:
			failures.append("Bootstrap graybox should expose editable architecture authoring nodes.")
		graybox_instance.queue_free()

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
