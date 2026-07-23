extends Node2D

const MAP_DATA := preload("res://scripts/map/map_data.gd")
const MAP_PATH := "res://maps/crossroads_plaza.json"
const TILE_SIZE := Vector2(112.0, 56.0)
const ELEVATION_STEP := 0.25
const HEIGHT_STEP := 0.25

const TERRAIN_OPTIONS := [
	MAP_DATA.TERRAIN_ROAD,
	MAP_DATA.TERRAIN_SIDEWALK,
	MAP_DATA.TERRAIN_PATH,
	MAP_DATA.TERRAIN_WATER
]
const SHAPE_OPTIONS := ["brush", "line", "ellipse", "ring"]
const OBJECT_PRESETS := [
	{"name": "Aethelgard Merchant House", "asset_id": "building.aethelgard_merchant_house", "kind": 3, "render_style": 2, "footprint": Vector2i(5, 6), "height": 4.0, "color": Color(0.72, 0.67, 0.56), "roof_color": Color(0.11, 0.27, 0.42), "awning_color": Color(0.77, 0.63, 0.39), "blocks_movement": true},
	{"name": "Golden Stein Tavern", "asset_id": "building.aethelgard_tavern", "kind": 3, "render_style": 2, "footprint": Vector2i(5, 5), "height": 3.7, "color": Color(0.66, 0.61, 0.50), "roof_color": Color(0.13, 0.24, 0.36), "awning_color": Color(0.12, 0.26, 0.52), "blocks_movement": true},
	{"name": "Blueglass Curio Shop", "asset_id": "building.aethelgard_curio_shop", "kind": 3, "render_style": 2, "footprint": Vector2i(4, 5), "height": 4.4, "color": Color(0.74, 0.69, 0.58), "roof_color": Color(0.10, 0.29, 0.48), "awning_color": Color(0.10, 0.25, 0.54), "blocks_movement": true},
	{"name": "Civic Guildhall", "asset_id": "building.aethelgard_guildhall", "kind": 3, "render_style": 2, "footprint": Vector2i(7, 6), "height": 5.2, "color": Color(0.76, 0.72, 0.63), "roof_color": Color(0.12, 0.28, 0.46), "awning_color": Color(0.13, 0.25, 0.51), "blocks_movement": true},
	{"name": "Ring Arcade Row", "asset_id": "building.aethelgard_arcade_row", "kind": 3, "render_style": 2, "footprint": Vector2i(8, 3), "height": 3.2, "color": Color(0.68, 0.60, 0.48), "roof_color": Color(0.38, 0.24, 0.17), "awning_color": Color(0.55, 0.36, 0.23), "blocks_movement": true},
	{"name": "Blue Stall", "asset_id": "market.stall.blue", "kind": 4, "footprint": Vector2i.ONE, "height": 0.85, "color": Color(0.16, 0.27, 0.55), "blocks_movement": false},
	{"name": "Stall Row", "asset_id": "market.stall.row", "kind": 4, "footprint": Vector2i(1, 3), "height": 0.85, "color": Color(0.55, 0.35, 0.22), "blocks_movement": false},
	{"name": "Route Marker", "asset_id": "route.marker", "kind": 5, "footprint": Vector2i.ONE, "height": 0.55, "color": Color(0.73, 0.65, 0.50), "blocks_movement": false},
	{"name": "Spawn Marker", "asset_id": "custom", "kind": 6, "footprint": Vector2i.ONE, "height": 1.0, "color": Color(0.28, 0.42, 0.58), "blocks_movement": false},
	{"name": "Banner", "asset_id": "civic.banner.blue_gold", "kind": 8, "footprint": Vector2i.ONE, "height": 1.4, "color": Color(0.12, 0.22, 0.50), "blocks_movement": false},
	{"name": "Combat Area", "asset_id": "combat.same_scene_area", "kind": 9, "footprint": Vector2i(11, 7), "height": 0.0, "color": Color(0.20, 0.55, 0.78, 0.60), "blocks_movement": false}
]

var _map_data: Dictionary = {}
var _bounds: Dictionary = {}
var _terrain_by_key: Dictionary = {}
var _placements: Array[Dictionary] = []
var _selected_terrain_index := 0
var _selected_shape_index := 0
var _selected_object_index := 0
var _selected_placement_index := -1
var _default_elevation := 0.0
var _object_mode := false
var _is_dragging := false
var _is_panning := false
var _drag_start_grid := Vector2i.ZERO
var _drag_current_grid := Vector2i.ZERO
var _last_pan_mouse := Vector2.ZERO
var _camera: Camera2D
var _status_label: Label
var _status_message := "Loaded"


func _ready() -> void:
	_load_map()
	_build_camera()
	_build_ui()
	queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		_handle_key(event)
	elif event is InputEventMouseButton:
		_handle_mouse_button(event)
	elif event is InputEventMouseMotion:
		_handle_mouse_motion(event)


func _draw() -> void:
	_draw_grid()
	_draw_bounds_frame()
	_draw_terrain()
	_draw_placements()
	_draw_cursor_preview()


func _load_map() -> void:
	_map_data = MAP_DATA.load_map(MAP_PATH)
	if _map_data.is_empty():
		_map_data = _default_map()
	_bounds = MAP_DATA.bounds(_map_data)
	_terrain_by_key.clear()
	for entry in _map_data.get("terrain", []):
		if typeof(entry) != TYPE_DICTIONARY:
			continue
		var grid_position: Vector2i = MAP_DATA.grid_from_terrain_entry(entry)
		_terrain_by_key[MAP_DATA.terrain_key(grid_position)] = str(entry.get("kind", MAP_DATA.TERRAIN_SIDEWALK))

	_placements.clear()
	for raw_placement in _map_data.get("placements", []):
		if typeof(raw_placement) == TYPE_DICTIONARY:
			_placements.append(_normalize_placement(raw_placement))


