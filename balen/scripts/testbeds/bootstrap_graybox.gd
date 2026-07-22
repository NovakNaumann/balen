extends Node2D

const TITLE_SCENE := "res://scenes/ui/title_screen.tscn"
const DESIGN_RESOLUTION := Vector2(1920.0, 1080.0)
const TILE_SIZE := Vector2(112.0, 56.0)
const MOVE_SPEED_PIXELS := 340.0
const FLOOR_HALF_EXTENTS := Vector2i(14, 24)
const FOUNTAIN_GRID := Vector2i(0, -6)
const EAST_WEST_ROAD_Y := 7
const EVIDENCE_GRID := Vector2i(-9, 11)

const ACTOR_DEFINITIONS := [
	{"id": "debug.knight", "name": "DEBUG Knight", "grid": Vector2i(-2, 20), "color": Color(0.28, 0.42, 0.58)},
	{"id": "debug.runescribe", "name": "DEBUG Runescribe", "grid": Vector2i(-1, 20), "color": Color(0.46, 0.31, 0.59)},
	{"id": "debug.slayer_scout", "name": "DEBUG Slayer-Scout", "grid": Vector2i(0, 20), "color": Color(0.32, 0.49, 0.35)},
	{"id": "debug.fourth_slot", "name": "DEBUG Fourth Slot", "grid": Vector2i(1, 20), "color": Color(0.56, 0.32, 0.27)}
]

const PLAZA_ROUTES := [
	{"name": "Aethelgard City", "grid": Vector2i(0, 24), "color": Color(0.73, 0.65, 0.50)},
	{"name": "The Ringmarket", "grid": Vector2i(12, 7), "color": Color(0.79, 0.55, 0.31)},
	{"name": "Slayers Guild HQ", "grid": Vector2i(-12, 7), "color": Color(0.45, 0.46, 0.42)},
	{"name": "Citadel Training", "grid": Vector2i(7, -23), "color": Color(0.38, 0.48, 0.66)},
	{"name": "Citadel Archives", "grid": Vector2i(-7, -23), "color": Color(0.56, 0.49, 0.37)},
	{"name": "Stable Yard", "grid": Vector2i(12, 16), "color": Color(0.55, 0.36, 0.22)}
]

const ARCHITECTURE_BLOCKERS := [
	{"origin": Vector2i(-18, -14), "footprint": Vector2i(5, 7)},
	{"origin": Vector2i(-18, -5), "footprint": Vector2i(5, 8)},
	{"origin": Vector2i(-18, 5), "footprint": Vector2i(5, 8)},
	{"origin": Vector2i(-18, 15), "footprint": Vector2i(5, 7)},
	{"origin": Vector2i(13, -14), "footprint": Vector2i(5, 7)},
	{"origin": Vector2i(13, -5), "footprint": Vector2i(5, 8)},
	{"origin": Vector2i(13, 5), "footprint": Vector2i(5, 8)},
	{"origin": Vector2i(13, 15), "footprint": Vector2i(5, 7)},
	{"origin": Vector2i(-15, 24), "footprint": Vector2i(6, 4)},
	{"origin": Vector2i(-6, 24), "footprint": Vector2i(12, 4)},
	{"origin": Vector2i(9, 24), "footprint": Vector2i(6, 4)},
	{"origin": Vector2i(-14, -1), "footprint": Vector2i(3, 5)},
	{"origin": Vector2i(-13, 13), "footprint": Vector2i(3, 5)},
	{"origin": Vector2i(-12, 17), "footprint": Vector2i(4, 4)},
	{"origin": Vector2i(11, -1), "footprint": Vector2i(3, 5)},
	{"origin": Vector2i(10, 18), "footprint": Vector2i(4, 5)},
	{"origin": Vector2i(-11, -18), "footprint": Vector2i(2, 2)},
	{"origin": Vector2i(-7, -19), "footprint": Vector2i(2, 2)},
	{"origin": Vector2i(7, -19), "footprint": Vector2i(2, 2)},
	{"origin": Vector2i(11, -18), "footprint": Vector2i(2, 2)},
	{"origin": Vector2i(-12, 18), "footprint": Vector2i(2, 2)},
	{"origin": Vector2i(12, 18), "footprint": Vector2i(2, 2)}
]

var _camera: Camera2D
var _world_root: Node2D
var _overlay_root: Node2D
var _hud_label: Label
var _dialog_panel: PanelContainer
var _dialog_label: Label

var _view_rotation_steps := 0
var _zoom := 1.0
var _combat_overlay_visible := true
var _selected_actor_id := "debug.knight"
var _evidence_collected := false
var _actor_states: Dictionary = {}
var _actor_nodes: Dictionary = {}


func _ready() -> void:
	GameState.current_scene_path = "res://scenes/testbeds/bootstrap_graybox.tscn"
	_initialize_actor_states()
	_restore_scene_state_from_game_state()
	_build_scene()
	_rebuild_world()
	_build_overlay()
	_refresh_hud()


func _process(delta: float) -> void:
	_handle_keyboard_input()
	_handle_mouse_input()
	_update_actor_motion(delta)
	_update_camera_position()


func _build_scene() -> void:
	var background := ColorRect.new()
	background.name = "Native1080Background"
	background.color = Color(0.09, 0.11, 0.105)
	background.size = DESIGN_RESOLUTION * 4.0
	background.position = -background.size * 0.5
	background.z_index = -1000
	add_child(background)

	_world_root = Node2D.new()
	_world_root.name = "Isometric2_5DWorld"
	add_child(_world_root)

	_camera = Camera2D.new()
	_camera.name = "Native1080Camera2D"
	_camera.enabled = true
	_camera.position = Vector2.ZERO
	_camera.zoom = Vector2(_zoom, _zoom)
	add_child(_camera)


func _initialize_actor_states() -> void:
	for actor in ACTOR_DEFINITIONS:
		var actor_id := str(actor.id)
		if _actor_states.has(actor_id):
			continue

		var grid_position: Vector2i = actor.grid
		_actor_states[actor_id] = {
			"id": actor_id,
			"display_name": str(actor.name),
			"grid": grid_position,
			"target_grid": grid_position,
			"world_position": _iso(grid_position)
		}


