@tool
extends Node2D
class_name PlazaAuthoringNode

const ASSET_CATALOG := preload("res://scripts/world/map_asset_catalog.gd")

enum AuthoringKind {
	ROAD,
	SIDEWALK,
	FOUNDATION,
	BUILDING,
	TENT,
	ROUTE,
	SPAWN,
	CROWD,
	BANNER,
	COMBAT_AREA
}

enum RenderStyle {
	AUTO,
	GROUND_REGION,
	BUILDING_MASS,
	MODULAR_BLOCK,
	MARKER,
	ACTOR,
	COMBAT_AREA
}

const TILE_SIZE := Vector2(112.0, 56.0)

var _is_syncing_position := false

@export_enum(
	"custom",
	"ground.road.primary_boulevard",
	"ground.road.ring_segment",
	"ground.sidewalk.civic_apron",
	"ground.foundation.masonry",
	"building.civic_facade_blue",
	"building.guild_front",
	"building.arcade_row",
	"market.stall.blue",
	"market.stall.row",
	"civic.banner.blue_gold",
	"route.marker",
	"crowd.marker",
	"combat.same_scene_area"
) var asset_id := ASSET_CATALOG.ASSET_CUSTOM:
	set(value):
		asset_id = value
		_apply_asset_preset(value)
		queue_redraw()

@export var kind: AuthoringKind = AuthoringKind.BUILDING:
	set(value):
		kind = value
		queue_redraw()

@export var render_style: RenderStyle = RenderStyle.AUTO:
	set(value):
		render_style = value
		queue_redraw()

@export var grid_position := Vector2i.ZERO:
	set(value):
		grid_position = value
		_sync_position_to_grid()
		queue_redraw()

@export var footprint := Vector2i.ONE:
	set(value):
		footprint = Vector2i(maxi(1, value.x), maxi(1, value.y))
		queue_redraw()

@export var display_name := ""
@export var actor_id := ""
@export var height_tiles := 1.0:
	set(value):
		height_tiles = maxf(0.0, value)
		queue_redraw()

@export var color := Color(0.70, 0.64, 0.52):
	set(value):
		color = value
		queue_redraw()

@export var roof_color := Color(0.16, 0.31, 0.46):
	set(value):
		roof_color = value
		queue_redraw()

@export var awning_color := Color(0.0, 0.0, 0.0, 0.0):
	set(value):
		awning_color = value
		queue_redraw()

@export var blocks_movement := false:
	set(value):
		blocks_movement = value
		queue_redraw()

@export_multiline var asset_notes := ""

func _ready() -> void:
	_sync_position_to_grid()
	queue_redraw()


func _process(_delta: float) -> void:
	if not Engine.is_editor_hint() or _is_syncing_position:
		return

	var expected_position := grid_to_iso(grid_position)
	if position == expected_position:
		return

	grid_position = world_to_grid(position)


func get_authoring_kind() -> int:
	return int(kind)


func get_render_style() -> int:
	return int(_effective_render_style())


func _sync_position_to_grid() -> void:
	_is_syncing_position = true
	position = grid_to_iso(grid_position)
	_is_syncing_position = false


func _draw() -> void:
	if not Engine.is_editor_hint():
		return

	var preview_color := color
	preview_color.a = _preview_alpha()
	draw_colored_polygon(_footprint_polygon(), preview_color)
	if _effective_render_style() == RenderStyle.BUILDING_MASS:
		_draw_building_volume_preview()
	elif _effective_render_style() == RenderStyle.MODULAR_BLOCK:
		_draw_modular_preview()
	if blocks_movement:
		draw_polyline(_footprint_polygon(), Color(1.0, 0.25, 0.18, 0.85), 3.0, true)
	else:
		draw_polyline(_footprint_polygon(), _preview_outline_color(), _preview_outline_width(), true)


func _apply_asset_preset(selected_asset_id: String) -> void:
	if selected_asset_id == ASSET_CATALOG.ASSET_CUSTOM:
		return

	var asset := ASSET_CATALOG.get_asset(selected_asset_id)
	if asset.is_empty():
		return

	kind = int(asset.get("kind", int(kind)))
	render_style = int(asset.get("render_style", int(render_style)))
	footprint = asset.get("footprint", footprint)
	height_tiles = float(asset.get("height", height_tiles))
	display_name = str(asset.get("label", display_name))
	asset_notes = "%s\n%s" % [str(asset.get("category", "")), selected_asset_id]
	color = asset.get("color", color)
	roof_color = asset.get("roof_color", roof_color)
	awning_color = asset.get("awning_color", awning_color)
	blocks_movement = bool(asset.get("blocks_movement", blocks_movement))