func _default_map() -> Dictionary:
	return {
		"schema_version": 1,
		"id": "crossroads_plaza",
		"display_name": "Crossroads Plaza of Aethelgard",
		"bounds": MAP_DATA.DEFAULT_BOUNDS.duplicate(true),
		"tile_size": [int(TILE_SIZE.x), int(TILE_SIZE.y)],
		"terrain": [],
		"placements": []
	}


func _normalize_placement(raw_placement: Dictionary) -> Dictionary:
	var kind := int(raw_placement.get("kind", 3))
	var fallback_color: Color = Color(0.70, 0.64, 0.52)
	var placement := {
		"name": str(raw_placement.get("name", "Map Object")),
		"asset_id": str(raw_placement.get("asset_id", "custom")),
		"kind": kind,
		"grid": MAP_DATA.grid_from_array(raw_placement.get("grid", []), Vector2i.ZERO),
		"footprint": MAP_DATA.grid_from_array(raw_placement.get("footprint", []), Vector2i.ONE),
		"height": float(raw_placement.get("height", 1.0)),
		"elevation": float(raw_placement.get("elevation", 0.0)),
		"color": MAP_DATA.color_from_array(raw_placement.get("color", []), fallback_color),
		"roof_color": MAP_DATA.color_from_array(raw_placement.get("roof_color", []), Color(0.16, 0.31, 0.46)),
		"awning_color": MAP_DATA.color_from_array(raw_placement.get("awning_color", []), Color.TRANSPARENT),
		"render_style": int(raw_placement.get("render_style", 0)),
		"blocks_movement": bool(raw_placement.get("blocks_movement", kind == 3))
	}
	if raw_placement.has("actor_id"):
		placement["actor_id"] = str(raw_placement.get("actor_id", ""))
	return placement


func _build_camera() -> void:
	_camera = Camera2D.new()
	_camera.name = "MapBuilderCamera"
	_camera.enabled = true
	_camera.position = Vector2.ZERO
	_camera.zoom = Vector2(0.62, 0.62)
	add_child(_camera)


func _build_ui() -> void:
	var layer := CanvasLayer.new()
	layer.name = "MapBuilderUI"
	add_child(layer)

	var panel := PanelContainer.new()
	panel.anchor_left = 0.015
	panel.anchor_top = 0.015
	panel.anchor_right = 0.50
	panel.anchor_bottom = 0.30
	layer.add_child(panel)

	var stack := VBoxContainer.new()
	stack.add_theme_constant_override("separation", 6)
	panel.add_child(stack)

	_status_label = Label.new()
	_status_label.add_theme_font_size_override("font_size", 16)
	stack.add_child(_status_label)

	var bounds_label := Label.new()
	bounds_label.text = "Map Boundary"
	bounds_label.add_theme_font_size_override("font_size", 14)
	stack.add_child(bounds_label)

	var bounds_row := HBoxContainer.new()
	bounds_row.add_theme_constant_override("separation", 4)
	stack.add_child(bounds_row)
	_add_button(bounds_row, "All -", _resize_all_bounds.bind(-1))
	_add_button(bounds_row, "All +", _resize_all_bounds.bind(1))
	_add_button(bounds_row, "W In", _resize_bound.bind("west", -1))
	_add_button(bounds_row, "W Out", _resize_bound.bind("west", 1))
	_add_button(bounds_row, "E In", _resize_bound.bind("east", -1))
	_add_button(bounds_row, "E Out", _resize_bound.bind("east", 1))
	_add_button(bounds_row, "N In", _resize_bound.bind("north", -1))
	_add_button(bounds_row, "N Out", _resize_bound.bind("north", 1))
	_add_button(bounds_row, "S In", _resize_bound.bind("south", -1))
	_add_button(bounds_row, "S Out", _resize_bound.bind("south", 1))

	var object_label := Label.new()
	object_label.text = "Selected Object"
	object_label.add_theme_font_size_override("font_size", 14)
	stack.add_child(object_label)

	var object_row := HBoxContainer.new()
	object_row.add_theme_constant_override("separation", 4)
	stack.add_child(object_row)
	_add_button(object_row, "Elev -", _adjust_selected_elevation.bind(-ELEVATION_STEP))
	_add_button(object_row, "Elev +", _adjust_selected_elevation.bind(ELEVATION_STEP))
	_add_button(object_row, "Height -", _adjust_selected_height.bind(-HEIGHT_STEP))
	_add_button(object_row, "Height +", _adjust_selected_height.bind(HEIGHT_STEP))
	_refresh_status()


func _add_button(parent: Control, text: String, callback: Callable) -> void:
	var button := Button.new()
	button.text = text
	button.focus_mode = Control.FOCUS_NONE
	button.pressed.connect(callback)
	parent.add_child(button)


func _handle_key(event: InputEventKey) -> void:
	if event.alt_pressed:
		_handle_boundary_hotkey(event)
		return

	match event.keycode:
		KEY_1:
			_select_terrain(0)
		KEY_2:
			_select_terrain(1)
		KEY_3:
			_select_terrain(2)
		KEY_4:
			_select_terrain(3)
		KEY_B:
			_select_shape("brush")
		KEY_L:
			_select_shape("line")
		KEY_E:
			_select_shape("ellipse")
		KEY_R:
			_select_shape("ring")
		KEY_O:
			_object_mode = not _object_mode
			_status_message = "Object mode" if _object_mode else "Terrain mode"
		KEY_TAB:
			_selected_object_index = (_selected_object_index + 1) % OBJECT_PRESETS.size()
			_object_mode = true
			_status_message = "Selected object: %s" % OBJECT_PRESETS[_selected_object_index]["name"]
		KEY_G:
			_generate_sidewalk_outline()
			_status_message = "Generated 2-tile sidewalks around roads"
		KEY_S:
			_save_map()
		KEY_F5:
			_load_map()
			_status_message = "Reloaded"
		KEY_PAGEUP:
			_adjust_selected_elevation(ELEVATION_STEP)
		KEY_PAGEDOWN:
			_adjust_selected_elevation(-ELEVATION_STEP)
		KEY_PERIOD:
			_adjust_selected_height(HEIGHT_STEP)
		KEY_COMMA:
			_adjust_selected_height(-HEIGHT_STEP)
	_refresh_status()
	queue_redraw()