func _restore_scene_state_from_game_state() -> void:
	var scene_state: Dictionary = GameState.world_state.get("bootstrap_graybox", {})
	if scene_state.is_empty():
		_write_scene_state_to_game_state()
		return

	_selected_actor_id = str(scene_state.get("selected_actor_id", _selected_actor_id))
	_combat_overlay_visible = bool(scene_state.get("combat_overlay_visible", _combat_overlay_visible))
	_evidence_collected = bool(scene_state.get("evidence_collected", _evidence_collected))

	var saved_actor_states: Dictionary = GameState.party_runtime_state.get("debug_party", {})
	for actor_id in saved_actor_states.keys():
		if not _actor_states.has(actor_id):
			continue

		var saved_state: Dictionary = saved_actor_states[actor_id]
		var grid_position := _vector2i_from_array(saved_state.get("grid", []), _actor_states[actor_id].grid)
		if not _is_grid_walkable(grid_position):
			grid_position = _fallback_actor_grid(actor_id)
		_actor_states[actor_id].grid = grid_position
		_actor_states[actor_id].target_grid = grid_position
		_actor_states[actor_id].world_position = _iso(grid_position)


func _write_scene_state_to_game_state() -> void:
	var saved_actor_states := {}
	for actor_id in _actor_states.keys():
		var actor_state: Dictionary = _actor_states[actor_id]
		var grid_position: Vector2i = actor_state.grid
		saved_actor_states[actor_id] = {
			"grid": [grid_position.x, grid_position.y],
			"selected": actor_id == _selected_actor_id
		}

	GameState.party_runtime_state["debug_party"] = saved_actor_states
	GameState.evidence_state["testbed.crossroads_caravan_ledger"] = {
		"collected": _evidence_collected,
		"visibility": "public",
		"provenance": "testbed.crossroads_plaza"
	}
	GameState.world_state["bootstrap_graybox"] = {
		"selected_actor_id": _selected_actor_id,
		"combat_overlay_visible": _combat_overlay_visible,
		"evidence_collected": _evidence_collected
	}


func _rebuild_world() -> void:
	for child in _world_root.get_children():
		child.queue_free()

	_actor_nodes.clear()
	_add_architecture_foundation_fill()
	_add_nonwalkable_boundary_fill()
	_add_diamond_floor(Vector2i.ZERO, FLOOR_HALF_EXTENTS, Color(0.61, 0.56, 0.48), "Crossroads Plaza Stone")
	_add_ring_city_plaza_bands()
	_add_radial_roads()
	_add_outer_canals_and_bridges()
	_add_citadel_axis()
	_add_central_fountain()
	_add_grand_city_backdrop()
	_add_plaza_frontage_architecture()
	_add_market_tents()
	_add_civic_banners()
	_add_route_markers()
	_add_crowd_markers()
	_add_evidence_marker()

	_overlay_root = Node2D.new()
	_overlay_root.name = "SameSceneCombatOverlay"
	_overlay_root.visible = _combat_overlay_visible
	_world_root.add_child(_overlay_root)
	_add_same_environment_combat_overlay(Vector2i(5, 11), Vector2i(11, 7))

	for actor in ACTOR_DEFINITIONS:
		_add_actor_marker(str(actor.id), str(actor.name), actor.color)

	var label := Label.new()
	label.text = "Crossroads Plaza, Aethelgard: one grand ring-city plaza node"
	label.position = _iso(Vector2i(-12, -23)) + Vector2(-80.0, -96.0)
	label.add_theme_font_size_override("font_size", 24)
	_world_root.add_child(label)

	_refresh_actor_visuals()


func _build_overlay() -> void:
	var layer := CanvasLayer.new()
	layer.name = "MilestoneOverlay"
	add_child(layer)

	var panel := PanelContainer.new()
	panel.anchor_left = 0.02
	panel.anchor_top = 0.02
	panel.anchor_right = 0.34
	panel.anchor_bottom = 0.22
	layer.add_child(panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 16)
	margin.add_theme_constant_override("margin_top", 14)
	margin.add_theme_constant_override("margin_right", 16)
	margin.add_theme_constant_override("margin_bottom", 14)
	panel.add_child(margin)

	_hud_label = Label.new()
	_hud_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_hud_label.add_theme_font_size_override("font_size", 18)
	margin.add_child(_hud_label)

	_dialog_panel = PanelContainer.new()
	_dialog_panel.anchor_left = 0.30
	_dialog_panel.anchor_top = 0.68
	_dialog_panel.anchor_right = 0.70
	_dialog_panel.anchor_bottom = 0.94
	_dialog_panel.visible = false
	layer.add_child(_dialog_panel)

	var dialog_margin := MarginContainer.new()
	dialog_margin.add_theme_constant_override("margin_left", 20)
	dialog_margin.add_theme_constant_override("margin_top", 18)
	dialog_margin.add_theme_constant_override("margin_right", 20)
	dialog_margin.add_theme_constant_override("margin_bottom", 18)
	_dialog_panel.add_child(dialog_margin)

	_dialog_label = Label.new()
	_dialog_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_dialog_label.add_theme_font_size_override("font_size", 20)
	dialog_margin.add_child(_dialog_label)


