extends Node

const DEFAULT_DEBUG_SEED := 1517

var content_build_version := "milestone_0"
var debug_seed := DEFAULT_DEBUG_SEED
var current_scene_path := "res://scenes/ui/title_screen.tscn"
var party_runtime_state: Dictionary = {}
var quest_facts: Dictionary = {}
var evidence_state: Dictionary = {}
var world_state: Dictionary = {}


func reset_for_new_game() -> void:
	debug_seed = DEFAULT_DEBUG_SEED
	current_scene_path = "res://scenes/ui/title_screen.tscn"
	party_runtime_state.clear()
	quest_facts.clear()
	evidence_state.clear()
	world_state.clear()


func to_save_data() -> Dictionary:
	return {
		"save_schema_version": 1,
		"content_build_version": content_build_version,
		"debug_seed": debug_seed,
		"current_scene_path": current_scene_path,
		"party_runtime_state": party_runtime_state.duplicate(true),
		"quest_facts": quest_facts.duplicate(true),
		"evidence_state": evidence_state.duplicate(true),
		"world_state": world_state.duplicate(true)
	}


func apply_save_data(save_data: Dictionary) -> void:
	content_build_version = str(save_data.get("content_build_version", content_build_version))
	debug_seed = int(save_data.get("debug_seed", DEFAULT_DEBUG_SEED))
	current_scene_path = str(save_data.get("current_scene_path", current_scene_path))
	party_runtime_state = _dictionary_or_empty(save_data.get("party_runtime_state", {}))
	quest_facts = _dictionary_or_empty(save_data.get("quest_facts", {}))
	evidence_state = _dictionary_or_empty(save_data.get("evidence_state", {}))
	world_state = _dictionary_or_empty(save_data.get("world_state", {}))


func _dictionary_or_empty(value: Variant) -> Dictionary:
	if typeof(value) == TYPE_DICTIONARY:
		return value.duplicate(true)

	return {}