func _handle_boundary_hotkey(event: InputEventKey) -> void:
	var delta := -1 if event.shift_pressed else 1
	match event.keycode:
		KEY_LEFT:
			_resize_bound("west", delta)
		KEY_RIGHT:
			_resize_bound("east", delta)
		KEY_UP:
			_resize_bound("north", delta)
		KEY_DOWN:
			_resize_bound("south", delta)
		_:
			return
	_refresh_status()
	queue_redraw()


func _select_terrain(index: int) -> void:
	_selected_terrain_index = clampi(index, 0, TERRAIN_OPTIONS.size() - 1)
	_object_mode = false
	_status_message = "Selected terrain: %s" % _selected_terrain()


func _select_shape(shape_name: String) -> void:
	var index := SHAPE_OPTIONS.find(shape_name)
	if index >= 0:
		_selected_shape_index = index
		_object_mode = false
		_status_message = "Selected shape: %s" % shape_name


func _resize_all_bounds(delta: int) -> void:
	_bounds["min_x"] = int(_bounds["min_x"]) - delta
	_bounds["max_x"] = int(_bounds["max_x"]) + delta
	_bounds["min_y"] = int(_bounds["min_y"]) - delta
	_bounds["max_y"] = int(_bounds["max_y"]) + delta
	_sanitize_bounds()
	_status_message = "Map boundary resized to %s" % _bounds_text()
	_refresh_status()
	queue_redraw()


func _resize_bound(side: String, direction: int) -> void:
	match side:
		"west":
			_bounds["min_x"] = int(_bounds["min_x"]) - direction
		"east":
			_bounds["max_x"] = int(_bounds["max_x"]) + direction
		"north":
			_bounds["min_y"] = int(_bounds["min_y"]) - direction
		"south":
			_bounds["max_y"] = int(_bounds["max_y"]) + direction
	_sanitize_bounds()
	_status_message = "%s boundary resized to %s" % [side.capitalize(), _bounds_text()]
	_refresh_status()
	queue_redraw()


func _sanitize_bounds() -> void:
	if int(_bounds["min_x"]) > int(_bounds["max_x"]) - 2:
		_bounds["min_x"] = int(_bounds["max_x"]) - 2
	if int(_bounds["min_y"]) > int(_bounds["max_y"]) - 2:
		_bounds["min_y"] = int(_bounds["max_y"]) - 2


func _bounds_text() -> String:
	return "x %d..%d, y %d..%d" % [int(_bounds["min_x"]), int(_bounds["max_x"]), int(_bounds["min_y"]), int(_bounds["max_y"])]


func _adjust_selected_elevation(delta: float) -> void:
	if _selected_placement_index >= 0 and _selected_placement_index < _placements.size():
		var placement := _placements[_selected_placement_index]
		placement["elevation"] = maxf(0.0, float(placement.get("elevation", 0.0)) + delta)
		_status_message = "%s elevation: %.2f" % [str(placement.get("name", "Object")), float(placement["elevation"])]
	else:
		_default_elevation = maxf(0.0, _default_elevation + delta)
		_status_message = "Default object elevation: %.2f" % _default_elevation
	_refresh_status()
	queue_redraw()


func _adjust_selected_height(delta: float) -> void:
	if _selected_placement_index < 0 or _selected_placement_index >= _placements.size():
		_status_message = "Select an object before changing height"
		_refresh_status()
		return

	var placement := _placements[_selected_placement_index]
	placement["height"] = maxf(0.0, float(placement.get("height", 1.0)) + delta)
	_status_message = "%s height: %.2f" % [str(placement.get("name", "Object")), float(placement["height"])]
	_refresh_status()
	queue_redraw()


func _handle_mouse_button(event: InputEventMouseButton) -> void:
	if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
		_camera.zoom *= 0.9
	elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
		_camera.zoom *= 1.1
	elif event.button_index == MOUSE_BUTTON_MIDDLE:
		_is_panning = event.pressed
		_last_pan_mouse = get_viewport().get_mouse_position()
	elif event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_drag_start_grid = _mouse_grid()
			_drag_current_grid = _drag_start_grid
			_is_dragging = true
			if _object_mode:
				var placement_index := _find_placement_index_at(_drag_start_grid)
				if placement_index >= 0:
					_selected_placement_index = placement_index
					_status_message = "Selected %s" % str(_placements[_selected_placement_index].get("name", "Object"))
				else:
					_place_object(_drag_start_grid)
				_is_dragging = false
			elif _selected_shape() == "brush":
				_paint_brush(_drag_start_grid)
		elif _is_dragging:
			_drag_current_grid = _mouse_grid()
			_commit_shape(_drag_start_grid, _drag_current_grid)
			_is_dragging = false
	elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		if _object_mode:
			_remove_object_at(_mouse_grid())
		else:
			_erase_brush(_mouse_grid())
	_refresh_status()
	queue_redraw()


func _handle_mouse_motion(event: InputEventMouseMotion) -> void:
	if _is_panning:
		var mouse_position := get_viewport().get_mouse_position()
		_camera.position -= (mouse_position - _last_pan_mouse) / _camera.zoom.x
		_last_pan_mouse = mouse_position
	elif _is_dragging:
		_drag_current_grid = _mouse_grid()
		if not _object_mode and _selected_shape() == "brush":
			_paint_brush(_drag_current_grid)
	queue_redraw()


