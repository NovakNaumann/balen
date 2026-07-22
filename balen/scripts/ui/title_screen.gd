extends Control

const TESTBED_SCENE := "res://scenes/testbeds/bootstrap_graybox.tscn"


func _ready() -> void:
	GameState.current_scene_path = "res://scenes/ui/title_screen.tscn"
	EventBus.scene_requested.connect(_on_scene_requested)
	_build_ui()


func _build_ui() -> void:
	var background := ColorRect.new()
	background.color = Color(0.055, 0.067, 0.065)
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var panel := PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.custom_minimum_size = Vector2(560.0, 360.0)
	add_child(panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 32)
	margin.add_theme_constant_override("margin_top", 28)
	margin.add_theme_constant_override("margin_right", 32)
	margin.add_theme_constant_override("margin_bottom", 28)
	panel.add_child(margin)

	var stack := VBoxContainer.new()
	stack.alignment = BoxContainer.ALIGNMENT_CENTER
	stack.add_theme_constant_override("separation", 14)
	margin.add_child(stack)

	var title := Label.new()
	title.text = "BALEN"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 46)
	stack.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "Milestone 0 Godot Testbed"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_font_size_override("font_size", 18)
	stack.add_child(subtitle)

	var scope := Label.new()
	scope.text = "Repository foundation, source rules, services, and graybox boot scene."
	scope.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	scope.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	stack.add_child(scope)

	var start_button := Button.new()
	start_button.text = "Start Graybox"
	start_button.pressed.connect(func() -> void: EventBus.request_scene(TESTBED_SCENE))
	stack.add_child(start_button)

	var save_button := Button.new()
	save_button.text = "Write Smoke Save"
	save_button.pressed.connect(func() -> void: SaveService.save_game())
	stack.add_child(save_button)

	var footer := Label.new()
	footer.text = "Canon guardrails active: true dragons, Drakken, and false-wyrms remain distinct."
	footer.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	footer.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	footer.add_theme_font_size_override("font_size", 12)
	stack.add_child(footer)


func _on_scene_requested(scene_path: String) -> void:
	GameState.current_scene_path = scene_path
	get_tree().change_scene_to_file(scene_path)

