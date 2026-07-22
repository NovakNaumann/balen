extends Node2D

const TITLE_SCENE := "res://scenes/ui/title_screen.tscn"
const DESIGN_RESOLUTION := Vector2(1920.0, 1080.0)
const TILE_SIZE := Vector2(112.0, 56.0)

var _camera: Camera2D
var _world_root: Node2D
var _view_rotation_steps := 0
var _zoom := 1.0


func _ready() -> void:
	GameState.current_scene_path = "res://scenes/testbeds/bootstrap_graybox.tscn"
	_build_scene()
	_rebuild_world()
	_build_overlay()


func _process(_delta: float) -> void:
	_handle_camera_input()


func _build_scene() -> void:
	var background := ColorRect.new()
	background.name = "Native1080Background"
	background.color = Color(0.09, 0.11, 0.105)
	background.size = DESIGN_RESOLUTION
	background.position = -DESIGN_RESOLUTION * 0.5
	background.z_index = -1000
	add_child(background)

	_world_root = Node2D.new()
	_world_root.name = "Isometric2_5DWorld"
	add_child(_world_root)

	_camera = Camera2D.new()
	_camera.name = "Native1080Camera2D"
	_camera.enabled = true
	_camera.position = Vector2.ZERO
	add_child(_camera)


func _rebuild_world() -> void:
	for child in _world_root.get_children():
		child.queue_free()

	_add_diamond_floor(Vector2i(0, 0), Vector2i(9, 7), Color(0.42, 0.48, 0.43), "Aethelgard Courtyard")
	_add_isometric_block("North Wall Placeholder", Vector2i(0, -4), Vector2i(10, 1), 2.0, Color(0.34, 0.36, 0.34))
	_add_isometric_block("Archive Block Placeholder", Vector2i(-4, -1), Vector2i(2, 2), 1.6, Color(0.37, 0.35, 0.31))
	_add_isometric_block("Market Stall Placeholder", Vector2i(3, 1), Vector2i(3, 2), 1.0, Color(0.50, 0.39, 0.24))
	_add_isometric_block("Evidence Marker", Vector2i(1, -1), Vector2i(1, 1), 0.45, Color(0.82, 0.68, 0.30))
	_add_same_environment_combat_overlay(Vector2i(0, 1), Vector2i(7, 5))

	_add_actor_marker("DEBUG Knight", Vector2i(-2, 3), Color(0.28, 0.42, 0.58))
	_add_actor_marker("DEBUG Runescribe", Vector2i(-1, 3), Color(0.46, 0.31, 0.59))
	_add_actor_marker("DEBUG Slayer-Scout", Vector2i(0, 3), Color(0.32, 0.49, 0.35))
	_add_actor_marker("DEBUG Fourth Slot", Vector2i(1, 3), Color(0.56, 0.32, 0.27))

	var label := Label.new()
	label.text = "2.5D isometric graybox: exploration and combat share this environment"
	label.position = Vector2(-430.0, -330.0)
	label.add_theme_font_size_override("font_size", 24)
	_world_root.add_child(label)


func _build_overlay() -> void:
	var layer := CanvasLayer.new()
	layer.name = "MilestoneOverlay"
	add_child(layer)

	var panel := PanelContainer.new()
	panel.anchor_left = 0.02
	panel.anchor_top = 0.02
	panel.anchor_right = 0.30
	panel.anchor_bottom = 0.17
	layer.add_child(panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 16)
	margin.add_theme_constant_override("margin_top", 14)
	margin.add_theme_constant_override("margin_right", 16)
	margin.add_theme_constant_override("margin_bottom", 14)
	panel.add_child(margin)

	var label := Label.new()
	label.text = "Milestone 0 2.5D Graybox\nNative target: 1920 x 1080\nCombat overlay stays in-world\nQ/E rotate view, wheel zoom, Esc title"
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", 18)
	margin.add_child(label)


func _handle_camera_input() -> void:
	if Input.is_action_just_pressed("camera_rotate_left"):
		_view_rotation_steps = wrapi(_view_rotation_steps - 1, 0, 4)
		_rebuild_world()

	if Input.is_action_just_pressed("camera_rotate_right"):
		_view_rotation_steps = wrapi(_view_rotation_steps + 1, 0, 4)
		_rebuild_world()

	if Input.is_action_just_pressed("zoom_in"):
		_zoom = minf(1.35, _zoom + 0.1)
		_camera.zoom = Vector2(_zoom, _zoom)

	if Input.is_action_just_pressed("zoom_out"):
		_zoom = maxf(0.75, _zoom - 0.1)
		_camera.zoom = Vector2(_zoom, _zoom)

	if Input.is_action_just_pressed("pause"):
		GameState.current_scene_path = TITLE_SCENE
		get_tree().change_scene_to_file(TITLE_SCENE)


func _add_diamond_floor(origin: Vector2i, size: Vector2i, color: Color, node_name: String) -> void:
	for x in range(origin.x - size.x / 2, origin.x + size.x / 2 + 1):
		for y in range(origin.y - size.y / 2, origin.y + size.y / 2 + 1):
			var tile_position := _iso(Vector2i(x, y))
			var tile := Polygon2D.new()
			tile.name = "%s %d,%d" % [node_name, x, y]
			tile.polygon = PackedVector2Array([
				tile_position + Vector2(0.0, -TILE_SIZE.y * 0.5),
				tile_position + Vector2(TILE_SIZE.x * 0.5, 0.0),
				tile_position + Vector2(0.0, TILE_SIZE.y * 0.5),
				tile_position + Vector2(-TILE_SIZE.x * 0.5, 0.0)
			])
			tile.color = color.lightened(0.08 if (x + y) % 2 == 0 else 0.0)
			tile.z_index = int(tile_position.y)
			_world_root.add_child(tile)