func _mouse_grid() -> Vector2i:
	return _world_to_grid(get_global_mouse_position())


func _selected_terrain() -> String:
	return TERRAIN_OPTIONS[_selected_terrain_index]


func _selected_shape() -> String:
	return SHAPE_OPTIONS[_selected_shape_index]


func _paint_brush(grid_position: Vector2i) -> void:
	if not _grid_in_bounds(grid_position):
		return
	_terrain_by_key[MAP_DATA.terrain_key(grid_position)] = _selected_terrain()
	_status_message = "Painted %s at %s" % [_selected_terrain(), str(grid_position)]


func _erase_brush(grid_position: Vector2i) -> void:
	_terrain_by_key.erase(MAP_DATA.terrain_key(grid_position))
	_status_message = "Erased terrain at %s" % str(grid_position)


func _commit_shape(start_grid: Vector2i, end_grid: Vector2i) -> void:
	var shape := _selected_shape()
	if shape == "brush":
		return
	var cells := _shape_cells(start_grid, end_grid, shape)
	for grid_position in cells:
		if _grid_in_bounds(grid_position):
			_terrain_by_key[MAP_DATA.terrain_key(grid_position)] = _selected_terrain()
	_status_message = "Painted %s %s (%d cells)" % [_selected_terrain(), shape, cells.size()]


func _shape_cells(start_grid: Vector2i, end_grid: Vector2i, shape: String) -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	var min_x := mini(start_grid.x, end_grid.x)
	var max_x := maxi(start_grid.x, end_grid.x)
	var min_y := mini(start_grid.y, end_grid.y)
	var max_y := maxi(start_grid.y, end_grid.y)
	if shape == "line":
		return _line_cells(start_grid, end_grid)

	var center := Vector2((float(min_x + max_x) * 0.5), (float(min_y + max_y) * 0.5))
	var radius_x := maxf(1.0, float(max_x - min_x) * 0.5)
	var radius_y := maxf(1.0, float(max_y - min_y) * 0.5)
	for x in range(min_x, max_x + 1):
		for y in range(min_y, max_y + 1):
			var normalized := pow((float(x) - center.x) / radius_x, 2.0) + pow((float(y) - center.y) / radius_y, 2.0)
			if shape == "ellipse" and normalized <= 1.0:
				cells.append(Vector2i(x, y))
			elif shape == "ring" and normalized >= 0.60 and normalized <= 1.18:
				cells.append(Vector2i(x, y))
	return cells


func _line_cells(start_grid: Vector2i, end_grid: Vector2i) -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	var delta := end_grid - start_grid
	var steps := maxi(abs(delta.x), abs(delta.y))
	if steps == 0:
		cells.append(start_grid)
		return cells
	for step in range(steps + 1):
		var t := float(step) / float(steps)
		cells.append(Vector2i(roundi(lerpf(start_grid.x, end_grid.x, t)), roundi(lerpf(start_grid.y, end_grid.y, t))))
	return cells


func _generate_sidewalk_outline() -> void:
	var road_cells: Array[Vector2i] = []
	for key in _terrain_by_key.keys():
		if str(_terrain_by_key[key]) == MAP_DATA.TERRAIN_ROAD:
			road_cells.append(_grid_from_key(str(key)))

	for key in _terrain_by_key.keys():
		if str(_terrain_by_key[key]) == MAP_DATA.TERRAIN_SIDEWALK:
			_terrain_by_key.erase(key)

	for road_cell in road_cells:
		for offset_x in range(-2, 3):
			for offset_y in range(-2, 3):
				var grid_position := road_cell + Vector2i(offset_x, offset_y)
				if not _grid_in_bounds(grid_position):
					continue
				var key := MAP_DATA.terrain_key(grid_position)
				if _terrain_by_key.get(key, "") != MAP_DATA.TERRAIN_ROAD:
					_terrain_by_key[key] = MAP_DATA.TERRAIN_SIDEWALK


func _place_object(grid_position: Vector2i) -> void:
	var preset: Dictionary = OBJECT_PRESETS[_selected_object_index]
	var placement := {
		"name": "%s %03d" % [str(preset["name"]), _placements.size() + 1],
		"asset_id": str(preset["asset_id"]),
		"kind": int(preset["kind"]),
		"grid": grid_position,
		"footprint": preset["footprint"],
		"height": float(preset["height"]),
		"elevation": _default_elevation,
		"color": preset["color"],
		"roof_color": preset.get("roof_color", Color(0.16, 0.31, 0.46)),
		"awning_color": preset.get("awning_color", Color.TRANSPARENT),
		"render_style": int(preset.get("render_style", 0)),
		"blocks_movement": bool(preset["blocks_movement"])
	}
	if int(preset["kind"]) == 6:
		placement["actor_id"] = "debug.spawn_%03d" % (_placements.size() + 1)
	_placements.append(placement)
	_selected_placement_index = _placements.size() - 1
	_status_message = "Placed %s at %s" % [preset["name"], str(grid_position)]


func _remove_object_at(grid_position: Vector2i) -> void:
	for index in range(_placements.size() - 1, -1, -1):
		var placement := _placements[index]
		if _grid_in_footprint(grid_position, placement["grid"], placement["footprint"]):
			_placements.remove_at(index)
			if _selected_placement_index == index:
				_selected_placement_index = -1
			elif _selected_placement_index > index:
				_selected_placement_index -= 1
			_status_message = "Removed object at %s" % str(grid_position)
			return
	_status_message = "No object at %s" % str(grid_position)


func _find_placement_index_at(grid_position: Vector2i) -> int:
	for index in range(_placements.size() - 1, -1, -1):
		var placement := _placements[index]
		if _grid_in_footprint(grid_position, placement["grid"], placement["footprint"]):
			return index
	return -1


