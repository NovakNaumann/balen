extends Node

const SOURCE_MANIFEST_PATH := "res://source_data/voyage/source_manifest.json"

var _definitions: Dictionary = {}
var _source_manifest: Dictionary = {}


func _ready() -> void:
	load_source_manifest()


func load_source_manifest() -> Dictionary:
	if not FileAccess.file_exists(SOURCE_MANIFEST_PATH):
		_source_manifest = {}
		return _source_manifest

	var file := FileAccess.open(SOURCE_MANIFEST_PATH, FileAccess.READ)
	if file == null:
		push_error("Unable to read source manifest: %s" % SOURCE_MANIFEST_PATH)
		_source_manifest = {}
		return _source_manifest

	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		push_error("Source manifest is not a JSON object: %s" % SOURCE_MANIFEST_PATH)
		_source_manifest = {}
		return _source_manifest

	_source_manifest = parsed
	return _source_manifest


func get_source_manifest() -> Dictionary:
	return _source_manifest.duplicate(true)


func register_definition(category: StringName, id: StringName, definition: Dictionary) -> void:
	if not _definitions.has(category):
		_definitions[category] = {}

	var category_definitions: Dictionary = _definitions[category]
	category_definitions[id] = definition.duplicate(true)


func has_definition(category: StringName, id: StringName) -> bool:
	return _definitions.has(category) and _definitions[category].has(id)


func get_definition(category: StringName, id: StringName) -> Dictionary:
	if not has_definition(category, id):
		return {}

	return _definitions[category][id].duplicate(true)


func clear_runtime_cache() -> void:
	_definitions.clear()
	load_source_manifest()

