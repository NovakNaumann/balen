extends Node

const BUILD_TAG := "milestone_0_bootstrap"
const DEBUG_NAMESPACE_PREFIX := "debug."
const TESTBED_NAMESPACE_PREFIX := "testbed."

var deterministic_seed := 1517


func _ready() -> void:
	seed(deterministic_seed)
	_configure_input_actions()


func get_build_report() -> Dictionary:
	return {
		"build_tag": BUILD_TAG,
		"deterministic_seed": deterministic_seed,
		"debug_namespaces": [DEBUG_NAMESPACE_PREFIX, TESTBED_NAMESPACE_PREFIX]
	}


func is_testbed_or_debug_id(id: String) -> bool:
	return id.begins_with(DEBUG_NAMESPACE_PREFIX) or id.begins_with(TESTBED_NAMESPACE_PREFIX)


func assert_condition(condition: bool, message: String) -> bool:
	if not condition:
		push_error(message)
		return false

	return true


func _configure_input_actions() -> void:
	_ensure_mouse_action("select", MOUSE_BUTTON_LEFT)
	_ensure_mouse_action("move_command", MOUSE_BUTTON_RIGHT)
	_ensure_key_action("camera_rotate_left", KEY_Q)
	_ensure_key_action("camera_rotate_right", KEY_E)
	_ensure_mouse_action("zoom_in", MOUSE_BUTTON_WHEEL_UP)
	_ensure_mouse_action("zoom_out", MOUSE_BUTTON_WHEEL_DOWN)
	_ensure_key_action("open_journal", KEY_J)
	_ensure_key_action("open_inventory", KEY_I)
	_ensure_key_action("toggle_combat_overlay", KEY_TAB)
	_ensure_key_action("quick_save", KEY_F5)
	_ensure_key_action("quick_load", KEY_F9)
	_ensure_key_action("pause", KEY_ESCAPE)


func _ensure_key_action(action_name: StringName, physical_keycode: Key) -> void:
	_ensure_action(action_name)
	if not InputMap.action_get_events(action_name).is_empty():
		return

	var event := InputEventKey.new()
	event.physical_keycode = physical_keycode
	InputMap.action_add_event(action_name, event)


func _ensure_mouse_action(action_name: StringName, button_index: MouseButton) -> void:
	_ensure_action(action_name)
	if not InputMap.action_get_events(action_name).is_empty():
		return

	var event := InputEventMouseButton.new()
	event.button_index = button_index
	InputMap.action_add_event(action_name, event)


func _ensure_action(action_name: StringName) -> void:
	if not InputMap.has_action(action_name):
		InputMap.add_action(action_name, 0.5)