func _save_map() -> void:
	var terrain_entries: Array[Dictionary] = []
	for key in _terrain_by_key.keys():
		var grid_position := _grid_from_key(str(key))
		terrain_entries.append({
			"x": grid_position.x,
			"y": grid_position.y,
			"kind": str(_terrain_by_key[key])
		})

	var placement_entries: Array[Dictionary] = []
	for placement in _placements:
		var entry := {
			"name": str(placement["name"]),
			"asset_id": str(placement["asset_id"]),
			"kind": int(placement["kind"]),
			"grid": [placement["grid"].x, placement["grid"].y],
			"footprint": [placement["footprint"].x, placement["footprint"].y],
			"height": float(placement["height"]),
			"elevation": float(placement.get("elevation", 0.0)),
			"color": MAP_DATA.color_to_array(placement["color"]),
			"render_style": int(placement.get("render_style", 0)),
			"blocks_movement": bool(placement["blocks_movement"])
		}
		if placement.has("roof_color"):
			entry["roof_color"] = MAP_DATA.color_to_array(placement["roof_color"])
		if placement.has("awning_color"):
			entry["awning_color"] = MAP_DATA.color_to_array(placement["awning_color"])
		if placement.has("actor_id"):
			entry["actor_id"] = str(placement["actor_id"])
		placement_entries.append(entry)

	var saved_map := _map_data.duplicate(true)
	saved_map["bounds"] = {
		"min_x": int(_bounds["min_x"]),
		"max_x": int(_bounds["max_x"]),
		"min_y": int(_bounds["min_y"]),
		"max_y": int(_bounds["max_y"])
	}
	saved_map["terrain"] = MAP_DATA.sorted_terrain(terrain_entries)
	saved_map["placements"] = placement_entries
	if MAP_DATA.save_map(MAP_PATH, saved_map):
		_status_message = "Saved %s" % MAP_PATH
	else:
		_status_message = "Save failed"
	_load_map()


func _draw_grid() -> void:
	for x in range(int(_bounds["min_x"]), int(_bounds["max_x"]) + 1):
		for y in range(int(_bounds["min_y"]), int(_bounds["max_y"]) + 1):
			var center := _grid_to_world(Vector2i(x, y))
			draw_polyline(_diamond(center), Color(0.32, 0.34, 0.33, 0.32), 1.0, true)


func _draw_bounds_frame() -> void:
	var origin := Vector2i(int(_bounds["min_x"]), int(_bounds["min_y"]))
	var size := Vector2i(int(_bounds["max_x"]) - int(_bounds["min_x"]) + 1, int(_bounds["max_y"]) - int(_bounds["min_y"]) + 1)
	var polygon := _footprint_polygon(origin, size)
	draw_polyline(polygon, Color(1.0, 0.78, 0.18, 0.95), 5.0, true)
	for point in polygon:
		draw_circle(point, 7.0, Color(1.0, 0.42, 0.18, 0.95))


func _draw_terrain() -> void:
	for key in _terrain_by_key.keys():
		var grid_position := _grid_from_key(str(key))
		var terrain_kind := str(_terrain_by_key[key])
		var color := MAP_DATA.terrain_color(terrain_kind)
		color.a = 0.88
		draw_colored_polygon(_diamond(_grid_to_world(grid_position)), color)


func _draw_placements() -> void:
	var ordered_placements := _placements.duplicate()
	ordered_placements.sort_custom(_sort_placements_for_draw)
	for placement in ordered_placements:
		_draw_placement_model(placement)


func _sort_placements_for_draw(a: Dictionary, b: Dictionary) -> bool:
	var anchor_a: Vector2 = _grid_to_world(a.get("grid", Vector2i.ZERO) + a.get("footprint", Vector2i.ONE))
	var anchor_b: Vector2 = _grid_to_world(b.get("grid", Vector2i.ZERO) + b.get("footprint", Vector2i.ONE))
	return anchor_a.y < anchor_b.y


func _draw_placement_model(placement: Dictionary) -> void:
	var kind := int(placement.get("kind", 3))
	var origin: Vector2i = placement.get("grid", Vector2i.ZERO)
	var footprint: Vector2i = placement.get("footprint", Vector2i.ONE)
	var height := float(placement.get("height", 1.0))
	var elevation := float(placement.get("elevation", 0.0))
	var color: Color = placement.get("color", Color(0.70, 0.64, 0.52))
	var asset_id := str(placement.get("asset_id", "custom"))
	var is_selected := _placement_index_for_identity(placement) == _selected_placement_index

	match kind:
		3:
			_draw_plaza_building_model(origin, footprint, height, elevation, color, placement.get("roof_color", Color(0.16, 0.31, 0.46)), placement.get("awning_color", Color.TRANSPARENT), asset_id)
		4:
			_draw_repeated_block_model(origin, footprint, height, elevation, color)
		9:
			var combat_color := color
			combat_color.a = 0.38
			draw_colored_polygon(_footprint_polygon(origin, footprint), combat_color)
		_:
			_draw_isometric_block_model(origin, footprint, height, elevation, color)

	var outline := _elevated_footprint_polygon(origin, footprint, elevation)
	draw_polyline(outline, Color(1.0, 0.88, 0.24, 1.0) if is_selected else Color(1.0, 0.26, 0.18, 0.82) if bool(placement.get("blocks_movement", false)) else Color(0.20, 0.72, 1.0, 0.72), 3.0 if is_selected else 2.0, true)


func _placement_index_for_identity(target: Dictionary) -> int:
	for index in range(_placements.size()):
		if _placements[index] == target:
			return index
	return -1