func _handle_keyboard_input() -> void:
	if Input.is_action_just_pressed("camera_rotate_left"):
		_view_rotation_steps = wrapi(_view_rotation_steps - 1, 0, 4)
		_snap_actor_world_positions_to_grid()
		_rebuild_world()

	if Input.is_action_just_pressed("camera_rotate_right"):
		_view_rotation_steps = wrapi(_view_rotation_steps + 1, 0, 4)
		_snap_actor_world_positions_to_grid()
		_rebuild_world()

	if Input.is_action_just_pressed("zoom_in"):
		_zoom = minf(1.35, _zoom + 0.1)
		_camera.zoom = Vector2(_zoom, _zoom)

	if Input.is_action_just_pressed("zoom_out"):
		_zoom = maxf(0.75, _zoom - 0.1)
		_camera.zoom = Vector2(_zoom, _zoom)

	if Input.is_action_just_pressed("toggle_combat_overlay"):
		_toggle_combat_overlay()

	if Input.is_action_just_pressed("quick_save"):
		_write_scene_state_to_game_state()
		SaveService.save_game()
		_show_dialog("Debug quick save written.\nActor positions, selected party member, evidence, and overlay state were stored.")

	if Input.is_action_just_pressed("quick_load"):
		if SaveService.load_game():
			_restore_scene_state_from_game_state()
			_snap_actor_world_positions_to_grid()
			_rebuild_world()
			_refresh_hud()
			_show_dialog("Debug quick save loaded.\nThe working test restored scene state from SaveService.")
		else:
			_show_dialog("No debug quick save found yet. Press F5 after moving or inspecting evidence.")

	if Input.is_action_just_pressed("pause"):
		_write_scene_state_to_game_state()
		GameState.current_scene_path = TITLE_SCENE
		get_tree().change_scene_to_file(TITLE_SCENE)


func _handle_mouse_input() -> void:
	if Input.is_action_just_pressed("select"):
		var mouse_world := get_global_mouse_position()
		if _try_select_actor(mouse_world):
			return
		if mouse_world.distance_to(_iso(EVIDENCE_GRID)) <= 46.0:
			_collect_evidence()

	if Input.is_action_just_pressed("move_command"):
		var target_grid := _grid_from_world(get_global_mouse_position())
		if _is_grid_walkable(target_grid):
			_set_actor_target(_selected_actor_id, target_grid)
		else:
			_show_dialog("That tile is outside the authored Crossroads Plaza test area.")


func _update_actor_motion(delta: float) -> void:
	var any_moved := false
	for actor_id in _actor_states.keys():
		var actor_state: Dictionary = _actor_states[actor_id]
		var target_position := _iso(actor_state.target_grid)
		var world_position: Vector2 = actor_state.world_position
		if world_position.distance_to(target_position) <= 1.0:
			actor_state.world_position = target_position
			actor_state.grid = actor_state.target_grid
			continue

		actor_state.world_position = world_position.move_toward(target_position, MOVE_SPEED_PIXELS * delta)
		any_moved = true

	if any_moved:
		_refresh_actor_visuals()
		_write_scene_state_to_game_state()


func _update_camera_position() -> void:
	if _camera == null or not _actor_states.has(_selected_actor_id):
		return

	var actor_state: Dictionary = _actor_states[_selected_actor_id]
	var target_position: Vector2 = actor_state.world_position + Vector2(0.0, -130.0)
	var top_edge := _iso(Vector2i(0, -FLOOR_HALF_EXTENTS.y - 2)).y - 220.0
	var bottom_edge := _iso(Vector2i(0, FLOOR_HALF_EXTENTS.y + 2)).y + 120.0
	var left_edge := _iso(Vector2i(-FLOOR_HALF_EXTENTS.x - 2, 0)).x - 260.0
	var right_edge := _iso(Vector2i(FLOOR_HALF_EXTENTS.x + 2, 0)).x + 260.0
	_camera.position = Vector2(
		clampf(target_position.x, left_edge, right_edge),
		clampf(target_position.y, top_edge, bottom_edge)
	)


func _try_select_actor(mouse_world: Vector2) -> bool:
	var closest_actor_id := ""
	var closest_distance := 99999.0
	for actor_id in _actor_states.keys():
		var actor_position: Vector2 = _actor_states[actor_id].world_position
		var distance := mouse_world.distance_to(actor_position + Vector2(0.0, -35.0))
		if distance < closest_distance:
			closest_actor_id = actor_id
			closest_distance = distance

	if closest_actor_id != "" and closest_distance <= 52.0:
		_selected_actor_id = closest_actor_id
		_refresh_actor_visuals()
		_write_scene_state_to_game_state()
		_refresh_hud()
		return true

	return false


func _set_actor_target(actor_id: String, target_grid: Vector2i) -> void:
	if not _actor_states.has(actor_id):
		return

	if not _is_grid_walkable(target_grid):
		_show_dialog("That tile is blocked by Crossroads Plaza walls, buildings, or test boundary.")
		return

	_actor_states[actor_id].target_grid = target_grid
	_show_dialog("%s moving to tile %s." % [_actor_states[actor_id].display_name, str(target_grid)])
	_write_scene_state_to_game_state()


func _collect_evidence() -> void:
	_evidence_collected = true
	_write_scene_state_to_game_state()
	_refresh_hud()
	_rebuild_world()
	_show_dialog("Crossroads Plaza public note: Maelin Vossmark's caravan ledger records permits, route contracts, escort postings, and missing cargo claims.\nVisibility: public testbed fact.\nNo hiddenInfo or secret lore is exposed here.")


func _toggle_combat_overlay() -> void:
	_combat_overlay_visible = not _combat_overlay_visible
	if _overlay_root != null:
		_overlay_root.visible = _combat_overlay_visible
	_write_scene_state_to_game_state()
	_refresh_hud()


func _refresh_hud() -> void:
	if _hud_label == null:
		return

	var selected_name := str(_actor_states.get(_selected_actor_id, {}).get("display_name", _selected_actor_id))
	var evidence_text := "collected" if _evidence_collected else "available"
	var combat_text := "shown" if _combat_overlay_visible else "hidden"
	_hud_label.text = "Crossroads Plaza Grandeur Test\nNative target: 1920 x 1080\nSelected: %s\nCaravan ledger: %s\nCombat overlay: %s\nRing-city plaza node, not full city\nLeft-click select/inspect, right-click move\nTab overlay, F5 save, F9 load, Esc title" % [selected_name, evidence_text, combat_text]


func _show_dialog(text: String) -> void:
	if _dialog_panel == null or _dialog_label == null:
		return

	_dialog_label.text = text
	_dialog_panel.visible = true