func _effective_render_style() -> int:
	if render_style != RenderStyle.AUTO:
		return render_style

	match kind:
		AuthoringKind.ROAD, AuthoringKind.SIDEWALK, AuthoringKind.FOUNDATION:
			return RenderStyle.GROUND_REGION
		AuthoringKind.BUILDING:
			return RenderStyle.BUILDING_MASS
		AuthoringKind.TENT:
			return RenderStyle.MODULAR_BLOCK
		AuthoringKind.ROUTE, AuthoringKind.CROWD, AuthoringKind.BANNER:
			return RenderStyle.MARKER
		AuthoringKind.SPAWN:
			return RenderStyle.ACTOR
		AuthoringKind.COMBAT_AREA:
			return RenderStyle.COMBAT_AREA
		_:
			return RenderStyle.MARKER


func _preview_alpha() -> float:
	if kind == AuthoringKind.ROAD or kind == AuthoringKind.SIDEWALK or kind == AuthoringKind.FOUNDATION:
		return 0.78
	return 0.45


func _preview_outline_color() -> Color:
	match kind:
		AuthoringKind.ROAD:
			return Color(1.0, 0.86, 0.42, 0.96)
		AuthoringKind.SIDEWALK:
			return Color(0.66, 0.72, 0.76, 0.92)
		AuthoringKind.FOUNDATION:
			return Color(0.42, 0.42, 0.36, 0.88)
		_:
			return Color(0.2, 0.8, 1.0, 0.7)


func _preview_outline_width() -> float:
	if kind == AuthoringKind.ROAD or kind == AuthoringKind.SIDEWALK or kind == AuthoringKind.FOUNDATION:
		return 3.0
	return 2.0


func _draw_building_volume_preview() -> void:
	var corners := [
		Vector2.ZERO,
		grid_to_iso(Vector2i(footprint.x, 0)),
		grid_to_iso(footprint),
		grid_to_iso(Vector2i(0, footprint.y))
	]
	var lift := Vector2(0.0, -height_tiles * TILE_SIZE.y)
	var wall_color := color.darkened(0.25)
	wall_color.a = 0.38
	var roof_preview_color := roof_color
	roof_preview_color.a = 0.46
	var side_face := PackedVector2Array([corners[1] + lift, corners[2] + lift, corners[2], corners[1]])
	var front_face := PackedVector2Array([corners[2] + lift, corners[3] + lift, corners[3], corners[2]])
	var top_face := PackedVector2Array([corners[0] + lift, corners[1] + lift, corners[2] + lift, corners[3] + lift])
	draw_colored_polygon(side_face, wall_color)
	draw_colored_polygon(front_face, wall_color.darkened(0.12))
	draw_colored_polygon(top_face, roof_preview_color)
	draw_polyline(_volume_outline(corners, lift), Color(1.0, 0.46, 0.24, 0.88), 2.0, true)


func _draw_modular_preview() -> void:
	var module_outline := Color(0.95, 0.82, 0.35, 0.88)
	for x in range(footprint.x):
		for y in range(footprint.y):
			var origin := grid_to_iso(Vector2i(x, y))
			var module_points := PackedVector2Array()
			for point in _unit_footprint_polygon():
				module_points.append(origin + point)
			draw_polyline(module_points, module_outline, 1.5, true)


func _volume_outline(corners: Array, lift: Vector2) -> PackedVector2Array:
	return PackedVector2Array([
		corners[0] + lift,
		corners[1] + lift,
		corners[2] + lift,
		corners[2],
		corners[3],
		corners[3] + lift
	])


func _footprint_polygon() -> PackedVector2Array:
	return PackedVector2Array([
		Vector2.ZERO,
		grid_to_iso(Vector2i(footprint.x, 0)),
		grid_to_iso(footprint),
		grid_to_iso(Vector2i(0, footprint.y))
	])


func _unit_footprint_polygon() -> PackedVector2Array:
	return PackedVector2Array([
		Vector2.ZERO,
		grid_to_iso(Vector2i(1, 0)),
		grid_to_iso(Vector2i(1, 1)),
		grid_to_iso(Vector2i(0, 1))
	])


static func grid_to_iso(grid: Vector2i) -> Vector2:
	var x := float(grid.x - grid.y) * TILE_SIZE.x * 0.5
	var y := float(grid.x + grid.y) * TILE_SIZE.y * 0.5
	return Vector2(x, y)


static func world_to_grid(world_position: Vector2) -> Vector2i:
	var grid_x := (world_position.x / (TILE_SIZE.x * 0.5) + world_position.y / (TILE_SIZE.y * 0.5)) * 0.5
	var grid_y := (world_position.y / (TILE_SIZE.y * 0.5) - world_position.x / (TILE_SIZE.x * 0.5)) * 0.5
	return Vector2i(roundi(grid_x), roundi(grid_y))