func _draw_plaza_building_model(origin: Vector2i, footprint: Vector2i, height_tiles: float, elevation_tiles: float, body_color: Color, roof_color: Color, awning_color: Color, asset_id: String) -> void:
	var profile := _architecture_profile(asset_id)
	_draw_isometric_block_model(origin, footprint, height_tiles, elevation_tiles, body_color)
	var tier_offset: int = maxi(1, int(floor(float(footprint.y) / 3.0)))
	var upper_origin := origin + Vector2i(0, tier_offset)
	var upper_footprint := Vector2i(footprint.x, maxi(1, footprint.y - tier_offset))
	_draw_isometric_block_model(upper_origin, upper_footprint, height_tiles + 0.8, elevation_tiles, body_color.lightened(0.05))
	_draw_roof_cap_model(upper_origin, upper_footprint, height_tiles + 1.05, elevation_tiles, roof_color)
	_draw_architecture_details(origin, footprint, height_tiles, elevation_tiles, body_color, roof_color, awning_color, profile)


func _architecture_profile(asset_id: String) -> Dictionary:
	match asset_id:
		"building.aethelgard_tavern", "building.guild_front":
			return {"windows": 5, "rows": 2, "spires": 3, "banner_count": 2, "shopfront": true, "sign": true, "dormers": 1, "tower": false, "arcade": false}
		"building.aethelgard_curio_shop":
			return {"windows": 4, "rows": 3, "spires": 5, "banner_count": 1, "shopfront": true, "sign": true, "dormers": 2, "tower": true, "arcade": false}
		"building.aethelgard_guildhall", "building.civic_facade_blue":
			return {"windows": 6, "rows": 3, "spires": 7, "banner_count": 3, "shopfront": false, "sign": false, "dormers": 2, "tower": true, "arcade": false}
		"building.aethelgard_arcade_row", "building.arcade_row":
			return {"windows": 7, "rows": 1, "spires": 4, "banner_count": 2, "shopfront": true, "sign": false, "dormers": 0, "tower": false, "arcade": true}
		_:
			return {"windows": 4, "rows": 2, "spires": 4, "banner_count": 1, "shopfront": true, "sign": false, "dormers": 1, "tower": false, "arcade": false}


func _draw_architecture_details(origin: Vector2i, footprint: Vector2i, height_tiles: float, elevation_tiles: float, body_color: Color, roof_color: Color, awning_color: Color, profile: Dictionary) -> void:
	var corners := _elevated_corners(origin, footprint, elevation_tiles)
	var lift := Vector2(0.0, -height_tiles * TILE_SIZE.y)
	var facade_top_left: Vector2 = corners[3] + lift
	var facade_top_right: Vector2 = corners[2] + lift
	var facade_bottom_left: Vector2 = corners[3]
	var facade_bottom_right: Vector2 = corners[2]
	var trim := Color(0.91, 0.69, 0.28)
	var glass := Color(0.12, 0.30, 0.42)
	var shadow := Color(0.05, 0.06, 0.06, 0.42)

	draw_line(facade_top_left, facade_top_right, trim, 4.0)
	draw_line(corners[0] + lift, corners[1] + lift, trim.darkened(0.10), 3.0)
	draw_line(corners[1] + lift, corners[2] + lift, trim.darkened(0.06), 3.0)

	var column_count: int = maxi(2, int(profile.get("windows", 4)))
	for index in range(column_count):
		var t := (float(index) + 0.5) / float(column_count)
		var top_point := facade_top_left.lerp(facade_top_right, t)
		var bottom_point := facade_bottom_left.lerp(facade_bottom_right, t)
		var pier_top := facade_top_left.lerp(facade_top_right, t)
		var pier_bottom := facade_bottom_left.lerp(facade_bottom_right, t)
		if index % 2 == 0:
			draw_line(pier_top, pier_bottom, body_color.lightened(0.16), 2.0)
		for row in range(int(profile.get("rows", 2))):
			var row_t := (float(row) + 1.0) / (float(profile.get("rows", 2)) + 1.45)
			var window_center := top_point.lerp(bottom_point, row_t)
			_draw_screen_rect(window_center + Vector2(0.0, -6.0), Vector2(20.0, 28.0), shadow)
			_draw_screen_rect(window_center + Vector2(0.0, -8.0), Vector2(14.0, 22.0), glass.lightened(0.18 if row % 2 == 0 else 0.02))

	var door_center := facade_top_left.lerp(facade_top_right, 0.5).lerp(facade_bottom_left.lerp(facade_bottom_right, 0.5), 0.82)
	_draw_screen_rect(door_center + Vector2(0.0, -24.0), Vector2(36.0, 58.0), Color(0.18, 0.12, 0.08))
	draw_arc(door_center + Vector2(0.0, -54.0), 21.0, PI, TAU, 20, trim, 3.0)

	if awning_color.a > 0.0 or bool(profile.get("shopfront", false)):
		var awning := awning_color if awning_color.a > 0.0 else Color(0.12, 0.26, 0.52)
		var left := facade_bottom_left.lerp(facade_bottom_right, 0.18)
		var right := facade_bottom_left.lerp(facade_bottom_right, 0.82)
		var awning_poly := PackedVector2Array([left + Vector2(0.0, -48.0), right + Vector2(0.0, -48.0), right + Vector2(20.0, -18.0), left + Vector2(-20.0, -18.0)])
		draw_colored_polygon(awning_poly, awning)
		draw_line(left + Vector2(0.0, -48.0), right + Vector2(0.0, -48.0), trim, 3.0)
		for stripe in range(1, 5):
			var stripe_t := float(stripe) / 5.0
			var stripe_top := (left + Vector2(0.0, -48.0)).lerp(right + Vector2(0.0, -48.0), stripe_t)
			var stripe_bottom := (left + Vector2(-20.0, -18.0)).lerp(right + Vector2(20.0, -18.0), stripe_t)
			draw_line(stripe_top, stripe_bottom, awning.lightened(0.20), 1.5)

	if bool(profile.get("sign", false)):
		var sign_anchor := facade_bottom_left.lerp(facade_bottom_right, 0.22) + Vector2(-18.0, -86.0)
		draw_line(sign_anchor + Vector2(0.0, -24.0), sign_anchor, trim, 2.0)
		_draw_screen_rect(sign_anchor + Vector2(0.0, 12.0), Vector2(34.0, 28.0), Color(0.16, 0.12, 0.08))
		draw_arc(sign_anchor + Vector2(0.0, 12.0), 11.0, 0.0, TAU, 20, trim, 2.0)

	for banner in range(int(profile.get("banner_count", 1))):
		var banner_t := (float(banner) + 1.0) / (float(profile.get("banner_count", 1)) + 1.0)
		var banner_top := facade_top_left.lerp(facade_top_right, banner_t).lerp(facade_bottom_left.lerp(facade_bottom_right, banner_t), 0.36)
		_draw_banner(banner_top, trim)

	for spire in range(int(profile.get("spires", 3))):
		var spire_t := 0.08 + (0.84 * float(spire) / maxf(1.0, float(profile.get("spires", 3) - 1)))
		var base := (corners[0] + lift).lerp(corners[1] + lift, spire_t)
		_draw_spire(base, trim)

	for dormer in range(int(profile.get("dormers", 0))):
		var dormer_t := (float(dormer) + 1.0) / (float(profile.get("dormers", 0)) + 1.0)
		var dormer_base := (corners[0] + lift).lerp(corners[1] + lift, dormer_t) + Vector2(0.0, 16.0)
		_draw_dormer(dormer_base, body_color.lightened(0.12), roof_color)

	if bool(profile.get("tower", false)):
		var tower_origin := origin + Vector2i(maxi(0, footprint.x - 1), 0)
		_draw_isometric_block_model(tower_origin, Vector2i(1, 1), height_tiles + 1.4, elevation_tiles, body_color.lightened(0.08))
		_draw_spire(_grid_to_world(tower_origin) + Vector2(0.0, -(height_tiles + 1.55) * TILE_SIZE.y), trim)

	if bool(profile.get("arcade", false)):
		for arch in range(maxi(3, footprint.x)):
			var t := (float(arch) + 0.5) / float(maxi(3, footprint.x))
			var arch_base := facade_bottom_left.lerp(facade_bottom_right, t)
			draw_arc(arch_base + Vector2(0.0, -28.0), 18.0, PI, TAU, 18, body_color.lightened(0.20), 3.0)