func _add_architecture_foundation_fill() -> void:
	for blocker in ARCHITECTURE_BLOCKERS:
		var origin: Vector2i = blocker.origin
		var footprint: Vector2i = blocker.footprint
		for x in range(origin.x, origin.x + footprint.x):
			for y in range(origin.y, origin.y + footprint.y):
				var grid_position := Vector2i(x, y)
				if _is_plaza_road_cell(grid_position):
					continue
				var center := _iso(grid_position)
				var foundation := Polygon2D.new()
				foundation.name = "Architecture Foundation %d,%d" % [x, y]
				foundation.polygon = _diamond(center)
				foundation.color = Color(0.32, 0.31, 0.27, 0.96)
				foundation.z_index = int(center.y) - 4
				_world_root.add_child(foundation)


func _add_nonwalkable_boundary_fill() -> void:
	for x in range(-FLOOR_HALF_EXTENTS.x, FLOOR_HALF_EXTENTS.x + 1):
		for y in range(-FLOOR_HALF_EXTENTS.y, FLOOR_HALF_EXTENTS.y + 1):
			var grid_position := Vector2i(x, y)
			if _is_grid_walkable(grid_position):
				continue

			var center := _iso(grid_position)
			var fill := Polygon2D.new()
			fill.name = "Ring City Edge Masonry %d,%d" % [x, y]
			fill.polygon = _diamond(center)
			fill.color = Color(0.28, 0.29, 0.26, 0.95) if _is_grid_blocked_by_architecture(grid_position) else Color(0.22, 0.25, 0.23, 0.90)
			fill.z_index = int(center.y) - 6
			_world_root.add_child(fill)


func _add_diamond_floor(origin: Vector2i, half_extents: Vector2i, color: Color, node_name: String) -> void:
	for x in range(origin.x - half_extents.x, origin.x + half_extents.x + 1):
		for y in range(origin.y - half_extents.y, origin.y + half_extents.y + 1):
			var grid_position := Vector2i(x, y)
			if not _is_grid_walkable(grid_position):
				continue

			var tile_position := _iso(grid_position)
			var tile := Polygon2D.new()
			tile.name = "%s %d,%d" % [node_name, x, y]
			tile.polygon = _diamond(tile_position)
			tile.color = color.lightened(0.08 if (x + y) % 2 == 0 else 0.0)
			tile.z_index = int(tile_position.y)
			_world_root.add_child(tile)


func _add_ring_city_plaza_bands() -> void:
	for x in range(-FLOOR_HALF_EXTENTS.x, FLOOR_HALF_EXTENTS.x + 1):
		for y in range(-FLOOR_HALF_EXTENTS.y, FLOOR_HALF_EXTENTS.y + 1):
			var grid_position := Vector2i(x, y)
			if not _is_grid_walkable(grid_position):
				continue

			var radius: float = _ring_radius(grid_position)
			var is_inner_ring: bool = absf(radius - 4.8) <= 0.34
			var is_middle_ring: bool = absf(radius - 8.8) <= 0.42
			var is_outer_ring: bool = absf(radius - 12.2) <= 0.48
			if not (is_inner_ring or is_middle_ring or is_outer_ring):
				continue

			var center := _iso(grid_position)
			var ring_tile := Polygon2D.new()
			ring_tile.name = "Ring City Plaza Band %d,%d" % [x, y]
			ring_tile.polygon = _diamond(center)
			ring_tile.color = Color(0.68, 0.61, 0.48, 0.96) if is_outer_ring else Color(0.79, 0.73, 0.59, 0.96)
			ring_tile.z_index = int(center.y) + 2
			_world_root.add_child(ring_tile)

	var fountain_center := _iso(FOUNTAIN_GRID)
	_add_screen_ellipse_outline("Inner fountain traffic ring", fountain_center, 440.0, 214.0, Color(0.90, 0.78, 0.45, 0.72), 4.0, int(fountain_center.y) + 42)
	_add_screen_ellipse_outline("Outer civic plaza ring", fountain_center, 860.0, 418.0, Color(0.72, 0.62, 0.42, 0.58), 5.0, int(fountain_center.y) + 36)


func _add_radial_roads() -> void:
	for x in range(-FLOOR_HALF_EXTENTS.x, FLOOR_HALF_EXTENTS.x + 1):
		for y in range(-FLOOR_HALF_EXTENTS.y, FLOOR_HALF_EXTENTS.y + 1):
			var grid_position := Vector2i(x, y)
			if not _is_grid_walkable(grid_position):
				continue

			var on_diagonal_spoke: bool = abs(abs(x) - abs(y - FOUNTAIN_GRID.y)) <= 1 and _ring_radius(grid_position) <= 12.8
			if _is_plaza_road_cell(grid_position) or on_diagonal_spoke:
				var tile := Polygon2D.new()
				var center := _iso(grid_position)
				tile.name = "Crossroads Fountain Boulevard %d,%d" % [x, y]
				tile.polygon = _diamond(center)
				tile.color = Color(0.80, 0.76, 0.67, 0.94) if on_diagonal_spoke else Color(0.82, 0.78, 0.66, 0.96)
				tile.z_index = int(center.y) + 1
				_world_root.add_child(tile)


func _add_outer_canals_and_bridges() -> void:
	for x in range(-13, 14):
		for y in [-28, 28]:
			var grid_position := Vector2i(x, y)
			var center := _iso(grid_position)
			var water := Polygon2D.new()
			water.name = "Backdrop Ring Canal %s" % str(grid_position)
			water.polygon = _diamond(center)
			water.color = Color(0.13, 0.39, 0.54, 0.82)
			water.z_index = int(center.y) - 10
			_world_root.add_child(water)

	for grid_position in [Vector2i(0, -28), Vector2i(0, 28), Vector2i(-11, -28), Vector2i(11, 28)]:
		_add_isometric_block("Distant Stone Bridge %s" % str(grid_position), grid_position, Vector2i(2, 1), 0.18, Color(0.69, 0.64, 0.54))


