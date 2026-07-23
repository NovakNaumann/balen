extends Node2D

const MAP_DATA := preload("res://scripts/map/map_data.gd")
const MAP_PATH := "res://maps/crossroads_plaza.json"
const TILE_SIZE := Vector2(112.0, 56.0)

const TERRAIN_OPTIONS := [
	MAP_DATA.TERRAIN_ROAD,
	MAP_DATA.TERRAIN_SIDEWALK,
	MAP_DATA.TERRAIN_PATH,
	MAP_DATA.TERRAIN_WATER
]
const SHAPE_OPTIONS := ["brush", "line", "ellipse", "ring"]
const OBJECT_PRESETS := [
	{"name": "Civic Facade", "asset_id": "building.civic_facade_blue", "kind": 3, "footprint": Vector2i(5, 7), "height": 4.2, "color": Color(0.69, 0.64, 0.54), "roof_color": Color(0.12, 0.27, 0.43), "blocks_movement": true},
	{"name": "Guild Front", "asset_id": "building.guild_front", "kind": 3, "footprint": Vector2i(4, 5), "height": 3.7, "color": Color(0.58, 0.56, 0.50), "roof_color": Color(0.16, 0.18, 0.18), "blocks_movement": true},
	{"name": "Arcade Row", "asset_id": "building.arcade_row", "kind": 3, "footprint": Vector2i(8, 3), "height": 3.2, "color": Color(0.66, 0.58, 0.46), "roof_color": Color(0.43, 0.25, 0.18), "blocks_movement": true},
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
		_handle_key(event.keycode)
	elif event is InputEventMouseButton:
		_handle_mouse_button(event)
	elif event is InputEventMouseMotion:
		_handle_mouse_motion(event)


func _draw() -> void:
	_draw_grid()
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
		"color": MAP_DATA.color_from_array(raw_placement.get("color", []), fallback_color),
		"roof_color": MAP_DATA.color_from_array(raw_placement.get("roof_color", []), Color(0.16, 0.31, 0.46)),
		"awning_color": MAP_DATA.color_from_array(raw_placement.get("awning_color", []), Color.TRANSPARENT),
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
	panel.anchor_right = 0.42
	panel.anchor_bottom = 0.18
	layer.add_child(panel)

	_status_label = Label.new()
	_status_label.add_theme_font_size_override("font_size", 16)
	panel.add_child(_status_label)
	_refresh_status()


func _handle_key(keycode: int) -> void:
	match keycode:
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
		"color": preset["color"],
		"roof_color": preset.get("roof_color", Color(0.16, 0.31, 0.46)),
		"awning_color": preset.get("awning_color", Color.TRANSPARENT),
		"blocks_movement": bool(preset["blocks_movement"])
	}
	if int(preset["kind"]) == 6:
		placement["actor_id"] = "debug.spawn_%03d" % (_placements.size() + 1)
	_placements.append(placement)
	_status_message = "Placed %s at %s" % [preset["name"], str(grid_position)]


func _remove_object_at(grid_position: Vector2i) -> void:
	for index in range(_placements.size() - 1, -1, -1):
		var placement := _placements[index]
		if _grid_in_footprint(grid_position, placement["grid"], placement["footprint"]):
			_placements.remove_at(index)
			_status_message = "Removed object at %s" % str(grid_position)
			return
	_status_message = "No object at %s" % str(grid_position)


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
			"color": MAP_DATA.color_to_array(placement["color"]),
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


func _draw_terrain() -> void:
	for key in _terrain_by_key.keys():
		var grid_position := _grid_from_key(str(key))
		var terrain_kind := str(_terrain_by_key[key])
		var color := MAP_DATA.terrain_color(terrain_kind)
		color.a = 0.88
		draw_colored_polygon(_diamond(_grid_to_world(grid_position)), color)


func _draw_placements() -> void:
	for placement in _placements:
		var color: Color = placement["color"]
		color.a = 0.58
		var polygon := _footprint_polygon(placement["grid"], placement["footprint"])
		draw_colored_polygon(polygon, color)
		draw_polyline(polygon, Color(1.0, 0.26, 0.18, 0.88) if bool(placement["blocks_movement"]) else Color(0.20, 0.72, 1.0, 0.78), 2.0, true)


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
	_status_label.text = "Balen Map Builder\nMode: %s | Terrain: %s | Shape: %s | Object: %s\n1-4 terrain, B/L/E/R shapes, O objects, Tab asset, G sidewalks, S save, F5 reload\n%s" % [
		mode,
		_selected_terrain(),
		_selected_shape(),
		OBJECT_PRESETS[_selected_object_index]["name"],
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
