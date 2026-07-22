extends Node

const DEFAULT_SAVE_PATH := "user://balen_milestone_0_save.json"


func save_game(save_path: String = DEFAULT_SAVE_PATH) -> bool:
	var file := FileAccess.open(save_path, FileAccess.WRITE)
	if file == null:
		push_error("Unable to open save path for writing: %s" % save_path)
		return false

	var payload := JSON.stringify(GameState.to_save_data(), "\t")
	file.store_string(payload)
	EventBus.save_completed.emit(save_path)
	return true


func load_game(save_path: String = DEFAULT_SAVE_PATH) -> bool:
	if not FileAccess.file_exists(save_path):
		push_warning("Save path does not exist: %s" % save_path)
		return false

	var file := FileAccess.open(save_path, FileAccess.READ)
	if file == null:
		push_error("Unable to open save path for reading: %s" % save_path)
		return false

	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		push_error("Save file is not a JSON object: %s" % save_path)
		return false

	GameState.apply_save_data(parsed)
	EventBus.load_completed.emit(save_path)
	return true