func _add_citadel_axis() -> void:
	_add_isometric_block("Distant Magi-Knight Citadel Gatehouse", Vector2i(-3, -30), Vector2i(6, 2), 3.5, Color(0.70, 0.66, 0.56))
	_add_isometric_block("Distant Magi-Knight Citadel Spire", Vector2i(1, -33), Vector2i(1, 1), 7.8, Color(0.78, 0.75, 0.66))

	var banner := Label.new()
	banner.text = "Citadel backdrop, not walkable city scale"
	banner.position = _iso(Vector2i(2, -31)) + Vector2(24.0, -248.0)
	banner.add_theme_font_size_override("font_size", 14)
	banner.z_index = int(banner.position.y) + 50
	_world_root.add_child(banner)


func _add_central_fountain() -> void:
	var center := _iso(FOUNTAIN_GRID)
	var basin := Polygon2D.new()
	basin.name = "Crossroads Fountain Basin"
	basin.polygon = PackedVector2Array([
		center + Vector2(0.0, -72.0),
		center + Vector2(112.0, -24.0),
		center + Vector2(130.0, 0.0),
		center + Vector2(112.0, 24.0),
		center + Vector2(0.0, 72.0),
		center + Vector2(-112.0, 24.0),
		center + Vector2(-130.0, 0.0),
		center + Vector2(-112.0, -24.0)
	])
	basin.color = Color(0.53, 0.67, 0.70)
	basin.z_index = int(center.y) + 20
	_world_root.add_child(basin)

	_add_isometric_block("Fountain Stone Tier", FOUNTAIN_GRID, Vector2i(1, 1), 0.35, Color(0.76, 0.72, 0.63))
	_add_isometric_block("Fountain Water Jet Placeholder", FOUNTAIN_GRID, Vector2i(1, 1), 0.95, Color(0.34, 0.70, 0.86))


func _add_grand_city_backdrop() -> void:
	for facade in [
		{"name": "Left Ring City Facade A", "grid": Vector2i(-18, -14), "footprint": Vector2i(5, 7), "height": 4.2, "color": Color(0.69, 0.64, 0.54), "roof": Color(0.12, 0.27, 0.43)},
		{"name": "Left Ring City Facade B", "grid": Vector2i(-18, -5), "footprint": Vector2i(5, 8), "height": 4.9, "color": Color(0.63, 0.56, 0.45), "roof": Color(0.18, 0.34, 0.48)},
		{"name": "Left Ring City Facade C", "grid": Vector2i(-18, 5), "footprint": Vector2i(5, 8), "height": 4.4, "color": Color(0.66, 0.59, 0.48), "roof": Color(0.40, 0.25, 0.19)},
		{"name": "Left Ring City Facade D", "grid": Vector2i(-18, 15), "footprint": Vector2i(5, 7), "height": 4.0, "color": Color(0.70, 0.62, 0.50), "roof": Color(0.20, 0.40, 0.38)},
		{"name": "Right Ring City Facade A", "grid": Vector2i(13, -14), "footprint": Vector2i(5, 7), "height": 4.3, "color": Color(0.70, 0.65, 0.55), "roof": Color(0.14, 0.31, 0.46)},
		{"name": "Right Ring City Facade B", "grid": Vector2i(13, -5), "footprint": Vector2i(5, 8), "height": 5.1, "color": Color(0.61, 0.55, 0.45), "roof": Color(0.18, 0.35, 0.50)},
		{"name": "Right Ring City Facade C", "grid": Vector2i(13, 5), "footprint": Vector2i(5, 8), "height": 4.6, "color": Color(0.68, 0.61, 0.50), "roof": Color(0.44, 0.27, 0.17)},
		{"name": "Right Ring City Facade D", "grid": Vector2i(13, 15), "footprint": Vector2i(5, 7), "height": 4.1, "color": Color(0.66, 0.60, 0.50), "roof": Color(0.40, 0.24, 0.47)},
		{"name": "Lower Foreground Dome Left", "grid": Vector2i(-15, 24), "footprint": Vector2i(6, 4), "height": 4.6, "color": Color(0.16, 0.31, 0.46), "roof": Color(0.08, 0.22, 0.38)},
		{"name": "Lower Foreground Arcade", "grid": Vector2i(-6, 24), "footprint": Vector2i(12, 4), "height": 3.9, "color": Color(0.67, 0.61, 0.51), "roof": Color(0.36, 0.23, 0.17)},
		{"name": "Lower Foreground Dome Right", "grid": Vector2i(9, 24), "footprint": Vector2i(6, 4), "height": 4.6, "color": Color(0.18, 0.34, 0.47), "roof": Color(0.08, 0.24, 0.39)}
	]:
		var grid_position: Vector2i = facade.grid
		var footprint: Vector2i = facade.footprint
		var height: float = facade.height
		var color: Color = facade.color
		var roof_color: Color = facade.roof
		_add_plaza_building(str(facade.name), grid_position, footprint, height, color, roof_color)

	for grid_position in [Vector2i(-11, -18), Vector2i(-7, -19), Vector2i(7, -19), Vector2i(11, -18), Vector2i(-12, 18), Vector2i(12, 18)]:
		_add_plaza_building("Blue roof civic tower %s" % str(grid_position), grid_position, Vector2i(2, 2), 5.4, Color(0.70, 0.66, 0.56), Color(0.12, 0.29, 0.48))


