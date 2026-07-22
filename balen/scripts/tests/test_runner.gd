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
	_expect_file("res://source_data/voyage/source_manifest.json", failures)

	var registry_script: Variant = load("res://scripts/autoload/DataRegistry.gd")
	if registry_script == null:
		failures.append("DataRegistry script failed to load.")
	else:
		var registry: Node = registry_script.new()
		root.add_child(registry)
		var manifest := registry.load_source_manifest()
		if manifest.get("heroes_version", "") != "Voyage.IO Heroes V35":
			failures.append("Source manifest does not record Voyage.IO Heroes V35.")
		registry.queue_free()

	var game_state_script: Variant = load("res://scripts/autoload/GameState.gd")
	if game_state_script == null:
		failures.append("GameState script failed to load.")
	else:
		var game_state: Node = game_state_script.new()
		var save_data: Dictionary = game_state.to_save_data()
		if save_data.get("debug_seed", 0) != 1517:
			failures.append("GameState default debug seed must be 1517.")

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

