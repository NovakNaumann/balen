extends Node

signal scene_requested(scene_path: String)
signal game_state_changed(change_id: StringName, payload: Dictionary)
signal debug_message(message: String)
signal save_completed(save_path: String)
signal load_completed(save_path: String)


func request_scene(scene_path: String) -> void:
	scene_requested.emit(scene_path)


func publish_state_change(change_id: StringName, payload: Dictionary = {}) -> void:
	game_state_changed.emit(change_id, payload)


func publish_debug(message: String) -> void:
	debug_message.emit(message)