func _add_plaza_frontage_architecture() -> void:
	for building in [
		{"name": "Slayers Guild Plaza Front", "grid": Vector2i(-14, -1), "footprint": Vector2i(3, 5), "height": 3.7, "body": Color(0.58, 0.56, 0.50), "roof": Color(0.16, 0.18, 0.18), "awning": Color(0.30, 0.32, 0.31)},
		{"name": "Left Ringmarket Row", "grid": Vector2i(-13, 13), "footprint": Vector2i(3, 5), "height": 3.2, "body": Color(0.66, 0.58, 0.46), "roof": Color(0.43, 0.25, 0.18), "awning": Color(0.54, 0.34, 0.22)},
		{"name": "Permit Offices Arcade", "grid": Vector2i(-12, 17), "footprint": Vector2i(4, 4), "height": 3.5, "body": Color(0.70, 0.64, 0.52), "roof": Color(0.16, 0.31, 0.46), "awning": Color(0.11, 0.22, 0.49)},
		{"name": "Ringmarket Plaza Front", "grid": Vector2i(11, -1), "footprint": Vector2i(3, 5), "height": 3.6, "body": Color(0.68, 0.61, 0.50), "roof": Color(0.48, 0.30, 0.17), "awning": Color(0.73, 0.45, 0.18)},
		{"name": "Stable Yard Plaza Front", "grid": Vector2i(10, 18), "footprint": Vector2i(4, 5), "height": 3.1, "body": Color(0.61, 0.50, 0.39), "roof": Color(0.22, 0.40, 0.34), "awning": Color(0.25, 0.45, 0.36)}
	]:
		var grid_position: Vector2i = building.grid
		var footprint: Vector2i = building.footprint
		var height: float = building.height
		var body_color: Color = building.body
		var roof_color: Color = building.roof
		var awning_color: Color = building.awning
		_add_plaza_building(str(building.name), grid_position, footprint, height, body_color, roof_color)
		_add_frontage_awning("%s Awning" % str(building.name), grid_position + Vector2i(0, footprint.y - 1), Vector2i(footprint.x, 1), awning_color)

	for grid_position in [
		Vector2i(-11, -8), Vector2i(-11, -4), Vector2i(-11, 0), Vector2i(-11, 13), Vector2i(-11, 17),
		Vector2i(10, -8), Vector2i(10, -4), Vector2i(10, 3), Vector2i(10, 18), Vector2i(10, 22)
	]:
		_add_isometric_block("Plaza Arcade Pier %s" % str(grid_position), grid_position, Vector2i(1, 1), 1.9, Color(0.74, 0.69, 0.58))


func _add_market_tents() -> void:
	for tent in [
		{"name": "Ringmarket Blue Awning", "grid": Vector2i(8, -3), "color": Color(0.18, 0.29, 0.58)},
		{"name": "Ringmarket Amber Awning", "grid": Vector2i(8, 2), "color": Color(0.72, 0.43, 0.18)},
		{"name": "Lower Blue Market Stall", "grid": Vector2i(9, 14), "color": Color(0.16, 0.27, 0.55)},
		{"name": "Lower Violet Market Stall", "grid": Vector2i(7, 17), "color": Color(0.48, 0.29, 0.50)},
		{"name": "Caravan Permit Desk", "grid": EVIDENCE_GRID, "color": Color(0.40, 0.25, 0.13)},
		{"name": "Stable Tack Awning", "grid": Vector2i(8, 18), "color": Color(0.25, 0.45, 0.36)},
		{"name": "Slayer Notice Awning", "grid": Vector2i(-9, 4), "color": Color(0.35, 0.36, 0.34)},
		{"name": "Left Cloth Merchant", "grid": Vector2i(-9, 13), "color": Color(0.55, 0.35, 0.22)},
		{"name": "Left Food Seller", "grid": Vector2i(-8, 18), "color": Color(0.22, 0.44, 0.34)}
	]:
		var grid_position: Vector2i = tent.grid
		_add_isometric_block(str(tent.name), grid_position, Vector2i(1, 1), 0.85, tent.color)


func _add_civic_banners() -> void:
	for grid_position in [Vector2i(-5, -15), Vector2i(5, -15), Vector2i(-7, -6), Vector2i(7, -6), Vector2i(-7, 3), Vector2i(7, 3), Vector2i(-6, 12), Vector2i(6, 12), Vector2i(-5, 20), Vector2i(5, 20)]:
		_add_isometric_block("Blue Gold Civic Banner %s" % str(grid_position), grid_position, Vector2i(1, 1), 1.4, Color(0.12, 0.22, 0.50))


func _add_route_markers() -> void:
	for route in PLAZA_ROUTES:
		var grid_position: Vector2i = route.grid
		var color: Color = route.color
		_add_isometric_block("%s Route Marker" % str(route.name), grid_position, Vector2i(1, 1), 0.55, color)

		var label := Label.new()
		label.text = str(route.name)
		label.position = _iso(grid_position) + Vector2(-46.0, -54.0)
		label.add_theme_font_size_override("font_size", 13)
		label.z_index = int(label.position.y) + 30
		_world_root.add_child(label)


func _add_crowd_markers() -> void:
	for grid_position in [
		Vector2i(-1, -18), Vector2i(1, -17), Vector2i(-3, -13), Vector2i(3, -12),
		Vector2i(-6, -8), Vector2i(6, -8), Vector2i(-2, -5), Vector2i(2, -4),
		Vector2i(-9, -2), Vector2i(9, -1), Vector2i(-5, 1), Vector2i(5, 2),
		Vector2i(-2, 6), Vector2i(2, 7), Vector2i(-7, 8), Vector2i(7, 8),
		Vector2i(-10, 12), Vector2i(10, 12), Vector2i(-4, 13), Vector2i(4, 14),
		Vector2i(-2, 18), Vector2i(2, 19), Vector2i(-6, 20), Vector2i(6, 20)
	]:
		var base := _iso(grid_position) + Vector2(0.0, -12.0)
		var crowd := Polygon2D.new()
		crowd.name = "Crowd Placeholder %s" % str(grid_position)
		crowd.polygon = PackedVector2Array([
			base + Vector2(-6.0, 3.0),
			base + Vector2(0.0, -18.0),
			base + Vector2(6.0, 3.0),
			base + Vector2(0.0, 8.0)
		])
		crowd.color = Color(0.20 + abs(grid_position.x) * 0.025, 0.17, 0.13 + abs(grid_position.y) * 0.03, 0.95)
		crowd.z_index = int(base.y) + 8
		_world_root.add_child(crowd)


func _add_evidence_marker() -> void:
	var marker_color := Color(0.52, 0.52, 0.52) if _evidence_collected else Color(0.82, 0.68, 0.30)
	_add_isometric_block("Evidence Marker", EVIDENCE_GRID, Vector2i(1, 1), 0.45, marker_color)

	var tag := Label.new()
	tag.text = "Maelin's ledger: read" if _evidence_collected else "Maelin's ledger"
	tag.position = _iso(EVIDENCE_GRID) + Vector2(26.0, -58.0)
	tag.add_theme_font_size_override("font_size", 13)
	tag.z_index = int(tag.position.y) + 20
	_world_root.add_child(tag)