func _draw_screen_rect(center: Vector2, size: Vector2, color: Color) -> void:
	var half := size * 0.5
	draw_colored_polygon(PackedVector2Array([
		center + Vector2(-half.x, -half.y),
		center + Vector2(half.x, -half.y),
		center + Vector2(half.x, half.y),
		center + Vector2(-half.x, half.y)
	]), color)


func _draw_banner(top_center: Vector2, trim_color: Color) -> void:
	var banner_color := Color(0.10, 0.22, 0.52)
	var banner := PackedVector2Array([
		top_center + Vector2(-13.0, 0.0),
		top_center + Vector2(13.0, 0.0),
		top_center + Vector2(13.0, 48.0),
		top_center + Vector2(0.0, 62.0),
		top_center + Vector2(-13.0, 48.0)
	])
	draw_colored_polygon(banner, banner_color)
	draw_polyline(banner, trim_color, 2.0, true)
	draw_line(top_center + Vector2(-8.0, 18.0), top_center + Vector2(8.0, 18.0), trim_color, 2.0)


func _draw_spire(base: Vector2, trim_color: Color) -> void:
	draw_colored_polygon(PackedVector2Array([
		base + Vector2(-9.0, 0.0),
		base + Vector2(9.0, 0.0),
		base + Vector2(0.0, -36.0)
	]), trim_color)
	draw_line(base + Vector2(0.0, -36.0), base + Vector2(0.0, -48.0), trim_color.lightened(0.18), 2.0)


func _draw_dormer(base: Vector2, body_color: Color, roof_color: Color) -> void:
	_draw_screen_rect(base + Vector2(0.0, 5.0), Vector2(30.0, 26.0), body_color)
	draw_colored_polygon(PackedVector2Array([
		base + Vector2(-20.0, -7.0),
		base + Vector2(20.0, -7.0),
		base + Vector2(0.0, -30.0)
	]), roof_color)
	_draw_screen_rect(base + Vector2(0.0, 8.0), Vector2(10.0, 15.0), Color(0.13, 0.31, 0.43))


func _draw_repeated_block_model(origin: Vector2i, footprint: Vector2i, height_tiles: float, elevation_tiles: float, color: Color) -> void:
	for x in range(footprint.x):
		for y in range(footprint.y):
			_draw_isometric_block_model(origin + Vector2i(x, y), Vector2i.ONE, height_tiles, elevation_tiles, color)


func _draw_roof_cap_model(origin: Vector2i, footprint: Vector2i, height_tiles: float, elevation_tiles: float, color: Color) -> void:
	var corners := _elevated_corners(origin, footprint, elevation_tiles)
	var lift := Vector2(0.0, -height_tiles * TILE_SIZE.y)
	var roof := PackedVector2Array([corners[0] + lift, corners[1] + lift, corners[2] + lift, corners[3] + lift])
	var ridge := PackedVector2Array([
		corners[0] + lift,
		(corners[1] + corners[2]) * 0.5 + lift + Vector2(0.0, -18.0),
		corners[2] + lift,
		(corners[3] + corners[0]) * 0.5 + lift + Vector2(0.0, -18.0)
	])
	draw_colored_polygon(roof, color)
	draw_colored_polygon(ridge, color.lightened(0.10))


