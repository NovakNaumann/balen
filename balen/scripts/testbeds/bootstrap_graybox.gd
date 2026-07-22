extends Node3D

const TITLE_SCENE := "res://scenes/ui/title_screen.tscn"

var _camera_pivot: Node3D
var _camera: Camera3D
var _yaw_degrees := 45.0
var _zoom_distance := 18.0


func _ready() -> void:
	GameState.current_scene_path = "res://scenes/testbeds/bootstrap_graybox.tscn"
	_build_world()
	_build_camera()
	_build_overlay()


func _process(delta: float) -> void:
	_handle_camera_input(delta)


func _build_world() -> void:
	var environment := WorldEnvironment.new()
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0.50, 0.58, 0.62)
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.82, 0.84, 0.78)
	env.ambient_light_energy = 0.8
	environment.environment = env
	add_child(environment)

	var sun := DirectionalLight3D.new()
	sun.name = "DebugSun"
	sun.rotation_degrees = Vector3(-50.0, 35.0, 0.0)
	sun.light_energy = 2.2
	add_child(sun)

	_add_box("Aethelgard Courtyard Floor", Vector3.ZERO, Vector3(18.0, 0.35, 14.0), Color(0.44, 0.48, 0.43))
	_add_box("North Wall Placeholder", Vector3(0.0, 1.5, -7.2), Vector3(18.0, 3.0, 0.4), Color(0.34, 0.35, 0.34))
	_add_box("Archive Block Placeholder", Vector3(-5.0, 1.0, -2.5), Vector3(3.0, 2.0, 3.0), Color(0.38, 0.36, 0.32))
	_add_box("Market Stall Placeholder", Vector3(4.5, 0.75, 2.0), Vector3(3.5, 1.5, 2.0), Color(0.49, 0.40, 0.27))
	_add_box("Interactable Evidence Marker", Vector3(1.5, 0.45, -1.0), Vector3(0.8, 0.55, 0.8), Color(0.78, 0.67, 0.32))

	_add_actor_marker("DEBUG Knight", Vector3(-2.0, 0.75, 3.0), Color(0.28, 0.41, 0.56))
	_add_actor_marker("DEBUG Runescribe", Vector3(-0.65, 0.75, 3.0), Color(0.45, 0.30, 0.58))
	_add_actor_marker("DEBUG Slayer-Scout", Vector3(0.7, 0.75, 3.0), Color(0.31, 0.48, 0.34))
	_add_actor_marker("DEBUG Fourth Slot", Vector3(2.05, 0.75, 3.0), Color(0.54, 0.32, 0.28))


func _build_camera() -> void:
	_camera_pivot = Node3D.new()
	_camera_pivot.name = "IsometricCameraPivot"
	add_child(_camera_pivot)

	_camera = Camera3D.new()
	_camera.name = "IsometricCamera"
	_camera.current = true
	_camera.fov = 38.0
	_camera_pivot.add_child(_camera)
	_update_camera_transform()


func _build_overlay() -> void:
	var layer := CanvasLayer.new()
	layer.name = "MilestoneOverlay"
	add_child(layer)

	var panel := PanelContainer.new()
	panel.anchor_left = 0.02
	panel.anchor_top = 0.02
	panel.anchor_right = 0.36
	panel.anchor_bottom = 0.20
	layer.add_child(panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 14)
	margin.add_theme_constant_override("margin_top", 12)
	margin.add_theme_constant_override("margin_right", 14)
	margin.add_theme_constant_override("margin_bottom", 12)
	panel.add_child(margin)

	var label := Label.new()
	label.text = "Milestone 0 Graybox\nAethelgard hub placeholder\nCamera: Q/E rotate, wheel zoom, Esc title"
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	margin.add_child(label)


func _handle_camera_input(delta: float) -> void:
	var rotation_input := Input.get_axis("camera_rotate_left", "camera_rotate_right")
	if not is_zero_approx(rotation_input):
		_yaw_degrees += rotation_input * 90.0 * delta
		_update_camera_transform()

	if Input.is_action_just_pressed("zoom_in"):
		_zoom_distance = maxf(10.0, _zoom_distance - 1.5)
		_update_camera_transform()

	if Input.is_action_just_pressed("zoom_out"):
		_zoom_distance = minf(26.0, _zoom_distance + 1.5)
		_update_camera_transform()

	if Input.is_action_just_pressed("pause"):
		GameState.current_scene_path = TITLE_SCENE
		get_tree().change_scene_to_file(TITLE_SCENE)


func _update_camera_transform() -> void:
	if _camera_pivot == null or _camera == null:
		return

	_camera_pivot.rotation_degrees = Vector3(0.0, _yaw_degrees, 0.0)
	_camera.position = Vector3(0.0, _zoom_distance * 0.82, _zoom_distance)
	_camera.rotation_degrees = Vector3(-55.0, 0.0, 0.0)


func _add_box(node_name: String, position: Vector3, size: Vector3, color: Color) -> void:
	var body := StaticBody3D.new()
	body.name = node_name
	body.position = position
	add_child(body)

	var mesh_instance := MeshInstance3D.new()
	var box := BoxMesh.new()
	box.size = size
	mesh_instance.mesh = box
	mesh_instance.material_override = _material(color)
	body.add_child(mesh_instance)

	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = size
	collision.shape = shape
	body.add_child(collision)


func _add_actor_marker(node_name: String, position: Vector3, color: Color) -> void:
	var marker := MeshInstance3D.new()
	marker.name = node_name
	marker.position = position
	var capsule := CapsuleMesh.new()
	capsule.radius = 0.28
	capsule.height = 1.45
	marker.mesh = capsule
	marker.material_override = _material(color)
	add_child(marker)


func _material(color: Color) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.78
	return material