func _add_isometric_block(node_name: String, origin: Vector2i, footprint: Vector2i, height_tiles: float, color: Color) -> void:
	var corners := [
		_iso(origin),
		_iso(origin + Vector2i(footprint.x, 0)),
		_iso(origin + footprint),
		_iso(origin + Vector2i(0, footprint.y))
	]
	var lift := Vector2(0.0, -height_tiles * TILE_SIZE.y)
	var top := PackedVector2Array([corners[0] + lift, corners[1] + lift, corners[2] + lift, corners[3] + lift])
	var right := PackedVector2Array([corners[1] + lift, corners[2] + lift, corners[2], corners[1]])
	var left := PackedVector2Array([corners[2] + lift, corners[3] + lift, corners[3], corners[2]])

	_add_polygon("%s RightFace" % node_name, right, color.darkened(0.18), int(corners[2].y))
	_add_polygon("%s LeftFace" % node_name, left, color.darkened(0.28), int(corners[2].y) + 1)
	_add_polygon("%s TopFace" % node_name, top, color.lightened(0.08), int(corners[2].y) + 2)


func _add_actor_marker(node_name: String, grid_position: Vector2i, color: Color) -> void:
	var base := _iso(grid_position)
	var shadow := Polygon2D.new()
	shadow.name = "%s Shadow" % node_name
	shadow.polygon = PackedVector2Array([
		base + Vector2(0.0, -13.0),
		base + Vector2(30.0, 0.0),
		base + Vector2(0.0, 13.0),
		base + Vector2(-30.0, 0.0)
	])
	shadow.color = Color(0.0, 0.0, 0.0, 0.24)
	shadow.z_index = int(base.y) + 3
	_world_root.add_child(shadow)

	var body := Polygon2D.new()
	body.name = node_name
	body.polygon = PackedVector2Array([
		base + Vector2(-22.0, 4.0),
		base + Vector2(-16.0, -60.0),
		base + Vector2(0.0, -90.0),
		base + Vector2(16.0, -60.0),
		base + Vector2(22.0, 4.0),
		base + Vector2(0.0, 18.0)
	])
	body.color = color
	body.z_index = int(base.y) + 4
	_world_root.add_child(body)

	var label := Label.new()
	label.text = node_name
	label.position = base + Vector2(-58.0, 20.0)
	label.add_theme_font_size_override("font_size", 13)
	label.z_index = int(base.y) + 5
	_world_root.add_child(label)


func _add_same_environment_combat_overlay(origin: Vector2i, size: Vector2i) -> void:
	for x in range(origin.x - size.x / 2, origin.x + size.x / 2 + 1):
		for y in range(origin.y - size.y / 2, origin.y + size.y / 2 + 1):
			var cell_color := Color(0.20, 0.55, 0.78, 0.34)
			if x <= origin.x - 2:
				cell_color = Color(0.23, 0.64, 0.42, 0.42)
			elif x >= origin.x + 2:
				cell_color = Color(0.78, 0.34, 0.28, 0.42)
			_add_diamond_outline("Same Scene Combat Cell %d,%d" % [x, y], _iso(Vector2i(x, y)), cell_color)

	var tag := Label.new()
	tag.text = "same-scene combat layer"
	tag.position = _iso(origin + Vector2i(2, -3)) + Vector2(12.0, -10.0)
	tag.add_theme_font_size_override("font_size", 14)
	tag.z_index = int(tag.position.y) + 20
	_world_root.add_child(tag)


func _add_diamond_outline(node_name: String, center: Vector2, color: Color) -> void:
	var outline := Line2D.new()
	outline.name = node_name
	outline.width = 2.0
	outline.closed = true
	outline.default_color = color
	outline.points = PackedVector2Array([
		center + Vector2(0.0, -TILE_SIZE.y * 0.5),
		center + Vector2(TILE_SIZE.x * 0.5, 0.0),
		center + Vector2(0.0, TILE_SIZE.y * 0.5),
		center + Vector2(-TILE_SIZE.x * 0.5, 0.0)
	])
	outline.z_index = int(center.y) + 10
	_world_root.add_child(outline)


func _add_polygon(node_name: String, points: PackedVector2Array, color: Color, z: int) -> void:
	var polygon := Polygon2D.new()
	polygon.name = node_name
	polygon.polygon = points
	polygon.color = color
	polygon.z_index = z
	_world_root.add_child(polygon)


func _iso(grid_position: Vector2i) -> Vector2:
	var rotated := _rotate_grid(grid_position)
	var x := float(rotated.x - rotated.y) * TILE_SIZE.x * 0.5
	var y := float(rotated.x + rotated.y) * TILE_SIZE.y * 0.5
	return Vector2(x, y)


func _rotate_grid(grid_position: Vector2i) -> Vector2i:
	match _view_rotation_steps:
		1:
			return Vector2i(-grid_position.y, grid_position.x)
		2:
			return Vector2i(-grid_position.x, -grid_position.y)
		3:
			return Vector2i(grid_position.y, -grid_position.x)
		_:
			return grid_position