func _add_plaza_building(node_name: String, origin: Vector2i, footprint: Vector2i, height_tiles: float, body_color: Color, roof_color: Color) -> void:
	_add_isometric_block("%s Body" % node_name, origin, footprint, height_tiles, body_color)

	var tier_offset: int = maxi(1, int(floor(float(footprint.y) / 3.0)))
	var upper_origin := origin + Vector2i(0, tier_offset)
	var upper_footprint := Vector2i(footprint.x, maxi(1, footprint.y - tier_offset))
	_add_isometric_block("%s Upper Mass" % node_name, upper_origin, upper_footprint, height_tiles + 0.8, body_color.lightened(0.05))
	_add_roof_cap("%s Roof Cap" % node_name, upper_origin, upper_footprint, height_tiles + 1.05, roof_color)


func _add_frontage_awning(node_name: String, origin: Vector2i, footprint: Vector2i, color: Color) -> void:
	_add_isometric_block(node_name, origin, footprint, 0.55, color)


func _add_roof_cap(node_name: String, origin: Vector2i, footprint: Vector2i, height_tiles: float, color: Color) -> void:
	var corners := [
		_iso(origin),
		_iso(origin + Vector2i(footprint.x, 0)),
		_iso(origin + footprint),
		_iso(origin + Vector2i(0, footprint.y))
	]
	var lift := Vector2(0.0, -height_tiles * TILE_SIZE.y)
	var eave := Vector2(0.0, -10.0)
	var roof := PackedVector2Array([
		corners[0] + lift + Vector2(0.0, -12.0),
		corners[1] + lift + Vector2(18.0, 0.0),
		corners[2] + lift + Vector2(0.0, 12.0),
		corners[3] + lift + Vector2(-18.0, 0.0)
	])
	var ridge := PackedVector2Array([
		corners[0] + lift + eave,
		(corners[1] + corners[2]) * 0.5 + lift + Vector2(0.0, -32.0),
		corners[2] + lift + Vector2(0.0, 12.0),
		(corners[3] + corners[0]) * 0.5 + lift + Vector2(0.0, -32.0)
	])
	_add_polygon("%s Main" % node_name, roof, color, int(corners[2].y) + 18)
	_add_polygon("%s Ridge" % node_name, ridge, color.lightened(0.10), int(corners[2].y) + 19)


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


func _add_actor_marker(actor_id: String, display_name: String, color: Color) -> void:
	var shadow := Polygon2D.new()
	shadow.name = "%s Shadow" % display_name
	shadow.color = Color(0.0, 0.0, 0.0, 0.24)
	_world_root.add_child(shadow)

	var body := Polygon2D.new()
	body.name = display_name
	body.color = color
	_world_root.add_child(body)

	var selection := Line2D.new()
	selection.name = "%s Selection" % display_name
	selection.width = 3.0
	selection.closed = true
	selection.default_color = Color(1.0, 0.88, 0.35, 0.95)
	_world_root.add_child(selection)

	var label := Label.new()
	label.text = display_name
	label.add_theme_font_size_override("font_size", 13)
	_world_root.add_child(label)

	_actor_nodes[actor_id] = {
		"shadow": shadow,
		"body": body,
		"selection": selection,
		"label": label
	}


func _refresh_actor_visuals() -> void:
	for actor_id in _actor_states.keys():
		if not _actor_nodes.has(actor_id):
			continue

		var actor_state: Dictionary = _actor_states[actor_id]
		var base: Vector2 = actor_state.world_position
		var z := int(base.y) + 4
		var nodes: Dictionary = _actor_nodes[actor_id]

		var shadow: Polygon2D = nodes.shadow
		shadow.polygon = PackedVector2Array([
			base + Vector2(0.0, -13.0),
			base + Vector2(30.0, 0.0),
			base + Vector2(0.0, 13.0),
			base + Vector2(-30.0, 0.0)
		])
		shadow.z_index = z

		var body: Polygon2D = nodes.body
		body.polygon = PackedVector2Array([
			base + Vector2(-22.0, 4.0),
			base + Vector2(-16.0, -60.0),
			base + Vector2(0.0, -90.0),
			base + Vector2(16.0, -60.0),
			base + Vector2(22.0, 4.0),
			base + Vector2(0.0, 18.0)
		])
		body.z_index = z + 1

		var selection: Line2D = nodes.selection
		selection.points = PackedVector2Array([
			base + Vector2(0.0, -23.0),
			base + Vector2(42.0, 0.0),
			base + Vector2(0.0, 23.0),
			base + Vector2(-42.0, 0.0)
		])
		selection.visible = actor_id == _selected_actor_id
		selection.z_index = z + 2

		var label: Label = nodes.label
		label.position = base + Vector2(-58.0, 20.0)
		label.z_index = z + 3


func _add_same_environment_combat_overlay(origin: Vector2i, size: Vector2i) -> void:
	for x in range(origin.x - size.x / 2, origin.x + size.x / 2 + 1):
		for y in range(origin.y - size.y / 2, origin.y + size.y / 2 + 1):
			var grid_position := Vector2i(x, y)
			if not _is_grid_walkable(grid_position):
				continue

			var cell_color := Color(0.20, 0.55, 0.78, 0.34)
			if x <= origin.x - 2:
				cell_color = Color(0.23, 0.64, 0.42, 0.42)
			elif x >= origin.x + 2:
				cell_color = Color(0.78, 0.34, 0.28, 0.42)
			_add_diamond_outline("Same Scene Combat Cell %d,%d" % [x, y], _iso(grid_position), cell_color)

	var tag := Label.new()
	tag.text = "same-scene combat layer"
	tag.position = _iso(origin + Vector2i(2, -3)) + Vector2(12.0, -10.0)
	tag.add_theme_font_size_override("font_size", 14)
	tag.z_index = int(tag.position.y) + 20
	_overlay_root.add_child(tag)