func _draw_isometric_block_model(origin: Vector2i, footprint: Vector2i, height_tiles: float, elevation_tiles: float, color: Color) -> void:
	if elevation_tiles > 0.0:
		_draw_elevation_guides(origin, footprint, elevation_tiles)
	var corners := _elevated_corners(origin, footprint, elevation_tiles)
	var lift := Vector2(0.0, -height_tiles * TILE_SIZE.y)
	var top := PackedVector2Array([corners[0] + lift, corners[1] + lift, corners[2] + lift, corners[3] + lift])
	var right := PackedVector2Array([corners[1] + lift, corners[2] + lift, corners[2], corners[1]])
	var left := PackedVector2Array([corners[2] + lift, corners[3] + lift, corners[3], corners[2]])
	draw_colored_polygon(right, color.darkened(0.18))
	draw_colored_polygon(left, color.darkened(0.28))
	draw_colored_polygon(top, color.lightened(0.08))


func _draw_elevation_guides(origin: Vector2i, footprint: Vector2i, elevation_tiles: float) -> void:
	var ground := _footprint_polygon(origin, footprint)
	var elevated := _elevated_footprint_polygon(origin, footprint, elevation_tiles)
	draw_polyline(ground, Color(0.0, 0.0, 0.0, 0.26), 2.0, true)
	for index in range(ground.size()):
		draw_line(ground[index], elevated[index], Color(1.0, 0.78, 0.22, 0.58), 2.0)


func _elevated_corners(origin: Vector2i, footprint: Vector2i, elevation_tiles: float) -> Array[Vector2]:
	var lift := Vector2(0.0, -elevation_tiles * TILE_SIZE.y)
	return [
		_grid_to_world(origin) + lift,
		_grid_to_world(origin + Vector2i(footprint.x, 0)) + lift,
		_grid_to_world(origin + footprint) + lift,
		_grid_to_world(origin + Vector2i(0, footprint.y)) + lift
	]


func _elevated_footprint_polygon(origin: Vector2i, footprint: Vector2i, elevation_tiles: float) -> PackedVector2Array:
	var corners := _elevated_corners(origin, footprint, elevation_tiles)
	return PackedVector2Array([corners[0], corners[1], corners[2], corners[3]])


func _draw_cursor_preview() -> void:
	var grid_position := _mouse_grid()
	var preview_color := Color(1.0, 0.88, 0.28, 0.85)
	if _object_mode:
		var preset: Dictionary = OBJECT_PRESETS[_selected_object_index]
		draw_polyline(_footprint_polygon(grid_position, preset["footprint"]), preview_color, 3.0, true)
	elif _is_dragging and _selected_shape() != "brush":
		for cell in _shape_cells(_drag_start_grid, _drag_current_grid, _selected_shape()):
			draw_polyline(_diamond(_grid_to_world(cell)), preview_color, 2.0, true)
	else:
		draw_polyline(_diamond(_grid_to_world(grid_position)), preview_color, 3.0, true)


func _refresh_status() -> void:
	if _status_label == null:
		return
	var mode := "Objects" if _object_mode else "Terrain"
	var selected_text := "none"
	if _selected_placement_index >= 0 and _selected_placement_index < _placements.size():
		var placement := _placements[_selected_placement_index]
		selected_text = "%s | elev %.2f | height %.2f" % [str(placement.get("name", "Object")), float(placement.get("elevation", 0.0)), float(placement.get("height", 0.0))]
	_status_label.text = "Balen Map Builder\nMode: %s | Terrain: %s | Shape: %s | Object: %s\nBounds: %s | Selected: %s\n1-4 terrain, B/L/E/R shapes, O objects, Tab asset, G sidewalks, S save, F5 reload\nAlt+Arrows resize, PageUp/PageDown elevation, ,/. height\n%s" % [
		mode,
		_selected_terrain(),
		_selected_shape(),
		OBJECT_PRESETS[_selected_object_index]["name"],
		_bounds_text(),
		selected_text,
		_status_message
	]


func _grid_to_world(grid_position: Vector2i) -> Vector2:
	return Vector2(
		float(grid_position.x - grid_position.y) * TILE_SIZE.x * 0.5,
		float(grid_position.x + grid_position.y) * TILE_SIZE.y * 0.5
	)


func _world_to_grid(world_position: Vector2) -> Vector2i:
	var grid_x := (world_position.y / (TILE_SIZE.y * 0.5) + world_position.x / (TILE_SIZE.x * 0.5)) * 0.5
	var grid_y := (world_position.y / (TILE_SIZE.y * 0.5) - world_position.x / (TILE_SIZE.x * 0.5)) * 0.5
	return Vector2i(roundi(grid_x), roundi(grid_y))


func _diamond(center: Vector2) -> PackedVector2Array:
	return PackedVector2Array([
		center + Vector2(0.0, -TILE_SIZE.y * 0.5),
		center + Vector2(TILE_SIZE.x * 0.5, 0.0),
		center + Vector2(0.0, TILE_SIZE.y * 0.5),
		center + Vector2(-TILE_SIZE.x * 0.5, 0.0)
	])


func _footprint_polygon(origin: Vector2i, footprint: Vector2i) -> PackedVector2Array:
	return PackedVector2Array([
		_grid_to_world(origin),
		_grid_to_world(origin + Vector2i(footprint.x, 0)),
		_grid_to_world(origin + footprint),
		_grid_to_world(origin + Vector2i(0, footprint.y))
	])


func _grid_from_key(key: String) -> Vector2i:
	var parts := key.split(",")
	if parts.size() < 2:
		return Vector2i.ZERO
	return Vector2i(int(parts[0]), int(parts[1]))


func _grid_in_bounds(grid_position: Vector2i) -> bool:
	return grid_position.x >= int(_bounds["min_x"]) and grid_position.x <= int(_bounds["max_x"]) and grid_position.y >= int(_bounds["min_y"]) and grid_position.y <= int(_bounds["max_y"])


func _grid_in_footprint(grid_position: Vector2i, origin: Vector2i, footprint: Vector2i) -> bool:
	return grid_position.x >= origin.x and grid_position.x < origin.x + footprint.x and grid_position.y >= origin.y and grid_position.y < origin.y + footprint.y