func _add_diamond_outline(node_name: String, center: Vector2, color: Color) -> void:
	var outline := Line2D.new()
	outline.name = node_name
	outline.width = 2.0
	outline.closed = true
	outline.default_color = color
	outline.points = _diamond(center)
	outline.z_index = int(center.y) + 10
	_overlay_root.add_child(outline)


func _add_screen_ellipse_outline(node_name: String, center: Vector2, radius_x: float, radius_y: float, color: Color, width: float, z: int) -> void:
	var outline := Line2D.new()
	outline.name = node_name
	outline.width = width
	outline.closed = true
	outline.default_color = color
	outline.points = _ellipse_points(center, radius_x, radius_y, 96)
	outline.z_index = z
	_world_root.add_child(outline)


func _add_polygon(node_name: String, points: PackedVector2Array, color: Color, z: int) -> void:
	var polygon := Polygon2D.new()
	polygon.name = node_name
	polygon.polygon = points
	polygon.color = color
	polygon.z_index = z
	_world_root.add_child(polygon)


func _diamond(center: Vector2) -> PackedVector2Array:
	return PackedVector2Array([
		center + Vector2(0.0, -TILE_SIZE.y * 0.5),
		center + Vector2(TILE_SIZE.x * 0.5, 0.0),
		center + Vector2(0.0, TILE_SIZE.y * 0.5),
		center + Vector2(-TILE_SIZE.x * 0.5, 0.0)
	])


func _ellipse_points(center: Vector2, radius_x: float, radius_y: float, count: int) -> PackedVector2Array:
	var points := PackedVector2Array()
	for index in range(count):
		var angle := TAU * float(index) / float(count)
		points.append(center + Vector2(cos(angle) * radius_x, sin(angle) * radius_y))
	return points


func _is_grid_walkable(grid_position: Vector2i) -> bool:
	if abs(grid_position.x) > FLOOR_HALF_EXTENTS.x or abs(grid_position.y) > FLOOR_HALF_EXTENTS.y:
		return false
	if _is_grid_blocked_by_architecture(grid_position):
		return false

	var in_round_plaza: bool = _ring_radius(grid_position) <= 13.4
	var in_sidewalk_apron: bool = abs(grid_position.y - EAST_WEST_ROAD_Y) <= 4 and abs(grid_position.x) <= 12
	return _is_plaza_road_cell(grid_position) or in_round_plaza or in_sidewalk_apron


func _is_grid_blocked_by_architecture(grid_position: Vector2i) -> bool:
	if _is_plaza_road_cell(grid_position):
		return false

	for blocker in ARCHITECTURE_BLOCKERS:
		var origin: Vector2i = blocker.origin
		var footprint: Vector2i = blocker.footprint
		var within_x: bool = grid_position.x >= origin.x and grid_position.x < origin.x + footprint.x
		var within_y: bool = grid_position.y >= origin.y and grid_position.y < origin.y + footprint.y
		if within_x and within_y:
			return true
	return false


func _is_plaza_road_cell(grid_position: Vector2i) -> bool:
	var on_main_boulevard: bool = abs(grid_position.x) <= 4
	var on_fountain_apron: bool = _ring_radius(grid_position) <= 10.8
	var on_east_west_exit: bool = abs(grid_position.y - EAST_WEST_ROAD_Y) <= 1 and abs(grid_position.x) <= FLOOR_HALF_EXTENTS.x
	var on_citadel_approach: bool = grid_position.y <= FOUNTAIN_GRID.y and abs(grid_position.x) <= 6
	return on_main_boulevard or on_fountain_apron or on_east_west_exit or on_citadel_approach


func _fallback_actor_grid(actor_id: String) -> Vector2i:
	for actor in ACTOR_DEFINITIONS:
		if str(actor.id) == actor_id:
			var default_grid: Vector2i = actor.grid
			if _is_grid_walkable(default_grid):
				return default_grid
	return Vector2i.ZERO


func _is_outer_corner(grid_position: Vector2i) -> bool:
	return abs(grid_position.x) >= FLOOR_HALF_EXTENTS.x - 1 and abs(grid_position.y) >= FLOOR_HALF_EXTENTS.y - 1


func _ring_radius(grid_position: Vector2i) -> float:
	var offset := grid_position - FOUNTAIN_GRID
	var x := float(offset.x)
	var y := float(offset.y) * 0.72
	return sqrt((x * x) + (y * y))


func _snap_actor_world_positions_to_grid() -> void:
	for actor_id in _actor_states.keys():
		var actor_state: Dictionary = _actor_states[actor_id]
		actor_state.world_position = _iso(actor_state.grid)
		actor_state.target_grid = actor_state.grid


func _iso(grid_position: Vector2i) -> Vector2:
	var rotated := _rotate_grid(grid_position)
	var x := float(rotated.x - rotated.y) * TILE_SIZE.x * 0.5
	var y := float(rotated.x + rotated.y) * TILE_SIZE.y * 0.5
	return Vector2(x, y)


func _grid_from_world(world_position: Vector2) -> Vector2i:
	var rotated_x := (world_position.x / (TILE_SIZE.x * 0.5) + world_position.y / (TILE_SIZE.y * 0.5)) * 0.5
	var rotated_y := (world_position.y / (TILE_SIZE.y * 0.5) - world_position.x / (TILE_SIZE.x * 0.5)) * 0.5
	return _unrotate_grid(Vector2i(roundi(rotated_x), roundi(rotated_y)))


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


func _unrotate_grid(grid_position: Vector2i) -> Vector2i:
	match _view_rotation_steps:
		1:
			return Vector2i(grid_position.y, -grid_position.x)
		2:
			return Vector2i(-grid_position.x, -grid_position.y)
		3:
			return Vector2i(-grid_position.y, grid_position.x)
		_:
			return grid_position


func _vector2i_from_array(value: Variant, fallback: Vector2i) -> Vector2i:
	if typeof(value) != TYPE_ARRAY:
		return fallback

	var values: Array = value
	if values.size() < 2:
		return fallback

	return Vector2i(int(values[0]), int(values[1]))
